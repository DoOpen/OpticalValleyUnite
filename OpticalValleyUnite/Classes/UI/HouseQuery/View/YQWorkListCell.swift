//
//  YQWorkListCell.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/2/20.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQWorkListCell: UITableViewCell {
    //工单名称
    @IBOutlet weak var workNameLabel: UILabel!
    //工单状态按钮
    @IBOutlet weak var workStateButton: UIButton!
    
    //时间label
    @IBOutlet weak var timeLabel: UILabel!
    //姓名label
    @IBOutlet weak var nameLabel: UILabel!
    
    //描述textView
    @IBOutlet weak var workDescribeTextView: UITextView!
    //项目label
    @IBOutlet weak var projectLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

  
    
    
}
