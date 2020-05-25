//
//  SignUpPage.swift
//  DeviceInventory
//
//  Created by Dhanshri Pawar on 28/04/20.
//  Copyright © 2020 Dhanshri Pawar. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class SignUpPage: CustomNavigationController, SignUpProtocol {
    
    var errorTextFieldOfSignUpPage: UILabel?
    let signUpPresenter = SignUpPresenter()
    var reachability : Reachability?


    @IBOutlet weak var signUpEmailTextField: UITextField!
    @IBOutlet weak var signUpCueIdTextField: UITextField!
    @IBOutlet weak var signUpUsernameTextField: UITextField!
    @IBOutlet weak var signUpPasswordTextField: UITextField!
    @IBOutlet weak var errorTextField: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var circularImage: UIImageView!
    
    override func viewDidLoad() {
       super.viewDidLoad()
       signUpPresenter.signUpDelegate = self as SignUpProtocol
       self.reachability = try? Reachability.init()
       
       if self.reachability?.connection != Reachability.Connection.unavailable {
           initUI()
       } else {
           showErrorAlert(title: "Not Connected", message: "Please check your internet connection.")
       }
        
    }
    
    func initUI() {
        // To add bottom layer for textfields and set borders for buttons.
        self.navigationItem.hidesBackButton = true
        navigationItem.title = "SignUp"
        errorTextField.alpha = 0
        signUpButton.layer.cornerRadius = 20.0
        circularImage.layer.masksToBounds = true
        circularImage.layer.cornerRadius = circularImage.bounds.width / 2
        signUpButton.layer.cornerRadius = 5.0
        loginButton.layer.cornerRadius = 5.0
        
    }
    
    // For redirection to Login Page on successfull signUp of new user.
    @IBAction func redirectToLoginButtonClicked(_ sender: UIButton) {
        redirect()
    }

    // When signUp button is clicked it will send the data from textfields to the presenter for validation and creation of new user.
    @IBAction func signUpButtonClicked(_ sender: UIButton) {
        signUpPresenter.signUpEmailFromSignUpPage = signUpEmailTextField.text!
        signUpPresenter.signUpPasswordFromSignUpPage = signUpPasswordTextField.text!
        signUpPresenter.signUpCueIDFromSignUpPage = signUpCueIdTextField.text!
        signUpPresenter.signUpUsernameFromSignUpPage = signUpUsernameTextField.text!
        errorTextFieldOfSignUpPage = errorTextField
        signUpPresenter.whenSignUpButtonClicked()
    }
    
    func redirect() {
        let loginpage = self.storyboard!.instantiateViewController(withIdentifier: "Loginpage") as! LoginPage
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
