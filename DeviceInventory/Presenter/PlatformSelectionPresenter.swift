//
//  PlatformSelectionPresenter.swift
//  DeviceInventory
//
//  Created by Dhanshri Pawar on 30/04/20.
//  Copyright © 2020 Dhanshri Pawar. All rights reserved.
//

import Foundation

protocol PlatformSelectionProtocol {
    func transitionToChangePasswordPage()
}

class PlatformSelectionPresenter {
 
    var platformSelectionDelegate : PlatformSelectionProtocol?
    
//    Perform redirection to Change Password Page.
    func performTransitionToChangePasswordPage() {
        platformSelectionDelegate?.transitionToChangePasswordPage()
    }
}
