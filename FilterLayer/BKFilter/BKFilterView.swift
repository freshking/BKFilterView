//
//  BKFilterView.swift
//  FilterLayer
//
//  Created by Bastian Kohlbauer on 06.03.16.
//  Copyright © 2016 Bastian Kohlbauer. All rights reserved.
//

import UIKit

// TODO: having to render alpha slows down performance of the filterview immense. find fix.

protocol BKFilterViewDelegate: class {
    func exculdedViews() -> [UIView]?
    func manipulateFilterContext(inout context: CGContext, rect: CGRect)
}

class BKFilterView: UIView {
    
    private var presetExcludedViews: [UIView]?
    
    weak var delegate: BKFilterViewDelegate?
    
    //MARK:- Override methods
    
    deinit {
        self.removeObserver(self, forKeyPath: "center")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.greenColor()
        // this is used to detect movement of the view and rerender drawRect
        self.addObserver(self, forKeyPath: "center", options: NSKeyValueObservingOptions.New, context: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.setNeedsDisplay()
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "center" {
            self.setNeedsDisplay()
        }
    }

    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        if let layer = UIApplication.sharedApplication().delegate?.window??.layer ?? UIApplication.sharedApplication().keyWindow?.layer {
            let scale = UIScreen.mainScreen().scale
            
            // get views that should be excluded from the screenshot
            var excludedViews: [UIView]? = delegate?.exculdedViews()
            if (excludedViews != nil && presetExcludedViews != nil) {
                for view in presetExcludedViews! {
                    excludedViews!.append(view)
                }
            }
            
            // make views invisible (so that we don't make a screenshot of it)
            self.setAlphaForViews(excludedViews, alpha: 0.0)
            
            // get partial screenshot
            var screenshot: UIImage?
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, scale)
            if let imageContext = UIGraphicsGetCurrentContext() {
                CGContextTranslateCTM(imageContext, -self.frame.origin.x, -self.frame.origin.y)
                layer.renderInContext(imageContext)
                screenshot = UIGraphicsGetImageFromCurrentImageContext()
            }
            UIGraphicsEndImageContext()
            
            // draw cropped screenshot
            screenshot?.drawInRect(rect)
            
            // get current context
            var context = UIGraphicsGetCurrentContext()!
            
            // manipulate context
            delegate?.manipulateFilterContext(&context, rect: rect)

            // make views visible again
            self.setAlphaForViews(excludedViews, alpha: 1.0)
        }
    }
    
    //MARK:- Control methods
    
    internal func setExcludedViews(views: [UIView]?)
    {
        presetExcludedViews = views
    }
    
    internal func revealCircular(completion: (() -> Void)?)
    {
        self.userInteractionEnabled = false
        
        let maskLayerRadius = CGFloat(hypotf(Float(self.bounds.size.width), Float(self.bounds.size.height))) / 2.0
        let maskLayerEdgeLength: CGFloat = (maskLayerRadius * 2.0)
        let maskLayerBounds: CGRect = CGRectMake(0.0, 0.0, maskLayerEdgeLength, maskLayerEdgeLength)
        let maskLayerPosition: CGPoint = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0)
        
        let maskLayer = CAShapeLayer()
        maskLayer.bounds = CGRectMake((self.bounds.size.width-1.0)/2.0, (self.bounds.size.height-1.0)/2.0, 1.0, 1.0)
        maskLayer.path = UIBezierPath(roundedRect: maskLayer.bounds, cornerRadius: maskLayer.bounds.size.width/2.0).CGPath
        maskLayer.position = maskLayerPosition
        maskLayer.anchorPoint = CGPointMake(0.5, 0.5)
        self.layer.mask = maskLayer
        
        let pathAnimation: CABasicAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.toValue = UIBezierPath(roundedRect: maskLayerBounds, cornerRadius: maskLayerRadius).CGPath
        
        let boundsAnimation: CABasicAnimation = CABasicAnimation(keyPath: "bounds")
        boundsAnimation.toValue = NSValue(CGRect: maskLayerBounds)

        let animationGroup: CAAnimationGroup = CAAnimationGroup()
        animationGroup.animations = [pathAnimation, boundsAnimation]
        animationGroup.removedOnCompletion = false
        animationGroup.duration = 0.6
        animationGroup.fillMode  = kCAFillModeForwards

        CATransaction.begin()
        CATransaction.setCompletionBlock({ () -> Void in
            maskLayer.removeFromSuperlayer()
            self.userInteractionEnabled = true
            completion?()
        })
        maskLayer.addAnimation(animationGroup, forKey: "animationGroup")
        CATransaction.commit()
    }
    
    internal func hideCircular(completion: (() -> Void)?)
    {
        self.userInteractionEnabled = false
        
        let maskLayerRadius: CGFloat = 1.0
        let maskLayerEdgeLength: CGFloat = (maskLayerRadius * 2.0)
        let maskLayerBounds: CGRect = CGRectMake((self.bounds.size.width-maskLayerEdgeLength)/2.0, (self.bounds.size.height-maskLayerEdgeLength)/2.0, maskLayerEdgeLength, maskLayerEdgeLength)
        let maskLayerPosition: CGPoint = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0)
        let fromRadius: CGFloat = CGFloat(hypotf(Float(self.bounds.size.width), Float(self.bounds.size.height))) / 2.0
        
        let maskLayer = CAShapeLayer()
        maskLayer.bounds = CGRectMake(0.0, 0.0, (2 * fromRadius), (2 * fromRadius))
        maskLayer.path = UIBezierPath(roundedRect: maskLayer.bounds, cornerRadius: fromRadius).CGPath
        maskLayer.position = maskLayerPosition
        maskLayer.anchorPoint = CGPointMake(0.5, 0.5)
        self.layer.mask = maskLayer
        
        let pathAnimation: CABasicAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.toValue = UIBezierPath(roundedRect: maskLayerBounds, cornerRadius: maskLayerRadius).CGPath
        
        let boundsAnimation: CABasicAnimation = CABasicAnimation(keyPath: "bounds")
        boundsAnimation.toValue = NSValue(CGRect: maskLayerBounds)
        
        let animationGroup: CAAnimationGroup = CAAnimationGroup()
        animationGroup.animations = [pathAnimation, boundsAnimation]
        animationGroup.removedOnCompletion = false
        animationGroup.duration = 0.6
        animationGroup.fillMode  = kCAFillModeForwards
        
        CATransaction.begin()
        CATransaction.setCompletionBlock({ () -> Void in
            maskLayer.removeFromSuperlayer()
            self.userInteractionEnabled = true
            completion?()
        })
        maskLayer.addAnimation(animationGroup, forKey: "animationGroup")
        CATransaction.commit()
    }
    
    //MARK:- Private methods
    
    private func setAlphaForViews(views: [UIView]?, alpha: CGFloat)
    {
        self.alpha = alpha
        if views != nil && views!.count > 0 {
            for view in views! {
                view.alpha = alpha
            }
        }
    }
}
