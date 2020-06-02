//
//  LoginPesenter.swift
//  DeviceInventory
//
//  Created by Dhanshri Pawar on 27/04/20.
//  Copyright © 2020 Dhanshri Pawar. All rights reserved.
//

import Foundation
import Firebase

protocol LoginPageProtocol {
    var errorTextFieldOfLoginPage : UILabel? { get set }
    var user : User? {get set}
    func loadSpinner()
    func hideSpinner()
    func transtionToPlatformSelection()
}

class LoginPresenter {
    
    var loginDelegate : LoginPageProtocol?
    var emailTextFromLoginPage : String?
    var passwordTextFromLoginPage : String?
    var adminData : [Admin]?
    
    // When login button is clicked it will validate the credentials and will transit to Platform Selection Page.
    func whenLoginButtonIsClicked() {
        
        let error = validateTextFields()
        if error != nil {
            showError(error!)
        }else {
            // cleaned data after validation
            guard let email = emailTextFromLoginPage?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            guard let password = passwordTextFromLoginPage?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            
            if loginDelegate?.user == User.admin {
                guard let adminData = adminData else { return }
                var adminFound : Bool = false
                for user in adminData {
                    if user.email == email {
                        adminFound = true
                        self.showError("")
                        loginDelegate?.loadSpinner()
                        DatabaseManager.shared.signInUser(email: email, password: password) { (successful, error) in
                            if successful == true {
                                // If there is no error the signing in will be successfull and it will transit to Platform selection page.
                                self.loginDelegate?.hideSpinner()
                                self.saveLoggedState(email: email, password: password)
                                self.loginDelegate?.transtionToPlatformSelection()
                            } else {
                                 // If there is an error while signing in the user then it will display the error on the screen.
                                self.loginDelegate?.hideSpinner()
                                self.showError(error!)
                            }
                        }
                    }
                }
                if adminFound == false {
                    self.showError("Email not found.")
                }
            } else if loginDelegate?.user == User.employee {
                
                DatabaseManager.shared.signInUser(email: email, password: password) { (successful, error) in
                    if successful == true {
                        // If there is no error the signing in will be successfull and it will transit to Platform selection page.
                         self.saveLoggedState(email: email, password: password)
                         self.loginDelegate?.transtionToPlatformSelection()
                    } else {
                         // If there is an error while signing in the user then it will display the error on the screen.
                        self.showError(error!)
                    }
                }
            }
        }
    }
    
    //fetch admin details to match admin email.
    func fetchAdminDetails() {
        DatabaseManager.shared.takeSnapshotOfAdminDetails { (adminDetails) in
            self.adminData = adminDetails
            if self.adminData?.count != 0 {
                 self.loginDelegate?.hideSpinner()
            }
        }
    }
    
    // Function to validate all the text fields whether they are empty.
    func validateTextFields() -> String? {
        if emailTextFromLoginPage?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextFromLoginPage?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill all fields."
        }
        return nil
    }
    
    // If there is any error while doing the process of sign in, it will display the error on screen.
    func showError(_ message : String) {
        loginDelegate?.errorTextFieldOfLoginPage!.text = message
        loginDelegate?.errorTextFieldOfLoginPage!.alpha = 1
    }
    
    func saveLoggedState(email : String, password : String) {
        let def = UserDefaults.standard
        guard let user = loginDelegate?.user else { return }
        def.set(true, forKey: "is_authenticated") // save true flag to UserDefaults
        def.set(email, forKey: "withEmail")
        def.set(password, forKey: "withPassword")
        if user == User.admin
        {
            def.set("admin", forKey: "forUser")
        } else {
            def.set("employee", forKey: "forUser")
        }
        def.synchronize()
    }
    
    
}
