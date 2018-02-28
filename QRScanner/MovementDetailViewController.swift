//
//  MovementDetailViewController.swift
//  QRScanner
//
//  Created by Markith on 12/21/17.
//  Copyright © 2017 Markith. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class MovementDetailViewController: UIViewController {
    
    let movementDetailCell = "MovementDetailCell"
    var receivedData = ""
    
    var kegID = ""
    var date = ""
    var employee = ""
    var beer = ""
    var customer = ""
    var notes = ""
    var status = ""
    var sortByProperty = ""
        
    @IBOutlet weak var kegIDLabel: UILabel?
    @IBOutlet weak var dateLabel: UILabel?
    @IBOutlet weak var employeeLabel: UILabel?
    @IBOutlet weak var beerLabel: UILabel?
    @IBOutlet weak var customerLabel: UILabel?
    @IBOutlet weak var notesLabel: UILabel?
    @IBOutlet weak var statusLabel: UILabel!
    
    
    override func viewDidLoad() {
        kegIDLabel?.text = "Keg ID: \(kegID)"
        dateLabel?.text = "Date: \(date)"
        employeeLabel?.text = "Entered by: \(employee)"
        beerLabel?.text = "Beer: \(beer)"
        customerLabel?.text = "Customer name: \(customer)"
        notesLabel?.text = "Notes: \(notes)"
        statusLabel?.text = "Status: \(status)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let databaseVC = segue.destination as? DatabaseTableViewController
        databaseVC?.sortByProperty = self.sortByProperty
    }
    
    
    
    
    
}
