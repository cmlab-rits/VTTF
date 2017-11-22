
import UIKit

public extension UIColor
{
    /**
     
     数字から色を生成する
     
     - parameter rgbValue: 
        色を表す数字
        16進数で2桁ずつ(透明度、R、G、B)を表す
     
     - returns: 生成された色
     
     */
    public class func colorFromHex(_ rgbValue: UInt) -> UIColor {
        return UIColor(
            red  : CGFloat((rgbValue & 0x00FF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x0000FF00) >>  8) / 255.0,
            blue : CGFloat( rgbValue & 0x000000FF)        / 255.0,
            alpha: CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0
        )
    }
    
    public static var turquoise   : UIColor { return UIColor.colorFromHex(0xFF1ABC9C) }
    public static var greenSea    : UIColor { return UIColor.colorFromHex(0xFF16A085) }
    public static var emerland    : UIColor { return UIColor.colorFromHex(0xFF2ECC71) }
    public static var nephritis   : UIColor { return UIColor.colorFromHex(0xFF27AE60) }
    public static var peterRiver  : UIColor { return UIColor.colorFromHex(0xFF3498DB) }
    public static var belizeHole  : UIColor { return UIColor.colorFromHex(0xFF2980B9) }
    public static var amethyst    : UIColor { return UIColor.colorFromHex(0xFF9B59B6) }
    public static var wisteria    : UIColor { return UIColor.colorFromHex(0xFF8E44AD) }
    public static var wetAsphalt  : UIColor { return UIColor.colorFromHex(0xFF34495E) }
    public static var midnightBlue: UIColor { return UIColor.colorFromHex(0xFF2C3E50) }
    public static var sunflower   : UIColor { return UIColor.colorFromHex(0xFFF1C40F) }
    public static var tangerine   : UIColor { return UIColor.colorFromHex(0xFFF39C12) }
    public static var carrot      : UIColor { return UIColor.colorFromHex(0xFFE67E22) }
    public static var pumpkin     : UIColor { return UIColor.colorFromHex(0xFFD35400) }
    public static var alizarin    : UIColor { return UIColor.colorFromHex(0xFFE74C3C) }
    public static var pomegranate : UIColor { return UIColor.colorFromHex(0xFFC0392B) }
    public static var clouds      : UIColor { return UIColor.colorFromHex(0xFFECF0F1) }
    public static var silver      : UIColor { return UIColor.colorFromHex(0xFFBDC3C7) }
    public static var concrete    : UIColor { return UIColor.colorFromHex(0xFF95A5A6) }
    public static var asbestos    : UIColor { return UIColor.colorFromHex(0xFF7F8C8D) }
}
