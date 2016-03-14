//
//  WMCamera.swift
//  sampleCustomCamera
//
//  Created by Wataru Maeda on 3/14/16.
//  Copyright © 2016 wataru maeda. All rights reserved.
//

import UIKit
import AVFoundation
import AssetsLibrary

class WMCamera: UIViewController, AVCaptureFileOutputRecordingDelegate
{
    // ビデオのアウトプット.
    private var myVideoOutput : AVCaptureMovieFileOutput!
    private var isRecirding : Bool?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        isRecirding = false
        var myDevice: AVCaptureDevice?
        let devices = AVCaptureDevice.devices()
        let audioCaptureDevice = AVCaptureDevice.devicesWithMediaType(AVMediaTypeAudio)
        
        // マイクをセッションのInputに追加.
        var audioInput = AVCaptureDeviceInput()
        do {
            audioInput = try AVCaptureDeviceInput(device: audioCaptureDevice[0] as! AVCaptureDevice)
        }
        catch let error as NSError
        {
            print(error)
            return
        }
        
        // バックライトをmyDeviceに格納.
        for device in devices
        {
            if(device.position == AVCaptureDevicePosition.Back)
            {
                myDevice = device as? AVCaptureDevice
            }
        }
        
        // バックカメラを取得.
        var videoInput = AVCaptureDeviceInput()
        do {
            videoInput = try AVCaptureDeviceInput(device: myDevice)
        }
        catch let error as NSError
        {
            print(error)
        }
        
        // 出力先を生成.
        myVideoOutput = AVCaptureMovieFileOutput()
        let myImageOutput = AVCaptureStillImageOutput()
        let session = AVCaptureSession()
        session.addInput(videoInput)
        session.addInput(audioInput)
        session.addOutput(myImageOutput)
        session.addOutput(myVideoOutput)
        
        // 画像を表示するレイヤーを生成.
        let myVideoLayer = AVCaptureVideoPreviewLayer(session: session)
        myVideoLayer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height / 3 * 2)
        myVideoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.view.layer.addSublayer(myVideoLayer)
        
        // セッション開始.
        session.startRunning()
        self.initView()
    }
    
    func initView()
    {
        self.view.backgroundColor = UIColor.whiteColor()
        
        // Button (Snap, Stop)
        let hBtn = 100 as CGFloat
        let btnSnap: UIButton = UIButton(type: .Custom)
        btnSnap.frame = CGRectMake(0, 0, hBtn, hBtn)
        btnSnap.backgroundColor = UIColor.blackColor()
        btnSnap.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 3 * 2 + self.view.frame.size.height / 6)
        btnSnap.layer.cornerRadius = hBtn / 2
        btnSnap.addTarget(self, action:"snap:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(btnSnap)
        
        // Button (Flash)
        let btnFlash: UIButton = UIButton(type: .Custom)
        btnFlash.setImage(UIImage(named: "flash"), forState: .Normal)
        btnFlash.frame = CGRectMake(0, 0, 70, 70)
        btnFlash.center = CGPointMake(self.view.frame.size.width / 4 - hBtn / 4, self.view.frame.size.height / 3 * 2 + self.view.frame.size.height / 6)
        btnFlash.layer.cornerRadius = 35
        btnFlash.layer.borderWidth = 3
        btnFlash.layer.borderColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.2).CGColor
        btnFlash.addTarget(self, action:"flash", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(btnFlash)
        
        // Button (Retry)
        let btnRetry: UIButton = UIButton(type: .Custom)
        btnRetry.setImage(UIImage(named: "retry"), forState: .Normal)
        btnRetry.frame = CGRectMake(0, 0, 70, 70)
        btnRetry.center = CGPointMake(self.view.frame.size.width / 4 * 3 + hBtn / 4, self.view.frame.size.height / 3 * 2 + self.view.frame.size.height / 6)
        btnRetry.layer.cornerRadius = 35
        btnRetry.layer.borderWidth = 3
        btnRetry.layer.borderColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.2).CGColor
        btnRetry.addTarget(self, action:"retry", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(btnRetry)
    }
    
    
    // MARK: - Action
    internal func snap(btn: UIButton)
    {
        // Snap (Movie)
        if isRecirding == false
        {
            // フォルダ.
            let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
            guard let documentsDirectory = paths[0] as String? else {
                return
            }
            
            let filePath : String? = "\(documentsDirectory)/test.mp4"
            let fileURL : NSURL = NSURL(fileURLWithPath: filePath!)
            myVideoOutput.startRecordingToOutputFileURL(fileURL, recordingDelegate: self)
            isRecirding = true
        }
        // Stop (Movie)
        else
        {
            myVideoOutput.stopRecording()
            isRecirding = false
        }
    }
    
    internal func flash()
    {
        
    }
    
    internal func retry()
    {
        
    }
    
    // MARK:- AVCaptureFileOutputRecordingDelegate
    func captureOutput(captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAtURL outputFileURL: NSURL!, fromConnections connections: [AnyObject]!, error: NSError!)
    {
        print("didFinishRecordingToOutputFileAtURL")
    }
    
    func captureOutput(captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAtURL fileURL: NSURL!, fromConnections connections: [AnyObject]!)
    {
        print("didStartRecordingToOutputFileAtURL")
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
