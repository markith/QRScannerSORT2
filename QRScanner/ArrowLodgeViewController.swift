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
    let url = "https://www.google.com"
    
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
        UIApplication.shared.open(URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSdiRV0aDQzU59W6_58i5FPMZ_cJlVkK8x_O8O9SyDh6YQ27WQ/viewform?usp=sf_link")! as URL, options: [:], completionHandler: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is DatabaseTableViewController {
            let databaseTableViewVC = segue.destination as? DatabaseTableViewController
            if sortByButton == "dateButton" {
                databaseTableViewVC?.sortByProperty = "date"
            } else if sortByButton == "beerNameButton" {
                databaseTableViewVC?.sortByProperty = "beerName"
            } else if sortByButton == "customerNameButton" {
                databaseTableViewVC?.sortByProperty = "customerName"
            } else if sortByButton == "lifeCycleStatusButton" {
                databaseTableViewVC?.sortByProperty = "lifeCycleStatus"
            } else if sortByButton == "kegIDButton" {
                databaseTableViewVC?.sortByProperty = "kegID"
            } else if sortByButton == "inventoryButton" {
                databaseTableViewVC?.sortByProperty = "inventory"
            }
    }
    }
}









