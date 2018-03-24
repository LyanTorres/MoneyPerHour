//
//  InterfaceController.swift
//  TorresLyan_MoneyPerHour WatchKit Extension
//
//  Created by Lyan Torres on 3/12/18.
//  Copyright © 2018 Lyan Torres. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController {
    
    
    @IBOutlet var startButton: WKInterfaceButton!
    @IBOutlet var finishSignUpLBL: WKInterfaceLabel!
    var user: User?
    var keys = UserKeys()
    let session = WCSession.default
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        
        getUserInfo()
        NotificationCenter.default.addObserver(self, selector: #selector(gotAlertFromPhone), name: NSNotification.Name(rawValue: "gotAlert"), object: nil)
        
        if user != nil {
            hideOrShowLBL(userSignedUp: true)
        } else {
            hideOrShowLBL(userSignedUp: false)
        }
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @objc func gotAlertFromPhone(info:NSNotification) {
        let message = info.userInfo
        user = User.init(hourlyPay: (message!["msg"] as? Double)!, goalName: "", goalTotal: 0, goalPercentage: 0)
        hideOrShowLBL(userSignedUp: true)
        saveUserInfo(user: user!)
    }
    
    // saving their info into user defaults so that we can get them when we need them and at start up
    func saveUserInfo(user: User) {
        UserDefaults.standard.set(user.getHourlyPay(), forKey: keys.getPayKey())
        UserDefaults.standard.set(user.getGoalName(), forKey: keys.getGoalNameKey())
        UserDefaults.standard.set(user.getGoalTotal(), forKey: keys.getTotalKey())
        UserDefaults.standard.set(user.getGoalPercentage(), forKey: keys.getPercentageKey())
    }
    
    
    // Getting data from the user defaults
    func getUserInfo() {
        
        if let hourlyPay = UserDefaults.standard.double(forKey: keys.getPayKey()) as? Double {
            
            // since there is something then we need to get the rest of the data
            if  let goalName = UserDefaults.standard.string(forKey: keys.getGoalNameKey()) {
                
                let goalTotal = UserDefaults.standard.integer(forKey: keys.getTotalKey())
                let goalPercentage = UserDefaults.standard.integer(forKey: keys.getPercentageKey())
                
                self.user = User.init(hourlyPay: hourlyPay, goalName: goalName, goalTotal: goalTotal, goalPercentage: goalPercentage)
                
            }
        }
    }
    
    
    func hideOrShowLBL(userSignedUp: Bool){
        startButton.setEnabled(userSignedUp)
        finishSignUpLBL.setHidden(userSignedUp)
    }
}

