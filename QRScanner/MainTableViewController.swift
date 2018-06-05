//
//  MainTableViewController.swift
//  QRScanner
//
//  Created by Markith on 5/10/18.
//  Copyright © 2018 Markith. All rights reserved.
//

import UIKit
import Firebase

class MainTableViewController: UITableViewController {
    
    var kegID = ""
    var date = ""
    var employee = ""
    var beer = ""
    var customer = ""
    var notes = ""
    var status = ""
    var chosenBeer = ""
    var sortedMovements: [KegMovement] = []
    var movements: [KegMovement] = []
    var tempArray = [String]()
    var chosenBeerArray = [KegMovement]()
    var sortByProperty = ""
    
    @IBOutlet weak var tableViewTitle: UINavigationItem!
    
    // Comment out "keg-movements" and uncomment "testing-movements" during development
    // Also make this change in QRScannerVC, DatabaseVC and KegFormVC
//    let ref = Database.database().reference(withPath: "testing-movements")
    let ref = Database.database().reference(withPath: "new-keg-movements")
//    let ref = Database.database().reference(withPath: "keg-movements")
    
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
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sortTheMovements()
        return tempArray.count
    }
    
    func sortTheMovements() {
        switch sortByProperty {
        case "inventory":
            
            let arraySortedByDate = movements.sorted( by: { $0.dateTimeIntervalSince1970.compare($1.dateTimeIntervalSince1970) == .orderedDescending } )
            var arrayIfMostRecentEntryIsFull = [String]()
            
            for keg in arraySortedByDate {
                if arrayIfMostRecentEntryIsFull.contains(keg.beerName) {
                    // do nothing
                } else if keg.lifeCycleStatus == "full" && keg.locationName == "Arrow Lodge Brewing" {
                    arrayIfMostRecentEntryIsFull.append(keg.beerName)
                }
            }
            tempArray = arrayIfMostRecentEntryIsFull
            tableViewTitle.title = "Current Inventory"
            print("Movements: \(movements)")
        case "date":
            sortedMovements = movements.sorted( by: { $0.dateTimeIntervalSince1970.compare($1.dateTimeIntervalSince1970) == .orderedDescending } )
            
            for date in sortedMovements {
                if tempArray.contains(date.dateShort) {
                } else {
                    tempArray.append(date.dateShort)
                }
            }
            tableViewTitle.title = "Sorted by Date"
        case "beerName":
            sortedMovements = movements.sorted( by: { $0.beerName.compare($1.beerName) == .orderedAscending } )
            
            for beer in sortedMovements {
                if tempArray.contains(beer.beerName) {
                } else {
                    tempArray.append(beer.beerName)
                }
            }
            tableViewTitle.title = "Sorted by Beer"
        case "customerName":
            sortedMovements = movements.sorted( by: { $0.locationName.compare($1.locationName) == .orderedAscending } )
            for customer in sortedMovements {
                if tempArray.contains(customer.locationName) {
                } else {
                    tempArray.append(customer.locationName)
                }
            }
            tableViewTitle.title = "Sorted by Customer"
        case "lifeCycleStatus":
            sortedMovements = movements.sorted( by: { $0.lifeCycleStatus.compare($1.lifeCycleStatus) == .orderedAscending } )
            for kegStatus in sortedMovements {
                if tempArray.contains(kegStatus.lifeCycleStatus) {
                } else {
                    tempArray.append(kegStatus.lifeCycleStatus)
                }
            }
            tableViewTitle.title = "Sorted by Keg Status"
        case "kegID":
            sortedMovements = movements.sorted( by: { $0.kegID.compare($1.kegID) == .orderedAscending } )
            for kegID in sortedMovements {
                if tempArray.contains(kegID.kegID) {
                } else {
                    tempArray.append(kegID.kegID)
                }
            }
            tableViewTitle.title = "Sorted by Keg ID"
        default:
            print("sortTheMovements switch func didn't work")
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableCell", for: indexPath)
        chosenBeer = tempArray[indexPath.row]
        cell.textLabel?.text = chosenBeer
        
        return cell
    }
    
    // TODO: create func to replace most of the code in prepareForSegue
    // Choose a better name for the function
    func createArrayOfSelectedProperty() {
        
    }
    
    // Got the two step sort for the beer
    // Now to make it work for all the other properties
    // Should probably create a new function that does all the sorting and creates arrays before this segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "beerSegue" {
            switch sortByProperty {
            case "inventory":
                let databaseTableViewVC = segue.destination as? DatabaseTableViewController
                databaseTableViewVC?.sortByProperty = "inventory"
                
                let beerChosen = tempArray[(self.tableView.indexPathForSelectedRow?.row)!]
                print("beerChosen: \(beerChosen)")
                chosenBeerArray.removeAll()
                
                for beer in movements {
                    if beer.beerName == beerChosen {
                        if chosenBeerArray.contains(where: { $0.kegID == beer.kegID } ) {
                            // do nothing
                        } else if beer.locationName == "Arrow Lodge Brewing" && beer.lifeCycleStatus == "full" {
                            chosenBeerArray.append(beer)
                            print("Prepare for segue: \(beer.beerName)")
                        }
                    }
                }
                databaseTableViewVC?.sortedMovements = chosenBeerArray
                databaseTableViewVC?.tableViewTitle.title = beerChosen
            case "date":
                let databaseTableViewVC = segue.destination as? DatabaseTableViewController
                databaseTableViewVC?.sortByProperty = "date"
                
                let beerChosen = tempArray[(self.tableView.indexPathForSelectedRow?.row)!]
                print("beerChosen: \(beerChosen)")
                chosenBeerArray.removeAll()
                
                for beer in movements {
                    if beer.dateShort == beerChosen {
                        chosenBeerArray.append(beer)
                        print("Prepare for segue: \(beer.dateShort)")
                    }
                }
                databaseTableViewVC?.sortedMovements = chosenBeerArray
                databaseTableViewVC?.tableViewTitle.title = beerChosen
            case "beerName":
                let databaseTableViewVC = segue.destination as? DatabaseTableViewController
                databaseTableViewVC?.sortByProperty = "beerName"
                
                let beerChosen = tempArray[(self.tableView.indexPathForSelectedRow?.row)!]
                print("beerChosen: \(beerChosen)")
                chosenBeerArray.removeAll()
                
                for beer in movements {
                    if beer.beerName == beerChosen {
                        chosenBeerArray.append(beer)
                        print("Prepare for segue: \(beer.beerName)")
                    }
                }
                databaseTableViewVC?.sortedMovements = chosenBeerArray
                databaseTableViewVC?.tableViewTitle.title = beerChosen
            case "customerName":
                let databaseTableViewVC = segue.destination as? DatabaseTableViewController
                databaseTableViewVC?.sortByProperty = "customerName"
                
                let beerChosen = tempArray[(self.tableView.indexPathForSelectedRow?.row)!]
                print("beerChosen: \(beerChosen)")
                chosenBeerArray.removeAll()
                
                for beer in movements {
                    if beer.locationName == beerChosen {
                        chosenBeerArray.append(beer)
                        print("Prepare for segue: \(beer.locationName)")
                    }
                }
                databaseTableViewVC?.sortedMovements = chosenBeerArray
                databaseTableViewVC?.tableViewTitle.title = beerChosen
            case "lifeCycleStatus":
                let databaseTableViewVC = segue.destination as? DatabaseTableViewController
                databaseTableViewVC?.sortByProperty = "lifeCycleStatus"
                
                let beerChosen = tempArray[(self.tableView.indexPathForSelectedRow?.row)!]
                print("beerChosen: \(beerChosen)")
                chosenBeerArray.removeAll()
                
                for beer in movements {
                    if beer.lifeCycleStatus == beerChosen {
                        chosenBeerArray.append(beer)
                        print("Prepare for segue: \(beer.lifeCycleStatus)")
                    }
                }
                databaseTableViewVC?.sortedMovements = chosenBeerArray
                databaseTableViewVC?.tableViewTitle.title = beerChosen
            case "kegID":
                let databaseTableViewVC = segue.destination as? DatabaseTableViewController
                databaseTableViewVC?.sortByProperty = "kegID"
                
                let beerChosen = tempArray[(self.tableView.indexPathForSelectedRow?.row)!]
                print("beerChosen: \(beerChosen)")
                chosenBeerArray.removeAll()
                
                for beer in movements {
                    if beer.kegID == beerChosen {
                        chosenBeerArray.append(beer)
                        print("Prepare for segue: \(beer.lifeCycleStatus)")
                    }
                }
                databaseTableViewVC?.sortedMovements = chosenBeerArray
                databaseTableViewVC?.tableViewTitle.title = beerChosen
            default:
                print("Something went wrong in prepareForSegue")
            }
            
        }
    }
}
