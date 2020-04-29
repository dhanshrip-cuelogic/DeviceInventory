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
}

class LoginPresenter {
    
    var loginDelegate : LoginPageProtocol?
    
    var emailTextFromLoginPage : String?
    var passwordTextFromLoginPage : String?
    
    init() {
        }
    
    
    func whenLoginButtonIsClicked() {
        
        let error = validateTextFields()
        
        if error != nil {
            showError(error!)
        }else {
            
            // cleaned data after validation
            let email = emailTextFromLoginPage
            let password = passwordTextFromLoginPage
            
            //sign in with provided email and password
            Auth.auth().signIn(withEmail: email!, password: password!) { (result, error) in
                if error != nil {
                    self.showError("error while sign in user.")
                }else {
                    print("login successfull !!!!!")
                }
            }
        }
        

    }
    
    func validateTextFields() -> String? {
        if emailTextFromLoginPage?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextFromLoginPage?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                   return "Please fill all fields."
               }
               return nil
    }
    
    func transitionToSignUp() {
//          performSegue(withIdentifier: "redirectToSignUpPage", sender: self)
      }
      
    func performTransitionToPlatformSelection() {
        // platform selection page
    }
    
    func showError(_ message : String) {
        loginDelegate?.errorTextFieldOfLoginPage!.text = message
        loginDelegate?.errorTextFieldOfLoginPage!.alpha = 1
    }

}
