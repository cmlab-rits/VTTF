//
//  BaseApplicationViewController.swift
//  ColorCoordinate
//
//  Created by Yuki Takeda on 2017/10/28.
//  Copyright © 2017年 teakun. All rights reserved.
//

import UIKit

class BaseApplicationViewController: UIViewController {

    private let appManager = BaseApplicationManager.sharedInstance

    private var scrollView = AppScrollView()
    private var contentView = UIView()
    private var flickView: FlickGuideView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = false
        appManager.delegate = self

        // たかはし: ここではUIScrollViewではなく独自実装のscrollViewを宣言
        scrollView = AppScrollView(frame: self.view.frame)
        scrollView.contentSize = appManager.workspaceSize
        scrollView.backgroundColor = UIColor.clouds
        scrollView.isUserInteractionEnabled = true
        view.addSubview(scrollView)
        scrollView.minimumZoomScale = self.view.frame.width / appManager.basisWorkspaceSize.width
        scrollView.maximumZoomScale = 1.0


        contentView = UIView(frame: CGRect(origin: CGPoint(0,0), size: appManager.workspaceSize))
        scrollView.addSubview(contentView)
        // MEMO: 間違ってるけどカラーセンサでは絶対位置を取ってくるからどうでもいい
        scrollView.contentOffset = calcStartPoint()
        addLabel()
        scrollView.delegate = self
        scrollView.pinchGestureRecognizer?.addTarget(self, action: #selector(pinchAction(sender:)))

        flickView = FlickGuideView(frame: CGRect(origin: CGPoint(0,0), size: CGSize(self.view.frame.width, self.view.frame.width)))
        flickView!.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 0)
        self.view.addSubview(self.flickView!)
        flickView?.isHidden = true

    }

    @objc func pinchAction(sender: UIPinchGestureRecognizer) {
        if sender.velocity <= -0.3{
            zoomOutScrollView()
        } else if sender.velocity >= 0.3{
            zoomInScrollView()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func calcStartPoint() -> CGPoint {
        let x = appManager.workspaceSize.width / 2
        let y = appManager.workspaceSize.height - ( view.frame.height / 2 )
        return CGPoint(x: x, y: y)
    }

    // たかはし:それぞれのラベルにscrollViewへの参照を持たせておく
    func addLabel() {
        for label in appManager.fieldLabels {
            self.contentView.addSubview(label)
        }
    }

    func getCurrentPositionInScrollView() -> CGPoint{
        let point = CGPoint(x: self.scrollView.contentOffset.x + (view.frame.width / 2 ), y: self.scrollView.contentOffset.y + (view.frame.height / 2 ))
        return point
    }

    public func scrollLock() {
        scrollView.scrollLock()
    }

    public func scrollUnlock() {
        scrollView.scrollUnlock()
    }

    func zoomOutScrollView() {
        scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
    }

    func zoomInScrollView() {
        scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
    }

    func addFlickGuideView(label: BaseAppLabel) {

        UIView.animate(withDuration: 0.5, animations: {
            label.midX = self.scrollView.contentOffset.x + (self.view.frame.width / 2)
            label.midY = self.scrollView.contentOffset.y + (self.view.frame.width / 2)
        })
        self.flickView?.isHidden = false
    }

    func hideFlickGuideView() {
        self.flickView?.isHidden = true
    }

}

extension BaseApplicationViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentView
    }
}

extension BaseApplicationViewController: BaseAppManagerDelegate {
    func appManager(manager: BaseApplicationManager, initalize labels: [BaseAppLabel]) {
        addLabel()
    }

    func appManager(manager: BaseApplicationManager, scroll move: (Int, Int)) {
        self.scrollView.contentOffset.x += move.0.cgFloat
        self.scrollView.contentOffset.y += move.1.cgFloat

    }

    func appManager(manager: BaseApplicationManager, add player: Player, view: UIView) {
    }

    func appManager(manager: BaseApplicationManager, longpress label: BaseAppLabel){
        addFlickGuideView(label: label)
    }
}

























