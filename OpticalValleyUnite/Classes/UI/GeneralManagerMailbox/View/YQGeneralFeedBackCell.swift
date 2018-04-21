//
//  YQGeneralFeedBackCell.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/4/21.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQGeneralFeedBackCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var model : YQGeneralFeedBackModel?{
        
        didSet{
            
            self.timeLabel.text = model?.createTime
            self.titleLabel.text = model?.title
            
            switch (model?.status)! {
                case 0://未处理
                    self.typeLabel.text = "待处理"
                    break
                case 1://已处理
                    self.typeLabel.text = "已处理"
                    break
                default:
                    break
            }
            
        }
    }
    
    
    
}
