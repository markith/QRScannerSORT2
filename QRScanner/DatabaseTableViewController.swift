//
//  DatabaseTableViewController.swift
//  QRScanner
//
//  Created by Markith on 12/19/17.
//  Copyright © 2017 Markith. All rights reserved.
//

import UIKit
import Firebase

class DatabaseTableViewController: UITableViewController {

    // Comment out "keg-movements" and uncomment "testing-movements" during development
    // Also make this change in QRScannerVC, MainTableVC and KegFormVC
//    let ref = Database.database().reference(withPath: "testing-movements")
    let ref = Database.database().reference(withPath: "new-keg-movements")
//    let ref = Database.database().reference(withPath: "keg-movements")

    var movements: [KegMovement] = []
    var sortedMovements: [KegMovement] = []
    
    var kegID = ""
    var date = ""
    var employee = ""
    var beer = ""
    var customer = ""
    var notes = ""
    var status = ""
    var receivedData = ""
    var sortByProperty = ""
    var numberOfSections = Int()
    var soldArray: [KegMovement] = []
    var fullArray: [KegMovement] = []
    var emptyArray: [KegMovement] = []
    var tableViewTitleText = ""
    var tableViewSubtitleText = ""
        
    var sortedDict = [Array<KegMovement>]()
    
    @IBOutlet weak var tableViewTitle: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref.observe(.value, with: { snapshot in
            var newMovements: [KegMovement] = []
            for movements in snapshot.children {
                let kegMovement = KegMovement(snapshot: movements as! DataSnapshot)
                newMovements.append(kegMovement)
            }
            self.movements = newMovements
            self.tableView.reloadData()
        })
        print("DTVC sortByProperty: \(sortByProperty)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sortOnSelectedRow() {
        switch sortByProperty {
        case "inventory":
            sortedMovements = sortedMovements.sorted( by: { $0.beerName.compare($1.beerName) == .orderedAscending } )
        case "date":
            // DATE: steps to attempt new date getting procedure
            sortedMovements = sortedMovements.sorted( by: { $0.dateTimeIntervalSince1970.compare($1.dateTimeIntervalSince1970) == .orderedDescending } )

            
//            sortedMovements = sortedMovements.sorted( by: { $0.dateLong.compare($1.dateLong) == .orderedDescending } )
        case "beerName":
            sortedMovements = sortedMovements.sorted( by: { $0.beerName.compare($1.beerName) == .orderedAscending } )
        case "customerName":
            let tempSort = sortedMovements.filter( { $0.lifeCycleStatus == "sold" } )
            sortedMovements = tempSort.sorted( by: { $0.locationName.compare($1.locationName) == .orderedAscending } )
        case "lifeCycleStatus":
            sortedMovements = sortedMovements.sorted( by: { $0.dateTimeIntervalSince1970.compare($1.dateTimeIntervalSince1970) == .orderedDescending } )
        case "kegID":
            sortedMovements = sortedMovements.sorted( by: { $0.kegID.compare($1.kegID) == .orderedAscending } )
        default:
            print("Something went wrong with the switch case")
        }
    }
    
    // MARK: UITableView Delegate methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sortOnSelectedRow()
        return sortedMovements.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovementsCell", for: indexPath)
        let kegMovement = sortedMovements[indexPath.row]
        cell.textLabel?.text = "\(kegMovement.kegID): \(kegMovement.dateShort)"
        
        switch sortByProperty {
        case "inventory":
            cell.detailTextLabel?.text = "\(kegMovement.lifeCycleStatus) | Beer: \(kegMovement.beerName) | Location: \(kegMovement.locationName)"
        case "date":
            cell.detailTextLabel?.text = "\(kegMovement.lifeCycleStatus) | Beer: \(kegMovement.beerName) | Location: \(kegMovement.locationName)"
        case "beerName":
            cell.detailTextLabel?.text = "Beer: \(kegMovement.beerName)"
        case "customerName":
            cell.detailTextLabel?.text = "Location: \(kegMovement.locationName) | \(kegMovement.lifeCycleStatus) | Beer: \(kegMovement.beerName)"
        case "lifeCycleStatus":
            cell.detailTextLabel?.text = "\(kegMovement.lifeCycleStatus) | Beer: \(kegMovement.beerName) | Location: \(kegMovement.locationName)"
        case "kegID":
            cell.detailTextLabel?.text = "\(kegMovement.lifeCycleStatus) | Beer: \(kegMovement.beerName) | Location: \(kegMovement.locationName)"
        default:
            print("Something went wrong with the switch case")
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let kegMovement = sortedMovements[indexPath.row]
        
        kegID = kegMovement.kegID
        date = kegMovement.dateLong
        employee = kegMovement.employeeName
        beer = kegMovement.beerName
        customer = kegMovement.locationName
        notes = kegMovement.notes
        status = kegMovement.lifeCycleStatus
                
        self.performSegue(withIdentifier: "movementDetailSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "movementDetailSegue" {
            // get a reference to the second view controller
            let movementDetailViewController = segue.destination as! MovementDetailViewController
            
            // set a variable in the second view controller with the data to pass
            movementDetailViewController.kegID = kegID
            movementDetailViewController.date = date
            movementDetailViewController.employee = employee
            movementDetailViewController.beer = beer
            movementDetailViewController.customer = customer
            movementDetailViewController.notes = notes
            movementDetailViewController.status = status
            
            movementDetailViewController.sortByProperty = self.sortByProperty
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}














