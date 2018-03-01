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
    let ref = Database.database().reference(withPath: "keg-movements")
    var movements: [KegMovement] = []
    var sortedMovements: [KegMovement] = []
    
    var updatedIDLabel = ""
    var updatedLocationLabel = ""
    var updatedBeerLabel = ""
    var updatedBeerName = ""
    var updatedLocationName = ""
    var updatedNotesText = ""
    var updatedVCTitle = ""
    var updatedSendButtonTitle = ""
    var lifeCycleStatus = ""
    var dateForDatabase: String! = ""
    var dateForTableView: String! = ""
    
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
        formatterForDatabase.timeStyle = .medium
        formatterForDatabase.dateStyle = .long
        
        let formatterForTableView = DateFormatter()
        formatterForTableView.timeStyle = .short
        formatterForTableView.dateStyle = .short
        
        // get the date time String from the date object
        dateForDatabase = formatterForDatabase.string(from: currentDateTime)
        dateForTableView = formatterForTableView.string(from: currentDateTime)
        
        kegIDTextField.text = qrScannedCode as String?
        dateTextField.text = dateForTableView
        employeeNameTextField.text = "Mark Fransen"
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
                                       style: .default) { _ in
                                        // 1
                                        guard let text = self.dateForDatabase else { return }
                                        
                                        // 2
                                        let kegMovement = KegMovement(dateLong: self.dateForDatabase, dateShort: self.dateForTableView, kegID: self.kegIDTextField.text!, employeeName: self.employeeNameTextField.text!, beerName: self.beerNameTextField.text!, locationName: self.locationNameTextField.text!, notes: self.notesTextField.text!, lifeCycleStatus: self.lifeCycleStatus)
                                        
                                        // 3
                                        let kegMovementRef = self.ref.child(text.lowercased())
                                        
                                        // 4
                                        kegMovementRef.setValue(kegMovement.toAnyObject())
                                        
                                        self.dismiss(animated: true, completion:nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.setValue(messageText, forKey: "attributedMessage")
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //    func textFieldShouldReturn(textField: UITextField) -> Bool {
    //        textField.resignFirstResponder()
    //        return true
    //    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

