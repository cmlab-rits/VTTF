
import UIKit


public extension UIButton {

    
    /**
     
     簡易版イニシャライザ
     
     - parameters:
        - title: ボタンのタイトル
        - titleColor: ボタンのタイトルの文字色
     
     */
    public convenience init(_ title: String, _ titleColor: UIColor? = nil) {
        self.init()
        
        if let titleColor: UIColor = titleColor {
            self.setTitleColor(titleColor, for: UIControlState.normal)
        }
        self.setTitle(title, for: UIControlState.normal)
        self.showsTouchWhenHighlighted = true
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.titleLabel?.minimumScaleFactor = 0.1
    }
}
