//
//  DubanCell.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/4/1.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit

class DubanCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var model: WorkOrderDetailModel?{
        didSet{
            if let model = model{
                
                if model.status == 0 {
                    timeLabel.text = model.time
                    nameLabel.text = model.reportPeopleName
                    if let url = URL(string: (model.reportPeopleIcon)){
                        iconView.kf.setImage(with: url)
                    }else{
                        iconView.image = UIImage(named: "avatar")
                    }
                }else{
                    timeLabel.text = model.EXEC_DATE
                    nameLabel.text = model.EXEC_PERSON_NAME
                    if let url = URL(string: (model.EXEC_PICTURE)){
                        iconView.kf.setImage(with: url)
                    }else{
                        iconView.image = UIImage(named: "avatar")
                    }
                }

                
                let array = ["待派发","已派发","已完成","已取消","已退回","已接受","处理中","已执行","已评价","关闭","督办","二级督办","三级督办",]
                statusLabel.text = array[max(model.status, 0)]
            }
        }
    }

}
