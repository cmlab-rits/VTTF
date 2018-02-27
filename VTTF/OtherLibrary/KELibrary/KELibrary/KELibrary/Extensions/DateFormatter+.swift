
import UIKit


public extension DateFormatter {
    
    
    public convenience init(_ dateFormat: String) {
        self.init()
        self.dateFormat = dateFormat
    }
}
