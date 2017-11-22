
import UIKit


public extension NSDictionary {
    
    
    /**
     
     object(forKey:) の短縮版
     
     */
    public func object(_ key: Any) -> Any? {
        return object(forKey: key)
    }

}
