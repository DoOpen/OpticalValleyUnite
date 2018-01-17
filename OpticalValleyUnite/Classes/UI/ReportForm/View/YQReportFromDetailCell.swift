//
//  YQReportFromDetailCell.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/1/17.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQReportFromDetailCell: UITableViewCell {

    @IBOutlet weak var reportFormTitleLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var model : YQReportFormDetailModel?{
        didSet{
            self.reportFormTitleLabel.text = model?.reportTitle
            
            self.timeLabel.text = model?.createTime
            
            self.nameLabel.text = model?.personName
        
        
        }
    
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

   

}
