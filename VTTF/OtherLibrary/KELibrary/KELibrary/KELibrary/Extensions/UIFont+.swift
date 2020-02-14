
import UIKit
import CoreGraphics


public extension UIFont {
    
    
    public class func awesomeFontOfSize(_ size: CGFloat) -> UIFont {
        struct Local {
            static let font: UIFont = {
                UIFont.loadFontWithName("fontawesome")
                return UIFont(name: "fontawesome", size: UIFont.labelFontSize)!
            }()
        }
        
        return Local.font.withSize(size)
    }
    
    
    public class func mplus1pLightFontOfSize(_ size: CGFloat) -> UIFont {
        struct Local {
            static let font: UIFont = {
                UIFont.loadFontWithName("mplus-1p-light")
                return UIFont(name: "mplus-1p-light", size: UIFont.labelFontSize)!
            }()
        }
        
        return Local.font.withSize(size)
    }
    
    
    public class func mplus1pRegularFontOfSize(_ size: CGFloat) -> UIFont {
        struct Local {
            static let font: UIFont = {
                UIFont.loadFontWithName("mplus-1p-regular")
                return UIFont(name: "mplus-1p-regular", size: UIFont.labelFontSize)!
            }()
        }
        
        return Local.font.withSize(size)
    }
    
    
    public static let awesomeFont: UIFont = UIFont.awesomeFontOfSize(UIFont.labelFontSize)
    public static let mplus1pLightFont: UIFont = UIFont.mplus1pLightFontOfSize(UIFont.labelFontSize)
    public static let mplus1pRegularFont: UIFont = UIFont.mplus1pRegularFontOfSize(UIFont.labelFontSize)
    
    
    private class func loadFontWithName(_ name: String) {
        let bundleURL: URL = Bundle(for: KEUtility.self).url(forResource: "KEFont", withExtension: "bundle")!
        let bundle: Bundle = Bundle(url: bundleURL)!
        let fontURL: URL = bundle.url(forResource: name, withExtension: "ttf")!
        let fontData: Data = try! Data(contentsOf: fontURL)
        
        let provider: CGDataProvider = CGDataProvider(data: fontData as CFData)!
        let font: CGFont = CGFont(provider)!
        
        CTFontManagerRegisterGraphicsFont(font, nil)
    }
}
