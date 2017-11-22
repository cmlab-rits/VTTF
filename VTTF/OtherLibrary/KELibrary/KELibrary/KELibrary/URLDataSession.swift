
import UIKit


/**
 
 URLからデータをダウンロードする
 
 */
public class URLDataSession: NSObject, URLSessionDataDelegate {
    
    
    /**
     
     ダウンロード後のコールバック
     
     */
    public var callback: ((Data?, Error?)->())?
    
    
    /**
     
     インスタンスを生成すると同時にダウンロードを開始する
     
     - parameters:
        - configuration: ダウンロードのコンフィギュレーション
        - url: ダウンロードするデータのURL
        - completion: ダウンロード後に呼ばれるコールバック
     
     */
    @discardableResult public init(_ configuration: URLSessionConfiguration, url: URL, completion: @escaping (Data?, Error?)->()) {
        self.callback = completion
        
        super.init()
        
        URLSession(configuration: configuration, delegate: self, delegateQueue: nil).dataTask(with: url).resume()
    }
    
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        self.callback?(data, nil)
    }
    
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error: Error = error {
            self.callback?(nil, error)
        }
    }
}
