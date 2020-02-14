
import UIKit


public extension DateFormatter {
    
    
    convenience init(_ dateFormat: String) {
        self.init()
        self.dateFormat = dateFormat
    }
}
