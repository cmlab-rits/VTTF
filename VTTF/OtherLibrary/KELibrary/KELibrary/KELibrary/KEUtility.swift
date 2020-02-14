
import UIKit


/*
 
 右辺が nil でない場合のみ代入する代入式
 
 */
infix operator ?=
public func ?=<T>(l: inout T, r: T?) {
    if let rr: T = r {
        l = rr
    }
}
infix operator ?<-
public func ?<-<T>(l: inout T, r: T?) -> T {
    if let rr: T = r {
        l = rr
    }
    return l
}


/*
 
 代入された値を返す代入式
 
 */
precedencegroup ArrowAssignment {
    assignment: true
    higherThan: BitwiseShiftPrecedence
}
infix operator <- : ArrowAssignment
@discardableResult public func <-<T>(l: inout T, r: T) -> T {
    l = r
    return l
}
@discardableResult public func <-<T>(l: inout T?, r: T?) -> T? {
    l = r
    return l
}


/* ローカルスコープ */
public func local(_ block: ()->()) {
    block()
}



/* 文字列のローカライズ */
public func localized(_ key: String, comment: String = "") -> String {
    return NSLocalizedString(key, comment: comment)
}
public func localized(_ key: String, tableName: String, comment: String = "") -> String {
    return NSLocalizedString(key, tableName: tableName, comment: comment)
}


/* ステータスバーの高さ */
public var StatusBarHeight: CGFloat {
    return UIApplication.shared.statusBarFrame.height
}
/* タブバーの高さ */
public func TabBarHeight( _ controller: UIViewController ) -> CGFloat? {
    return controller.tabBarController?.tabBar.frame.height
}


/* メインスレッドで実行 */
public func dispatchOnMainThreadAfter(_ delay: Double = 0, _ block: @escaping ()->()) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute: block)
}
public func dispatchOnMainThread(_ block: @escaping ()->()) {
    DispatchQueue.main.async(execute: block)
}


/* バックグラウンドスレッドで実行 */
public func dispatchOnBackground(_ block: @escaping ()->()) {
    OperationQueue().addOperation(block)
}
public func dispatchOnBackgrounds(_ blocks: ()->()...) {
    let queue: OperationQueue = OperationQueue()
    
    for block: ()->() in blocks {
        queue.addOperation(block)
    }
}


/* スレッドのシンクロを行う */
public func sync(_ lock: AnyObject, _ block: @escaping ()->()) {
    objc_sync_enter(lock)
    block()
    objc_sync_exit(lock)
}
public func sync(_ block: @escaping ()->()) {
    struct LocalHolder {
        static let Lock: NSObject = NSObject()
    }
    sync(LocalHolder.Lock, block)
}


/** 実行環境が phone の場合のみ処理を行う */
public func phone(_ block: @escaping ()->()) {
    if KEUtility.interface == UIUserInterfaceIdiom.phone {
        block()
    }
}
/** 実行環境が pad の場合のみ処理を行う */
public func pad(_ block: @escaping ()->()) {
    if KEUtility.interface == UIUserInterfaceIdiom.pad {
        block()
    }
}
public func pop<T>(phone: @escaping ()->T, pad: @escaping ()->T) -> T? {
    switch KEUtility.interface {
        case UIUserInterfaceIdiom.phone: return phone()
        case UIUserInterfaceIdiom.pad: return pad()
        default: return nil
    }
}


/**
 
 汎用
 
 */
public class KEUtility {

    
    /**
     
     保存先のパス
     
     */
    public static let fileDirectory: String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first! + "/"
    
    
    /**
     
     アプリのバージョン
     
     */
    public static var version: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    
    
    /**
     
     アプリのバージョンとビルド番号
     
     */
    public static var build: String = "\(KEUtility.version).\(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "")"
    
    
    /* launch flag */
    private static let _kittengine_KeyOfRun    : String = "key._kittengine_run"
    private static let _kittengine_KeyOfVersion: String = "key._kittengine_version"
    private static let _kittengine_KeyOfBuild  : String = "key._kittengine_build"
    /** アプリが初めて起動されたかどうか */
    public static var isFirstRun: Bool = {
        let userDefaults: UserDefaults = UserDefaults.standard
        let flag        : Bool         = !userDefaults.bool(forKey: KEUtility._kittengine_KeyOfRun)

        userDefaults.set( true, forKey: KEUtility._kittengine_KeyOfRun )
        userDefaults.synchronize()
        
        return flag
    }()
    /** このバージョンのアプリが初めて起動されたかどうか */
    public static var isFirstRunInVersion: Bool = {
        let version     : String       = KEUtility.version
        let userDefaults: UserDefaults = UserDefaults.standard
        let flag        : Bool         = userDefaults.object(forKey: KEUtility._kittengine_KeyOfVersion) as? String != version
        
        userDefaults.set(version, forKey: KEUtility._kittengine_KeyOfVersion)
        userDefaults.synchronize()
        
        return flag
    }()
    /** このビルドバージョンのアプリが初めて起動されたかどうか */
    public static var isFirstRunInBuild: Bool = {
        let build       : String       = KEUtility.build
        let userDefaults: UserDefaults = UserDefaults.standard
        let flag        : Bool         = userDefaults.object(forKey: KEUtility._kittengine_KeyOfBuild) as? String != build
        
        userDefaults.set(build, forKey: KEUtility._kittengine_KeyOfBuild)
        userDefaults.synchronize()
        
        return flag
    }()

    
    /** 最前面に表示されているビューコントローラ */
    public static var topViewController: UIViewController? {
        var top: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
        
        while top?.presentedViewController != nil {
            top = top?.presentedViewController
        }
        
        return top
    }
    
    
    /** OSで使用されている言語 */
    public static let currentLanguage: String = NSLocale.preferredLanguages.first!
    
    
    /**　実行されている端末　*/
    public static let interface: UIUserInterfaceIdiom = UIDevice.current.userInterfaceIdiom
    
    
    private init() {}
}

