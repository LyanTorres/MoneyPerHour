//
//  InfoFormViewController.swift
//  TorresLyan_MoneyPerHour
//
//  Created by Lyan Torres on 3/13/18.
//  Copyright © 2018 Lyan Torres. All rights reserved.
//

import UIKit

class InfoFormViewController: UIViewController {
    
    @IBOutlet weak var hourlyPayTF: UITextField!
    @IBOutlet weak var goalNameTF: UITextField!
    @IBOutlet weak var goalTotalTF: UITextField!
    @IBOutlet weak var percentageGoalTF: UITextField!
    @IBOutlet weak var percentageExampleLBL: UILabel!
    @IBOutlet weak var resetLBL: UILabel!
    @IBOutlet weak var resetSwitch: UISwitch!
    
    var user: User?
    var keys = UserKeys()
    var userEditing = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let currentUser = user {
            
            hourlyPayTF.text = String(currentUser.getHourlyPay())
            goalNameTF.text = currentUser.getGoalName()
            goalTotalTF.text = String(currentUser.getGoalTotal())
            percentageGoalTF.text = String(currentUser.getGoalPercentage())
            percentageExampleLBL.text = "$\(String(format: "%.2f", currentUser.getGoalPercentage()))"
            
        }
        
        if userEditing{
            resetLBL.isHidden = false
            resetSwitch.isHidden = false
        }
        
        createGradientLayer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func saveButtonWasPressed(_ sender: Any) {
        
        // check if the information they provided is there AND that it's valid
        if let hourlyPayString = hourlyPayTF.text, let goalName = goalNameTF.text, let goalTotalString = goalTotalTF.text, let goalPercentageString = percentageGoalTF.text {
            
            // make sure that some of them are numbers, becasue that's what we need
            if let hourlyPay = Double(hourlyPayString), let goalTotal = Int(goalTotalString), let goalPercentage = Int(goalPercentageString) {
                user = User.init(hourlyPay: hourlyPay, goalName: goalName, goalTotal: goalTotal, goalPercentage: goalPercentage)
                saveUserInfo(user: user!)
                
                if userEditing {
                    if resetSwitch.isOn {
                        UserDefaults.standard.set(0.0, forKey: keys.getGoalProgress())
                    }
                }
                
                performSegue(withIdentifier: "unwindToMain", sender: self)
                
            } else {
                // tell them something went wrong, trying to be specific
                showAlert(title: "Invalid Input", message: "Please make sure to fill out all present fields with the appropriate information.")
            }
            
        }else {
            // tell them something went wrong, trying to be specific
            showAlert(title: "Missing fields", message: "Please make sure to fill out all present fields.")
        }
        
    }
    
    // alert function that'll make our lives easier
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // saving their info into user defaults so that we can get them when we need them and at start up
    func saveUserInfo(user: User) {
        UserDefaults.standard.set(user.getHourlyPay(), forKey: keys.getPayKey())
        UserDefaults.standard.set(user.getGoalName(), forKey: keys.getGoalNameKey())
        UserDefaults.standard.set(user.getGoalTotal(), forKey: keys.getTotalKey())
        UserDefaults.standard.set(user.getGoalPercentage(), forKey: keys.getPercentageKey())
    }
    
    
    // SUPERFICIAL
    
    @IBAction func typedInPerc(_ sender: UITextField) {
        if let input = sender.text{
            if let percentage: Int = Int(input) {
                
                let perc = Double(percentage) / 100.00
                percentageExampleLBL.text = "$\(String(format: "%.2f", perc))"
                
            }
        }
    }
    
    
    
    func createGradientLayer() {
        var gradientLayer: CAGradientLayer?
        
        gradientLayer = CAGradientLayer()
        
        gradientLayer?.frame = self.view.bounds
        
        gradientLayer?.colors = [UIColor.init(red:0.05, green: 0.04, blue: 0.05, alpha: 1).cgColor, UIColor.init(red: 0.24, green: 0.24, blue: 0.24, alpha: 1).cgColor]
        
        self.view.layer.insertSublayer(gradientLayer!, at: 0)
    }
    
}

