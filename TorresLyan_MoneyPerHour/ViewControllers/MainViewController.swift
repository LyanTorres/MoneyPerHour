//
//  MainViewController.swift
//  TorresLyan_MoneyPerHour
//
//  Created by Lyan Torres on 3/13/18.
//  Copyright © 2018 Lyan Torres. All rights reserved.
//

import UIKit
import WatchConnectivity

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var user:User?
    var keys = UserKeys()
    let session = WCSession.default
    
    @IBOutlet weak var goalProgress: UILabel!
    @IBOutlet weak var goalTotal: UILabel!
    @IBOutlet weak var goalName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserInfo()
        
        NotificationCenter.default.addObserver(self, selector: #selector(messageReceived), name: NSNotification.Name(rawValue: "newInfo"), object: nil)
        
        // checking if this is the first time that the user is opening the application
        if user != nil {
            // it isn't so lets update the UI
            updateUI()
            sendMessageToWatch()
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
    
    @objc func messageReceived(info:NSNotification) {
        // they finished a shift so we should add it to core data so we can store the info
        let message = info.userInfo!
        
        DispatchQueue.main.async {
            // do what you gotta do with the new data
        }
        
    }
    
    func sendMessageToWatch() {
        if self.session.isPaired && self.session.isWatchAppInstalled {
            // we don't really need to send data, just letting the watch know that the user can interact with it now
            self.session.sendMessage(["msg": user!.getHourlyPay()], replyHandler: nil, errorHandler: nil)
        }
    }
    
    // Getting data from the user defaults
    func getUserInfo() {
        
        if let hourlyPay = UserDefaults.standard.double(forKey: keys.getPayKey()) as? Double {
            
            // since there is something then we need to get the rest of the data
            if  let goalName = UserDefaults.standard.string(forKey: keys.getGoalNameKey()) {
                
                let goalTotal = UserDefaults.standard.integer(forKey: keys.getTotalKey())
                let goalPercentage = UserDefaults.standard.integer(forKey: keys.getPercentageKey())
                
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
        }
    }
    
    @IBAction func unwindToVC(segue:UIStoryboardSegue) {
        getUserInfo()
        updateUI()
        
        // this means they added info so let's tell the watch that they can press the button to start
        sendMessageToWatch()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? InfoFormViewController {
            destination.user = user
        }
    }
    
}

