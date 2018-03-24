//
//  WorkDay.swift
//  TorresLyan_MoneyPerHour
//
//  Created by Lyan Torres on 3/23/18.
//  Copyright © 2018 Lyan Torres. All rights reserved.
//

import Foundation

class WorkDay {
    
    var date: String
    var hoursWorked: Double
    var earnings: Double
    
    init(date: String, hoursWorked: Double, earnings: Double) {
        self.date = date
        self.hoursWorked = hoursWorked
        self.earnings = earnings
    }
    
    public func getDate() ->String {
        return date
    }
    
    public func getHoursWorked() ->Double {
        return hoursWorked
    }
    
    public func getEarnings() ->Double {
        return earnings
    }
}
