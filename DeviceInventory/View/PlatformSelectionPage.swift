//
//  PlatformSelectionPage.swift
//  DeviceInventory
//
//  Created by Dhanshri Pawar on 30/04/20.
//  Copyright © 2020 Dhanshri Pawar. All rights reserved.
//

import UIKit

class PlatformSelectionPage: UIViewController, PlatformSelectionProtocol {

    let platformSelectionPresenter = PlatformSelectionPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        platformSelectionPresenter.platformSelectionDelegate = self
    }
    
//   When Change Password Button is clicked it will call presenter function for transition.
    @IBAction func changePasswordButtonClicked(_ sender: Any) {
        platformSelectionPresenter.performTransitionToChangePasswordPage()
    }
    
//    Function for transition to Change Password Page.
    func transitionToChangePasswordPage() {
        performSegue(withIdentifier: "redirectToChangePasswordPage", sender: self)
    }
    
}
