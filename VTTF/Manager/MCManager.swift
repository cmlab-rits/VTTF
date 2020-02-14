//
//  MCManager.swift
//
//  Created by Yuki Takeda on 2017/09/17.
//  Copyright © 2017年 teakun. All rights reserved.
//

import Foundation
import UIKit
import MultipeerConnectivity

protocol MCManagerDelegate {

    // データをうけとったとき
    func mcManager(manager: MCManager, session: MCSession, didReceive data: Data, from peer: MCPeerID)

    // 接続中の端末の状態に変化があったとき
    func mcManager(manager: MCManager, session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState)

}

class MCManager: NSObject {
    static let sharedInstance = MCManager()

    fileprivate let serviceType = "vttf-mc-key"
    fileprivate let timeoutInterval = 0.0
    fileprivate let ownID: MCPeerID
    fileprivate let browser: MCNearbyServiceBrowser
    fileprivate let advertiser: MCNearbyServiceAdvertiser
    fileprivate let session: MCSession

    var delegate: MCManagerDelegate?

    // 接続中の端末一覧
    var connectedPeers: [MCPeerID] {
        return session.connectedPeers
    }

    override init() {
        ownID = MCPeerID(displayName: UIDevice.current.name)
        browser = MCNearbyServiceBrowser(peer: ownID, serviceType: serviceType)
        advertiser = MCNearbyServiceAdvertiser(peer: ownID, discoveryInfo: nil, serviceType: serviceType)
        session = MCSession(peer: ownID, securityIdentity: nil, encryptionPreference: .required)

        super.init()

        browser.delegate = self
        advertiser.delegate = self
        session.delegate = self
    }

    // 接続処理開始
    func startManager() {
        browser.startBrowsingForPeers()
        advertiser.startAdvertisingPeer()
    }

    // 接続処理の終了
    func stopManager() {
        browser.stopBrowsingForPeers()
        advertiser.stopAdvertisingPeer()
    }

    // 全体へのデータの送信
    func send(data: Data) {
        send(data: data, peers: connectedPeers)
    }

    // 一つに対してのデータの送信
    func send(data: Data, peer: MCPeerID) {
        let peers = [peer]
        send(data: data, peers: peers)
    }

    // 一部へのデータの送信
    func send(data: Data, peers: [MCPeerID]) {
        do {
            try session.send(data, toPeers: peers, with: .reliable)
        } catch let error {
            print(error)
        }
    }

}

extension MCManager: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        guard peerID != ownID else { return }
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: timeoutInterval)
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
    }

    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
    }
}

extension MCManager: MCNearbyServiceAdvertiserDelegate {

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
    }

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, session)
    }
}

extension MCManager: MCSessionDelegate {
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        dispatchOnMainThread {
            self.delegate?.mcManager(manager: self, session: session, didReceive: data, from: peerID)
        }
    }

    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        delegate?.mcManager(manager: self, session: session, peer: peerID, didChange: state)
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }

    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
        certificateHandler(true)
    }

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }

}
