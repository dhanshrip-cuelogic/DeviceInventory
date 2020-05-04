//
//  PlatformSelectionPresenter.swift
//  DeviceInventory
//
//  Created by Dhanshri Pawar on 30/04/20.
//  Copyright © 2020 Dhanshri Pawar. All rights reserved.
//

import Foundation

protocol PlatformSelectionProtocol {
    var platform : Platform? {get set}
    func transitionToChangePasswordPage()
    func transitionToDeviceListForEmployeePage()
    func transitionToDeviceListForAdmin()
}

class PlatformSelectionPresenter {
 
    var platformSelectionDelegate : PlatformSelectionProtocol?
    var userFromDelegate : User?
    
//    Perform redirection to Change Password Page.
    func performTransitionToChangePasswordPage() {
        platformSelectionDelegate?.transitionToChangePasswordPage()
    }
    
    // Here we are redirecting to device list pge according to the user.
    func performTransitionToShowDeviceList() {
        if userFromDelegate == .admin {
            platformSelectionDelegate?.transitionToDeviceListForAdmin()
        }
        if userFromDelegate == .employee {
            platformSelectionDelegate?.transitionToDeviceListForEmployeePage()
        }
    }
    
}
