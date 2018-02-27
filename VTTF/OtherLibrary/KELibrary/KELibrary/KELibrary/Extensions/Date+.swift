
import UIKit


public extension Date {
    
    
    public func string(_ widthFormat: DateFormatter) -> String {
        return widthFormat.string(from: self)
    }
    
    public func string(_ withFormatString: String) -> String {
        return self.string(DateFormatter(withFormatString))
    }
}
