//
//  LoginPage.swift
//  DeviceInventory
//
//  Created by Dhanshri Pawar on 27/04/20.
//  Copyright © 2020 Dhanshri Pawar. All rights reserved.
//

import UIKit
import Firebase

extension UITextField {
    func addBottomBorder(){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
        bottomLine.backgroundColor = UIColor.black.cgColor
        borderStyle = .none
        layer.addSublayer(bottomLine)
    }
}

class LoginPage: CustomNavigationController, LoginPageProtocol {
    
    var errorTextFieldOfLoginPage : UILabel?
    var user : User?
    let loginPresenter = LoginPresenter()
    
    @IBOutlet weak var circularImage: UIImageView!
    @IBOutlet weak var StackView: UIStackView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorTextField: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpPage: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginPresenter.loginDelegate = self
        prepareForLoading()
    }
    
    func prepareForLoading() {
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
    
    @IBAction func redirectToSignUpButtonClicked(_ sender: UIButton) {
        let signupPage = self.storyboard!.instantiateViewController(withIdentifier: "SignUpPage") as! SignUpPage
        self.navigationController?.pushViewController(signupPage, animated: false)
    }
    
    // When login button is clicked it will call the function from presenter for functionality.
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        loginPresenter.emailTextFromLoginPage = emailTextField.text!
        loginPresenter.passwordTextFromLoginPage = passwordTextField.text!
        errorTextFieldOfLoginPage = errorTextField
        loginPresenter.whenLoginButtonIsClicked()
    }
    
    // Function to perform redirection on successfull SignIn from Login Page to Platform Selection page.
    func transtionToPlatformSelection() {
        let platformSelection = self.storyboard!.instantiateViewController(withIdentifier: "PlatformSelectionPage") as! PlatformSelectionPage
        platformSelection.user = user
        self.navigationController?.pushViewController(platformSelection, animated: false)
    }
}

