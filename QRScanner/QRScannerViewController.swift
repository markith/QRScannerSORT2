//
//  QRScannerViewController
//  QRScanner
//
//  Created by Markith on 12/16/17.
//  Copyright © 2017 Markith. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

class QRScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    let ref = Database.database().reference(withPath: "keg-movements")
    var movements: [KegMovement] = []    
    var qrScannedCode = ""
    
    @IBOutlet var qrCodeLabel: UILabel?
    @IBOutlet weak var topBar: UIView!
    @IBAction func scanButton(_ sender: Any) {
        print("Scan button pressed...\(scannedCode)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is KegFormViewController {
            let kegFormVC = segue.destination as? KegFormViewController
            scannedCode = qrCodeLabel!.text!
            kegFormVC?.qrScannedCode = scannedCode
            
            let sortedMovements = movements.sorted( by: { $0.dateLong.compare($1.dateLong) == .orderedDescending } )
            
            // If it's not in the sorted then assume it's empty and do those things

            for keg in sortedMovements {
                if keg.kegID.contains(scannedCode) {
                    if scannedCode == keg.kegID {
                        if keg.lifeCycleStatus == "full" {
                            kegFormVC?.updatedBeerName = keg.beerName
                            kegFormVC?.lifeCycleStatus = "sold"
                            kegFormVC?.updatedVCTitle = "Keg Sold Form"
                            kegFormVC?.updatedLocationLabel = "Keg sold to:"
                            kegFormVC?.updatedNotesText = "Keg sold to customer and moved from full inventory"
                            kegFormVC?.updatedSendButtonTitle = "Mark keg as sold and delivered"
                            print("full to \(String(describing: kegFormVC?.lifeCycleStatus))")
                            break
                        } else if keg.lifeCycleStatus == "" || keg.lifeCycleStatus == "empty" {
                            kegFormVC?.lifeCycleStatus = "full"
                            kegFormVC?.updatedVCTitle = "Keg Fill Form"
                            kegFormVC?.updatedBeerLabel = "Enter name of beer:"
                            kegFormVC?.updatedNotesText = "Keg has been filled and ready for sale"
                            kegFormVC?.updatedLocationLabel = "Keg filled at brewery"
                            kegFormVC?.updatedLocationName = "Leave blank"
                            kegFormVC?.updatedSendButtonTitle = "Mark keg as filled and ready for sale"
                            print("empty to \(String(describing: kegFormVC?.lifeCycleStatus))")
                            break
                        } else if keg.lifeCycleStatus == "sold" {
                            kegFormVC?.updatedBeerName = keg.beerName
                            kegFormVC?.lifeCycleStatus = "empty"
                            kegFormVC?.updatedVCTitle = "Keg Return Form"
                            kegFormVC?.updatedLocationLabel = "Keg picked up from:"
                            kegFormVC?.updatedLocationName = keg.locationName
                            kegFormVC?.updatedNotesText = "Keg returned from customer and move to empty inventory"
                            kegFormVC?.updatedSendButtonTitle = "Return to Arrow Lodge as empty"
                            print("sold to \(String(describing: kegFormVC?.lifeCycleStatus))")
                            break
                        }
                    }
                }
                else {
                    kegFormVC?.lifeCycleStatus = "full"
                    kegFormVC?.updatedVCTitle = "Keg Fill Form"
                    kegFormVC?.updatedBeerLabel = "Enter name of beer:"
                    kegFormVC?.updatedNotesText = "Keg has been filled and ready for sale"
                    kegFormVC?.updatedLocationLabel = "Keg filled at brewery"
                    kegFormVC?.updatedLocationName = "Leave blank"
                    kegFormVC?.updatedSendButtonTitle = "Mark keg as filled and ready for sale"
                    print("New keg to \(String(describing: kegFormVC?.lifeCycleStatus))")
                    break
                }
            }
        }
    }
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    var scannedCode = ""
    
    let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                              AVMetadataObject.ObjectType.code39,
                              AVMetadataObject.ObjectType.code39Mod43,
                              AVMetadataObject.ObjectType.code93,
                              AVMetadataObject.ObjectType.code128,
                              AVMetadataObject.ObjectType.ean8,
                              AVMetadataObject.ObjectType.ean13,
                              AVMetadataObject.ObjectType.aztec,
                              AVMetadataObject.ObjectType.pdf417,
                              AVMetadataObject.ObjectType.qr,
                              AVMetadataObject.ObjectType.interleaved2of5]
    
    override func viewDidLoad() {
        
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video as the media type parameter.
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        qrCodeLabel?.text = "No QR code detected"
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            // Start video capture.
            captureSession?.startRunning()
            
            // Move the message label and top bar to the front
            view.bringSubview(toFront: qrCodeLabel!)
            view.bringSubview(toFront: topBar)
            
            // Initialize QR Code Frame to highlight the QR code
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
            }
        } catch {
            
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
        // 1
        ref.observe(.value, with: { snapshot in
            // 2
            var newMovements: [KegMovement] = []
            
            // 3
            for movements in snapshot.children {
                // 4
                let kegMovement = KegMovement(snapshot: movements as! DataSnapshot)
                newMovements.append(kegMovement)
            }
            
            // 5
            self.movements = newMovements
        })
    }
    
    // MARK: - AVCaptureMetadataOutputObjectsDelegate Methods
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            qrCodeLabel?.text = "No QR code detected"

            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                qrCodeLabel?.text = metadataObj.stringValue
            }
        }
    }
}




