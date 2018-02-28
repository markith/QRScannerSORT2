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
            }
    }
    }
}









