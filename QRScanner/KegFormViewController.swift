//
//  KegFormViewController.swift
//  QRScanner
//
//  Created by Markith on 12/17/17.
//  Copyright © 2017 Markith. All rights reserved.
//

import Foundation
import UIKit
import MessageUI
import Firebase

class KegFormViewController: UIViewController, MFMailComposeViewControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var kegIDTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var employeeNameTextField: UITextField!
    @IBOutlet weak var beerNameTextField: UITextField!
    @IBOutlet weak var beerNameLabel: UILabel!
    @IBOutlet var locationNameTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextField!
    @IBOutlet var locationNameLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var viewControllerTitle: UILabel!
    
    let qrVC = QRScannerViewController(nibName: "QRScannerViewController", bundle: nil)
    // Comment out "keg-movements" and uncomment "testing-movements" during development
    // Also make this change in QRScannerVC, MainTableVC and DatabaseTVC
//    let ref = Database.database().reference(withPath: "testing-movements")
    let ref = Database.database().reference(withPath: "new-keg-movements")
//    let ref = Database.database().reference(withPath: "keg-movements")


    var movements: [KegMovement] = []
    var sortedMovements: [KegMovement] = []
    
    var updatedIDLabel = ""
    var updatedLocationLabel = ""
    var updatedBeerLabel = ""
    var updatedBeerName = ""
    var updatedLocationName = ""
    var updatedNotesText = ""
    var updatedVCTitle = ""
    var updatedSendButtonTitle = "Submit new keg into inventory"
    var lifeCycleStatus = ""
    var dateForDatabase: String! = ""
    var dateForTableView: String! = ""
    var dateTimeIntervalSince1970: String! = ""
    
    var qrScannedCode = ""
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        print("Entry Cancelled")
    }
    
    override func viewDidLoad() {
        
        self.kegIDTextField.delegate = self
        self.dateTextField.delegate = self
        self.employeeNameTextField.delegate = self
        self.beerNameTextField.delegate = self
        self.locationNameTextField.delegate = self
        self.notesTextField.delegate = self
        
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
        
        // get the current date and time
        let currentDateTime = Date()
        
        // initialize the date formatter and set the style
        let formatterForDatabase = DateFormatter()

        formatterForDatabase.dateFormat = "MMM dd, yyyy hh:mm:ss a"
        
        let formatterForTableView = DateFormatter()
        formatterForTableView.dateStyle = .short
        
        dateForTableView = formatterForTableView.string(from: currentDateTime)
        
        // DATE: steps to attempt new date getting procedure
        
        let currentDate = Date()
        dateTimeIntervalSince1970 = "\(currentDate.timeIntervalSince1970)"
        print("dateTimeIntervalSince1970: \(dateTimeIntervalSince1970)")
        
        dateForDatabase = formatterForDatabase.string(from: currentDate)

        print("entryDate: \(currentDate)")
        print("dateForDatabase: \(dateForDatabase)")

        
        kegIDTextField.text = qrScannedCode as String?
        dateTextField.text = dateForDatabase
        employeeNameTextField.text = ""
        locationNameLabel.text = updatedLocationLabel
        beerNameTextField.text = updatedBeerName
        locationNameTextField.text = updatedLocationName
        notesTextField.text = updatedNotesText
        viewControllerTitle.text = updatedVCTitle
        sendButton.setTitle(updatedSendButtonTitle, for: .normal)
        
        // Dismiss keyboard by tapping anywhere
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    
    @IBAction func sendDatabase(_ sender: Any) {
        
        let paragraphStyle = NSMutableParagraphStyle()
        // Here is the key thing!
        paragraphStyle.alignment = .left
        
        let messageText = NSMutableAttributedString(
            string: "Date: \(dateTextField.text as! String)\nKeg ID: \(kegIDTextField.text as! String)\nBeer: \(beerNameTextField.text as! String)\nLocation: \(locationNameTextField.text as! String)\nEntered by: \(employeeNameTextField.text as! String)\nNotes: \(notesTextField.text as! String)" ,
            attributes: [
                NSAttributedStringKey.paragraphStyle: paragraphStyle,
                NSAttributedStringKey.font : UIFont.preferredFont(forTextStyle: .body),
                NSAttributedStringKey.foregroundColor : UIColor.black
            ]
        )
        
        let alert = UIAlertController(title: "Confirm Details:",
                                      message: "",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Send",
                                       style: .default, handler: { (action) -> Void in
                                        // 1
                                        guard let text = self.dateForDatabase else { return }

                                        // 2
                                        let kegMovement = KegMovement(dateLong: self.dateForDatabase, dateShort: self.dateForTableView, dateTimeIntervalSince1970: self.dateTimeIntervalSince1970, kegID: self.kegIDTextField.text!, employeeName: self.employeeNameTextField.text!, beerName: self.beerNameTextField.text!, locationName: self.locationNameTextField.text!, notes: self.notesTextField.text!, lifeCycleStatus: self.lifeCycleStatus)

                                        // 3
                                        let kegMovementRef = self.ref.child(text.lowercased())

                                        // 4
                                        kegMovementRef.setValue(kegMovement.toAnyObject())

                                        self.dismiss(animated: true, completion:nil)

                                        // going back to QRScannerVC after hitting send isn't working
                                        alert.dismiss(animated: true, completion: { () -> Void in
                                            self.performSegue(withIdentifier: "QRScannerViewController", sender: nil)
                                        })
                                        
        })
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
    
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        alert.setValue(messageText, forKey: "attributedMessage")
        
        present(alert, animated: true, completion: nil)
        
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

