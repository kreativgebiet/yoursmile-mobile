//
//  CameraViewController.swift
//  YSCTW
//
//  Created by Max Zimmermann on 07.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let captureSession = AVCaptureSession()
    var captureDevice: AVCaptureDevice?
    var stillImageOutput = AVCaptureStillImageOutput()
    
    public var dataManager: DataManager?
    public var selectedProject: Project?
    //ViewController will choose this callback if defined after image selection
    public var customCallback: ((_ image: UIImage) -> Void)?
    
    var image: UIImage?
    
    @IBOutlet weak var navBarLabel: UILabel!
    @IBOutlet weak var cameraRollButton: UIButton!
    @IBOutlet weak var cameraView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navBarLabel.text = "TAKE_PICTURE".localized
                
        let devices = AVCaptureDevice.devices()
        
        let helper = HelperFunctions()
        
        self.cameraRollButton.contentHorizontalAlignment = .center
        self.cameraRollButton.contentVerticalAlignment = .center
        self.cameraRollButton.setImage(helper.fetchLastPhoto(targetSize: CGSize(width: 100, height: 100)), for: .normal)
        
        for device in devices! {
            if ((device as AnyObject).hasMediaType(AVMediaTypeVideo)) {
                if((device as AnyObject).position == AVCaptureDevicePosition.back) {
                    captureDevice = device as? AVCaptureDevice
                }
            }
        }
        
        if captureDevice != nil {
            view.setNeedsLayout()
            view.layoutIfNeeded()
            
            beginSession()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    func focusTo(value : Float) {
        if let device = captureDevice {
            do {
                try device.lockForConfiguration()
                device.setFocusModeLockedWithLensPosition(value, completionHandler: { (time) -> Void in
                    
                })
                device.unlockForConfiguration()
            } catch {
                // handle error
                return
            }
        }
    }
    
    // MARK: - Button Handler
    
    @IBAction func closeButtonTapped(_ sender: AnyObject) {
        _ = navigationController?.popViewController(animated: false)
    }
    
    @IBAction func photoRollCameraButtonTapped(_ sender: UIButton) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func cameraButtonTapped(_ sender: AnyObject) {
        if let videoConnection = self.stillImageOutput.connection(withMediaType: AVMediaTypeVideo) {
            stillImageOutput.captureStillImageAsynchronously(from: videoConnection) {
                (imageDataSampleBuffer, error) -> Void in
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
                self.image = UIImage(data: imageData!)
                
                self.title = ""
                
                if self.customCallback != nil {
                    self.customCallback!(self.image!)
                } else {
                    self.performSegue(withIdentifier: "donationSegue", sender: self.selectedProject)
                }
                
            }
        }
    }
    
    @IBAction func cameraFlipButtonTapped(_ sender: AnyObject) {
        
        captureSession.beginConfiguration()
        
        let currentCameraInput:AVCaptureInput = captureSession.inputs.first as! AVCaptureInput
        captureSession.removeInput(currentCameraInput)
        
        var newCamera:AVCaptureDevice! = nil
        
        if let input = currentCameraInput as? AVCaptureDeviceInput {
            if (input.device.position == .back) {
                newCamera = cameraWithPosition(position: .front)
            } else {
                newCamera = cameraWithPosition(position: .back)
            }
        }
        
        var err: NSError?
        var newVideoInput: AVCaptureDeviceInput!
        do {
            newVideoInput = try AVCaptureDeviceInput(device: newCamera)
        } catch let err1 as NSError {
            err = err1
            newVideoInput = nil
        }
        
        if(newVideoInput == nil || err != nil) {
            print("Error creating capture device input: \(err!.localizedDescription)")
        } else {
            captureSession.addInput(newVideoInput)
        }
        
        captureSession.commitConfiguration()
    }
    
    func cameraWithPosition(position: AVCaptureDevicePosition) -> AVCaptureDevice? {
        let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
        for device in devices! {
            let device = device as! AVCaptureDevice
            if device.position == position {
                return device
            }
        }
        
        return nil
    }
    
    // MARK: - Camer-Focus
    
    let screenWidth = UIScreen.main.bounds.size.width
    
    func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let anyTouch = touches.anyObject() as! UITouch
        let touchPercent = anyTouch.location(in: self.view).x / screenWidth
        focusTo(value: Float(touchPercent))
    }
    
    func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        let anyTouch = touches.anyObject() as! UITouch
        let touchPercent = anyTouch.location(in: self.view).x / screenWidth
        focusTo(value: Float(touchPercent))
    }
    
    // MARK: - Camer-Configuration
    
    func configureDevice() {
        if let device = captureDevice {
            do {
                try device.lockForConfiguration()
            } catch {
                // handle error
                return
            }
            device.focusMode = .locked
            device.unlockForConfiguration()
        }
    }
    
    func beginSession() {
        
        configureDevice()
        
        let err : NSError? = nil
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
        } catch _ {
            print("error: \(err?.localizedDescription)")
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        previewLayer?.frame = self.cameraView.layer.bounds
        self.cameraView.layer.addSublayer(previewLayer!)
        captureSession.startRunning()
    }
    
    // MARK: - Image picker delegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) { 
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.image = pickedImage
        }
        
        picker.dismiss(animated: true, completion: nil)
        
        self.title = ""
        
        if self.customCallback != nil {
            self.customCallback!(self.image!)
        } else {
            self.performSegue(withIdentifier: "donationSegue", sender: self.selectedProject)
        }
        
    }


    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "donationSegue" {
            let destinationVC = segue.destination as! DonationViewController
            destinationVC.selfieImage = self.image
            destinationVC.dataManager = self.dataManager
            
            if let project = sender as? Project {
                destinationVC.selectedProject = project
            }
            
        }
        
    }

}
