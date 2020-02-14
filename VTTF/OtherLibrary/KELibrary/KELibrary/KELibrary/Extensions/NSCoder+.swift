
import UIKit


public extension NSCoder {
    
    
    public func encodeEnum<T: EnumCodable>(_ enumv: T, forKey: String) where T.RawValue == Int {
        self.encode(enumv.rawValue, forKey: forKey)
    }
    
    public func encodeEnum<T: EnumCodable>(_ enumv: T, forKey: String) where T.RawValue == CGFloat {
        self.encode(Double(enumv.rawValue), forKey: forKey)
    }
    
    public func encodeEnum<T: EnumCodable>(_ enumv: T, forKey: String) where T.RawValue == String {
        self.encode(enumv.rawValue, forKey: forKey)
    }
    
    
    public func decodeEnum<T: EnumCodable>(forKey: String, type: T.Type) -> T? where T.RawValue == Int {
        return T.init(rawValue: self.decodeInteger(forKey: forKey))
    }
    
    public func decodeEnum<T: EnumCodable>(forKey: String, type: T.Type) -> T? where T.RawValue == CGFloat {
        return T.init(rawValue: CGFloat(self.decodeDouble(forKey: forKey)))
    }
    
    public func decodeEnum<T: EnumCodable>(forKey: String, type: T.Type) -> T? where T.RawValue == String {
        if let s: String = self.decodeObject(forKey: forKey) as? String {
            return T.init(rawValue: s)
        }
        
        return nil
    }
    
    
    public func encodeEnums<T: EnumCodable>(_ enumv: [T], forKey: String) {
        var array: [T.RawValue] = []
        
        for v: T in enumv {
            array.append(v.rawValue)
        }
        
        self.encode(array, forKey: forKey)
    }
    
    public func decodeEnums<T: EnumCodable>(forKey: String, type: T.Type) -> [T]? {
        if let raws: [T.RawValue] = self.decodeObject(forKey: forKey) as? [T.RawValue] {
            var enums: [T] = []
            
            for raw: T.RawValue in raws {
                if let e: T = T.init(rawValue: raw) {
                    enums.append(e)
                }
            }
            
            return enums
        }
        
        return nil
    }
    
    
}
