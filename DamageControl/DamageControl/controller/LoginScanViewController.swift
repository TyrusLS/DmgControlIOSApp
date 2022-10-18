//
//  LoginScanViewController.swift
//  DamageControl
//
//  Created by Lukas Schlechter on 04.03.22.
//

import UIKit
import AVFoundation
import KeychainWrapper
import CoreData

extension LoginScanViewController: AVCaptureMetadataOutputObjectsDelegate{
    
}

class LoginScanViewController: UIViewController {
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
 
    @IBOutlet weak var topbar: UIView!
    @IBOutlet weak var label: UILabel!
    public var sceneState: String = ""

    let LoadData = LoadUserData
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // check if the metadataObject array is not nil snd it contains at least one object
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            label.text = "No Qr Code id detected"
            return
        }
        //Get the metadata object
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            // If the found metadata is equal to the Qr code metadta then Update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            
            
            label.text = metadataObj.stringValue
            
                    let tmp = metadataObj.stringValue?.components(separatedBy: "|")
                    if(tmp!.count==2){
                        LoadData.forEach { LoadData in
                    if(LoadData.password == tmp?[1] && LoadData.username == tmp?[0]){
                        
                        do {
                            guard let username = tmp?[0].data(using: .utf8) else {return}
                            guard let password = tmp?[1].data(using: .utf8) else {return}
                            try KeychainWrapper.set(value: username, account: "username")
                            try KeychainWrapper.set(value: password, account: "password")
                        } catch{
                            print(error)
                        }
                        
                        let qr = storyboard?.instantiateViewController(withIdentifier: "devicescan") as! UINavigationController
                        UIApplication.shared.keyWindow?.rootViewController = qr
                        UIApplication.shared.keyWindow?.makeKeyAndVisible()
                        
                        captureSession.stopRunning()}
                    else{
                        label.text = " Dieser QR-Code beinhaltet falsche Daten"
                    }
                }
              
                        
                        
                }
            else {
                    label.text = " Dieser QR-Code beinhaltet falsche Daten"
            }
            
        
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //get the back-facing caMERA FOR CAPTURING VIDEOS
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            print("failed to get the camera device")
            return
        }
        do {
            //get an instance of the AVCaptureDeviceInput class using the previous device object
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            //Set the input device on the capture session
            captureSession.addInput(input)
            
            // Intitialize a AvcaptureMetadataOutput object and set it as the outpu device to the cature session
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            //set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            //initialize the video preview layer and add it as a sublayer to the viewprevies views layer
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = topbar.layer.bounds
            topbar.layer.addSublayer(videoPreviewLayer!)
            
            
            //start video capture
            captureSession.startRunning()
            
            // Initialize Qr Code Frame to highlight the Qr Code
            
            qrCodeFrameView = UIView()
            
            if let qrcodeFrameView = qrCodeFrameView {
                qrcodeFrameView.layer.borderColor = UIColor.blue.cgColor
                qrcodeFrameView.layer.borderWidth = 2
                topbar.addSubview(qrcodeFrameView)
                topbar.bringSubviewToFront(qrcodeFrameView)
                topbar.bringSubviewToFront(label)
            }
            
           
            //view.bringSubviewToFront(topbar)
            
        }catch {
            //If any error occurs, simply print it out and don't continue anymore
            print(error)
            return
        }
    }
    override func viewDidLayoutSubviews() {
        if let connection = self.videoPreviewLayer?.connection {
                let currentDevice: UIDevice = UIDevice.current
                let orientation: UIDeviceOrientation = currentDevice.orientation
                let previewLayerConnection : AVCaptureConnection = connection
                videoPreviewLayer!.frame = self.topbar.bounds
                if (previewLayerConnection.isVideoOrientationSupported) {
                    switch (orientation) {
                    case .portrait:
                        previewLayerConnection.videoOrientation = AVCaptureVideoOrientation.portrait
                    case .landscapeRight:
                        previewLayerConnection.videoOrientation = AVCaptureVideoOrientation.landscapeLeft
                    case .landscapeLeft:
                        previewLayerConnection.videoOrientation = AVCaptureVideoOrientation.landscapeRight
                    case .portraitUpsideDown:
                        previewLayerConnection.videoOrientation = AVCaptureVideoOrientation.portraitUpsideDown
                        
                    default:
                        previewLayerConnection.videoOrientation = AVCaptureVideoOrientation.portrait
                    }
                }
            }
    }
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true)
    }
    

}

