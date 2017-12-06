//
//  NandemoExtenstion.swift
//  ColorCoordinate
//
//  Created by Yuki Takeda on 2017/09/15.
//  Copyright © 2017年 teakun. All rights reserved.
//

import Foundation
import UIKit

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

//
//  UIViewControllerExtension.swift
//  ColorCoordinate
//
//  Created by Yuki Takeda on 2017/05/29.
//  Copyright © 2017年 teakun. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    func getForegroundAlertController() -> UIAlertController? {

        var viewController = UIApplication.shared.keyWindow?.rootViewController
        while let controller = viewController?.presentedViewController {
            if controller is UIAlertController {
                viewController = controller
                break
            }
        }

        guard let alert = viewController as? UIAlertController else {
            return nil
        }
        return alert

    }
}


protocol StoryBoardInstantiatable {}
extension UIViewController: StoryBoardInstantiatable {}

extension StoryBoardInstantiatable where Self: UIViewController {
    static func instantiate() -> Self {
        let storyboard = UIStoryboard(name: self.className, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: self.className) as! Self
    }

    static func instantiate(withStoryboard storyboard: String) -> Self {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: self.className) as! Self
    }
}

extension UITableView {
    func register<T: UITableViewCell>(cellType: T.Type) {
        let className = cellType.className
        let nib = UINib(nibName: className, bundle: nil)
        register(nib, forCellReuseIdentifier: className)
    }

    func register<T: UITableViewCell>(cellTypes: [T.Type]) {
        cellTypes.forEach { register(cellType: $0) }
    }

    func dequeueReusableCell<T: UITableViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: type.className, for: indexPath) as! T
    }
}

extension UICollectionView {
    func register<T: UICollectionViewCell>(cellType: T.Type) {
        let className = cellType.className
        let nib = UINib(nibName: className, bundle: nil)
        register(nib, forCellWithReuseIdentifier: className)
    }

    func register<T: UICollectionViewCell>(cellTypes: [T.Type]) {
        cellTypes.forEach { register(cellType: $0) }
    }

    func register<T: UICollectionReusableView>(reusableViewType: T.Type, of kind: String = UICollectionElementKindSectionHeader) {
        let className = reusableViewType.className
        let nib = UINib(nibName: className, bundle: nil)
        register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: className)
    }

    func register<T: UICollectionReusableView>(reusableViewTypes: [T.Type], kind: String = UICollectionElementKindSectionHeader) {
        reusableViewTypes.forEach { register(reusableViewType: $0, of: kind) }
    }

    func dequeueReusableCell<T: UICollectionViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: type.className, for: indexPath) as! T
    }

    func dequeueReusableView<T: UICollectionReusableView>(with type: T.Type, for indexPath: IndexPath, of kind: String = UICollectionElementKindSectionHeader) -> T {
        return dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: type.className, for: indexPath) as! T
    }
}

protocol NibInstantiatable {}
extension UIView: NibInstantiatable {}

extension NibInstantiatable where Self: UIView {
    static func instantiate(withOwner ownerOrNil: Any? = nil) -> Self {
        let nib = UINib(nibName: self.className, bundle: nil)
        return nib.instantiate(withOwner: ownerOrNil, options: nil)[0] as! Self
    }
}
