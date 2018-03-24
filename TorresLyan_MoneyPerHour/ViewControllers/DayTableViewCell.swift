//
//  DayTableViewCell.swift
//  TorresLyan_MoneyPerHour
//
//  Created by Lyan Torres on 3/23/18.
//  Copyright © 2018 Lyan Torres. All rights reserved.
//

import UIKit

class DayTableViewCell: UITableViewCell {

    
    @IBOutlet weak var dateLBL: UILabel!
    @IBOutlet weak var earningsLBL: UILabel!
    @IBOutlet weak var timeWorkedLBL: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
