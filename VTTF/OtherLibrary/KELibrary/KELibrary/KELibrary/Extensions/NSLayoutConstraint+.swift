
import UIKit

@available(iOS 6.0, *)
public extension NSLayoutConstraint {
    
    
    /**
     
     アクティブにする
     
     */
    public func activate() {
        self.isActive = true
    }
    
    
    /**
     
     非アクティブにする
     
     */
    public func inactivate() {
        self.isActive = false
    }
}
