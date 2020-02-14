//
//  BaseApplicationViewController.swift
//  ColorCoordinate
//
//  Created by Yuki Takeda on 2017/10/28.
//  Copyright © 2017年 teakun. All rights reserved.
//

import UIKit
import AVFoundation

class BaseApplicationViewController: UIViewController {

    private let appManager = BaseApplicationManager.sharedInstance

    var scrollView = AppScrollView()
    private var contentView = UIView()
    private var myRightButton: UIBarButtonItem!
    private var tmpPosition: CGPoint?

//    private var isZoom: Bool
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appManager.delegate = self
        self.navigationItem.hidesBackButton = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    
        // たかはし: ここではUIScrollViewではなく独自実装のscrollViewを宣言
        scrollView = AppScrollView(frame: self.view.frame)
        scrollView.contentSize = appManager.workspaceSize
        scrollView.backgroundColor = UIColor.gray
        scrollView.isUserInteractionEnabled = true
        scrollView.isScrollEnabled = false
        view.addSubview(scrollView)
//        scrollView.minimumZoomScale = self.view.frame.width / appManager.basisWorkspaceSize.width
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 1.0
        contentView = UIView(frame: CGRect(origin: CGPoint(0,0), size: appManager.workspaceSize))
        contentView.backgroundColor = UIColor.asbestos
        scrollView.addSubview(contentView)
        // MEMO: 間違ってるけどカラーセンサでは絶対位置を取ってくるからどうでもいい
        scrollView.contentOffset = calcStartPoint()
        addLabel()
        scrollView.delegate = self
//        scrollView.pinchGestureRecognizer?.addTarget(self, action: #selector(pinchAction(sender:)))
        if appManager.role == .leader {
            myRightButton = UIBarButtonItem(title: "Label Init", style: .plain, target: self, action: #selector(onClickLabelInitButton(sender:)))
            self.navigationItem.rightBarButtonItem = myRightButton
        }
        let zoomButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(zoomAcction(sender:)))
        let resetButton = UIBarButtonItem(barButtonSystemItem: .rewind, target: self, action: #selector(resetAction(sender:)))
        self.navigationItem.leftBarButtonItems = [zoomButton, resetButton]
    }
        
   //ボタンが押された時
    @objc func onClickLabelInitButton(sender: UIBarButtonItem) {
        appManager.setupFieldObjects()
        addLabel()
        appManager.initalizeShareAllLabel()
    }
    
    @objc func pinchAction(sender: UIPinchGestureRecognizer) {
//        if sender.velocity <= -0.3 {
//            zoomOutScrollView()
//        } else if sender.velocity >= 0.3 {
//            zoomInScrollView()
//        }
    }
    
    @objc func zoomAcction(sender: UIBarButtonItem){
        if let tmp = tmpPosition {
            zoomInScrollView()
            scrollView.contentOffset = tmp
            tmpPosition = nil
        } else {
            zoomOutScrollView()
        }
    }

    @objc func resetAction(sender: UIBarButtonItem) {
        appManager.recaptureInitialPosition()
        UIView.animate(withDuration: 1.0, animations: {
            self.scrollView.contentOffset = self.calcStartPoint()
        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func calcStartPoint() -> CGPoint {
        if let startPosition = appManager.startPotiton {
            if startPosition == .left {
                let x = 0.cgFloat
                let y = appManager.workspaceSize.height - view.frame.height
                return CGPoint(x: x, y: y)
            } else {
                let x = appManager.workspaceSize.width - view.frame.width
                let y = appManager.workspaceSize.height - view.frame.height
                return CGPoint(x: x, y: y)
            }
        } else {
            let x = appManager.workspaceSize.width / 2
            let y = appManager.workspaceSize.height - ( view.frame.height / 2 )
            return CGPoint(x: x, y: y)
        }
       
    }

    
    // たかはし:それぞれのラベルにscrollViewへの参照を持たせておく
    func addLabel() {
        let subviews = self.contentView.subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }
        for label in appManager.fieldLabels {
            self.contentView.addSubview(label)
        }
    }

    public func scrollLock() {
        scrollView.scrollLock()
    }

    public func scrollUnlock() {
        scrollView.scrollUnlock()
    }

    func zoomOutScrollView() {
        tmpPosition = scrollView.contentOffset
        scrollView.minimumZoomScale = self.view.frame.width / appManager.basisWorkspaceSize.width
        scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
     
    }

    func zoomInScrollView() {
        scrollView.minimumZoomScale = 1.0
        scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
        if let position = tmpPosition{
            scrollView.contentOffset = position
        }
        //tmpPosition = nil
    }
}

extension BaseApplicationViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentView
    }
}

extension BaseApplicationViewController: BaseAppManagerDelegate {
    func appManager(manager: BaseApplicationManager, scroll move: (Float, Float)) {
        self.scrollView.contentOffset.x += CGFloat(move.0*7.0)
        self.scrollView.contentOffset.y += CGFloat(move.1*7.2)
    }
}
