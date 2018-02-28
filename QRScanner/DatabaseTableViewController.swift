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
    
    // attemping a change for github with this comment. Delete later.
    // this is a comment added on the TESTGIT

    let ref = Database.database().reference(withPath: "keg-movements")
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
            sortedMovements = movements.sorted( by: { $0.dateLong.compare($1.dateLong) == .orderedAscending } )
            tableViewTitle.title = "Sorted by Date"
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
        
        //        sortOnSelectedRow()
        
        //
        ////        var sortedMovements: [KegMovement] = []
        //        if sortByProperty == "date" {
        //            sortedMovements = movements.sorted( by: { $0.dateLong.compare($1.dateLong) == .orderedAscending } )
        //            tableViewTitle.title = "Sorted by Date"
        //        } else if sortByProperty == "beerName" {
        //            sortedMovements = movements.sorted( by: { $0.beerName.compare($1.beerName) == .orderedAscending } )
        //            tableViewTitle.title = "Sorted by Beer"
        //        } else if sortByProperty == "customerName" {
        //            // Sort out kegs that aren't currently with a customer
        //            // sort into array with only status "sold" then sort by date?
        //
        //            sortedMovements = movements.filter( { $0.lifeCycleStatus == "sold" } )
        //            print("customer filtered by sold \(sortedMovements)")
        ////            sortedMovements = tempSort.sorted( by: { $0.locationName.compare($1.locationName) == .orderedAscending } )
        //
        //            // Original working:
        ////            sortedMovements = movements.sorted( by: { $0.locationName.compare($1.locationName) == .orderedAscending } )
        //
        //            tableViewTitle.title = "Sorted by Customer"
        //                    } else if sortByProperty == "lifeCycleStatus" {
        //            sortedMovements = movements.sorted( by: { $0.lifeCycleStatus.compare($1.lifeCycleStatus) == .orderedAscending } )
        //            tableViewTitle.title = "Sorted by Keg Status"
        //        } else if sortByProperty == "kegID" {
        //            sortedMovements = movements.sorted( by: { $0.kegID.compare($1.kegID) == .orderedDescending } )
        //            tableViewTitle.title = "Sorted by Keg ID"
        //        }
        
        
        let kegMovement = sortedMovements[indexPath.row]
        
        cell.textLabel?.text = "\(kegMovement.kegID): \(kegMovement.dateShort)"
        
        for _ in sortedMovements {
            if kegMovement.lifeCycleStatus == "full" {
                cell.detailTextLabel?.text = "Filled: \(kegMovement.beerName) | Ready for sale."
            } else if kegMovement.lifeCycleStatus == "sold" {
                cell.detailTextLabel?.text = "Sold: \(kegMovement.beerName) | To: \(kegMovement.locationName)."
            } else if kegMovement.lifeCycleStatus == "empty" || kegMovement.lifeCycleStatus == ""{
                cell.detailTextLabel?.text = "Empty | returned from \(kegMovement.locationName)"
            }
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














