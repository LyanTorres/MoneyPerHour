//
//  ActiveShiftInterfaceController.swift
//  TorresLyan_MoneyPerHour WatchKit Extension
//
//  Created by Lyan Torres on 3/23/18.
//  Copyright © 2018 Lyan Torres. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class ActiveShiftInterfaceController: WKInterfaceController{
    
    @IBOutlet var endShiftButton: WKInterfaceButton!
    @IBOutlet var moneyEarnedLBL: WKInterfaceLabel!
    var user: User?
    var keys = UserKeys()
    var eightHourShiftTotal:Double!
    var timer: Timer!
    var moneyPerSec: Double!
    var moneyMade = 0.0
    var timeWorked = 0.0
    let session = WCSession.default
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        getUserInfo()
        startCounters()
        
        if let currentUser = user {
            eightHourShiftTotal = currentUser.getHourlyPay() * 1
            moneyPerSec = ((currentUser.getHourlyPay() / 60) / 60)
            
            if let shift = eightHourShiftTotal {
                moneyEarnedLBL.setText("$0.00 / $\(String(format: "%.2f", shift))")
            }
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
    
    
    func startCounters() {
        // setting it to re-occur every second
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateUI), userInfo: nil, repeats: true)
    }
    
    func stopCounter(){
        timer.invalidate()
    }
    
    @objc func updateUI() {
        
        if Int(moneyMade) != Int(eightHourShiftTotal) {
            moneyMade += moneyPerSec
            timeWorked += 0.01
            
            if let shift = eightHourShiftTotal{
                moneyEarnedLBL.setText("$\(String(format: "%.2f", moneyMade)) / $\(String(format: "%.2f", shift))")
            }
        } else {
            
            endShiftButton.setHidden(true)
            stopCounter()
            
            // they have finished their eight hour shift
            let action = WKAlertAction(title: "OK", style: WKAlertActionStyle.default) {
                self.dismiss()
            }
            presentAlert(withTitle: "Your shift is done!", message: "We'll log it for you!", preferredStyle: WKAlertControllerStyle.alert, actions:[action])
        }
    }
    
    @IBAction func shiftEndedWasPressed() {
        
        // save necessary information
        stopCounter()
        let applicationDict = ["moneyMade": moneyMade, "hoursWorked": timeWorked]
        self.session.sendMessage(applicationDict, replyHandler: nil, errorHandler: nil)
        
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

