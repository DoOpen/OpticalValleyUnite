//
//  YQEquipHomeListCell.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/2/27.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQEquipHomeListCell: UITableViewCell {
    
    ///属性列表项
    @IBOutlet weak var showImageView: ShowImageView!
    
    @IBOutlet weak var showContentView: UITextView!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var humidityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    
    
}
