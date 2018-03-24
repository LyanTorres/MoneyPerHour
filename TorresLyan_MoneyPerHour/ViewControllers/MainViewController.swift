//
//  MainViewController.swift
//  TorresLyan_MoneyPerHour
//
//  Created by Lyan Torres on 3/13/18.
//  Copyright © 2018 Lyan Torres. All rights reserved.
//

import UIKit
import WatchConnectivity
import CoreData

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var user:User?
    var keys = UserKeys()
    let session = WCSession.default
    var daysWorked: [WorkDay] = []
    var progressToGoal = 0.0
    
    @IBOutlet weak var goalProgress: UILabel!
    @IBOutlet weak var goalTotal: UILabel!
    @IBOutlet weak var goalName: UILabel!
    
    var daysWorkdedRetrieved: [DayWorked] = []
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var managedContext: NSManagedObjectContext!
    private var entityDaysDescription: NSEntityDescription!
    
    var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserInfo()
        
        NotificationCenter.default.addObserver(self, selector: #selector(messageReceived(info:)), name: NSNotification.Name(rawValue: "messageFromWatch"), object: nil)
        
        // checking if this is the first time that the user is opening the application
        if user != nil {
            // it isn't so lets update the UI
            updateUI()
            sendMessageToWatch()
        }
        
        
        managedContext = appDelegate.persistentContainer.viewContext
        entityDaysDescription = NSEntityDescription.entity(forEntityName: "DayWorked", in: managedContext)
        
        loadData()
        
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
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        let result = formatter.string(from: date)
        
        self.daysWorked.append(WorkDay.init(date: result, hoursWorked: (message["moneyMade"] as? Double)!, earnings: (message["hoursWorked"] as? Double)!))
        progressToGoal += (message["moneyMade"] as? Double)!
        UserDefaults.standard.set(progressToGoal, forKey: keys.getGoalProgress())
        
        saveData()
        
        DispatchQueue.main.async {
            self.tableView?.reloadData()
            self.goalProgress.text = String(format: "%.2f",self.progressToGoal)
        }
        
    }
    
    func sendMessageToWatch() {
        if self.session.isPaired && self.session.isWatchAppInstalled {
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
        
        do {
            progressToGoal = UserDefaults.standard.double(forKey: keys.getGoalProgress())
        } catch {
        
        }
    }
    
    func saveData() {
        
        clearData()
        
        for (_, dayy) in daysWorked.enumerated() {
            let day = DayWorked(context: managedContext)
            day.date = dayy.date
            day.hoursWorked = String(format: "%.2f",dayy.hoursWorked)
            day.moneyEarned = String(format: "%.2f",dayy.earnings)
        }
        
        appDelegate.saveContext()
    }
    
    func clearData() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "DayWorked")
        if let result = try? managedContext.fetch(fetchRequest) {
            for object in result {
                managedContext.delete(object)
            }
        }
        daysWorkdedRetrieved.removeAll()
    }
    
    func loadData() {
        
        daysWorked = []
        daysWorkdedRetrieved = []
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "DayWorked")
        
        do {
            daysWorkdedRetrieved = try managedContext.fetch(fetchRequest) as! [DayWorked]
        } catch {
            assertionFailure()
        }
        
        if daysWorkdedRetrieved.count != 0 {
            for (_, day) in daysWorkdedRetrieved.enumerated() {
                self.daysWorked.append(WorkDay.init(date: day.date!, hoursWorked: Double(day.hoursWorked!)!, earnings: Double(day.moneyEarned!)!))
            }
        }
        
        updateUI()
    }
    
    
    // TABLE VIEW FUNCTIONS -- SECTION
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tableView = tableView
        return daysWorked.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "day_of_week") as? DayTableViewCell {
            
            cell.dateLBL.text = daysWorked[indexPath.row].getDate()
            cell.earningsLBL.text = "$\(String(daysWorked[indexPath.row].getEarnings()))"
            cell.timeWorkedLBL.text = "\(String(format: "%.2f", daysWorked[indexPath.row].getHoursWorked())) hrs"
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            if indexPath.row < daysWorked.count {
                daysWorked.remove(at: indexPath.row)
                saveData()
                tableView.reloadData()
            }
        }
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
            goalProgress.text = String(format: "%.2f", progressToGoal)
            tableView?.reloadData()
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
            destination.userEditing = true
        }
    }
    
}

