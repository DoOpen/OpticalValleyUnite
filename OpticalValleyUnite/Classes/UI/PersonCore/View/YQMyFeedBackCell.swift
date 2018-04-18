//
//  YQMyFeedBackCell.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/4/2.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQMyFeedBackCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

    
    }

    
    var model : YQFeedbackListModel? {
        
        didSet{
        
            self.titleLabel.text = model?.title
            self.timeLabel.text = model?.createTime
            
        }
    
    }

   

}
