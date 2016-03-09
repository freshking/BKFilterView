//
//  FilterDemonstationViewController.swift
//  FilterLayer
//
//  Created by Bastian Kohlbauer on 06.03.16.
//  Copyright © 2016 Bastian Kohlbauer. All rights reserved.
//

import UIKit

class FilterDemonstationViewController: UIViewController, BKFilterViewDelegate {
    
    private var filterType: BKFilterType = BKFilterType.PhotoEffectMono
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let closeuButton = UIButton(type: UIButtonType.Custom)
        closeuButton.backgroundColor = UIColor.clearColor()
        closeuButton.setTitle("Close", forState: UIControlState.Normal)
        closeuButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        closeuButton.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Highlighted)
        closeuButton.addTarget(self, action: "leftMenuButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        closeuButton.sizeToFit()
        
        let barButtonItem = UIBarButtonItem(customView: closeuButton)
        self.navigationItem.rightBarButtonItem = barButtonItem
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationController?.navigationBarHidden
        self.generateBackground()
    }

    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        var filterView: BKFilterView?
        for view in self.view.subviews {
            if let tileView = view as? BackgroundTileView {
                tileView.removeFromSuperview()
            } else if let view = view as? BKFilterView {
                filterView = view
                
            }
        }
        self.generateBackground()
        
        if let filterView = filterView {
            filterView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds))
            self.view.bringSubviewToFront(filterView)
        }
    }

    //MARK:- Control functions
    
    internal func setFiltertype(type: BKFilterType) {
        
        self.title = type.rawValue
        filterType = type
        
        let a: CGFloat = 150.0
        let filterView = BKFilterView(frame: CGRectMake((self.view.bounds.size.width-a)/2.0, (self.view.bounds.size.height-a)/2.0, a, a))
        filterView.layer.borderWidth = 1.0
        filterView.layer.borderColor = UIColor.blackColor().CGColor
        filterView.delegate = self
        filterView.autoresizingMask = [UIViewAutoresizing.FlexibleLeftMargin, .FlexibleRightMargin, .FlexibleTopMargin ,.FlexibleBottomMargin]
        self.view.addSubview(filterView)
        
        let gesture = UIPanGestureRecognizer(target: self, action: Selector("viewDragged:"))
        gesture.cancelsTouchesInView = false
        filterView.addGestureRecognizer(gesture)
        
        filterView.revealCircular { () -> Void in
            
        }
    }
    
    //MARK:- BKFilterViewDelegate
    
    internal func exculdedViews() -> [UIView]?
    {
        return nil
    }
    
    internal func manipulateFilterContext(inout context: CGContext, rect: CGRect) {
        
        var filterValues = [String: AnyObject?]()
        let centerVector = CIVector(x: rect.size.width*1.5, y: rect.size.height*1.5)
        
        if filterType == .CircularScreen {
            filterValues["inputCenter"] = centerVector
            filterValues["inputWidth"] = NSNumber(float: 8.0) // default 6.0
            filterValues["inputSharpness"] = NSNumber(float: 0.8) // default 0.70
        } else if filterType == .BumpDistortion {
            filterValues["inputCenter"] = centerVector
            filterValues["inputRadius"] = NSNumber(float: Float(max(rect.size.width, rect.size.height))) // default 300.00
            filterValues["inputScale"] = NSNumber(float: 1.0) // default 0.50
        } else if filterType == .ColorControls {
            
            BKFilter.blackAndWhite(&context, rect: rect)
            return
        }
        
        
        
        BKFilter.filter(&context, rect: rect, type: filterType, filerValues: filterValues)
    }
    
    //MARK:- Private functions
    
    internal func viewDragged(gesture: UIPanGestureRecognizer)
    {
        let filterView = gesture.view as! BKFilterView
        let translation = gesture.translationInView(filterView) as CGPoint
        filterView.center = CGPointMake(filterView.center.x + translation.x, filterView.center.y + translation.y)
        gesture.setTranslation(CGPointZero, inView: filterView)
    }
    
    private func generateBackground()
    {
        let factor: CGFloat = (self.view.bounds.size.height/self.view.bounds.size.width)
        var width: CGFloat = (self.view.bounds.size.width / 12.0)
        var height: CGFloat = width * factor
        
        let orientation = UIApplication.sharedApplication().statusBarOrientation
        if UIInterfaceOrientationIsLandscape(orientation) {
            swap(&width, &height)
        }
        
        var viewCount: Int = Int(width) * Int(height)
        var x: CGFloat = 0.0
        var y: CGFloat = 0.0
        
        while viewCount > 0 {
            let tileView = BackgroundTileView(frame: CGRectMake(x, y, width, height))
            self.view.addSubview(tileView)
            x += width
            if (x > self.view.bounds.size.width) {
                x = 0.0
                y += height
            }
            viewCount--
        }
    }
    
    //MARK:- Button actions
    
    internal func leftMenuButtonAction(button: UIButton)
    {
        self.navigationController?.dismissViewControllerAnimated(true, completion: { () -> Void in
        })
    }
}

class BackgroundTileView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = self.randomColor()
        self.layer.borderColor = UIColor.whiteColor().CGColor
        self.layer.borderWidth = 1.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func randomColor() -> UIColor {
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
}
