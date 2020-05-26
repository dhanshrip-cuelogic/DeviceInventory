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
    func transtionToPlatformSelection()
}

class LoginPresenter {
    
    var loginDelegate : LoginPageProtocol?
    var emailTextFromLoginPage : String?
    var passwordTextFromLoginPage : String?
    
    init() {
    }
    
    // When login button is clicked it will validate the credentials and will transit to Platform Selection Page.
    func whenLoginButtonIsClicked() {
        
        let error = validateTextFields()
        if error != nil {
            showError(error!)
        }else {
            // cleaned data after validation
            guard let email = emailTextFromLoginPage?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            guard let password = passwordTextFromLoginPage?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            
            // sign in with provided email and password
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if error != nil {
                    // If there is an error while signing in the user then it will display the error on the screen.
                    self.showError("error while sign in user.")
                }else {
                    
                    self.saveLoggedState(email: email, password: password)
                    // If there is no error the signing in will be successfull and it will transit to Platform selection page.
                    self.loginDelegate?.transtionToPlatformSelection()
                }
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
