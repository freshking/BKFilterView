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
        let filteName = type.getCIFilterName()
        if let filter = CIFilter(name: filteName) {
            filter.setDefaults()
            filter.setValue(ciImage, forKey: kCIInputImageKey)
            if let outputImage = filter.outputImage {
                let outputImage: UIImage = UIImage(CIImage: outputImage)
                outputImage.drawInRect(rect)
            } else {
                print("Error rendering filter: \(filteName)")
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

enum BKFilterType {
    
    // TODO: complete from list: https://developer.apple.com/library/mac/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html#//apple_ref/doc/uid/TP30000136-SW166
    
    // CategoryColorEffect:
    
    case ColorCrossPolynomial
    case ColorCube
    case ColorCubeWithColorSpace
    case ColorInvert
    case ColorMap
    case ColorMonochrome
    case ColorPosterize
    case FalseColor
    case MaskToAlpha
    case MaximumComponent
    case MinimumComponent
    case PhotoEffectChrome
    case PhotoEffectFade
    case PhotoEffectInstant
    case PhotoEffectMono
    case PhotoEffectNoir
    case PhotoEffectProcess
    case PhotoEffectTonal
    case PhotoEffectTransfer
    case SepiaTone
    case Vignette
    
    
    func getCIFilterName() -> String {
        switch self {
        case .ColorCrossPolynomial:
            return "CIColorCrossPolynomial"
        case .ColorCube:
            return "CIColorCube"
        case .ColorCubeWithColorSpace:
            return "CIColorCubeWithColorSpace"
        case .ColorInvert:
            return "CIColorInvert"
        case .ColorMap:
            return "CIColorMap"
        case .ColorMonochrome:
            return "CIColorMonochrome"
        case .ColorPosterize:
            return "CIColorPosterize"
        case .FalseColor:
            return "CIFalseColor"
        case .MaskToAlpha:
            return "CIMaskToAlpha"
        case .MaximumComponent:
            return "CIMaximumComponent"
        case .MinimumComponent:
            return "CIMinimumComponent"
        case .PhotoEffectChrome:
            return "CIPhotoEffectChrome"
        case .PhotoEffectFade:
            return "CIPhotoEffectFade"
        case .PhotoEffectInstant:
            return "CIPhotoEffectInstant"
        case .PhotoEffectMono:
            return "CIPhotoEffectMono"
        case .PhotoEffectNoir:
            return "CIPhotoEffectNoir"
        case .PhotoEffectProcess:
            return "CIPhotoEffectProcess"
        case .PhotoEffectTonal:
            return "CIPhotoEffectTonal"
        case .PhotoEffectTransfer:
            return "CIPhotoEffectTransfer"
        case .SepiaTone:
            return "CISepiaTone"
        case .Vignette:
            return "CIVignette"
        }
    }
}