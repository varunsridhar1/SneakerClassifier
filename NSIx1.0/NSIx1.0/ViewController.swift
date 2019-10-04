//
//  ViewController.swift
//  NSIx1.0
//
//  Created by Abhilash Chilakamarthi on 10/4/19.
//  Copyright © 2019 NSI. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    let captureSession = AVCaptureSession()
    var previewLayer:CALayer!
    
    var captureDevice:AVCaptureDevice!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCamera()
    }

    func prepareCamera() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
        func beginSession() {
            do{
                let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
                
                captureSession.addInput(captureDeviceInput)
            } catch{
                print(error.localizedDescription)
            }
        }
        
        if let availableDevices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back).devices.first {
            captureDevice = availableDevices
            beginSession()
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            self.previewLayer = previewLayer
            self.view.layer.addSublayer(self.previewLayer)
            self.previewLayer.frame = self.view.layer.frame
            captureSession.startRunning()
            
            let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.videoSettings = [((kCVPixelBufferPixelFormatTypeKey as NSString) as String):NSNumber(value:kCVPixelFormatType_32BGRA)]
            dataOutput.alwaysDiscardsLateVideoFrames = true
            
            if captureSession.canAddOutput(dataOutput){
                captureSession.addOutput(dataOutput)
            }
            
            captureSession.commitConfiguration()
        
    }

}

