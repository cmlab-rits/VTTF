
import UIKit


public extension NSObject {
    
    
    /**
     
     クラス名
     
     */
    public class var className: String {
        return String(describing: self)
    }

    
    /**
     
     クラス名
     
     */
    public var className: String {
        return type(of: self).className
    }
}
