//
//  UIViewExtension.swift
//  VTTF
//
//  Created by Yuki Takeda on 2017/09/08.
//  Copyright © 2017年 cm.is.ritsumei.ac.jp. All rights reserved.
//


import UIKit

public extension UIView {


    /**

     ビューのサイズ

     */
    public var size: CGSize {
        get { return self.frame.size }
        set { self.frame = CGRect(self.x, self.y, newValue.width, newValue.height) }
    }


    /**

     ビューの座標

     */
    public var origin: CGPoint {
        get { return self.frame.origin }
        set { self.frame = CGRect(newValue.x, newValue.y, self.width, self.height) }
    }


    /**

     ビューの幅

     */
    public var width : CGFloat {
        get { return self.frame.width }
        set { self.frame = CGRect(self.x, self.y, newValue, self.height) }
    }


    /**

     ビューの高さ

     */
    public var height: CGFloat {
        get { return self.frame.height }
        set { self.frame = CGRect(self.x, self.y, self.width, newValue) }
    }


    /**

     ビューのx座標

     */
    public var x: CGFloat {
        get { return self.frame.origin.x }
        set { self.frame = CGRect(newValue, self.y, self.width, self.height) }
    }


    /**

     ビューのy座標

     */
    public var y: CGFloat {
        get { return self.frame.origin.y }
        set { self.frame = CGRect(self.x, newValue, self.width, self.height) }
    }


    /**

     ビューの底のy座標

     */
    public var maxX: CGFloat {
        return self.frame.maxX
    }


    /**

     ビューの右側のx座標

     */
    public var maxY: CGFloat {
        return self.frame.maxY
    }


    /**

     ビューの中央のx座標

     */
    public var midX: CGFloat {
        get { return self.frame.midX }
        set { self.frame = CGRect(newValue - self.width/2.0, self.y, self.width, self.height) }
    }


    /**

     ビューの中央のy座標

     */
    public var midY: CGFloat {
        get { return self.frame.midY }
        set { self.frame = CGRect(self.x, newValue - self.height/2.0, self.width, self.height) }
    }


    /**

     全てのサブビューを削除する

     */
    public func removeAllSubviews() {
        self.subviews.forEach { (view: UIView) in
            view.removeFromSuperview()
        }
    }


    /**

     複数のサブビューを追加する

     - parameter views: 追加するビューの配列

     */
    public func addSubviews(_ views: [UIView]) {
        views.forEach { (view: UIView) in
            self.addSubview(view)
        }
    }


    /**

     ビューのスクリーンショットを取得する

     - parameter scale: スクリーンショットのスケール

     - returns: スクリーンショットのイメージ

     */
    public func screenShot(scale: CGFloat) -> UIImage? {
        let imageBounds: CGRect = CGRect(0, 0, self.width * scale, self.bounds.size.height * scale)

        UIGraphicsBeginImageContextWithOptions(imageBounds.size, true, 0)

        self.drawHierarchy(in: imageBounds, afterScreenUpdates: true)

        var image: UIImage?
        if let contextImage: UIImage = UIGraphicsGetImageFromCurrentImageContext(), let cgImage: CGImage = contextImage.cgImage {
            image = UIImage(cgImage: cgImage, scale: UIScreen.main.scale, orientation: contextImage.imageOrientation)
        }

        UIGraphicsEndImageContext()

        return image
    }


    /**

     translatesAutoresizingMaskIntoConstraints を一括で設定する

     - parameters:
     - views: 設定するビュー
     - autoresize: 設定する値
     */
    public class func translatesAutoresizingMaskIntoConstraints(_ views: [UIView], autoresize: Bool) {
        views.forEach { (view: UIView) in
            view.translatesAutoresizingMaskIntoConstraints = autoresize
        }
    }
}




public extension CGRect {


    public var x: CGFloat { return self.origin.x }
    public var y: CGFloat { return self.origin.y }


    public var center: CGPoint {
        return CGPoint(self.midX, self.midY)
    }


    public init(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) {
        self.init(x: x, y: y, width: width, height: height)
    }
}

public extension CGPoint {


    public init(_ x: CGFloat, _ y: CGFloat) {
        self.init(x: x, y:y)
    }
}


