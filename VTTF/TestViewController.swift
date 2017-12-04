//
//  TestViewController.swift
//  VTTF
//
//  Created by Yuki Takeda on 2017/09/08.
//  Copyright © 2017年 cm.is.ritsumei.ac.jp. All rights reserved.
//

import UIKit

class TestViewController: UIViewController, SocketManagerDelegate {

    fileprivate let socketManager = SocketManager.sharedInstance
    let pointingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.socketManager.delegate = self
        self.view.backgroundColor = .red
        pointingView.backgroundColor = .black
        self.view.addSubview(pointingView)

        self.pointingView.midX = self.view.frame.width / 2
        self.pointingView.midY = self.view.frame.height / 2

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func manager(manager: SocketManager, scrollBy move: (Int, Int)) {
        self.pointingView.midX += CGFloat(move.0)
        self.pointingView.midY += CGFloat(move.1)
    }
    
}

