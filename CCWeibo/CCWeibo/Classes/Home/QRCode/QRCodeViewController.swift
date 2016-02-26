//
//  QRCodeViewController.swift
//  CCWeibo
//
//  Created by 徐才超 on 16/2/5.
//  Copyright © 2016年 徐才超. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var containerHeightCons: NSLayoutConstraint!
    @IBOutlet weak var scanLineTopCons: NSLayoutConstraint!
    @IBOutlet weak var scanLineView: UIImageView!
    @IBOutlet weak var tabBar: UITabBar!
    @IBAction func close(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private lazy var captureSession:AVCaptureSession = AVCaptureSession()
    private var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    // 扫码绿框绘制层
    private lazy var qrCodeBoundsDrawLayer: CALayer = {
        let layer = CALayer()
        layer.frame = UIScreen.mainScreen().bounds
        return layer
    }()
    private let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    // 支持的条码类型
    private var supportedBarCodes = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.selectedItem = tabBar.items![0]
        tabBar.delegate = self
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        startScanAnimation()
        startScan()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func startScanAnimation() {
        scanLineTopCons.constant = -containerHeightCons.constant
        self.view.layoutIfNeeded()
        
        UIView.animateWithDuration(2) { () -> Void in
            UIView.setAnimationRepeatCount(HUGE)
            self.scanLineTopCons.constant = self.containerHeightCons.constant
            self.view.layoutIfNeeded()
        }
    }

    private func startScan() {
        do {
            // 获取视频输入设备
            let input = try AVCaptureDeviceInput(device: captureDevice)
            // 建立视频捕捉会话
            if !captureSession.canAddInput(input) {
                return
            }
            captureSession.addInput(input)
            // 配置视频会话输出为元数据类型
            let captureMetadataOutput = AVCaptureMetadataOutput()
            if !captureSession.canAddOutput(captureMetadataOutput) {
                return
            }
            captureSession.addOutput(captureMetadataOutput)
            // 设置视频元数据输出的代理对象，参数队列一定要为串行队列
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            // 设置需要的条码元数据类型
            captureMetadataOutput.metadataObjectTypes = captureMetadataOutput.availableMetadataObjectTypes
            // 开始视频捕获，并启动预览
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.insertSublayer(videoPreviewLayer!, atIndex: 0)
            captureSession.startRunning()
            // 添加扫码绿框绘制层
            videoPreviewLayer?.addSublayer(qrCodeBoundsDrawLayer)
        } catch {
            print(error)
            return
        }
        
    }

}

// MARK: - TabBar切换
extension QRCodeViewController: UITabBarDelegate {
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if item.title == "二维码" {
            scanLineView.image = UIImage(named: "qrcode_scanline_qrcode")
            containerHeightCons.constant = 200
            self.view.layoutIfNeeded()
        } else {
            scanLineView.image = UIImage(named: "qrcode_scanline_barcode")
            containerHeightCons.constant = 150
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - 扫描元数据代理
extension QRCodeViewController: AVCaptureMetadataOutputObjectsDelegate {
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        // 验证至少读取到一个元数据对象
        if metadataObjects == nil || metadataObjects.count == 0 {
            resultLabel.text = "对准二维码进行扫描"
            clearCodeBounds()
            return
        }
        // 获取元数据对象
        guard let metadataObj = metadataObjects[0] as? AVMetadataMachineReadableCodeObject else { return }
        // 绘制扫码绿框
        let barCodeObject = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObj) as! AVMetadataMachineReadableCodeObject
        drawCodeBounds(barCodeObject)
        // 输出扫码结果
        if metadataObj.stringValue != nil {
            // 获取条码的内容文字信息
            resultLabel.text = metadataObj.stringValue
        }
    }
    
    private func drawCodeBounds(barCodeObject: AVMetadataMachineReadableCodeObject) {
        clearCodeBounds()
        //绿框4个顶角的坐标集合
        let corners = barCodeObject.corners
        var point: CGPoint = CGPointZero
        //绿框
        let greenBounds: CAShapeLayer = CAShapeLayer()
        greenBounds.fillColor = nil
        greenBounds.lineWidth = 2
        greenBounds.strokeColor = UIColor.greenColor().CGColor
        CGPointMakeWithDictionaryRepresentation((corners.first as! CFDictionaryRef), &point)
        let path = UIBezierPath()
        path.moveToPoint(point)
        for index in 1..<corners.count {
            CGPointMakeWithDictionaryRepresentation((corners[index] as! CFDictionaryRef), &point)
            path.addLineToPoint(point)
        }
        path.closePath()
        greenBounds.path = path.CGPath
        qrCodeBoundsDrawLayer.addSublayer(greenBounds)
        
    }
    
    //清除绿框
    private func clearCodeBounds() {
        guard let subLayers = qrCodeBoundsDrawLayer.sublayers where subLayers.count > 0 else { return }
        for layer in subLayers {
            layer.removeFromSuperlayer()
        }
    }
}
