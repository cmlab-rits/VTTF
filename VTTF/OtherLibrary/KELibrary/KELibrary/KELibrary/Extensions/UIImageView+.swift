
import UIKit


public extension UIImageView{
    
    
    /**
     
     画像を非同期で読み込む
     
     - parameter url: 画像のURL
     
     */
    func loadImage(_ url: URL) {
        struct LocalHolder {
            static let AsyncLoadImageIdentifier: String = "UIImageView_async"
        }
        
        let conf: URLSessionConfiguration = URLSessionConfiguration.background(withIdentifier: UUID().uuidString)
        conf.requestCachePolicy = URLRequest.CachePolicy.returnCacheDataElseLoad
        
        URLDataSession(conf, url: url) { (data: Data?, error: Error?) in
            if let data: Data = data {
                dispatchOnMainThread {
                    self.image = UIImage(data: data)
                }
            }
        }
    }
}
