//
//  WorkOrderStutasCell.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/1/13.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit
import Kingfisher

class WorkOrderStutasCell: UITableViewCell {

    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var TimeLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var detailModel: WorkOrderDetailModel?
    
    var model: WorkHistoryModel?{
        didSet{
            if let model = model{
                
                TimeLabel.text = model.time


                
                switch model.status {
                case 10://缺少界面
                    titleLabel.text = "待督办"
                    titleLabel.textColor = UIColor.red
                    tipLabel.text = model.content
                    nameLabel.text = ""

                case 11:
                    titleLabel.text = "已督办"
                    titleLabel.textColor = UIColor.red
                    tipLabel.text = "督办人: "
                    nameLabel.text = model.person_name

                case 2:
                    titleLabel.text = "已完成"
                    titleLabel.textColor = UIColor.darkText
                case 3:
                    titleLabel.text = "已关闭"
                    titleLabel.textColor = UIColor.darkText
                    
                case 5:
                    titleLabel.text = "已接单"
                    tipLabel.text = "接单人: "
                    nameLabel.text = model.person_name
                    
                    titleLabel.textColor = UIColor.colorFromRGB(rgbValue: 0xcccccc)
                case 6:
                    titleLabel.text = "处理中"
                    titleLabel.textColor = UIColor.darkText
                    
                case 7://是否改为已完成
                    
                    if detailModel?.orderType == "计划工单"{
                        nameLabel.text = model.content
                    }else{
                        nameLabel.text = model.text
                    }
                    
                    titleLabel.text = "已处理    (点击查看工单执行情况)"
                    titleLabel.textColor = UIColor.colorFromRGB(rgbValue: 0xcccccc)
                    tipLabel.text = ""
                    
                    nameLabel.setLineSpacing(8.0)

                case 8:
                    titleLabel.text = "已评价"
                    titleLabel.textColor = UIColor.darkText

                default:
                    titleLabel.text = "工单生成"
                }
            }
        }
    }

}

class WorkOrderCreatCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    //type == 1 代表工单上传   2 代表督办内容
    var type = 1{
        didSet{
            if type == 2{
                titleLabel.text = "督办内容"
                
                if model?.status == 0 {
                    timeLabel.text = model?.time
                    nameLabel.text = model?.reportPeopleName
                }else{
                    timeLabel.text = model?.EXEC_DATE
                    nameLabel.text = model?.EXEC_PERSON_NAME
                }
                
                
            }else{
                titleLabel.text = "工单生成"
            }
        }
    }
    
    var model: WorkOrderDetailModel?{
        didSet{
            
            if let model = model{
                timeLabel.text = model.time
                nameLabel.text = model.reportPeopleName
            }
        }
    }
}
