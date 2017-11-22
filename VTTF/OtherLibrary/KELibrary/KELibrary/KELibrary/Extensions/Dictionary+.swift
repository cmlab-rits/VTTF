
import UIKit


public extension Dictionary {
    
    
    public func writeTo(_ file: String, atomically: Bool) -> Bool {
        return (self as NSDictionary).write(toFile: file, atomically: atomically)
    }
}
