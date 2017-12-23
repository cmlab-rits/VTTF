//
//  BaseApplicationManager.swift
//  ColorCoordinate
//
//  Created by Yuki Takeda on 2017/10/28.
//  Copyright © 2017年 teakun. All rights reserved.
//

import UIKit
import MultipeerConnectivity

protocol BaseAppManagerDelegate {
    func appManager(manager: BaseApplicationManager, scroll move: (Int, Int))
    func appManager(manager: BaseApplicationManager, initalize labels: [BaseAppLabel])
    func appManager(manager: BaseApplicationManager, add player: Player, view: UIView)
    func appManager(manager: BaseApplicationManager, longpress label: BaseAppLabel)
    func appManager(manager: BaseApplicationManager, move player: Player)
}

class BaseApplicationManager: NSObject {
    static let sharedInstance = BaseApplicationManager()

    private let mcManager = MCManager.sharedInstance

    private let socketManager = SocketManager.sharedInstance

    private var viewController: BaseApplicationViewController?

    private var ownPlayer: Player?

    var players: [Player] = []

    private var direction: Direction?
    
    private var role: RoleInApp?

    private var taskLabelCount: Int = 20

    var delegate: BaseAppManagerDelegate?
    
    var fieldLabels: [BaseAppLabel] = []

    var currentSelectedLabel: BaseAppLabel?

    var playerPositionView: [UIView] = []

    var basisWorkspaceSize: CGSize = CGSize(width: 3500, height: 3500)

    var workspaceSize: CGSize {
        guard let direction = direction else { return basisWorkspaceSize }

        switch direction {
        case .front, .back:
            return basisWorkspaceSize
        case .left, .right:
            return CGSize(width: basisWorkspaceSize.height, height: basisWorkspaceSize.width)
        }
    }

    override init() {
        super.init()
        mcManager.delegate = self
        socketManager.delegate = self
    }

    func startApplication() {
        guard let role = role, let direction = direction else { return }
        mcManager.startManager()
        ownPlayer = Player(id: RandomUtil.generate16length(), name: UIDevice.current.name, position: CGPointZero, type: .own)
        if role == .leader {
            setupFieldObjects()
        }
    }
    
    func setupInitialSetting(role: RoleInApp, dir: Direction, vc: BaseApplicationViewController) {
        self.role = role
        self.direction = dir
        self.viewController = vc
        startApplication()
    }

    func updateOwnPlayerPosition(point: CGPoint) {
        let basePoint = convertToBasisPoint(point: point)
        ownPlayer?.position = basePoint
        shareMovePlayer()
    }

    func getCurrentPositionInScrollView() -> CGPoint? {
        return viewController?.getCurrentPositionInScrollView()
    }


    func selectedPlayerByFlickedLabel(player: Player) {
        guard let label = self.currentSelectedLabel else { return }
        label.midPoint = player.position
        shareUserFlickedLabel(label: label, to: player)
        currentSelectedLabel = nil
    }

    /// 作業空間に配置するラベルをつくる
    private func setupFieldObjects() {
        for i in 0..<taskLabelCount {
            let rect = CGRect(origin: genarateRandomPointInWorkspaceCircle(), size: CGSize(200,200))
            let showNumber = KERand.minMaxRandInt(0, 9)
            let id = "baseapplabel:\(i)"
            let label = BaseAppLabel(frame: rect, number: showNumber, id: id)
            label.delegate = self
            //仮
            label.tag = i
            fieldLabels.append(label)
        }
    }

    /// 作業空間の円の中でランダムな点を得る
    private func genarateRandomPointInWorkspaceCircle() -> CGPoint {
        var point = CGPoint(x: 0,y: 0)
        point.x = CGFloat(KERand.minMaxRandInt(0, Int(workspaceSize.width)))
        point.y = CGFloat(KERand.minMaxRandInt(0, Int(workspaceSize.height)))
        return point
    }

    /**
     作業空間が正方形のとき、ある点がカラーパターンでカバーできる円の内部に存在するかをチェックする
     */
    private func checkCoodinateInCircle(point: CGPoint) -> Bool {
        let halfR = pow(workspaceSize.halfWidth, 2)
        let wid = pow(workspaceSize.width - point.x, 2)
        let hei = pow(workspaceSize.height - point.y, 2)

        if (wid + hei) <= halfR {
            return true
        } else {
            return false
        }
    }



    /// 基の座標から方向に応じて座標を変換する
    ///
    /// - Parameters:
    ///   - dir: 方向
    ///   - point: 基の座標
    /// - Returns: 方向に応じた座標
    func convertFromBasisPointToDirectionPoint(dir: Direction, from point: CGPoint) -> CGPoint {
        var p: CGPoint = point
        switch dir {
        case .front:
            break
        case .back:
            p.x = basisWorkspaceSize.width - point.x
            p.y = basisWorkspaceSize.height - point.y
        case .left:
            p.x = point.y
            p.y = basisWorkspaceSize.width - point.x
        case .right:
            p.x = basisWorkspaceSize.height - point.y
            p.y = point.x
        }
        return p
    }

    func convertToDirectionPoint(point: CGPoint) -> CGPoint {
        return convertFromBasisPointToDirectionPoint(dir: self.direction!, from: point)
    }

    /// 方向に応じた座標から基の座標に変換する
    ///
    /// - Parameters:
    ///   - dir: 方向
    ///   - point: 方向に応じた座標
    /// - Returns: 基の座標
    func convertDirectionPointToBasisPoint(dir: Direction, point: CGPoint) -> CGPoint{
        var p: CGPoint = point
        switch dir {
        case .front:
            break
        case .back:
            p.x = basisWorkspaceSize.width - point.x
            p.y = basisWorkspaceSize.height - point.y
        case .left:
            p.x = basisWorkspaceSize.width - point.y
            p.y = point.x
        case .right:
            p.x = point.y
            p.y = basisWorkspaceSize.height - point.x
        }
        return p
    }

    // 入力された座標を自分自身の座標に応じて基の座標に変換する
    func convertToBasisPoint(point: CGPoint) -> CGPoint {
        return convertDirectionPointToBasisPoint(dir: self.direction!, point: point)
    }

    /*
     イベントの送信
    */

    /// ラベルの初期化
    func initalizeShareAllLabel(to peerID: MCPeerID){
        let labelDataArray = fieldLabels.flatMap{ $0.makeBaseAppLabel() }
        let encoder = JSONEncoder()

        do {
            let encoded = try encoder.encode(labelDataArray)
            let message = OperationMessage(operation: Operation.initalLabel.rawValue, data: encoded)
            if let data = message.encode() {
                mcManager.send(data: data, peer: peerID)
            }
        } catch {
            fatalError()
        }
    }
    /// ラベルの移動
    func shareMoveLabel(label: BaseAppLabel) {
        print("sharelabel")
        if let labelData = label.makeEncodedBaseAppLabelData() {
            let message = OperationMessage(operation: Operation.moveLabel.rawValue, data: labelData)
            if let data = message.encode() {
                mcManager.send(data: data)
            }
        }
    }

    /// フリックによるラベルの移動
    func shareFlickedLabel(label: BaseAppLabel, start: CGPoint, end: CGPoint) {
        if let flickedData = label.makeEncodedBaseAppLabelFlickedData() {
            let message = OperationMessage(operation: Operation.flickedLabel.rawValue, data: flickedData)
            if let data = message.encode() {
                mcManager.send(data: data)
            }
        }
    }

    /// ユーザ指定のフリックによるラベルの移動
    func shareUserFlickedLabel(label: BaseAppLabel,to player: Player){
        guard let own = self.ownPlayer else { return }
        if let userFlickedData = label.makeEncodedBaseAppLabelUserFlickedData(from: own, to: player) {
            let message = OperationMessage(operation: Operation.userFlickedLabel.rawValue, data: userFlickedData)
            if let data = message.encode() {
                mcManager.send(data: data)
            }
        }
    }

    /// 新規プレイヤーの参加
    func shareJoinNewPlayer() {
        if let playerData = ownPlayer?.makeEncodedPlayerData()  {
            let message = OperationMessage(operation: Operation.joinNewPlayer.rawValue, data: playerData)
            if let data = message.encode() {
                mcManager.send(data: data)
            }
        }
    }

    /// プレイヤーの移動
    func shareMovePlayer() {
        // 後でそれぞれの方向に直す
        if let playerData = ownPlayer?.makeEncodedPlayerData() {
            let message = OperationMessage(operation: Operation.movePlayer.rawValue, data: playerData)
            if let data = message.encode() {
                mcManager.send(data: data)
            }
        }
    }

    /**
     message受けたときのパース
     */
    func operationMessageDecode(data: Data){
        let decoder = JSONDecoder()
        guard let decodedMessage = try? decoder.decode(OperationMessage.self, from: data) else { return }
        guard let operationType = Operation(rawValue: decodedMessage.operation) else { return }
        print("operation:" + operationType.rawValue)
        let data = decodedMessage.data
        switch operationType {
        case .initalLabel:
            receiveInitalLabelOperation(data: data)
        case .moveLabel:
            receiveMoveLabelOperation(data: data)
        case .flickedLabel:
            receiveFlickedLabelOperation(data: data)
        case .userFlickedLabel:
            receiveUserFlickedLabelOparation(data: data)
        case .joinNewPlayer:
            receiveJoinNewPlayerOperation(data: data)
        case .movePlayer:
            receiveMovePlayerOperation(data: data)
        }
    }


    /*
     イベントの受信
     */
    /// ラベルの初期の共有
    private func receiveInitalLabelOperation(data: Data) {
        let decoder = JSONDecoder()
        guard let labelDataArray: [BaseAppLabelData] = try? decoder.decode([BaseAppLabelData].self, from: data) else { return }
        labelDataArray.map{ BaseAppLabel(frame: CGRect(origin: convertFromBasisPointToDirectionPoint(dir: self.direction!, from: $0.position), size: CGSize(200,200)), number: 0, id: $0.id) }
                .forEach{  $0.delegate = self ; self.fieldLabels.append($0) }
        self.delegate?.appManager(manager: self, initalize: fieldLabels)
    }

    /// ラベルの移動イベントを受け取った時の位置の更新
    private func receiveMoveLabelOperation(data: Data) {
        guard let baseAppLabelData: BaseAppLabelData = try? JSONDecoder().decode(BaseAppLabelData.self, from: data) else { return }
        let label = fieldLabels.filter{ $0.id == baseAppLabelData.id }.first
        if let label = label, let dir = direction {
            label.midPoint = convertFromBasisPointToDirectionPoint(dir: dir, from: baseAppLabelData.position)
        }
    }

    private func receiveFlickedLabelOperation(data: Data) {
        guard let baseAppLabelFlickedData: BaseAppLabelFlickedData = try? JSONDecoder().decode(BaseAppLabelFlickedData.self, from: data) else { return }
        let label = fieldLabels.filter{ $0.id == baseAppLabelFlickedData.id }.first
        if let label = label, let dir = direction {
            let covertedEndPoint = convertFromBasisPointToDirectionPoint(dir: dir, from: baseAppLabelFlickedData.end)
            label.moveLabelWithAnimation(start: label.midPoint, end: covertedEndPoint)
        }
    }

    private func receiveUserFlickedLabelOparation(data: Data) {
        guard let labelData = try? JSONDecoder().decode(BaseAppLabelUserFlickedData.self, from: data) else { return }
        let label = fieldLabels.filter{ $0.id == labelData.id }.first

        if let label = label {
            let convertedEndPoint = convertToDirectionPoint(point: labelData.end)
            label.center = convertedEndPoint
            if labelData.toPlayerID == self.ownPlayer?.id {
                let alert = UIAlertController(title: "受信", message: "ラベルを受け取りますか", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                let cancelAction = UIAlertAction(title: "拒否", style: .cancel, handler: { (_) -> () in
                    label.center = self.convertToDirectionPoint(point: labelData.start)
                    self.shareMoveLabel(label: label)
                })
                alert.addActions([cancelAction, okAction])
                viewController?.present(alert, animated: true, completion: nil)
            }
         }
    }

    private func receiveJoinNewPlayerOperation(data: Data) {
        guard let playerData: PlayerData = try? JSONDecoder().decode(PlayerData.self, from: data) else { return }
        let idlist = players.map{ $0.id }
        if !idlist.contains(playerData.id) {
            let newPlayer = Player(id: playerData.id, name: playerData.name, position: playerData.position, type: .other)
            players.append(newPlayer)
        }
    }

    private func receiveMovePlayerOperation(data: Data) {
        guard let playerData: PlayerData = try? JSONDecoder().decode(PlayerData.self, from: data) else { return }
        let player = players.filter{ $0.id == playerData.id }.first
        if let player = player {
            player.position = convertToDirectionPoint(point: playerData.position)
            self.delegate?.appManager(manager: self, move: player)
        }
    }
}

extension BaseApplicationManager: BaseAppLabelDelegate {
    func appLabel(touchesBegan label: BaseAppLabel) {
        viewController?.scrollLock()
        shareMovePlayer()
    }

    func appLabel(touchesMoved label: BaseAppLabel) {
        viewController?.scrollLock()
    }

    func appLabel(touchesEnded label: BaseAppLabel) {
        viewController?.scrollUnlock()
        shareMoveLabel(label: label)
    }

    func appLabel(flickMoved label: BaseAppLabel, start: CGPoint, end: CGPoint) {
        shareFlickedLabel(label: label, start: start, end: end)
    }

    func appLabel(longPressed label: BaseAppLabel) {
        self.currentSelectedLabel = label
        self.delegate?.appManager(manager: self, longpress: label)
    }
}

extension BaseApplicationManager: MCManagerDelegate {
    func mcManager(manager: MCManager, session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("connected")
            shareJoinNewPlayer()
            if role == .leader {
                initalizeShareAllLabel(to: peerID)
            }
        default:
            break
        }
    }

    func mcManager(manager: MCManager, session: MCSession, didReceive data: Data, from peer: MCPeerID) {
        dispatchOnMainThread {
            self.operationMessageDecode(data: data)
        }
    }
}

extension BaseApplicationManager: SocketManagerDelegate {
    func manager(manager: SocketManager, scrollBy move: (Int, Int)) {
        self.delegate?.appManager(manager: self, scroll: move)
    }
}



















