//
//  LoginPage.swift
//  DeviceInventory
//
//  Created by Dhanshri Pawar on 27/04/20.
//  Copyright © 2020 Dhanshri Pawar. All rights reserved.
//

import UIKit
import Firebase

class LoginPage: CustomNavigationController, LoginPageProtocol {
    
    var errorTextFieldOfLoginPage : UILabel?
    var user : User?
    let loginPresenter = LoginPresenter()
    var reachability : Reachability?

    
    @IBOutlet weak var circularImage: UIImageView!
    @IBOutlet weak var StackView: UIStackView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorTextField: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpPage: UIButton!
    @IBOutlet weak var accountLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginPresenter.loginDelegate = self
        
        // Checking network connectivity.
        self.reachability = try? Reachability.init()
        
        if self.reachability?.connection != Reachability.Connection.unavailable {
            initUI()
        } else {
            showErrorAlert(title: "Not Connected", message: "Please check your internet connection.")
        }
    }
    
    func initUI() {
        
        if user == User.admin {
            accountLabel.isHidden = true
            signUpPage.isHidden = true
            showSpinner(onView: self.view)
            loginPresenter.fetchAdminDetails()
        }
        
        self.navigationItem.hidesBackButton = true
        navigationItem.title = "Login"
        navigationItem.leftBarButtonItem = backToHomeScreen()
        
        // To set radius to the borders of button and Set this login page as delegate of its presenter.
        emailTextField.addBottomBorder()
        passwordTextField.addBottomBorder()
        circularImage.layer.masksToBounds = true
        circularImage.layer.cornerRadius = circularImage.bounds.width / 2
        errorTextField.alpha = 0
        loginButton.layer.cornerRadius = 5.0
        signUpPage.layer.cornerRadius = 5.0
    }
    
    func loadSpinner() {
        self.showSpinner(onView: self.view)
    }
    
    func hideSpinner() {
        self.removeSpinner()
    }
    
    @IBAction func redirectToSignUpButtonClicked(_ sender: UIButton) {
        let signupPage = self.storyboard!.instantiateViewController(withIdentifier: "SignUpPage") as! SignUpPage
        signupPage.user = user
        self.navigationController?.pushViewController(signupPage, animated: false)
    }
    
    // When login button is clicked it will call the function from presenter for functionality.
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        loginPresenter.emailTextFromLoginPage = emailTextField.text!
        loginPresenter.passwordTextFromLoginPage = passwordTextField.text!
        errorTextFieldOfLoginPage = errorTextField
        loginPresenter.whenLoginButtonIsClicked()
    }
    
    
    @IBAction func forgotPassword(_ sender: UIButton) {
        let resetPasswordPage = self.storyboard?.instantiateViewController(withIdentifier: "resetPassword") as! ResetPassword
        resetPasswordPage.user = user
        self.navigationController?.pushViewController(resetPasswordPage, animated: false)
    }
    
    // Function to perform redirection on successfull SignIn from Login Page to Platform Selection page.
    func transtionToPlatformSelection() {
        let platformSelection = self.storyboard!.instantiateViewController(withIdentifier: "PlatformSelectionPage") as! PlatformSelectionPage
        platformSelection.user = user
        self.navigationController?.pushViewController(platformSelection, animated: false)
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

