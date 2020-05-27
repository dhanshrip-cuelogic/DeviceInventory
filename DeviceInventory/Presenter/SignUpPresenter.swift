//
//  SignUpPresenter.swift
//  DeviceInventory
//
//  Created by Dhanshri Pawar on 29/04/20.
//  Copyright © 2020 Dhanshri Pawar. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

protocol SignUpProtocol {
    var errorTextFieldOfSignUpPage : UILabel? { get set }
    func redirect()
}

class SignUpPresenter {
    
    var signUpDelegate : SignUpProtocol?
    var signUpEmailFromSignUpPage : String?
    var signUpPasswordFromSignUpPage : String?
    var signUpCueIDFromSignUpPage : String?
    var signUpUsernameFromSignUpPage : String?
    
    // When user has clicked in SignUp button it will vlidate fields and create new user and It will save details of user.
    func whenSignUpButtonClicked() {
        // validate fields
        let error = validateFields()
        
        // if error while validating fields then display error on screen.
        if error != nil {
            showError(error!)
        }else {
            // cleaned data after validation
            guard let email = signUpEmailFromSignUpPage?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            guard let password = signUpPasswordFromSignUpPage?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            guard let cueid = signUpCueIDFromSignUpPage?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            guard let name = signUpUsernameFromSignUpPage?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            
            // create user with the email, CueID and Password.
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                if err != nil {
                    print(err!.localizedDescription)
//                    self.showError(err!.localizedDescription)
                }else {
                    // If user has created account successfully then the CueID will get saved into database.
                    DatabaseManager.shared.createNewUser(cueID: cueid, email: email, username: name) { successful in
                        if successful == true {
                            // After having successful SignUp it will transit to Login page for SignIn.
                            self.signUpDelegate?.redirect()
                        }else {
                            self.showError("Could not be able to save CueID")
                        }
                    }
                    
                }
            }
        }
    }
    
    // Function to validate all the text fields whether they are empty or are properly filled.
    func validateFields() -> String? {
        let passwordValidate = validatePassword()
        let emailValidate = validateEmail()
        let cueIdValidate = validateCueID()
        if signUpEmailFromSignUpPage?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || signUpPasswordFromSignUpPage?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill all fields."
        }
        else if passwordValidate == false {
            return "Please enter valid password."
        }
        else if emailValidate == false{
            return "Please enter valid email."
        }
        else if cueIdValidate == false {
            return "Please enter valid CueId."
        }
        return nil
    }
    
    // If there is any error while doing the process of sign up, it will display the error on screen.
    func showError(_ message : String) {
        signUpDelegate?.errorTextFieldOfSignUpPage!.text = message
        signUpDelegate?.errorTextFieldOfSignUpPage!.alpha = 1
    }
    
    // It will validate password with the given regular expression.
    func validatePassword() -> Bool? {
        guard let password = signUpPasswordFromSignUpPage else { return false }
        let passwordRegEx = "^([A-Z]+)([a-z]?.*)([!@#$%^&*.].*)([0-9].*)$"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        let passwordResult = passwordTest.evaluate(with: password)
        return passwordResult
    }
    
    // It will validate email with the given regular expression.
    func validateEmail() -> Bool? {
        guard let email = signUpEmailFromSignUpPage else { return false }
        let emailRegEx = "^([a-z]+)([.]{1})([a-z]+)(@cuelogic.com)$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let emailResult = emailTest.evaluate(with: email)
        return emailResult
    }
    
    // It will validate CueID with the given regular expression.
    func validateCueID() -> Bool? {
        guard let cueid = signUpCueIDFromSignUpPage else { return false}
        let cueIdRegEx = "^(Cue)([0-9]{5})$"
        let cueIdTest = NSPredicate(format:"SELF MATCHES %@", cueIdRegEx)
        let cueIdResult = cueIdTest.evaluate(with: cueid)
        return cueIdResult
    }
}
