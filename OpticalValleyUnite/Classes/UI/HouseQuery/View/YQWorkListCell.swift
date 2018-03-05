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
    
    var selectTag = -1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var model : YQWorkListModel?{
        didSet{
            
            //工单编号
            self.workNameLabel.text = model?.id
            
//            switch selectTag {
//                
//                case 1:
//                    self.workStateButton.setTitle(model?.unitStatusName, for: .normal)
//                    break
//                case 2:
//                    self.workStateButton.setTitle(model?.applyStatusName, for: .normal)
//                    break
//                case 3:
//                    self.workStateButton.setTitle(model?.unitStatusName, for: .normal)
//                    break
//                default:
//                    break
//            }
            
            self.workStateButton.setTitle(model?.unitStatusName, for: .normal)
            
            self.timeLabel.text = "执行人:" +  (model?.personName)!
            self.nameLabel.text = "执行时间:" +  (model?.createDate)!

            
            self.projectLabel.text = "所属项目:" +  (model?.parkName)!
            self.workDescribeTextView.text = model?.workunitName
            
        }
    
    }
    
    
}
