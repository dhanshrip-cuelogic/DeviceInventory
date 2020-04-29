//
//  LoginPage.swift
//  DeviceInventory
//
//  Created by Dhanshri Pawar on 27/04/20.
//  Copyright © 2020 Dhanshri Pawar. All rights reserved.
//

import UIKit
import Firebase

class LoginPage: UIViewController , LoginPageProtocol {
    
    var errorTextFieldOfLoginPage : UILabel?
    
    var user : String?
    
    let loginPresenter = LoginPresenter()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorTextField: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
//        To set radius to the borders of button and Set this login page as delegate of its presenter.
        errorTextField.alpha = 0
        loginButton.layer.cornerRadius = 20.0
        loginPresenter.loginDelegate = self
        
    }
    
    @IBAction func redirectToSignUpButtonClicked(_ sender: UIButton) {
//            loginPresenter.transitionToSignUp()
    }
    
//    When login button is clicked it will call the function from presenter for functionality.
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        loginPresenter.emailTextFromLoginPage = emailTextField.text!
        loginPresenter.passwordTextFromLoginPage = passwordTextField.text!
        errorTextFieldOfLoginPage = errorTextField
        loginPresenter.whenLoginButtonIsClicked()
    }
    
//    Function to perform redirection on successfull SignIn from Login Page to Platform Selection page.
    func transtionToPlatformSelection() {
        performSegue(withIdentifier: "redirectToPlatformSelectionPage", sender: self)
    }
    
    }

