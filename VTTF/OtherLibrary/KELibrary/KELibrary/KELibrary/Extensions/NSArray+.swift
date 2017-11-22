
import UIKit


public extension NSArray {
    
    
    /**
     
     object(at: Int) の安全版
     
     */
    public func safeObject(_ at: Int) -> Any? {
        return at < self.count && at >= 0 ? self.object(at: at) : nil
    }
}
