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
    // Also make this change in QRScannerVC and KegFormVC
    let ref = Database.database().reference(withPath: "keg-movements")
//    let ref = Database.database().reference(withPath: "testing-movements")
    
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
            self.tableView.reloadData()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sortOnSelectedRow() {
        switch sortByProperty {
        case "date":
            sortedMovements = movements.sorted( by: { $0.dateLong.compare($1.dateLong) == .orderedDescending } )
            tableViewTitle.title = "Sorted by Date"
            
            // Change title and subtitle in tableview based on how data is sorted:
//            tableViewTitleText = "\(kegMovement.dateShort): \(kegMovement.kegID)"
//            tableViewSubtitleText = "Filled: \(kegMovement.beerName) | Ready for sale."
            
        case "beerName":
            sortedMovements = movements.sorted( by: { $0.beerName.compare($1.beerName) == .orderedAscending } )
            tableViewTitle.title = "Sorted by Beer"
        case "customerName":
            // Trying to only include "sold" objects
            // IT WORKS!
            let tempSort = movements.filter( { $0.lifeCycleStatus == "sold" } )
            sortedMovements = tempSort.sorted( by: { $0.locationName.compare($1.locationName) == .orderedAscending } )
            
            // Old working code:
            //                sortedMovements = movements.sorted( by: { $0.locationName.compare($1.locationName) == .orderedAscending } )
            
            tableViewTitle.title = "Sorted by Customer"
            
            // Sort into sections by status or group into easy to view
        case "lifeCycleStatus":
//            for keg in movements {
//                if keg.lifeCycleStatus == "sold" {
//                    soldArray.append(keg)
//                    soldArray = soldArray.sorted( by: { $0.dateLong.compare($1.dateLong) == .orderedAscending } )
//                } else if keg.lifeCycleStatus == "full" {
//                    fullArray.append(keg)
//                    fullArray = fullArray.sorted( by: { $0.dateLong.compare($1.dateLong) == .orderedAscending } )
//                } else if keg.lifeCycleStatus == "empty" {
//                    emptyArray.append(keg)
//                    emptyArray = emptyArray.sorted( by: { $0.dateLong.compare($1.dateLong) == .orderedAscending } )
//                }
//                sortedDict = [soldArray, fullArray, emptyArray]
//                sortedMovements.append(contentsOf: soldArray)
//                sortedMovements.append(contentsOf: fullArray)
//                sortedMovements.append(contentsOf: emptyArray)
//                print("sortedMovements count: \(sortedMovements.count)")
//            }
            
            sortedMovements = movements.sorted( by: { $0.lifeCycleStatus.compare($1.lifeCycleStatus) == .orderedAscending } )
            tableViewTitle.title = "Sorted by Keg Status"
        case "kegID":
            sortedMovements = movements.sorted( by: { $0.kegID.compare($1.kegID) == .orderedDescending } )
            tableViewTitle.title = "Sorted by Keg ID"
        default:
            print("Something went wrong with the switch case")
        }
    }
    
    // MARK: UITableView Delegate methods
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return sortedDict.count
//    }
    

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sortOnSelectedRow()
        return sortedMovements.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovementsCell", for: indexPath)
        let kegMovement = sortedMovements[indexPath.row]
        cell.textLabel?.text = "\(kegMovement.kegID): \(kegMovement.dateShort)"
        
        switch sortByProperty {
        case "date":
            // Change title and subtitle in tableview based on how data is sorted:
            //cell.textLabel?.text = "\(kegMovement.dateShort): \(kegMovement.kegID)"
            cell.detailTextLabel?.text = "\(kegMovement.lifeCycleStatus) | Beer: \(kegMovement.beerName) | Location: \(kegMovement.locationName)"
        case "beerName":
            //cell.textLabel?.text = "\(kegMovement.beerName): \(kegMovement.kegID)"
            cell.detailTextLabel?.text = "Beer: \(kegMovement.beerName) | \(kegMovement.lifeCycleStatus) | Location: \(kegMovement.locationName)"
        case "customerName":
            //cell.textLabel?.text = "\(kegMovement.locationName): \(kegMovement.kegID)"
            cell.detailTextLabel?.text = "Location: \(kegMovement.locationName) | \(kegMovement.lifeCycleStatus) | Beer: \(kegMovement.beerName)"
        case "lifeCycleStatus":
            //cell.textLabel?.text = "\(kegMovement.lifeCycleStatus): \(kegMovement.kegID)"
            cell.detailTextLabel?.text = "\(kegMovement.lifeCycleStatus) | Beer: \(kegMovement.beerName) | Location: \(kegMovement.locationName)"
        case "kegID":
            //cell.textLabel?.text = "\(kegMovement.kegID): \(kegMovement.dateShort)"
            cell.detailTextLabel?.text = "\(kegMovement.lifeCycleStatus) | Beer: \(kegMovement.beerName) | Location: \(kegMovement.locationName)"
        default:
            print("Something went wrong with the switch case")
        }
        
//        for _ in sortedMovements {
//            if kegMovement.lifeCycleStatus == "full" {
//                cell.detailTextLabel?.text = "Filled: \(kegMovement.beerName) | Ready for sale."
//            } else if kegMovement.lifeCycleStatus == "sold" {
//                cell.detailTextLabel?.text = "Sold: \(kegMovement.beerName) | To: \(kegMovement.locationName)."
//            } else if kegMovement.lifeCycleStatus == "empty" || kegMovement.lifeCycleStatus == ""{
//                cell.detailTextLabel?.text = "Empty | returned from \(kegMovement.locationName)"
//            }
//        }
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














