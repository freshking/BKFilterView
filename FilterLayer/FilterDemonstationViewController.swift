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

    //MARK:- Control functions
    
    internal func setFiltertype(type: BKFilterType) {
        
        self.title = type.getCIFilterName()
        filterType = type
        
        let a: CGFloat = 150.0
        let filterView = BKFilterView(frame: CGRectMake((self.view.bounds.size.width-a)/2.0, (self.view.bounds.size.height-a)/2.0, a, a))
        filterView.layer.borderWidth = 1.0
        filterView.layer.borderColor = UIColor.blackColor().CGColor
        filterView.delegate = self
        filterView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, .FlexibleHeight]
        self.view.addSubview(filterView)
        
        let gesture = UIPanGestureRecognizer(target: self, action: Selector("viewDragged:"))
        gesture.cancelsTouchesInView = false
        filterView.addGestureRecognizer(gesture)
    }
    
    //MARK:- BKFilterViewDelegate
    
    internal func manipulateFilterContext(inout context: CGContext, rect: CGRect) {
        BKFilter.setType(&context, rect: rect, type: filterType)
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
        let width: CGFloat = (self.view.bounds.size.width / 12.0)
        let height: CGFloat = width * factor
        
        var viewCount: Int = Int(width) * Int(height)
        var x: CGFloat = 0.0
        var y: CGFloat = 0.0
        
        while viewCount > 0 {
            let view = UIView(frame: CGRectMake(x, y, width, height))
            view.backgroundColor = self.randomColor()
            view.layer.borderColor = UIColor.whiteColor().CGColor
            view.layer.borderWidth = 1.0
            self.view.addSubview(view)
            x += width
            if (x > self.view.bounds.size.width) {
                x = 0.0
                y += height
            }
            viewCount--
        }
    }
    
    private func randomColor() -> UIColor {
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
    
    //MARK:- Button actions
    
    internal func leftMenuButtonAction(button: UIButton)
    {
        self.navigationController?.dismissViewControllerAnimated(true, completion: { () -> Void in
        })
    }
}
