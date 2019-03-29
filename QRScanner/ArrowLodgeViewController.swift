//
//  ArrowLodgeViewController.swift
//  QRScanner
//
//  Created by Markith on 1/22/18.
//  Copyright © 2018 Markith. All rights reserved.
//

import UIKit
import Firebase

class ArrowLodgeViewController: UIViewController {

    var sortByButton = ""
    let url = ""
    
    @IBAction func currentInventoryButton(_ sender: Any) {
        sortByButton = "inventoryButton"
    }
    @IBAction func dateButton(_ sender: Any) {
        sortByButton = "dateButton"
    }
    @IBAction func beerNameButton(_ sender: Any) {
        sortByButton = "beerNameButton"
    }
    @IBAction func customerNameButton(_ sender: Any) {
        sortByButton = "customerNameButton"
    }
    @IBAction func lifeCycleStatusButton(_ sender: Any) {
        sortByButton = "lifeCycleStatusButton"
    }
    @IBAction func kegIDButton(_ sender: Any) {
        sortByButton = "kegIDButton"
    }
    @IBAction func reportBugButton(_ sender: Any) {
        UIApplication.shared.open(URL(string: url)! as URL, options: [:], completionHandler: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is MainTableViewController {
            
            let mainTVC = segue.destination as? MainTableViewController
            if sortByButton == "dateButton" {
                mainTVC?.sortByProperty = "date"
            } else if sortByButton == "beerNameButton" {
                mainTVC?.sortByProperty = "beerName"
            } else if sortByButton == "customerNameButton" {
                mainTVC?.sortByProperty = "customerName"
            } else if sortByButton == "lifeCycleStatusButton" {
                mainTVC?.sortByProperty = "lifeCycleStatus"
            } else if sortByButton == "kegIDButton" {
                mainTVC?.sortByProperty = "kegID"
            } else if sortByButton == "inventoryButton" {
                mainTVC?.sortByProperty = "inventory"
            }
    }
    }
}









