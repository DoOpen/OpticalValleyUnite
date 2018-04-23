//
//  YQGeneralManagerCheckCell.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/4/14.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQGeneralManagerCheckCell: UITableViewCell {

    @IBOutlet weak var titleLable: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var parkName: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var model : YQGeneralCheckOutModel? {
        
        didSet{
            
            self.statusLabel.text = model?.title
            self.parkName.text = model?.parkName
            self.timeLabel.text = model?.createTime
            self.titleLable.text = model?.title
            
            if model?.status == 0{
                
                self.statusLabel.text = "待处理"
                
            }else{
                
                self.statusLabel.text = "已处理"
            }
            
            
        }
    }
    
  
}
