
import UIKit


public extension String {
    
    
    /**
     
     文字列をローカライズする
     
     - returns: ローカライズされた文字列
     
     */
    public func localize() -> String {
        return NSLocalizedString(self, comment: "")
    }
    
    
    /**
     
     文字列をローカライズする
     
     - parameter tableName: ローカライズに用いるテーブル
     
     - returns: ローカライズされた文字列
     
     */
    public func localize(_ tableName: String) -> String {
        return NSLocalizedString(self, tableName: tableName, comment: "")
    }
    
    
    /**
     
     文字列をURLに変換する
     
     */
    public var url: URL? {
        return URL(string: self)
    }
    
    
    /* NSString で実装されていたプロパティ */
    public var NSString: NSString { return self as NSString }
    public var pathComponents           : [String] { return self.NSString.pathComponents            }
    public var lastPathComponent        : String   { return self.NSString.lastPathComponent         }
    public var pathExtension            : String   { return self.NSString.pathExtension             }
    public var deletingPathExtension    : String   { return self.NSString.deletingPathExtension     }
    public var deletingLastPathComponent: String   { return self.NSString.deletingLastPathComponent }
    public func appendingPathComponent( _ str: String ) -> String  { return self.NSString.appendingPathComponent(str) }
    public func appendingPathExtension( _ str: String ) -> String? { return self.NSString.appendingPathExtension(str) }
    
    
    /**
     
     文字列を分割する
     
     - parameter separatedBy: 区切り文字
     
     - returns: 分割された文字列の配列
     
     */
    public func split(_ separatedBy: String) -> [String] {
        return self.components(separatedBy: separatedBy)
    }
}

