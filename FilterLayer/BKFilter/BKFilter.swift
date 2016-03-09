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
    
    class func filter(inout context: CGContext, rect: CGRect, type: BKFilterType, filerValues: [String: AnyObject?]?)
    {
        let originalImage: CGImageRef = CGBitmapContextCreateImage(context)!
        let ciImage: CIImage = CIImage(CGImage: originalImage)
        let filterName = type.rawValue
        if var filter = CIFilter(name: filterName) {
            filter.setDefaults()
            filter.setValue(ciImage, forKey: kCIInputImageKey)
            self.setFilterValues(&filter, filerValues: filerValues)
            if let outputImage = filter.outputImage {
                let outputImage: UIImage = UIImage(CIImage: outputImage)
                outputImage.drawInRect(rect)
            } else {
                print("Error rendering filter: \(filterName)")
            }
        }
    }
    
    private class func setFilterValues(inout filter: CIFilter, filerValues: [String: AnyObject?]?)
    {
        if let filerValues = filerValues {
            for filterValue in filerValues {
                let key: String = filterValue.0
                let value: AnyObject? = filterValue.1
                filter.setValue(value, forKey: key)
            }
        }
    }
    
    //MARK:- Examples of custom filters
    
    class func blackAndWhite(inout context: CGContext, rect: CGRect) {
        let originalImage: CGImageRef = CGBitmapContextCreateImage(context)!
        let ciImage: CIImage = CIImage(CGImage: originalImage)
        let bwFilter = CIFilter(name: "CIColorControls")!
        bwFilter.setValue(ciImage, forKey: kCIInputImageKey)
        bwFilter.setValue(NSNumber(float: 0.0), forKey: kCIInputBrightnessKey)
        bwFilter.setValue(NSNumber(float: 1.1), forKey: kCIInputContrastKey)
        bwFilter.setValue(NSNumber(float: 0.0), forKey: kCIInputSaturationKey)
        if let bwFilterOutput = bwFilter.outputImage {
            let exposureFilter = CIFilter(name: "CIExposureAdjust")!
            exposureFilter.setValue(bwFilterOutput, forKey: kCIInputImageKey)
            exposureFilter.setValue(NSNumber(float: 0.7), forKey: kCIInputEVKey)
            if let outputImage = exposureFilter.outputImage {
                let outputImage: UIImage = UIImage(CIImage: outputImage)
                outputImage.drawInRect(rect)
            }
        }
    }

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