//
//  MainViewController.swift
//  TorresLyan_MoneyPerHour
//
//  Created by Lyan Torres on 3/13/18.
//  Copyright © 2018 Lyan Torres. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var user:User?
    var keys = UserKeys()
    
    @IBOutlet weak var goalProgress: UILabel!
    @IBOutlet weak var goalTotal: UILabel!
    @IBOutlet weak var goalName: UILabel!
    @IBOutlet weak var nextShift: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserInfo()
        
        // checking if this is the first time that the user is opening the application
        if user != nil {
            // it isn't so lets update the UI
            updateUI()
        }
        
        // adding the gradient effect on the bacgground so that it's consistent
        createGradientLayer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // can't preform a segue before the view loads (learned this the hard way) so we check here
        
        // checking if they've used this app before
        if user == nil {
            // they haven't so end them to the "sign up process"
            performSegue(withIdentifier: "goToSignUp", sender: self)
        }
    }
    
    // Getting data from the user defaults
    func getUserInfo() {
        
        if let hourlyPay = UserDefaults.standard.double(forKey: keys.getPayKey()) as? Double {
            
            // since there is something then we need to get the rest of the data
            if  let goalName = UserDefaults.standard.string(forKey: keys.getGoalNameKey()) {
                
                let goalTotal = UserDefaults.standard.integer(forKey: keys.getTotalKey())
                let goalPercentage = UserDefaults.standard.double(forKey: keys.getPercentageKey())
                
                user = User.init(hourlyPay: hourlyPay, goalName: goalName, goalTotal: goalTotal, goalPercentage: goalPercentage)
                
            }
        }
    }

    
    // TABLE VIEW FUNCTIONS -- SECTION
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
    
    // SUPERFICIAL STUFF, not really relevant to functionaility
    func createGradientLayer() {
        var gradientLayer: CAGradientLayer?
        
        gradientLayer = CAGradientLayer()
        
        gradientLayer?.frame = self.view.bounds
        
        gradientLayer?.colors = [UIColor.init(red:0.05, green: 0.04, blue: 0.05, alpha: 1).cgColor, UIColor.init(red: 0.24, green: 0.24, blue: 0.24, alpha: 1).cgColor]
        
        self.view.layer.insertSublayer(gradientLayer!, at: 0)
    }

    func updateUI(){
        if let userInfo = user {
            goalName.text = "Goal: " + userInfo.getGoalName()
            goalTotal.text = String(userInfo.getGoalTotal())
            nextShift.text = "N/A"
        }
    }
    
    @IBAction func unwindToVC(segue:UIStoryboardSegue) {
        getUserInfo()
        updateUI()
    }
    
}
