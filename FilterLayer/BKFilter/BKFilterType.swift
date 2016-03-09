//
//  BKFilterList.swift
//  FilterLayer
//
//  Created by Bastian Kohlbauer on 07.03.16.
//  Copyright © 2016 Bastian Kohlbauer. All rights reserved.
//

import Foundation

enum BKFilterType: String {
    
    //TODO: complete from list: https://developer.apple.com/library/mac/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html#//apple_ref/doc/uid/TP30000136-SW166
    
    static let collection: [String: [BKFilterType]] = [
        "Color Effect": colorEffecFilters,
        "Distortion Effect": distortionEffectFilters,
        "Halfton eEffect": halftoneEffectFilters,
        "Tile Effect": tileEffectFilters,
        "Stylize": stylizeFilters]
    
    case ColorControls = "CIColorControls"
    case ColorCrossPolynomial = "CIColorCrossPolynomial"
    case ColorCube = "CIColorCube"
    case ColorCubeWithColorSpace = "CIColorCubeWithColorSpace"
    case ColorInvert = "CIColorInvert"
    case ColorMap = "CIColorMap"
    case ColorMonochrome = "CIColorMonochrome"
    case ColorPosterize = "CIColorPosterize"
    case FalseColor = "CIFalseColor"
    case MaskToAlpha = "CIMaskToAlpha"
    case MaximumComponent = "CIMaximumComponent"
    case MinimumComponent = "CIMinimumComponent"
    case PhotoEffectChrome = "CIPhotoEffectChrome"
    case PhotoEffectFade = "CIPhotoEffectFade"
    case PhotoEffectInstant = "CIPhotoEffectInstant"
    case PhotoEffectMono = "CIPhotoEffectMono"
    case PhotoEffectNoir = "CIPhotoEffectNoir"
    case PhotoEffectProcess = "CIPhotoEffectProcess"
    case PhotoEffectTonal = "CIPhotoEffectTonal"
    case PhotoEffectTransfer = "CIPhotoEffectTransfer"
    case SepiaTone = "CISepiaTone"
    case Vignette = "CIVignette"
    
    static private let colorEffecFilters: [BKFilterType] = [
        ColorControls,
        ColorCrossPolynomial,
        ColorCube,
        ColorCubeWithColorSpace,
        ColorInvert,
        ColorMap,
        ColorMonochrome,
        ColorPosterize,
        FalseColor,
        MaskToAlpha,
        MaximumComponent,
        MinimumComponent,
        PhotoEffectChrome,
        PhotoEffectFade,
        PhotoEffectInstant,
        PhotoEffectMono,
        PhotoEffectNoir,
        PhotoEffectProcess,
        PhotoEffectTonal,
        PhotoEffectTransfer,
        SepiaTone,
        Vignette]
    
    //MARK:- CICategoryDistortionEffect

    //TODO: Some distorion effets require additional input to th CIFilter. Implement this.
    
    case BumpDistortion = "CIBumpDistortion"
    case BumpDistortionLinear = "CIBumpDistortionLinear"
    case CircleSplashDistortion = "CICircleSplashDistortion"
    case CircularWrap = "CICircularWrap"
    case Droste = "CIDroste"
    case DisplacementDistortion = "CIDisplacementDistortion"
    case GlassDistortion = "CIGlassDistortion"
    case GlassLozenge = "CIGlassLozenge"
    case HoleDistortion = "CIHoleDistortion"
    case LightTunnel = "CILightTunnel"
    case PinchDistortion = "CIPinchDistortion"
    case StretchCrop = "CIStretchCrop"
    case TorusLensDistortion = "CITorusLensDistortion"
    case TwirlDistortion = "CITwirlDistortion"
    
    static private let distortionEffectFilters: [BKFilterType] = [
        BumpDistortion,
        BumpDistortionLinear,
        CircleSplashDistortion,
        CircularWrap,
        Droste,
        DisplacementDistortion,
        GlassDistortion,
        GlassLozenge,
        HoleDistortion,
        LightTunnel,
        PinchDistortion,
        StretchCrop,
        TorusLensDistortion,
        TwirlDistortion]
    
    //MARK:- CICategoryHalftoneEffect

    case CircularScreen = "CICircularScreen"
    case CMYKHalftone = "CICMYKHalftone"
    case DotScreen = "CIDotScreen"
    case HatchedScreen = "CIHatchedScreen"
    case LineScreen = "CILineScreen"
    
    static private let halftoneEffectFilters: [BKFilterType] = [
        CircularScreen,
        CMYKHalftone,
        DotScreen,
        HatchedScreen,
        LineScreen]
    
    //MARK:- CICategoryTileEffect

    //TODO: Some distorion effets require additional input to th CIFilter. Implement this.
    
    case AffineClamp = "CIAffineClamp"
    case AffineTile = "CIAffineTile"
    case EightfoldReflectedTile = "CIEightfoldReflectedTile"
    case FourfoldReflectedTile = "CIFourfoldReflectedTile"
    case FourfoldRotatedTile = "CIFourfoldRotatedTile"
    case FourfoldTranslatedTile = "CIFourfoldTranslatedTile"
    case GlideReflectedTile = "CIGlideReflectedTile"
    case Kaleidoscope = "CIKaleidoscope"
    case OpTile = "CIOpTile"
    case ParallelogramTile = "CIParallelogramTile"
    case PerspectiveTile = "CIPerspectiveTile"
    case SixfoldReflectedTile = "CISixfoldReflectedTile"
    case SixfoldRotatedTile = "CISixfoldRotatedTile"
    case TriangleKaleidoscope = "CITriangleKaleidoscope"
    case TriangleTile = "CITriangleTile"
    case TwelvefoldReflectedTile = "CITwelvefoldReflectedTile"
    
    static private let tileEffectFilters: [BKFilterType] = [
        AffineClamp,
        AffineTile,
        EightfoldReflectedTile,
        FourfoldReflectedTile,
        FourfoldRotatedTile,
        FourfoldTranslatedTile,
        GlideReflectedTile,
        Kaleidoscope,
        OpTile,
        ParallelogramTile,
        PerspectiveTile,
        SixfoldReflectedTile,
        SixfoldRotatedTile,
        TriangleKaleidoscope,
        TriangleTile,
        TwelvefoldReflectedTile]
    
    //MARK:- CICategoryStylize
    
    //TODO: Some distorion effets require additional input to th CIFilter. Implement this.

    case BlendWithAlphaMask = "CIBlendWithAlphaMask"
    case BlendWithMask = "CIBlendWithMask"
    case Bloom = "CIBloom"
    case ComicEffect = "CIComicEffect"
    case Convolution3X3 = "CIConvolution3X3"
    case Convolution5X5 = "CIConvolution5X5"
    case Convolution7X7 = "CIConvolution7X7"
    case Convolution9Horizontal = "CIConvolution9Horizontal"
    case Convolution9Vertical = "CIConvolution9Vertical"
    case Crystallize = "CICrystallize"
    case DepthOfField = "CIDepthOfField"
    case Edges = "CIEdges"
    case EdgeWork = "CIEdgeWork"
    case Gloom = "CIGloom"
    case HeightFieldFromMask = "CIHeightFieldFromMask"
    case HexagonalPixellate = "CIHexagonalPixellate"
    case HighlightShadowAdjust = "CIHighlightShadowAdjust"
    case LineOverlay = "CILineOverlay"
    case Pixellate = "CIPixellate"
    case Pointillize = "CIPointillize"
    case ShadedMaterial = "CIShadedMaterial"
    case SpotColor = "CISpotColor"
    case SpotLight = "CISpotLight"

    static private let stylizeFilters: [BKFilterType] = [
        BlendWithAlphaMask,
        BlendWithMask,
        Bloom,
        ComicEffect,
        Convolution3X3,
        Convolution5X5,
        Convolution7X7,
        Convolution9Horizontal,
        Convolution9Vertical,
        Crystallize,
        DepthOfField,
        Edges,
        EdgeWork,
        Gloom,
        HeightFieldFromMask,
        HexagonalPixellate,
        HighlightShadowAdjust,
        LineOverlay,
        Pixellate,
        Pointillize,
        ShadedMaterial,
        SpotColor,
        SpotLight]
}