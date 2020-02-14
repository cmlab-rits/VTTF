//
//  OpenCVManager.swift
//  VTTF
//
//  Created by Hideyuki Takada on 2020/02/14.
//  Copyright © 2020 cm.is.ritsumei.ac.jp. All rights reserved.
//

import Foundation
import AVFoundation

protocol OpenCVManagerDelegate {
    func manager(manager: OpenCVManager, scrollBy move: (Float, Float))
}

class OpenCVManager: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    static let sharedInstance = OpenCVManager()
    var delegate: OpenCVManagerDelegate?
    
    var openCV = OpenCV()
    var session: AVCaptureSession!
    var device: AVCaptureDevice!
    var output: AVCaptureVideoDataOutput!

    override init() {
        super.init()

        if initCamera() {
            session.startRunning()
        } else {
            assert(false) //カメラが使えない
        }
    }
    
    func initCamera() -> Bool {
        let preset = AVCaptureSession.Preset.high //解像度
        //解像度
        //        AVCaptureSession.Preset.Photo : 852x640
        //        AVCaptureSession.Preset.High : 1280x720
        //        AVCaptureSession.Preset.Medium : 480x360
        //        AVCaptureSession.Preset.Low : 192x144


        let frame = CMTimeMake(1, 8) //フレームレート
        let position = AVCaptureDevice.Position.front //フロントカメラかバックカメラか

       // setImageViewLayout(preset: preset)//UIImageViewの大きさを調整

        // セッションの作成.
        session = AVCaptureSession()

        // 解像度の指定.
        session.sessionPreset = preset

        // デバイス取得.
        device = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera,
                                           for: AVMediaType.video,
                                           position: position)

        // VideoInputを取得.
        var input: AVCaptureDeviceInput! = nil
        do {
            input = try
                AVCaptureDeviceInput(device: device) as AVCaptureDeviceInput
        } catch let error {
            print(error)
            return false
        }

        // セッションに追加.
        if session.canAddInput(input) {
            session.addInput(input)
        } else {
            return false
        }

        // 出力先を設定
        output = AVCaptureVideoDataOutput()

        //ピクセルフォーマットを設定
        output.videoSettings =
            [ kCVPixelBufferPixelFormatTypeKey as AnyHashable as! String : Int(kCVPixelFormatType_32BGRA) ]

        //サブスレッド用のシリアルキューを用意
        output.setSampleBufferDelegate(self as AVCaptureVideoDataOutputSampleBufferDelegate, queue: DispatchQueue.main)

        // 遅れてきたフレームは無視する
        output.alwaysDiscardsLateVideoFrames = true

        // FPSを設定
        do {
            try device.lockForConfiguration()

            device.activeVideoMinFrameDuration = frame //フレームレート
            device.unlockForConfiguration()
        } catch {
            return false
        }

        // セッションに追加.
        if session.canAddOutput(output) {
            session.addOutput(output)
        } else {
            return false
        }

        // カメラの向きを合わせる
        for connection in output.connections {
            if connection.isVideoOrientationSupported {
                connection.videoOrientation = AVCaptureVideoOrientation.portrait
            }
        }

        return true
    }

    var prePoint = CGPoint(0.0,0.0)
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        DispatchQueue.main.async{ //非同期処理として実行
            let img = self.captureImage(sampleBuffer) //UIImageへ変換
            var resultPt: CGPoint //結果を格納する
            
            // *************** 画像処理 ***************
            resultPt = self.openCV.toCoordinate(img) //変換
            // *****************************************

            let dx = resultPt.x - self.prePoint.x
            let dy = resultPt.y - self.prePoint.y
            self.delegate?.manager(manager: self, scrollBy: (Float(dx), Float(-dy)))
            //self.scrollView.contentOffset.x += dx*7.0
            //self.scrollView.contentOffset.y -= dy*7.2
            
            self.prePoint = resultPt
        }
    }
    
    // sampleBufferからUIImageを作成
    func captureImage(_ sampleBuffer:CMSampleBuffer) -> UIImage{
        let imageBuffer: CVImageBuffer! = CMSampleBufferGetImageBuffer(sampleBuffer)

        // ベースアドレスをロック
        CVPixelBufferLockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: 0))

        // 画像データの情報を取得
        let baseAddress: UnsafeMutableRawPointer = CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0)!

        let bytesPerRow: Int = CVPixelBufferGetBytesPerRow(imageBuffer)
        let width: Int = CVPixelBufferGetWidth(imageBuffer)
        let height: Int = CVPixelBufferGetHeight(imageBuffer)

        // RGB色空間を作成
        let colorSpace: CGColorSpace! = CGColorSpaceCreateDeviceRGB()

        // Bitmap graphic contextを作成
        let bitsPerCompornent: Int = 8
        let bitmapInfo = CGBitmapInfo(rawValue: (CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue) as UInt32)
        let newContext: CGContext! = CGContext(data: baseAddress, width: width, height: height, bitsPerComponent: bitsPerCompornent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) as CGContext?

        // Quartz imageを作成
        let imageRef: CGImage! = newContext!.makeImage()

        // ベースアドレスをアンロック
        CVPixelBufferUnlockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: 0))

        // UIImageを作成
        let resultImage: UIImage = UIImage(cgImage: imageRef)

        return resultImage
    }

    func recaptureInitialPosition() {
        prePoint = CGPoint(0.0,0.0)
        openCV.resetCounter();
    }

}

