//
//  UserKeysForUserDefault.swift
//  TorresLyan_MoneyPerHour
//
//  Created by Lyan Torres on 3/13/18.
//  Copyright © 2018 Lyan Torres. All rights reserved.
//

import Foundation

class UserKeys {
    
    var hourlyPay = "hourlyPay"
    var goalName = "goalName"
    var goalTotal = "goalTotal"
    var goalPercentage = "goalPercentage"
    var earnings = "earnings"
    var hoursWorked = "hoursWorked"
    
    func getPayKey() -> String {
        return hourlyPay
    }
    
    func getGoalNameKey() -> String {
        return goalName
    }
    
    func getTotalKey() -> String {
        return goalTotal
    }
    
    func getPercentageKey() -> String {
        return goalPercentage
    }
    
    func getEarnings() -> String {
        return earnings
    }
    
    func getHoursWorked() -> String {
        return hoursWorked
    }
}

