//
//  HomeScreen.swift
//  DeviceInventory
//
//  Created by Dhanshri Pawar on 27/04/20.
//  Copyright © 2020 Dhanshri Pawar. All rights reserved.
//

import UIKit
import Firebase

class HomeScreen: CustomNavigationController, HomeScreenProtocol {
    
    private let homeScreenPresenter = HomeScreenPresenter()
    var user : User?
    var reachability : Reachability?
    
    @IBOutlet weak var adminButton: UIButton!
    @IBOutlet weak var employeeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.reachability = try? Reachability.init()
        
        if self.reachability?.connection != Reachability.Connection.unavailable {
            initUI()
        } else {
            showErrorAlert(title: "Not Connected", message: "Please check your internet connection.")
        }
        
    }
    
    @IBAction func adminButtonClicked(_ sender: UIButton) {
        user = .admin
        redirectToLogin()
    }
    
    @IBAction func employeeButtonPressed(_ sender: UIButton) {
        user = .employee
        redirectToLogin()
    }
    
    func initUI() {
        let def = UserDefaults.standard
        // return false if not found or stored value
        let is_authenticated = def.bool(forKey: "is_authenticated")
        
        if is_authenticated {
            guard let email = def.string(forKey: "withEmail") else { return }
            guard let password = def.string(forKey: "withPassword") else { return }
            guard let user = def.string(forKey: "forUser") else { return }
            
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if error != nil {
                    // If there is an error while signing in the user then it will display the error on the screen.
                    self.showErrorAlert(title: "Error in SignIn", message: error!.localizedDescription)
                }else {
                    // If there is no error the signing in will be successfull and it will transit to Platform selection page.
                    let platformPage = self.storyboard!.instantiateViewController(withIdentifier: "PlatformSelectionPage") as! PlatformSelectionPage
                    if user == "admin" {
                        platformPage.user = User.admin
                    } else {
                        platformPage.user = User.employee
                        
                    }
                    self.navigationController?.pushViewController(platformPage, animated: false)
                }
            }
        }
        
        // To curve borders of button -
        adminButton.layer.cornerRadius = 5.0
        employeeButton.layer.cornerRadius = 5.0
        
        // To set HomeScreen as delegate to HomeScreenProtocol
        homeScreenPresenter.homeScreenDelegate = self
    }
    
    // When user is selected it will send the user value to further viewcontrollers to show relevent data accordingly.
    func redirectToLogin() {
        let loginpage = self.storyboard!.instantiateViewController(withIdentifier: "Loginpage") as! LoginPage
        loginpage.user = user
        self.navigationController?.pushViewController(loginpage, animated: false)
    }
    
    func showErrorAlert(title : String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let FailAction = UIAlertAction(title: "OK", style: .default) { (errorAction) in
            self.viewDidLoad()
        }
        alert.addAction(FailAction)
        present(alert, animated: true, completion: nil)
    }
    
}
