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
    func manipulateFilterContext( context: inout CGContext, rect: CGRect)
}

class BKFilterView: UIView {
    
    private var presetExcludedViews: [UIView]?
    weak var delegate: BKFilterViewDelegate?
    
    //MARK:- Override functions
    
    deinit {
        self.removeObserver(self, forKeyPath: "center")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.green
        self.autoresizingMask = [UIView.AutoresizingMask.flexibleHeight, .flexibleWidth]
        // this is used to detect movement of the view and rerender drawRect
        self.addObserver(self, forKeyPath: "center", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setNeedsDisplay()
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "center" {
            self.setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if let viewToRender = BKFilterView.insertionView() {
            
            // screen scale
            let scale = UIScreen.main.scale
            
            // get views that should be excluded from the screenshot
            var excludedViews: [UIView]? = delegate?.exculdedViews()
            if presetExcludedViews != nil {
                if excludedViews == nil {
                    excludedViews = [UIView]()
                }
                for view in presetExcludedViews! {
                    excludedViews!.append(view)
                }
            }
            
            // make views invisible (so that we don't make a screenshot of it)
            self.setAlphaForViews(views: excludedViews, alpha: 0.0)
            
            // get partial screenshot
            var screenshot: UIImage?
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, scale)
            if (true) {
                if let imageContext = UIGraphicsGetCurrentContext() {
                    imageContext.translateBy(x: -self.frame.origin.x, y: -self.frame.origin.y)
                    viewToRender.layer.render(in: imageContext)
                    screenshot = UIGraphicsGetImageFromCurrentImageContext()
                }
            } else {
                // the commented out code below is actually a lot faster in rendering (10 - 15 times) the view
                // to the context but it interferes with any other ongoing animations. they get flushed out.
                // see http://stackoverflow.com/a/25704861/1856463
                // but if you are sure that you will never have this problem then feel free to use the code below and comment out the one above.
                // let renderFrame = CGRectMake(-self.frame.origin.x, -self.frame.origin.y, viewToRender.bounds.size.width, viewToRender.bounds.size.height)
                // viewToRender.drawViewHierarchyInRect(renderFrame, afterScreenUpdates: true)
            }
            screenshot = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            // draw cropped screenshot
            screenshot?.draw(in: rect)
            
            // get current context
            var context = UIGraphicsGetCurrentContext()!
            
            // manipulate context
            delegate?.manipulateFilterContext(context: &context, rect: rect)
            
            // make views visible again
            self.setAlphaForViews(views: excludedViews, alpha: 1.0)
        }
    }
    
    //MARK:- Control functions
    
    func setExcludedViews(views: [UIView]?)
    {
        presetExcludedViews = views
    }
    
    func revealCircular(duration: CFTimeInterval = 0.3, completion: (() -> Void)?)
    {
        self.isUserInteractionEnabled = false
        
        let maskLayerRadius = CGFloat(hypotf(Float(self.bounds.size.width), Float(self.bounds.size.height))) / 2.0
        let maskLayerEdgeLength: CGFloat = (maskLayerRadius * 2.0)
        let maskLayerBounds: CGRect = CGRect(x: 0.0, y: 0.0, width: maskLayerEdgeLength, height: maskLayerEdgeLength)
        let maskLayerPosition: CGPoint = CGPoint(x: self.bounds.size.width/2.0, y: self.bounds.size.height/2.0)
        
        let maskLayer = CAShapeLayer()
        maskLayer.bounds = CGRect(x: (self.bounds.size.width-1.0)/2.0, y: (self.bounds.size.height-1.0)/2.0, width: 1.0, height: 1.0)
        maskLayer.path = UIBezierPath(roundedRect: maskLayer.bounds, cornerRadius: maskLayer.bounds.size.width/2.0).cgPath
        maskLayer.position = maskLayerPosition
        maskLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.layer.mask = maskLayer
        
        let pathAnimation: CABasicAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.toValue = UIBezierPath(roundedRect: maskLayerBounds, cornerRadius: maskLayerRadius).cgPath
        
        let boundsAnimation: CABasicAnimation = CABasicAnimation(keyPath: "bounds")
        boundsAnimation.toValue = NSValue(cgRect: maskLayerBounds)
        
        let animationGroup: CAAnimationGroup = CAAnimationGroup()
        animationGroup.animations = [pathAnimation, boundsAnimation]
        animationGroup.isRemovedOnCompletion = false
        animationGroup.duration = duration
        animationGroup.fillMode  = CAMediaTimingFillMode.forwards
        
        CATransaction.begin()
        CATransaction.setCompletionBlock({ () -> Void in
            maskLayer.removeFromSuperlayer()
            self.isUserInteractionEnabled = true
            completion?()
        })
        maskLayer.add(animationGroup, forKey: "animationGroup")
        CATransaction.commit()
    }
    
    func hideCircular(duration: CFTimeInterval = 0.3, completion: (() -> Void)?)
    {
        self.isUserInteractionEnabled = false
        
        let maskLayerRadius: CGFloat = 1.0
        let maskLayerEdgeLength: CGFloat = (maskLayerRadius * 2.0)
        let maskLayerBounds: CGRect = CGRect(x: (self.bounds.size.width-maskLayerEdgeLength)/2.0, y: (self.bounds.size.height-maskLayerEdgeLength)/2.0, width: maskLayerEdgeLength, height: maskLayerEdgeLength)
        let maskLayerPosition: CGPoint = CGPoint(x: self.bounds.size.width/2.0, y: self.bounds.size.height/2.0)
        let fromRadius: CGFloat = CGFloat(hypotf(Float(self.bounds.size.width), Float(self.bounds.size.height))) / 2.0
        
        let maskLayer = CAShapeLayer()
        maskLayer.bounds = CGRect(x: 0.0, y: 0.0, width: (2 * fromRadius), height: (2 * fromRadius))
        maskLayer.path = UIBezierPath(roundedRect: maskLayer.bounds, cornerRadius: fromRadius).cgPath
        maskLayer.position = maskLayerPosition
        maskLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.layer.mask = maskLayer
        
        let pathAnimation: CABasicAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.toValue = UIBezierPath(roundedRect: maskLayerBounds, cornerRadius: maskLayerRadius).cgPath
        
        let boundsAnimation: CABasicAnimation = CABasicAnimation(keyPath: "bounds")
        boundsAnimation.toValue = NSValue(cgRect: maskLayerBounds)
        
        let animationGroup: CAAnimationGroup = CAAnimationGroup()
        animationGroup.animations = [pathAnimation, boundsAnimation]
        animationGroup.isRemovedOnCompletion = false
        animationGroup.duration = 0.3
        animationGroup.fillMode  = CAMediaTimingFillMode.forwards
        
        CATransaction.begin()
        CATransaction.setCompletionBlock({ () -> Void in
            maskLayer.removeFromSuperlayer()
            self.isUserInteractionEnabled = true
            completion?()
        })
        maskLayer.add(animationGroup, forKey: "animationGroup")
        CATransaction.commit()
    }
    
    //MARK:- Private functions
    
    private func setAlphaForViews(views: [UIView]?, alpha: CGFloat) {
        self.alpha = alpha
        if views != nil && views!.count > 0 {
            for view in views! {
                view.alpha = alpha
            }
        }
    }
    
    //MARK:- Class functions
    
    class func insertionView() -> UIView? {
        // this is the insertion view which will be screenshottet. this should be used as refrence view
        return UIApplication.topViewController()?.view
    }
}

//MARK:- UIApplication extension
extension UIApplication {
    class func topViewController(base: UIViewController? = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
