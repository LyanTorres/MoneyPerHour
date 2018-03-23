//
//  User.swift
//  TorresLyan_MoneyPerHour
//
//  Created by Lyan Torres on 3/13/18.
//  Copyright © 2018 Lyan Torres. All rights reserved.
//

import Foundation

class User {
    
    var hourlyPay: Double
    var goalName: String
    var goalTotal: Int
    var goalPercentage: Int
    
    public init(hourlyPay:Double, goalName:String, goalTotal:Int, goalPercentage:Int) {
        self.hourlyPay = hourlyPay
        self.goalName = goalName
        self.goalTotal = goalTotal
        self.goalPercentage = goalPercentage
    }
    
    public func getHourlyPay() -> Double {
        return hourlyPay
    }
    
    public func getGoalName() -> String {
        return goalName
    }
    
    public func getGoalTotal() -> Int {
        return goalTotal
    }
    
    public func getGoalPercentage() -> Int {
        return goalPercentage
    }
    
    public func setHourlyPay(newPay: Double){
        self.hourlyPay = newPay
    }
    
    public func setGoalName(goalName: String){
        self.goalName = goalName
    }
    
    public func setGoalTotal(goalTotal: Int){
        self.goalTotal = goalTotal
    }
    
    public func setGoalPercentage(goalPercentage: Int){
        self.goalPercentage = goalPercentage
    }
    
    
    
    
}
