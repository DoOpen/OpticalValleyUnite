//
//  OrderReturningCell.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/6/3.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit

class OrderReturningCell: UITableViewCell {

    @IBOutlet weak var text1Label: UILabel!
    
    @IBOutlet weak var text2Label: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }


    var model: WorkHistoryModel?{
        didSet{
            if let model = model{
                
                text1Label.text = model.person_name
                timeLabel.text = model.time
                text2Label.text = model.content
            }
            
        }
        
    }
    
}
