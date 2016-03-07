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
    func manipulateFilterContext(inout context: CGContext, rect: CGRect)
}

class BKFilterView: UIView {
    
    weak var delegate: BKFilterViewDelegate?
    
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
            
            // make self invisible (so that we don't make a screenshot of it)
            self.alpha = 0.0
            
            // get partial screenshow
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
            
            // manipulate context
            var context = UIGraphicsGetCurrentContext()!
            delegate?.manipulateFilterContext(&context, rect: rect)
            
            // make self visible again
            self.alpha = 1.0
        }
    }
}
