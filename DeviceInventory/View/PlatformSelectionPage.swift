//
//  PlatformSelectionPage.swift
//  DeviceInventory
//
//  Created by Dhanshri Pawar on 30/04/20.
//  Copyright © 2020 Dhanshri Pawar. All rights reserved.
//

import UIKit

class PlatformSelectionPage: UIViewController, PlatformSelectionProtocol {
    
    @IBOutlet weak var androidButton: UIButton!
    @IBOutlet weak var iOSButton: UIButton!
    
    let platformSelectionPresenter = PlatformSelectionPresenter()
    var user : User?
    var platform : Platform?
    
    override func viewDidLoad() {
       super.viewDidLoad()

        platformSelectionPresenter.platformSelectionDelegate = self
        platformSelectionPresenter.userFromDelegate = user
       }
    
    override func viewWillAppear(_ animated: Bool) {
        androidButton.layer.cornerRadius = 70.0
            iOSButton.layer.cornerRadius = 70.0
    }
    
    @IBAction func androidButtonClicked(_ sender: UIButton) {
        platform = .Android
        platformSelectionPresenter.performTransitionToShowDeviceList()
    }
    
    // When this button is pressed it willcheck for the user(admin/employee) and display the list accordingly related to the user.
    @IBAction func iOSButtonClicked(_ sender: UIButton) {
        platform = .iOS
        platformSelectionPresenter.performTransitionToShowDeviceList()
    }
    
//   When Change Password Button is clicked it will call presenter function for transition.
    @IBAction func changePasswordButtonClicked(_ sender: Any) {
        platformSelectionPresenter.performTransitionToChangePasswordPage()
    }
    
//    Function for transition to Change Password Page.
    func transitionToChangePasswordPage() {
        performSegue(withIdentifier: "redirectToChangePasswordPage", sender: self)
    }
    
    // If user is employee then it will transit to deviceListForEmployee.
    func transitionToDeviceListForEmployeePage() {
        performSegue(withIdentifier: "deviceListForEmployee", sender: self)
    }
    
    // If user is admin then it will transit to devicelistForAdmin.
    func transitionToDeviceListForAdmin() {
        performSegue(withIdentifier: "deviceListForAdmin", sender: self)
    }
    
    // Here we are passing value of platform to the segue for filtering devices according to the selected platform.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "deviceListForEmployee" {
            let employeeList = segue.destination as! DeviceListForEmployee
            employeeList.platform = platform
        }
        if segue.identifier == "deviceListForAdmin" {
            let adminList = segue.destination as! DeviceListForAdmin
            adminList.platform = platform
        }
    }
    
}
