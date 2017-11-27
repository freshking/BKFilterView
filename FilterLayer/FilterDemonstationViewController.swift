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
        
        let closeuButton = UIButton(type: UIButtonType.custom)
        closeuButton.backgroundColor = UIColor.clear
        closeuButton.setTitle("Close", for: .normal)
        closeuButton.setTitleColor(UIColor.black, for: .normal)
        closeuButton.setTitleColor(UIColor.lightGray, for: UIControlState.highlighted)
        closeuButton.addTarget(self, action: #selector(leftMenuButtonAction(button:)), for: UIControlEvents.touchUpInside)
        closeuButton.sizeToFit()
        
        let barButtonItem = UIBarButtonItem(customView: closeuButton)
        self.navigationItem.rightBarButtonItem = barButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.backgroundColor = UIColor.white
        //self.navigationController?.isNavigationBarHidden
        self.generateBackground()
    }
    
    override func willAnimateRotation(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
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
            
            filterView.center = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
            self.view.bringSubview(toFront: filterView)
        }
    }
    
    //MARK:- Control functions
    
    internal func setFiltertype(type: BKFilterType) {
        
        self.title = type.rawValue
        filterType = type
        
        let a: CGFloat = 150.0
        
        let filterView = BKFilterView(frame: CGRect(x: (self.view.bounds.size.width-a)/2.0, y: (self.view.bounds.size.height-a)/2.0, width: a, height: a))
        filterView.layer.borderWidth = 1.0
        filterView.layer.borderColor = UIColor.black.cgColor
        filterView.delegate = self
        filterView.autoresizingMask = [UIViewAutoresizing.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin ,.flexibleBottomMargin]
        self.view.addSubview(filterView)
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(viewDragged(gesture:)))
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
    
    internal func manipulateFilterContext( context: inout CGContext, rect: CGRect) {
        
        var filterValues = [String: AnyObject?]()
        let centerVector = CIVector(x: rect.size.width*1.5, y: rect.size.height*1.5)
        
        if filterType == .CircularScreen {
            filterValues["inputCenter"] = centerVector
            filterValues["inputWidth"] = NSNumber(value: 8.0) // default 6.0
            filterValues["inputSharpness"] = NSNumber(value: 0.8) // default 0.70
        } else if filterType == .BumpDistortion {
            filterValues["inputCenter"] = centerVector
            filterValues["inputRadius"] = NSNumber(value: Float(max(rect.size.width, rect.size.height))) // default 300.00
            filterValues["inputScale"] = NSNumber(value: 1.0) // default 0.50
        } else if filterType == .ColorControls {
            
            BKFilter.blackAndWhite(context: &context, rect: rect)
            return
        }
        
        
        
        BKFilter.filter(context: &context, rect: rect, type: filterType, filerValues: filterValues)
    }
    
    //MARK:- Private functions
    
    internal func viewDragged(gesture: UIPanGestureRecognizer)
    {
        let filterView = gesture.view as! BKFilterView
        let translation = gesture.translation(in: filterView) as CGPoint
        filterView.center = CGPoint(x: filterView.center.x + translation.x, y: filterView.center.y + translation.y)
        gesture.setTranslation(CGPoint.zero, in: filterView)
    }
    
    private func generateBackground()
    {
        let factor: CGFloat = (self.view.bounds.size.height/self.view.bounds.size.width)
        var width: CGFloat = (self.view.bounds.size.width / 12.0)
        var height: CGFloat = width * factor
        
        let orientation = UIApplication.shared.statusBarOrientation
        if UIInterfaceOrientationIsLandscape(orientation) {
            swap(&width, &height)
        }
        
        var viewCount: Int = Int(width) * Int(height)
        var x: CGFloat = 0.0
        var y: CGFloat = 0.0
        
        while viewCount > 0 {
            
            let tileView = BackgroundTileView(frame: CGRect(x: x, y: y, width: width, height: height))
            self.view.addSubview(tileView)
            x += width
            if (x > self.view.bounds.size.width) {
                x = 0.0
                y += height
            }
            viewCount = viewCount - 1
        }
    }
    
    //MARK:- Button actions
    
    internal func leftMenuButtonAction(button: UIButton)
    {
        self.navigationController?.dismiss(animated: true, completion: { () -> Void in
        })
    }
}

class BackgroundTileView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = self.randomColor()
        self.layer.borderColor = UIColor.white.cgColor
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

