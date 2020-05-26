//
//  DeviceHistoryPresenter.swift
//  DeviceInventory
//
//  Created by Dhanshri Pawar on 06/05/20.
//  Copyright © 2020 Dhanshri Pawar. All rights reserved.
//

import Foundation

protocol DeviceHistoryProtocol {
    var resultData : [IssuedDevices] {get set }
    var issuedDevices : [IssuedDevices] {get set}
    var lastKey : String {get set}
    func reloadTable()
}

class DeviceHistoryPresenter {
    
    var deviceHistoryDelegate : DeviceHistoryProtocol?
    var sortedData : [IssuedDevices] = []
    
    func sortByDeviceID(id : String, fromDate : TimeInterval, toDate : TimeInterval, fetch : Bool){
        DatabaseManager.shared.takeSnapshotForDeviceHistory(of: id, fromDate : fromDate, toDate: toDate, fetchingAgain: fetch, completionHandler: { (issuedData) in
            
                    let orderedArray = issuedData! as NSArray
                    let fromPredicate = NSPredicate(format: "date >= %d", fromDate)
                    let toPredicate = NSPredicate(format: "date < %d", toDate)
                    let predicateRule = NSCompoundPredicate(orPredicateWithSubpredicates: [fromPredicate , toPredicate])
                    let filteredData = orderedArray.filtered(using: predicateRule)
        
                    for device in filteredData {
                        self.deviceHistoryDelegate?.issuedDevices.append(device as! IssuedDevices)
                    }
                    self.deviceHistoryDelegate?.reloadTable()
        })
    }    
}
