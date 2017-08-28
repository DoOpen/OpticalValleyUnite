//
//  DeviceCell.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/7/11.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit

class DeviceCell: UITableViewCell {

    @IBOutlet weak var workOderCodeLabel: UILabel!
    @IBOutlet weak var workOrderNameLabel: UILabel!
    @IBOutlet weak var workOrderTypeLabel: UILabel!
    @IBOutlet weak var workOderClassifyLabel: UILabel!
    @IBOutlet weak var carryPeopleLabel: UILabel!
    @IBOutlet weak var managerPeopleLabel: UILabel!
    @IBOutlet weak var carryTimeLabel: UILabel!
    @IBOutlet weak var workOderStutasLabel: UILabel!
    @IBOutlet weak var supervisePeopleLabel: UILabel!
    
    var model: WorkOrderDetailModel?{
        didSet{
            workOderCodeLabel.text = model?.id
            workOrderNameLabel.text = model?.content
            workOrderTypeLabel.text = model?.orderType
            workOderClassifyLabel.text = model?.workTypeName
            carryPeopleLabel.text = model?.EXEC_PERSON_NAME
            carryTimeLabel.text = model?.EXEC_DATE
            managerPeopleLabel.text = model?.managerNmae
            
            switch model!.status {
            case 10:
                workOderStutasLabel.text = "待督办"
                
            case 11:
                workOderStutasLabel.text = "已督办"
                
            case 0:
                workOderStutasLabel.text = "待派发"
            case 1:
                workOderStutasLabel.text = "已派发"

            case 2:
                workOderStutasLabel.text = "已完成"
                
            case 3:
                workOderStutasLabel.text = "已关闭"
                
            case 4:
                workOderStutasLabel.text = "待派发"
                
            case 5:
                workOderStutasLabel.text = "已接单"
                
            case 6:
                workOderStutasLabel.text = "处理中"
                
                
            case 7:
                workOderStutasLabel.text = "已处理"
                
                
            case 8:
                workOderStutasLabel.text = "已评价"
                
                
            default:
                workOderStutasLabel.text = "工单生成"
            }
            
            supervisePeopleLabel.text = model?.SUPERVISE_PERSON_NAMES

            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
