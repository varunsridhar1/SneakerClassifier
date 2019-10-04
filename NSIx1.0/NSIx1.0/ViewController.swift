//
//  ViewController.swift
//  NSIx1.0
//
//  Created by Abhilash Chilakamarthi on 10/4/19.
//  Copyright © 2019 NSI. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    let captureSession = AVCaptureSession()
    var previewLayer:CALayer!
    
    var captureDevice:AVCaptureDevice!
    
    var takePhoto = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCamera()
    }

    func prepareCamera() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
        if let availableDevices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back).devices.first {
            captureDevice = availableDevices
            beginSession()
        }
    }
    
    func beginSession() {
             do{
                 let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
                 
                 captureSession.addInput(captureDeviceInput)
             } catch{
                 print(error.localizedDescription)
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
        
        let queue = DispatchQueue(label: "com.NSI.NSI")
        dataOutput.setSampleBufferDelegate(self, queue: queue)
    }
    
    func endSession() {
        self.captureSession.stopRunning()
        if let inputs = self.captureSession.inputs as? [AVCaptureDeviceInput] {
            for input in inputs {
                self.captureSession.removeInput(input)
            }
        }
    }
   
    @IBAction func takePhoto(_ sender: Any) {
        takePhoto = true
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if takePhoto {
            takePhoto = false
            
            if let image = self.getImageFromSampleBuffer(buffer: sampleBuffer) {
                let photoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhotoVC") as! PhotoViewController
                
                //HEY YOU! LOOK HERE THIS IS THE PIC!
                photoVC.takenPhoto = image
                
                DispatchQueue.main.async {
                    self.present(photoVC, animated: true, completion: {
                        self.endSession()
                    })
                    
                }
            }
        }
    }
    
    func getImageFromSampleBuffer(buffer:CMSampleBuffer) -> UIImage? {
        if let pixelBuffer = CMSampleBufferGetImageBuffer(buffer) {
            let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
            let context = CIContext()
            let imageRect = CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))
            
            if let image = context.createCGImage(ciImage, from: imageRect) {
                return UIImage(cgImage: image, scale: UIScreen.main.scale, orientation: .right)
            }
        }
        
        return nil
    }

}

