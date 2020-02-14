
import UIKit

public extension UIView {
    
    
    /**
     
     ビューのサイズ
     
     */
    var size: CGSize {
        get { return self.frame.size }
        set { self.frame = CGRect(self.x, self.y, newValue.width, newValue.height) }
    }
    
    
    /**
     
     ビューの座標
     
     */
    var origin: CGPoint {
        get { return self.frame.origin }
        set { self.frame = CGRect(newValue.x, newValue.y, self.width, self.height) }
    }
    
    
    /**
     
     ビューの幅
     
     */
    var width : CGFloat {
        get { return self.frame.width }
        set { self.frame = CGRect(self.x, self.y, newValue, self.height) }
    }
    
    
    /**
     
     ビューの高さ
     
     */
    var height: CGFloat {
        get { return self.frame.height }
        set { self.frame = CGRect(self.x, self.y, self.width, newValue) }
    }
    
    
    /**
     
     ビューのx座標
     
     */
    var x: CGFloat {
        get { return self.frame.origin.x }
        set { self.frame = CGRect(newValue, self.y, self.width, self.height) }
    }
    
    
    /**
     
     ビューのy座標
     
     */
    var y: CGFloat {
        get { return self.frame.origin.y }
        set { self.frame = CGRect(self.x, newValue, self.width, self.height) }
    }
    
    
    /**
     
     ビューの底のy座標
     
     */
    var maxX: CGFloat {
        return self.frame.maxX
    }
    
    
    /**
     
     ビューの右側のx座標
     
     */
    var maxY: CGFloat {
        return self.frame.maxY
    }
    
    
    /**
     
     ビューの中央のx座標
     
     */
    var midX: CGFloat {
        get { return self.frame.midX }
        set { self.frame = CGRect(newValue - self.width/2.0, self.y, self.width, self.height) }
    }
    
    
    /**
     
     ビューの中央のy座標
     
     */
    var midY: CGFloat {
        get { return self.frame.midY }
        set { self.frame = CGRect(self.x, newValue - self.height/2.0, self.width, self.height) }
    }
    
    
    /**
     
     全てのサブビューを削除する
     
     */
    func removeAllSubviews() {
        self.subviews.forEach { (view: UIView) in
            view.removeFromSuperview()
        }
    }
    
    
    /**
     
     複数のサブビューを追加する
     
     - parameter views: 追加するビューの配列
     
     */
    func addSubviews(_ views: [UIView]) {
        views.forEach { (view: UIView) in
            self.addSubview(view)
        }
    }
    
    
    /**
     
     nil でなければビューを追加する
     
     - parameter subview: 追加するサブビュー
     
     */
    func add(_ subview: UIView?) {
        if let v: UIView = subview {
            self.addSubview(v)
        }
    }
    
    
    /**
     
     ビューのスクリーンショットを取得する
     
     - parameter scale: スクリーンショットのスケール
     
     - returns: スクリーンショットのイメージ
     
     */
    func screenShot(scale: CGFloat) -> UIImage? {
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
    class func translatesAutoresizingMaskIntoConstraints(_ views: [UIView], autoresize: Bool) {
        views.forEach { (view: UIView) in
            view.translatesAutoresizingMaskIntoConstraints = autoresize
        }
    }
}

