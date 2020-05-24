//
//  DisplayDetailsPage.swift
//  DeviceInventory
//
//  Created by Dhanshri Pawar on 06/05/20.
//  Copyright © 2020 Dhanshri Pawar. All rights reserved.
//

import UIKit
import MessageUI

class DisplayDetailsPage: CustomNavigationController, DisplayDeviceProtocol , MFMailComposeViewControllerDelegate{
    
    
    @IBOutlet weak var deviceIDLabel: UILabel!
    @IBOutlet weak var modelNameLabel: UILabel!
    @IBOutlet weak var platformLabel: UILabel!
    @IBOutlet weak var osVersionLabel: UILabel!
    @IBOutlet weak var issuedButtonLabel: UIButton!
    @IBOutlet weak var checkoutButtonLabel: UIButton!
    @IBOutlet weak var CheckinButtonLabel: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var complaintButton: UIButton!
    
    let displayPresenter = DisplayDevicePresenter()
    var deviceID : String?
    var modelName : String?
    var platform : String?
    var osVersion : String?
    var status : String?
    var issuedUserCueID : String?
    var currentUserCueID : String?
    var currentUserName : String?
    var user : User?

    override func viewDidLoad() {
        super.viewDidLoad()
        displayPresenter.displayDelegate = self
        prepareForLoading()
    }
    
    func prepareForLoading() {
        self.navigationItem.hidesBackButton = true
        navigationItem.title = "Device Details"
        navigationItem.leftBarButtonItem = backButton()
        
        CheckinButtonLabel.layer.cornerRadius = 5.0
        checkoutButtonLabel.layer.cornerRadius = 5.0
        issuedButtonLabel.layer.cornerRadius = 5.0
        historyButton.layer.cornerRadius = 5.0
        complaintButton.layer.cornerRadius = 5.0
        
        displayPresenter.currentDeviceID = deviceID
       
        
        deviceIDLabel.text = deviceID
        modelNameLabel.text = modelName
        platformLabel.text = platform
        osVersionLabel.text = osVersion
    
        if user == User.employee {
            displayPresenter.getCurrentUser { (userID, userName) in
                   self.currentUserCueID = userID
                   self.currentUserName = userName
                   self.setActionButton()
            }
            
            displayPresenter.getIssuedUser { (issuedBy) in
                   self.issuedUserCueID = issuedBy
                   self.setActionButton()
            }
        } else if user == User.admin{
            CheckinButtonLabel.isHidden = true
            checkoutButtonLabel.isHidden = true
            issuedButtonLabel.isHidden = true
        }
    }
    
    func setActionButton() {
        if status == "Available" {
            CheckinButtonLabel.isHidden = false
            checkoutButtonLabel.isHidden = true
            issuedButtonLabel.isHidden = true
        }
        if status == "Issued" {
            if issuedUserCueID == currentUserCueID {
                checkoutButtonLabel.isHidden = false
                issuedButtonLabel.isHidden = true
                CheckinButtonLabel.isHidden = true
            } else {
                issuedButtonLabel.isHidden = false
                checkoutButtonLabel.isHidden = true
                CheckinButtonLabel.isHidden = true
            }
        }
    }

    @IBAction func Checkin(_ sender: UIButton) {
        // It will call a method from presenter to perform action of this button i.e., to save time of check-in for this user.
        let currentDateAndTime = displayPresenter.getDateAndTime()
        let currentDate = currentDateAndTime.date
        let currentTime = currentDateAndTime.time
        let childID = currentDateAndTime.childID
        
        guard let id = currentUserCueID else { return }
        guard let name = currentUserName else { return }
        guard let deviceid = deviceID else { return }
        displayPresenter.whenCheckinButtonIsClicked(childID : childID, cueID: id, name : name, deviceID: deviceid, date: currentDate, checkin: currentTime)
    }
    
    @IBAction func Checkout(_ sender: UIButton) {
        // It will call a method from presenter to perform action of this button i.e., to save time of check-in for this user.
        let currentTime = displayPresenter.getDateAndTime().time
        guard let deviceid = deviceID else { return }
        displayPresenter.whenCheckoutButtonIsClicked(deviceID: deviceid, checkout: currentTime)
    }
    
    @IBAction func registerComplaint(_ sender: UIButton) {
        let recipientEmail = "dhanshrip35@gmail.com"
        let subject = "Complaint against device."
        let body = "I have found this device damaged!!!"
        
        guard MFMailComposeViewController.canSendMail()
            else {
                showErrorAlert(title: "Failed", message: "Mail could not be sent.")
                return
            }
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = self
        mail.setToRecipients([recipientEmail])
        mail.setSubject(subject)
        mail.setMessageBody(body, isHTML: false)

        present(mail, animated: true)
    }
    
    @IBAction func issuedButton(_ sender: UIButton) {
    }
    
    @IBAction func deviceHistory(_ sender: UIButton) {
        let deviceHistoryPage = self.storyboard!.instantiateViewController(withIdentifier: "DeviceHistoryPage") as! DeviceHistoryPage
        deviceHistoryPage.deviceID = deviceID
        self.navigationController?.pushViewController(deviceHistoryPage, animated: false)
    }
    
    
    
    // On successfull action of deleting or editing data it will show an successful alert.
    func showAlert() {
        let alert = UIAlertController(title: "Successfull", message: "Issued device Succesfully", preferredStyle: .alert)
        let OkAction = UIAlertAction(title: "OK", style: .default) { (saveAction) in
            self.checkoutButtonLabel.isHidden = false
            self.CheckinButtonLabel.isHidden = true
            self.issuedButtonLabel.isHidden = true
        }
        alert.addAction(OkAction)
        present(alert, animated: true, completion: nil)
    }
    
    // On successfully checkout it will showw and alert.
    func showAlertAfterCheckout() {
        let alert = UIAlertController(title: "Successfull", message: "Checkout Succesfully", preferredStyle: .alert)
        let OkAction = UIAlertAction(title: "OK", style: .default) { (saveAction) in
            self.checkoutButtonLabel.isHidden = true
            self.CheckinButtonLabel.isHidden = false
            self.issuedButtonLabel.isHidden = true
        }
        alert.addAction(OkAction)
        present(alert, animated: true, completion: nil)
    }
    
    // If it fails to perform the operation it will sow an alert regarding the same.
    func showErrorAlert(title : String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let FailAction = UIAlertAction(title: "OK", style: .default) { (errorAction) in
        }
        alert.addAction(FailAction)
        present(alert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
}
