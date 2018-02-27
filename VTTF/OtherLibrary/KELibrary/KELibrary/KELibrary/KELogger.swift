import UIKit


public let Logger: KELogger? = KELogger()



public enum LogLevel: Int, Comparable {
    
    
    case Verbose = 1
    case Debug
    case Info
    case Warning
    case Error
    case None
    
    
    public var description: String {
        switch self {
        case LogLevel.Verbose: return "Verbose"
        case LogLevel.Debug  : return "Debug"
        case LogLevel.Info   : return "Info"
        case LogLevel.Warning: return "Warning"
        case LogLevel.Error  : return "Error"
        case LogLevel.None   : return "None"
        }
    }
    
    
    public var initial: String {
        let d: String = self.description
        
        return String(d[d.startIndex])
    }
    
    
    public static func <(l: LogLevel, r: LogLevel) -> Bool {
        return l.rawValue < r.rawValue
    }
    public static func ==(l: LogLevel, r: LogLevel) -> Bool {
        return l.rawValue == r.rawValue
    }
}


public class KELogger {
    
    
    /** 出力するログの最低レベル */
    public var logLevel: LogLevel = LogLevel.Verbose
    
    
    /** 日付を表示するかどうか */
    public var showsDate: Bool = false
    
    /** 時間を表示するかどうか */
    public var showsTime: Bool = true
    
    /** 呼び出し元のファイル名を表示するかどうか */
    public var showsFile: Bool = true
    
    /** 呼び出し元の関数名を表示するかどうか */
    public var showsFunction: Bool = true
    
    /** 呼び出し元の関数の引数名を表示するかどうか */
    public var showsArgumentLabel: Bool = false
    
    /** 呼び出し元の行番号を表示するかどうか */
    public var showsLine: Bool = true
    
    /** ログレベルを表示するかどうか */
    public var showsLogLevel: Bool = true
    
    
    /** 日付のフォーマット */
    public var dateFormatter: DateFormatter = DateFormatter("yyyy-MM-dd")
    
    /** 時間のフォーマット */
    public var timeFormatter: DateFormatter = DateFormatter("HH:mm:ss")
    
    
    /** verboseログの出力先 */
    public var vStream: ((LogLevel, String, Any)->())?
    /** debugログの出力先 */
    public var dStream: ((LogLevel, String, Any)->())?
    /** infoログの出力先 */
    public var iStream: ((LogLevel, String, Any)->())?
    /** warningログの出力先 */
    public var wStream: ((LogLevel, String, Any)->())?
    /** errorログの出力先 */
    public var eStream: ((LogLevel, String, Any)->())?
    
    
    /** ログ出力用のview */
    public let logView: KELogView = KELogView()
    
    
    public init() {
        self.setStream(self.standardOutput)
    }
    
    
    /**
     
     全ログレベルの出力先を変更する
     
     - parameter stream: 出力先
     
     */
    public func setStream(_ stream: ((LogLevel, String, Any)->())?) {
        self.vStream = (self.dStream <- (self.iStream <- (self.wStream <- (self.eStream <- stream))))
    }
    
    
    /** verboseログを出力する */
    public func v(_ body: Any = "", file: String = #file, function: String = #function, line: Int = #line) {
        if self.logLevel <= LogLevel.Verbose {
            self.vStream?(LogLevel.Verbose, self.header(LogLevel.Verbose, file, function, line), body)
        }
    }
    
    /** debugログを出力する */
    public func d(_ body: Any = "", file: String = #file, function: String = #function, line: Int = #line) {
        if self.logLevel <= LogLevel.Debug {
            self.dStream?(LogLevel.Debug, self.header(LogLevel.Debug, file, function, line), body)
        }
    }
    
    /** infoログを出力する */
    public func i(_ body: Any = "", file: String = #file, function: String = #function, line: Int = #line) {
        if self.logLevel <= LogLevel.Info {
            self.iStream?(LogLevel.Info, self.header(LogLevel.Info, file, function, line), body)
        }
    }
    
    /** warningログを出力する */
    public func w(_ body: Any = "", file: String = #file, function: String = #function, line: Int = #line) {
        if self.logLevel <= LogLevel.Warning {
            self.wStream?(LogLevel.Warning, self.header(LogLevel.Warning, file, function, line), body)
        }
    }
    
    /** errorログを出力する */
    public func e(_ body: Any = "", file: String = #file, function: String = #function, line: Int = #line) {
        if self.logLevel <= LogLevel.Error {
            self.eStream?(LogLevel.Error, self.header(LogLevel.Error, file, function, line), body)
        }
    }
    
    
    private func header(_ logLevel: LogLevel, _ file: String, _ function: String, _ line: Int) -> String {
        var header: String = ""
        
        if self.showsDate || self.showsTime {
            let date: Date = Date()
            header += "["
            if self.showsDate {
                header += "\(date.string(self.dateFormatter))\(self.showsTime ? " " : "")"
            }
            if self.showsTime {
                header += date.string(self.timeFormatter)
            }
            header += "]"
        }
        
        if self.showsFile {
            header += "\(file.deletingPathExtension.lastPathComponent)"
        }
        
        if self.showsFunction {
            let funcs: [String] = function.split("(")
            header += ".\(funcs.first!)"
            if self.showsArgumentLabel && funcs.count >= 2 {
                header += "(\(funcs[1])"
            }
        }
        
        if self.showsLine {
            header += ":\(line)"
        }
        
        if self.showsLogLevel {
            header += " [\(logLevel.initial)]"
        }
        
        return header
    }
    
    
    /** 標準出力 */
    public func standardOutput(_ logLevel: LogLevel, header: String, body: Any) {
        print("\(header) \(body)")
    }
    
    /** view出力 */
    public func logViewOutput(_ logLevel: LogLevel, header: String, body: Any) {
        self.logView.logViewOutput(logLevel, header: header, body: body)
    }
}



public class KELogView: UIView {
    
    
    /** ログのフォント */
    public var logFont: UIFont = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
    
    
    /** ログのヘッダの色 */
    public var headerColor : UIColor = UIColor.silver
    
    /** ログレベル毎の色 */
    public var logColors: Dictionary<LogLevel, UIColor> = [
        LogLevel.Verbose: UIColor.white,
        LogLevel.Debug  : UIColor.peterRiver,
        LogLevel.Info   : UIColor.emerland,
        LogLevel.Warning: UIColor.carrot,
        LogLevel.Error  : UIColor.alizarin,
        LogLevel.None   : UIColor.black
    ]
    
    
    /** ログを表示するview */
    public let logTextView: UITextView = {
        let view: UITextView = UITextView()
        
        view.bounces = true
        view.alwaysBounceVertical = true
        view.indicatorStyle = UIScrollViewIndicatorStyle.white
        view.isEditable = false
        view.text = ""
        
        return view
    }()
    
    
    convenience public init() {
        self.init(frame: CGRect.zero)
        
        self.logTextView.backgroundColor = UIColor.black
        self.logTextView.font = self.logFont
 
        self.addSubview(self.logTextView)
    }
    
    
    override public func layoutSubviews() {
        self.logTextView.frame = CGRect(0.0, 0.0, self.frame.size.width, self.frame.size.height)
    }
    
    
    public func logViewOutput(_ logLevel: LogLevel, header: String, body: Any) {
        let isScroll: Bool = self.logTextView.contentOffset.y >= (self.logTextView.contentSize.height - self.logTextView.bounds.size.height - 30.0)
        
        let log: NSMutableAttributedString = NSMutableAttributedString(attributedString: self.logTextView.attributedText)
        log.append(self.attributedHeader("\n\(header)"))
        log.append(self.attributedBody(logLevel, " \(body)"))
        self.logTextView.attributedText = log
        
        if isScroll && self.logTextView.contentSize.height >= self.logTextView.bounds.size.height {
            self.logTextView.setContentOffset(CGPoint(0, self.logTextView.contentSize.height - self.logTextView.frame.size.height), animated: true)
        }
    }
    
    
    private func attributedHeader(_ header: String) -> NSAttributedString {
        return NSAttributedString(string: header, attributes: [
            NSAttributedStringKey.foregroundColor: self.headerColor,
            NSAttributedStringKey.font: self.logFont
            ])
    }
    
    
    private func attributedBody(_ logLevel: LogLevel, _ body: String) -> NSAttributedString {
        return NSAttributedString(string: body, attributes: [
            NSAttributedStringKey.foregroundColor: self.logColors[logLevel]!,
            NSAttributedStringKey.font: self.logFont
            ])
    }
}
