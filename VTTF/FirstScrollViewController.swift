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

class FirstScrollViewController: UIViewController, UIScrollViewDelegate {
    
    //private let manager = SocketManager.sharedInstance
    fileprivate let mcManager = MCManager.sharedInstance
    let scrollView = AppScrollView()
    var myLabel: UILabel!

    var testlabel: VttfLabel = VttfLabel()
    var labelList: [VttfLabel] = []
    private var taskLabelCount: Int = 15
    
    var direction: Direction = .front

    override func viewDidLoad() {
        super.viewDidLoad()
//        manager.delegate = self

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
            let label = VttfLabel(frame: CGRect(origin:CGPoint(x: i*150,y:i*150),size:CGSize(width: 100, height: 100)))
            label.vc = self
            self.scrollView.addSubview(label)
            labelList.append(label)
//            mcManager.send(data: )
        }
    }
    

        
        
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

/*
extension FirstScrollViewController: SocketManagerDelegate {
    func manager(manager: SocketManager, scrollBy move: (Int, Int)) {
        self.scrollView.contentOffset.x += CGFloat(move.0)
        self.scrollView.contentOffset.y += CGFloat(move.0)

    }
}
*/
