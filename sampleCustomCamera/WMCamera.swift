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
    private var vidOutput : AVCaptureMovieFileOutput?
    private var session : AVCaptureSession?
    private var isRecording : Bool?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.initView()
        self.initCamera(AVCaptureDevicePosition.Back)
    }
    
    // MARK: - UI
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
        btnSnap.addTarget(self, action:"snap", forControlEvents: UIControlEvents.TouchUpInside)
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
        let btnSwitch: UIButton = UIButton(type: .Custom)
        btnSwitch.setImage(UIImage(named: "retry"), forState: .Normal)
        btnSwitch.frame = CGRectMake(0, 0, 70, 70)
        btnSwitch.center = CGPointMake(self.view.frame.size.width / 4 * 3 + hBtn / 4, self.view.frame.size.height / 3 * 2 + self.view.frame.size.height / 6)
        btnSwitch.layer.cornerRadius = 35
        btnSwitch.layer.borderWidth = 3
        btnSwitch.layer.borderColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.2).CGColor
        btnSwitch.addTarget(self, action:"switchCamera", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(btnSwitch)
    }
    
    func initCamera(position: AVCaptureDevicePosition)
    {
        isRecording = false
        var myDevice: AVCaptureDevice?
        let devices = AVCaptureDevice.devices()
        let captureDevice = AVCaptureDevice.devicesWithMediaType(AVMediaTypeAudio)
        
        // Back camera
        var videoInput = AVCaptureDeviceInput()
        for device in devices
        {
            if(device.position == position)
            {
                myDevice = device as? AVCaptureDevice
                do {
                    videoInput = try AVCaptureDeviceInput(device: myDevice)
                }
                catch let error as NSError
                {
                    print(error)
                    return
                }
            }
        }
        
        // Audio
        var audioInput = AVCaptureDeviceInput()
        do {
            audioInput = try AVCaptureDeviceInput(device: captureDevice[0] as! AVCaptureDevice)
        }
        catch let error as NSError
        {
            print(error)
            return
        }
        
        // Create session
        vidOutput = AVCaptureMovieFileOutput()
        let myImageOutput = AVCaptureStillImageOutput()
        session = AVCaptureSession()
        session?.beginConfiguration()
        session?.sessionPreset = AVCaptureSessionPresetMedium
        session?.addInput(videoInput)
        session?.addInput(audioInput)
        session?.addOutput(myImageOutput)
        session?.addOutput(vidOutput)
        session?.commitConfiguration()
        
        // Add video layer
        let vidLayer = AVCaptureVideoPreviewLayer(session: session)
        vidLayer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height / 3 * 2)
        vidLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.view.layer.addSublayer(vidLayer)
        
        // Start session
        session?.startRunning()
    }
    
    // MARK: - Action
    internal func snap()
    {
        // Snap (Movie)
        if isRecording == false
        {
            // フォルダ.
            let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
            guard let docDirectory = paths[0] as String? else {
                return
            }
            
            let filePath : String? = "\(docDirectory)/temp.mp4"
            let fileURL : NSURL = NSURL(fileURLWithPath: filePath!)
            vidOutput?.startRecordingToOutputFileURL(fileURL, recordingDelegate: self)
            isRecording = true
        }
        // Stop (Movie)
        else
        {
            vidOutput?.stopRecording()
            isRecording = false
        }
    }
    
    internal func flash()
    {
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        if  device.hasTorch
        {
            do {
                try device.lockForConfiguration()
            }
            catch let error as NSError
            {
                print("\(error)")
                return
            }
            device.torchMode = AVCaptureTorchMode.Off == device.torchMode ? AVCaptureTorchMode.On : AVCaptureTorchMode.Off
            device.unlockForConfiguration()
        }
    }
    
    internal func switchCamera()
    {
        if (session != nil)
        {
            guard let currentCamera = session?.inputs[0] as? AVCaptureDeviceInput else
            {
                return
            }
            
            if currentCamera.device.position == AVCaptureDevicePosition.Front
            {
                self.initCamera(AVCaptureDevicePosition.Back)
            }
            else
            {
                self.initCamera(AVCaptureDevicePosition.Front)
            }
        }
    }
    
    // MARK:- AVCaptureFileOutputRecordingDelegate
    func captureOutput(captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAtURL fileURL: NSURL!, fromConnections connections: [AnyObject]!)
    {
        print("didStartRecordingToOutputFileAtURL")
    }
    
    func captureOutput(captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAtURL outputFileURL: NSURL!, fromConnections connections: [AnyObject]!, error: NSError!)
    {
        print("didFinishRecordingToOutputFileAtURL")
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
