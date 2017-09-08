//
//  ViewController.swift
//  VTTF
//
//  Created by Yuki Takeda on 2017/09/08.
//  Copyright © 2017年 cm.is.ritsumei.ac.jp. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    fileprivate let socketManager = SocketManager.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        socketManager.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: SocketManagerDelegate {
    func manager(manager: SocketManager, scrollBy move: (Int, Int)) {
        print("dx = \(move.0), dy = \(move.1)")
    }
}
