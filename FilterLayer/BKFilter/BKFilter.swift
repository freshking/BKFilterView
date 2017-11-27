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
    
    class func filter( context: inout CGContext, rect: CGRect, type: BKFilterType, filerValues: [String: AnyObject?]?)
    {
        let originalImage: CGImage = context.makeImage()!
        let ciImage: CIImage = CIImage(cgImage: originalImage)
        let filterName = type.rawValue
        if var filter = CIFilter(name: filterName) {
            filter.setDefaults()
            filter.setValue(ciImage, forKey: kCIInputImageKey)
            self.setFilterValues(filter: &filter, filerValues: filerValues)
            if let outputImage = filter.outputImage {
                let outputImage: UIImage = UIImage(ciImage: outputImage)
                outputImage.draw(in: rect)
            } else {
                print("Error rendering filter: \(filterName)")
            }
        }
    }
    
    private class func setFilterValues( filter: inout CIFilter, filerValues: [String: AnyObject?]?)
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
    
    class func blackAndWhite( context: inout CGContext, rect: CGRect) {
        let originalImage: CGImage = context.makeImage()!
        let ciImage: CIImage = CIImage(cgImage: originalImage)
        let bwFilter = CIFilter(name: "CIColorControls")!
        bwFilter.setValue(ciImage, forKey: kCIInputImageKey)
        bwFilter.setValue(NSNumber(value: 0.0), forKey: kCIInputBrightnessKey)
        bwFilter.setValue(NSNumber(value: 1.1), forKey: kCIInputContrastKey)
        bwFilter.setValue(NSNumber(value: 0.0), forKey: kCIInputSaturationKey)
        if let bwFilterOutput = bwFilter.outputImage {
            let exposureFilter = CIFilter(name: "CIExposureAdjust")!
            exposureFilter.setValue(bwFilterOutput, forKey: kCIInputImageKey)
            exposureFilter.setValue(NSNumber(value: 0.7), forKey: kCIInputEVKey)
            if let outputImage = exposureFilter.outputImage {
                let outputImage: UIImage = UIImage(ciImage: outputImage)
                outputImage.draw(in: rect)
            }
        }
    }

    class func setYellow( context: inout CGContext, rect: CGRect) {
        let color = UIColor(red: 0.5, green: 0.5, blue: 0.0, alpha: 0.4).cgColor
        context.setBlendMode(CGBlendMode.multiply)
        //context.setFillColor(CGColorGetComponents(color))
        context.setFillColor(color.components!)
        context.fill(rect)
    }
    
    class func setGrayscale( context: inout CGContext, rect: CGRect) {
        let originalImage: CGImage = context.makeImage()!
        let width: Int = originalImage.width
        let height: Int = originalImage.height
        let bytesPerComponent: Int = 8
        let bytesPerRow: Int = 0
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapInfo: UInt32 = CGImageAlphaInfo.none.rawValue
        context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bytesPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)!
        let drawRect = CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height))
        context.draw(originalImage, in: drawRect)
        let outputImage: UIImage = UIImage(cgImage: context.makeImage()!)
        outputImage.draw(in: rect)
    }
}

