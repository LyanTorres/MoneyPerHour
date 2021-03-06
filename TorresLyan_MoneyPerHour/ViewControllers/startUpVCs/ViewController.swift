//
//  ViewController.swift
//  TorresLyan_MoneyPerHour
//
//  Created by Lyan Torres on 3/12/18.
//  Copyright © 2018 Lyan Torres. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var user: User?
    var keys = UserKeys()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createGradientLayer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func createGradientLayer() {
        var gradientLayer: CAGradientLayer?
        
        gradientLayer = CAGradientLayer()
        
        gradientLayer?.frame = self.view.bounds
        
        gradientLayer?.colors = [UIColor.init(red:0.05, green: 0.04, blue: 0.05, alpha: 1).cgColor, UIColor.init(red: 0.24, green: 0.24, blue: 0.24, alpha: 1).cgColor]
        
        self.view.layer.insertSublayer(gradientLayer!, at: 0)
    }
    

}

