//
//  DeviceScanViewController.swift
//  DamageControl
//
//  Created by Lukas Schlechter on 04.03.22.
//

import UIKit
import AVFoundation
import KeychainWrapper
import CoreData



class DeviceScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var scanView: UIView!
    @IBOutlet weak var testbtn: UIButton!
    @IBOutlet weak var testdeviceTF: UITextField!
    @IBOutlet weak var stackView: UIStackView!
    
    let LoadData = LoaddeviceData
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // check if the metadataObject array is not nil snd it contains at least one object
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
           outputLabel.text = "No Qr Code id detected"
            return
        }
        //Get the metadata object
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            // If the found metadata is equal to the Qr code metadta then Update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            outputLabel.text = metadataObj.stringValue
            testfunction(string: metadataObj.stringValue!)
        }
    }
    
    override func viewDidLoad() { 
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
        hideKeyboardWhenTappedAround()
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
            
            //initialize the video preview layer and add it as a sublayer to the viewprevies view#s layer
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = scanView.layer.bounds
            
            scanView.layer.addSublayer(videoPreviewLayer!)
            
            
            //start video capture
            captureSession.startRunning()
            
            // Initialize Qr Code Frame to highlight the Qr Code
            
            qrCodeFrameView = UIView()
            
            if let qrcodeFrameView = qrCodeFrameView {
                qrcodeFrameView.layer.borderColor = UIColor.blue.cgColor
                qrcodeFrameView.layer.borderWidth = 2
                scanView.addSubview(qrcodeFrameView)
                scanView.bringSubviewToFront(qrcodeFrameView)
                scanView.bringSubviewToFront(testbtn)
                scanView.bringSubviewToFront(testdeviceTF)
                scanView.bringSubviewToFront(outputLabel)
                scanView.bringSubviewToFront(stackView)
                
            }
            //view.bringSubviewToFront(topbar)
            
        }catch {
            //If any error occurs, simply print it out and don't continue anymore
            print(error)
            return
        }
    }
    
    // logout button Action
  
    @IBAction func Logout(_ sender: Any) {
        do{
            try KeychainWrapper.deleteAll()
        }catch{
            
        }
        let mainscreen = storyboard?.instantiateViewController(withIdentifier: "login") as! UINavigationController
        UIApplication.shared.keyWindow?.rootViewController = mainscreen
        UIApplication.shared.keyWindow?.makeKeyAndVisible()
    }
   
    func deviceCoreDataexists(device: String) -> Bool{
        do{
            let tmp = try context.fetch(EquipmentData.fetchRequest(device: device))
            if(!tmp.isEmpty){
                return true
            }
        }catch{
        }
        return false
        
    }
    func createDeviceCoreData(device: String) -> String{
        let newuser = UserData(context: context)
        let newequip = EquipmentData(context: context)
        let newsturz = Sturzschaden(context: context)
        let newsonstige = Sonstigerschaden(context: context)
        newequip.id = device
        newequip.userdata = newuser
        newequip.sturzschaden = newsturz
        newequip.sonstigerschaden = newsonstige
        newequip.sturzschaden?.checked = false
        newequip.sonstigerschaden?.checked = false
        do{
            try context.save()
        }catch{
            
        }
        return device
        
    }
    func getDeviceCoreData(device: String) -> String? {
        do{
        let tmp = try context.fetch(EquipmentData.fetchRequest(device: device))
            if(tmp.count == 1){
                return tmp[0].id}
        }catch{}
        return nil
         }

    @IBAction func testbutton(_ sender: Any) {
        let testString : String = testdeviceTF.text ?? "device04"
        testfunction(string: testString)
    }
    func testfunction(string: String) {
        LoadData.forEach{ LoadData in
            if(LoadData.deviceID == string){
                let stringValue :String = string
                if(deviceCoreDataexists(device: stringValue)){
                    do{
                        guard let currentDevice = getDeviceCoreData(device: stringValue)?.data(using: .utf8)else {return}
                    try KeychainWrapper.set(value: currentDevice, account: "currentdevice")
                    }catch{
                        print(error)
                    }
                }else {
                    
                    do{
                        guard let currentDevice = createDeviceCoreData(device: stringValue).data(using: .utf8)else {return}
                    try KeychainWrapper.set(value: currentDevice, account: "currentdevice")
                    }catch{
                        print(error)
                    }
                }
                
                let mainscreen = storyboard?.instantiateViewController(withIdentifier: "MainScreen") as! UINavigationController
                UIApplication.shared.keyWindow?.rootViewController = mainscreen
                UIApplication.shared.keyWindow?.makeKeyAndVisible()
            }
            outputLabel.text = "Dieser QR-Code beinhaltet falsche Daten"
        }
        
    }
    override func viewDidLayoutSubviews() {
        if let connection = self.videoPreviewLayer?.connection {
                let currentDevice: UIDevice = UIDevice.current
                let orientation: UIDeviceOrientation = currentDevice.orientation
                let previewLayerConnection : AVCaptureConnection = connection
            videoPreviewLayer!.frame = self.scanView.bounds
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
    
    
    
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -210 // Move view 150 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }
    
  
}

