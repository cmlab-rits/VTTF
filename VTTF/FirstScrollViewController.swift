//
//  FirstScrollViewController.swift
//  VTTF
//
//  Created by Yusuke Takahahsi on 2017/10/04.
//  Copyright © 2017年 cm.is.ritsumei.ac.jp. All rights reserved.
//

import UIKit
import MultipeerConnectivity
//enum Direction {
//    case a
//    case b
//    case c
//    case d
//
//}

class FirstScrollViewController: UIViewController, UIScrollViewDelegate{
    private let manager = SocketManager.sharedInstance
    fileprivate let mcManager = MCManager.sharedInstance
    let scrollView = AppScrollView()
    var myLabel: UILabel!

    var testlabel: VttfLabel = VttfLabel()
    var labelList: [VttfLabel] = []
    private var taskLabelCount: Int = 15
    
    var direction: Direction = .front
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        mcManager.delegate = self
        
        scrollView.backgroundColor = UIColor.gray
        
        // 表示窓のサイズと位置を設定
        
        scrollView.frame.size = CGSize(width: 768, height: 1024)
        scrollView.center = self.view.center
        
        // 中身の大きさを設定
        scrollView.contentSize = CGSize(width: 2500, height: 1500)
        
        // スクロールの跳ね返り
        scrollView.bounces = false
        
        // スクロールバーの見た目と余白
        scrollView.indicatorStyle = .white
        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        scrollView.isUserInteractionEnabled = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = true
        // Delegate を設定
        scrollView.delegate = self
        
        self.view.addSubview(scrollView)
        makeLabel()
        mcManager.startManager()
    }
    
    func makeLabel() {
        for i in 0..<10 {
            let label = VttfLabel(frame: CGRect(origin:CGPoint(x: i*150,y:i*150),size:CGSize(width: 150, height: 150)))
            label.vc = self
            self.scrollView.addSubview(label)
            labelList.append(label)
//            mcManager.send(data: )
        }
    }
    
//    func convertPosition(point: CGPoint) -> CGPoint {
//        switch self.direction {
//        case .a:
//            return point
//        case .b:
//            return CGPoint (x: point.x, y: scrollView.size.height  - point.y)
//        case .c:
//            return CGPoint (x: scrollView.size.width - point.x, y: scrollView.size.height - point.y)
//        case .d:
//            return CGPoint (x: scrollView.size.width - point.x, y: point.y)
//        }
//    }
//        case a: {(point:CGPoint: (width:x,height:y)) -> CGPoint in return CGPoint(width:x,height:y)}
//        case b: = {(point:CGPoint: (width:x,heifht:y)) -> CGPoint in return CGPoint(width:x,height:height-y)}
//        case c: = {(point:CGPoint:(width:x,height:y)) -> CGPoint in return CGPoint(width:width-x,height:height-y)}
//        case d: = {(point:CGPoint:(width:x,height:y)) -> CGPoint in return CGPoint(width:width-x,width:y)}
        
        
    
    
    
//        // ScrollViewの中身を作る
//         for i in 1 ..< 10 {
//            let mylabel = UILabel()
//            mylabel.text = "LABEL\(i)"
//            mylabel.sizeToFit()
//            mylabel.backgroundColor = UIColor.blue
//            mylabel.center = CGPoint(x: 200 * i, y: 100 * i)
//            scrollView.addSubview(mylabel)
//            
//           }

        
        
        
        
    /*    self.view.addSubview(scrollView)
        
        myLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        myLabel.text = "Drag!"
        myLabel.textAlignment = NSTextAlignment.center
        myLabel.backgroundColor = UIColor.red
       // myLabel.layer.masksToBounds = true
        myLabel.center = self.view.center
        myLabel.layer.cornerRadius = 40.0
        myLabel.tag = 1
        myLabel.isUserInteractionEnabled = true
        // Labelをviewに追加.
        self.scrollView.addSubview(myLabel)

        }
        */
    

    
    /*
 
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesBegan")
    
    
        
   /*
        
        // タッチをやり始めた座標を取得
        let touch: UITouch = touches.first!
        let startPoint = touch.location(in: self.view)
        //print("startPoint =\(startPoint)")
        
        // タッチをやり始めた時のイメージの座標を取得
        _ = self.myLabel.frame.origin
        
        // イメージの範囲
        let MinX = myLabel!.x
        let MaxX = myLabel!.x + self.myLabel!.frame.width
        let MinY = myLabel!.y
        let MaxY = myLabel!.y + self.myLabel!.frame.height
        
        // イメージの範囲内をタッチした時のみisImageInsideをtrueにする
        var isImageInside: Bool = false
        if (MinX <= startPoint.x && startPoint.x <= MaxX) && (MinY <= startPoint.y && startPoint.y <= MaxY) {
            print("Inside of Image")
            isImageInside = true
            
        } else {
            print("Outside of Image")
            isImageInside = false
        }

      */
        
        
        // Labelアニメーション.
        UIView.animate(withDuration: 0.06,
                       // アニメーション中の処理.
            animations: { () -> Void in
                // 縮小用アフィン行列を作成する.
                self.myLabel.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        })
        { (Bool) -> Void in
        }
    }
    /*
     ドラッグを感知した際に呼ばれるメソッド.
     (ドラッグ中何度も呼ばれる)
     */
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print("touchesMoved")
        
    
        
 
        
        
        // タッチイベントを取得.
        let aTouch: UITouch = touches.first!
        
        // 移動した先の座標を取得.
        let location = aTouch.location(in: self.scrollView)
        
        print(location)
        
        // 移動する前の座標を取得.
        let prevLocation = aTouch.previousLocation(in: self.scrollView)
        
        // CGRect生成.
        
        // var myFrame: CGRect = self.scrollView.frame
        
        // ドラッグで移動したx, y距離をとる.
        let deltaX: CGFloat = location.x - prevLocation.x
        let deltaY: CGFloat = location.y - prevLocation.y
        
        // 移動した分の距離をmyFrameの座標にプラスする.
        myLabel.origin.x += deltaX
        myLabel.origin.y += deltaY
        
        // frameにmyFrameを追加.
//        self.scrollView.frame = myFrame
    
        

    /*指が離れたことを感知した際に呼ばれるメソッド.
     
    */
    }

        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print("touchesEnded")
        
        // Labelアニメーション.
     /*   UIView.animate(withDuration: 0.1,
                       
                       // アニメーション中の処理.
            animations: { () -> Void in
                // 拡大用アフィン行列を作成する.
                self.myLabel.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
                // 縮小用アフィン行列を作成する.
                self.myLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
        { (Bool) -> Void in
            
      }
        
       */

    }
    
 
 */

     
    
    
    
        
        
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    /* 以下は UITextFieldDelegate のメソッド */
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // スクロール中の処理
        print("didScroll")
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // ドラッグ開始時の処理
        print("beginDragging")
     }
  }



class AppScrollView: UIScrollView {
    public func scrollLock() {
        self.isScrollEnabled = false
    }
    
    public func scrollUnlock() {
        self.isScrollEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesEnded(touches, with: event)
    }
}


extension FirstScrollViewController: MCManagerDelegate{
    func mcManager(manager: MCManager, session: MCSession, didReceive data: Data, from peer: MCPeerID) {
    }
    func mcManager(manager: MCManager, session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
    }
}


extension FirstScrollViewController: SocketManagerDelegate {
    func manager(manager: SocketManager, scrollBy move: (Int, Int)) {
        self.scrollView.contentOffset.x += CGFloat(move.0)
        self.scrollView.contentOffset.y += CGFloat(move.0)

    }
}





