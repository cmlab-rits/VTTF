
import UIKit


public extension String {
    
    
    /**
     
     文字列をローカライズする
     
     - returns: ローカライズされた文字列
     
     */
    func localize() -> String {
        return NSLocalizedString(self, comment: "")
    }
    
    
    /**
     
     文字列をローカライズする
     
     - parameter tableName: ローカライズに用いるテーブル
     
     - returns: ローカライズされた文字列
     
     */
    func localize(_ tableName: String) -> String {
        return NSLocalizedString(self, tableName: tableName, comment: "")
    }
    
    
    /**
     
     文字列をURLに変換する
     
     */
    var url: URL? {
        return URL(string: self)
    }
    
    
    /* NSString で実装されていたプロパティ */
    var NSString: NSString { return self as NSString }
    var pathComponents           : [String] { return self.NSString.pathComponents            }
    var lastPathComponent        : String   { return self.NSString.lastPathComponent         }
    var pathExtension            : String   { return self.NSString.pathExtension             }
    var deletingPathExtension    : String   { return self.NSString.deletingPathExtension     }
    var deletingLastPathComponent: String   { return self.NSString.deletingLastPathComponent }
    func appendingPathComponent( _ str: String ) -> String  { return self.NSString.appendingPathComponent(str) }
    func appendingPathExtension( _ str: String ) -> String? { return self.NSString.appendingPathExtension(str) }
    
    
    /**
     
     文字列を分割する
     
     - parameter separatedBy: 区切り文字
     
     - returns: 分割された文字列の配列
     
     */
    func split(_ separatedBy: String) -> [String] {
        return self.components(separatedBy: separatedBy)
    }
}

