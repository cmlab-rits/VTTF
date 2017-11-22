
import UIKit

public extension UITableView {
    
    
    /**
     
     セクションのセルを全て取得する
     
     - parameter section: セルを取得するセクション
     
     - returns: セクションに属する全てのセル
     
     */
    public func cellsForSection(_ section: Int) -> [UITableViewCell] {
        var cells: [UITableViewCell] = []
        var row: Int = 0
        
        while let cell: UITableViewCell = self.cellForRow(at: IndexPath(section, row)) {
            cells.append(cell)
            row += 1
        }
        
        return cells
    }
    
    
    /**
     
     dequeueReusableCell(withIdentifier:for:)の短縮版
     
     */
    public func dequeueReusableCell(_ identifier: String, indexPath: IndexPath) -> UITableViewCell {
        return self.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
    }
}
