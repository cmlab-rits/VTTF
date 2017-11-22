
import UIKit


open class KEViewController: UIViewController {
    
    
    public lazy var contentView: UIView = UIView()
    
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.contentView)
    }
    
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.contentView.frame = CGRect(0.0, self.topLayoutGuide.length, self.view.frame.width, self.view.frame.height - self.topLayoutGuide.length - self.bottomLayoutGuide.length)
        
        self.viewDidLayoutSubviews(rect: self.contentView.frame)
    }
    
    
    /**
     
     ビューがレイアウトされるべきタイミングで呼ばれる
     
     - parameter rect: ビューの表示領域
     
     */
    open func viewDidLayoutSubviews(rect: CGRect) {}
}
