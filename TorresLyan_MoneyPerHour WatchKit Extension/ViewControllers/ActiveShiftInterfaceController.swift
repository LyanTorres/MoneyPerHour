//
//  ActiveShiftInterfaceController.swift
//  TorresLyan_MoneyPerHour WatchKit Extension
//
//  Created by Lyan Torres on 3/23/18.
//  Copyright © 2018 Lyan Torres. All rights reserved.
//

import WatchKit
import Foundation


class ActiveShiftInterfaceController: WKInterfaceController {
    
    @IBOutlet var goalEarnedLBL: WKInterfaceLabel!
    @IBOutlet var moneyEarnedLBL: WKInterfaceLabel!
    var user: User?
    var keys = UserKeys()
    var eightHourShiftTotal:Double?
    var timer: Timer!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        startCounter()
        eightHourShiftTotal = user!.getHourlyPay() * 8
        
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    func startCounter() {
        // setting it to re-occur every second
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateUI), userInfo: nil, repeats: true)
    }
    
    @objc func updateUI() {
        
    }
    
    func doMath() -> Double {
        
        
        
        return 0.0
    }
    
    
    @IBAction func shiftEndedWasPressed() {
        
        // save necessary information
        
        
        self.dismiss()
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
    

}
