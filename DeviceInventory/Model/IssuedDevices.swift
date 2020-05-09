//
//  IssuedDevices.swift
//  DeviceInventory
//
//  Created by Dhanshri Pawar on 06/05/20.
//  Copyright © 2020 Dhanshri Pawar. All rights reserved.
//

import Foundation

struct IssuedDevices : Codable {
    var CueID : String
    var DeviceID : String
    var Date : String
    var Checkin : String
    var Checkout : String
    var Status : String
}
