//
//  DisplayDetailsPage.swift
//  DeviceInventory
//
//  Created by Dhanshri Pawar on 06/05/20.
//  Copyright © 2020 Dhanshri Pawar. All rights reserved.
//

import UIKit

class DisplayDetailsPage: UIViewController, DisplayDeviceProtocol {
    
    
    @IBOutlet weak var deviceIDLabel: UILabel!
    @IBOutlet weak var modelNameLabel: UILabel!
    @IBOutlet weak var platformLabel: UILabel!
    @IBOutlet weak var osVersionLabel: UILabel!
    @IBOutlet weak var issuedButtonLabel: UIButton!
    @IBOutlet weak var checkoutButtonLabel: UIButton!
    @IBOutlet weak var CheckinButtonLabel: UIButton!
    
    let displayPresenter = DisplayDevicePresenter()
    var deviceID : String?
    var modelName : String?
    var platform : String?
    var osVersion : String?
    var status : String?
    var cueID = "Cue10018"


    override func viewDidLoad() {
        super.viewDidLoad()
        displayPresenter.displayDelegate = self
        displayPresenter.databaseReference()
        deviceIDLabel.text = deviceID
        modelNameLabel.text = modelName
        platformLabel.text = platform
        osVersionLabel.text = osVersion
        if status == "Available" {
            CheckinButtonLabel.isHidden = false
            checkoutButtonLabel.isHidden = true
            issuedButtonLabel.isHidden = true
        }
        if status == "Issued" {
            if cueID == cueID {
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
        let currentDate = getDateAndTime().date
        let currentTime = getDateAndTime().time
        displayPresenter.whenCheckinButtonIsClicked(cueID: cueID, deviceID: deviceID!, date: currentDate, checkin: currentTime)
    }
    
    @IBAction func Checkout(_ sender: UIButton) {
        // It will call a method from presenter to perform action of this button i.e., to save time of check-in for this user.
//        let currentDate = getDateAndTime().date
        let currentTime = getDateAndTime().time
        displayPresenter.whenCheckoutButtonIsClicked(deviceID: deviceID!, checkout: currentTime)
        
    }
    
    @IBAction func registerComplaint(_ sender: UIButton) {
    }
    
    @IBAction func issuedButton(_ sender: UIButton) {
    }
    
    
    @IBAction func deviceHistory(_ sender: UIButton) {
        performSegue(withIdentifier: "redirectToDeviceHistoryPage", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let deviceHistoryPage = segue.destination as! DeviceHistoryPage
        deviceHistoryPage.deviceID = deviceID
    }
    
    // function to get date component from calender.
    func getDateAndTime() -> (date : String, time : String){
        let presentDate = Date()
        let calender = Calendar.current
        let component = calender.dateComponents([.year, .month, .day, .hour, .minute], from: presentDate)
        let convertedDate = "\(component.day ?? 00)-\(component.month ?? 00)-\(component.year ?? 00)"
        let convertedTime = "\(component.hour ?? 00):\(component.minute ?? 00)"
        return (convertedDate, convertedTime)
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
    func showErrorAlert() {
        let alert = UIAlertController(title: "Failed", message: "Failed to perform operation", preferredStyle: .alert)
        let FailAction = UIAlertAction(title: "OK", style: .default) { (errorAction) in
        }
        alert.addAction(FailAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    
}
