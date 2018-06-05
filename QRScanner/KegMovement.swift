//
//  KegMovement.swift
//  QRScanner
//
//  Created by Markith on 12/19/17.
//  Copyright © 2017 Markith. All rights reserved.
//

import Foundation
import Firebase



class KegMovement {
    
    let key: String
    let dateLong: String
    let dateShort: String
    let dateTimeIntervalSince1970: String
    let kegID: String
    let employeeName: String
    let beerName: String
    let locationName: String
    let notes: String
    var lifeCycleStatus: String // "empty", "full", or "sold"
    let ref: DatabaseReference?

    init(key: String = "", dateLong: String, dateShort: String, dateTimeIntervalSince1970: String, kegID: String, employeeName: String, beerName: String, locationName: String, notes: String, lifeCycleStatus: String) {
        self.key = key
        self.dateLong = dateLong
        self.dateShort = dateShort
        self.dateTimeIntervalSince1970 = dateTimeIntervalSince1970
        self.kegID = kegID
        self.employeeName = employeeName
        self.beerName = beerName
        self.locationName = locationName
        self.notes = notes
        self.lifeCycleStatus = lifeCycleStatus
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        dateLong = snapshotValue["dateLong"] as! String
        dateShort = snapshotValue["dateShort"] as! String
        dateTimeIntervalSince1970 = snapshotValue["dateTimeIntervalSince1970"] as! String
        kegID = snapshotValue["kegID"] as! String
        employeeName = snapshotValue["employeeName"] as! String
        beerName = snapshotValue["beerName"] as! String
        locationName = snapshotValue["locationName"] as! String
        notes = snapshotValue["notes"] as! String
        lifeCycleStatus = snapshotValue["lifeCycleStatus"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "dateLong": dateLong,
            "dateShort": dateShort,
            "dateTimeIntervalSince1970": dateTimeIntervalSince1970,
            "kegID": kegID,
            "employeeName": employeeName,
            "beerName": beerName,
            "locationName": locationName,
            "notes": notes,
            "lifeCycleStatus": lifeCycleStatus
        ]
    }
}






