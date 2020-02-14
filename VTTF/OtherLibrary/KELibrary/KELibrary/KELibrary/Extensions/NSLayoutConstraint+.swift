
import UIKit

@available(iOS 6.0, *)
public extension NSLayoutConstraint {
    
    
    /**
     
     アクティブにする
     
     */
    func activate() {
        self.isActive = true
    }
    
    
    /**
     
     非アクティブにする
     
     */
    func inactivate() {
        self.isActive = false
    }
}
