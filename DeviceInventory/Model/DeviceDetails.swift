//
//  DeviceDetails.swift
//  DeviceInventory
//
//  Created by Dhanshri Pawar on 02/05/20.
//  Copyright © 2020 Dhanshri Pawar. All rights reserved.
//

import Foundation

struct DeviceDetails : Codable{
    var deviceID : String
    var modelName : String
    var platform : String
    var oSVersion : String
    var status : String
}
