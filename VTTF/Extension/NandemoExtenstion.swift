//
//  NandemoExtenstion.swift
//  ColorCoordinate
//
//  Created by Yuki Takeda on 2017/09/15.
//  Copyright © 2017年 teakun. All rights reserved.
//

import Foundation
import UIKit
import KELibrary

extension Int {
    var cgFloat: CGFloat{
        return CGFloat( self )
    }
}

extension UIView {
    public var midPoint: CGPoint {
        get { return CGPoint(x: self.midX, y: self.midY) }
        set {
            self.midX = newValue.x
            self.midY = newValue.y
        }
    }
}
extension UIImage {
    func averageColor() -> UIColor? {
        if let cgImage = self.cgImage, let averageFilter = CIFilter(name: "CIAreaAverage") {
            let ciImage = CIImage(cgImage: cgImage)
            let extent = ciImage.extent
            let ciExtent = CIVector(x: extent.origin.x, y: extent.origin.y, z: extent.size.width, w: extent.size.height)
            averageFilter.setValue(ciImage, forKey: kCIInputImageKey)
            averageFilter.setValue(ciExtent, forKey: kCIInputExtentKey)
            if let outputImage = averageFilter.outputImage {
                let context = CIContext(options: nil)
                var bitmap = [UInt8](repeating: 0, count: 4)
                context.render(outputImage,
                               toBitmap: &bitmap,
                               rowBytes: 4,
                               bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
                               format: kCIFormatRGBA8,
                               colorSpace: CGColorSpaceCreateDeviceRGB())

                return UIColor(red: CGFloat(bitmap[0]) / 255.0, green: CGFloat(bitmap[1]) / 255.0, blue: CGFloat(bitmap[2]) / 255.0, alpha: 1.0)
            }
        }
        return nil
    }
}
