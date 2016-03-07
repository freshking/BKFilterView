//
//  BKFilter.swift
//  FilterLayer
//
//  Created by Bastian Kohlbauer on 06.03.16.
//  Copyright © 2016 Bastian Kohlbauer. All rights reserved.
//

import UIKit

class BKFilter {
    
    //MARK:- Base filter
    
    class func setType(inout context: CGContext, rect: CGRect, type: BKFilterType)
    {
        let originalImage: CGImageRef = CGBitmapContextCreateImage(context)!
        let ciImage: CIImage = CIImage(CGImage: originalImage)
        let filterName = type.rawValue
        if let filter = CIFilter(name: filterName) {
            filter.setDefaults()
            filter.setValue(ciImage, forKey: kCIInputImageKey)
            if let outputImage = filter.outputImage {
                let outputImage: UIImage = UIImage(CIImage: outputImage)
                outputImage.drawInRect(rect)
            } else {
                print("Error rendering filter: \(filterName)")
            }
        }
    }
    
    //MARK:- Examples of custom filters

    class func setYellow(inout context: CGContext, rect: CGRect) {
        let color = UIColor(red: 0.5, green: 0.5, blue: 0.0, alpha: 0.4).CGColor
        CGContextSetBlendMode(context, CGBlendMode.Multiply)
        CGContextSetFillColor(context, CGColorGetComponents(color))
        CGContextFillRect(context, rect)
    }
    
    class func setGrayscale(inout context: CGContext, rect: CGRect) {
        let originalImage: CGImageRef = CGBitmapContextCreateImage(context)!
        let width: Int = CGImageGetWidth(originalImage)
        let height: Int = CGImageGetHeight(originalImage)
        let bytesPerComponent: Int = 8
        let bytesPerRow: Int = 0
        let colorSpace: CGColorSpaceRef = CGColorSpaceCreateDeviceGray()!
        let bitmapInfo: UInt32 = CGImageAlphaInfo.None.rawValue
        context = CGBitmapContextCreate(nil, width, height, bytesPerComponent, bytesPerRow, colorSpace, bitmapInfo)!
        let drawRect = CGRectMake(0.0, 0.0, CGFloat(width), CGFloat(height))
        CGContextDrawImage(context, drawRect, originalImage)
        let outputImage: UIImage = UIImage(CGImage: CGBitmapContextCreateImage(context)!)
        outputImage.drawInRect(rect)
    }
}