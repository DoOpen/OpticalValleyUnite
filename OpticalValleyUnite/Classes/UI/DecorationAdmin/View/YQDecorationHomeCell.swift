//
//  YQDecorationHomeCell.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/2/6.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQDecorationHomeCell: UITableViewCell {
    ///属性列表
    @IBOutlet weak var workTypeLabel: UILabel!
    
    @IBOutlet weak var workOrderNameLabel: UILabel!
    
    @IBOutlet weak var workStateLabel: UIButton!
    
    @IBOutlet weak var workDescribetionLabel: UITextView!
    
    @IBOutlet weak var projectNameLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    var model : Any?{
        
        didSet{
        
        
        }
        
    }
    
       
}
