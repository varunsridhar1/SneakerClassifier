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

    //some self explanatory global fields
    let captureSession = AVCaptureSession()
    var previewLayer:CALayer!
    var captureDevice:AVCaptureDevice!
    var takePhoto = false
    
    //checks if the app loaded then immediately
    //opens up camera view
    //first thing that gets called!
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCamera()
    }
    
    //func to access camera and start a capture session
    func prepareCamera() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
        //checks if there are capture devices
        //if there are it defaults to using the wideangle camera
        //can possibly add further support for dual and triple cams
        //left it like this so its universally compatible
        if let availableDevices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back).devices.first {
            captureDevice = availableDevices
            beginSession()
        }
    }
    
    //main meat of our app
    func beginSession() {
        //stuck in this loop till we get a capturedevice
         do {
             let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
             captureSession.addInput(captureDeviceInput)
         } catch {print(error.localizedDescription)}
        
        //creates viewfinder using capture session
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)

        self.previewLayer = previewLayer
        self.view.layer.addSublayer(self.previewLayer)
        //resizes the capture preview to fill screen
        previewLayer.videoGravity = .resizeAspectFill
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
    
    //Denotes what happens when we click our capture button in the app
    @IBAction func takePhoto(_ sender: Any) {
        //its really basic and just sets our field to true
        takePhoto = true
    }
    
    //function that handles picture after being taken.
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        //gets triggered by the button click
        if takePhoto {
            takePhoto = false
            
            //"if let" basically checks if "image" will have a non null
            //value when passed data from sampleBuffer
            //an extra round of checking cuz pressing a button wont
            //always register a captured image
            if let image = self.getImageFromSampleBuffer(buffer: sampleBuffer) {
                //image gets shuttled to our other PhotoViewController
                //which currently presents the photo
                //our trained Model's code could likely be triggered or
                //placed here
                let photoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhotoVC") as! PhotoViewController
                
                
                photoVC.takenPhoto = image
                
                DispatchQueue.main.async {
                    self.present(photoVC, animated: true, completion: {
                        self.endSession()
                    })
                    
                }
            }
        }
    }
    
    //accesses image that gets taken from our buffer
    //heavily referenced this part from resources
    //not sure about intracies of this call
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

