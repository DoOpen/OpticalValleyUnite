//
//  YQDeviceCell2.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/11/6.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit

class YQDeviceCell2: UITableViewCell {
    
    //工单类型(计划和 应急)
    @IBOutlet weak var workOrderTypeButton: UIButton!
    //工单号(p01985375)
    @IBOutlet weak var workOrderNumber: UILabel!
    //工单状态(待派发)
    @IBOutlet weak var workOrderType: UIButton!
    //工单内容(内容详情)
    @IBOutlet weak var workOrderContent: UILabel!
    //工单执行人
    @IBOutlet weak var workExecutor: UILabel!
    //工单执行时间
    @IBOutlet weak var workTime: UILabel!
    
    //分割cellImage
    @IBOutlet weak var tempImageView: UIImageView!
    
    
    var model: WorkOrderDetailModel?{
        
        didSet{
            
            workOrderNumber.text = model?.id
            workExecutor.text = "执行人:" + (model?.EXEC_PERSON_NAME)!
            workTime.text = "执行时间:" + (model?.EXEC_DATE)!
            
//            workOrderNameLabel.text = model?.content
//            workOrderTypeLabel.text = model?.orderType
//            workOderClassifyLabel.text = model?.workTypeName
//            carryPeopleLabel.text = model?.EXEC_PERSON_NAME
//            carryTimeLabel.text = model?.EXEC_DATE
//            managerPeopleLabel.text = model?.managerNmae
            
            switch model!.status {
                
            case 10:
                
                workOrderType.setTitle("待督办", for: .normal)
                // workOderStutasLabel.text = "待督办"
                
            case 11:
                
                workOrderType.setTitle("已督办", for: .normal)
                // workOderStutasLabel.text = "已督办"
                
            case 0:
                
                workOrderType.setTitle("待派发", for: .normal)
                // workOderStutasLabel.text = "待派发"
            case 1:
                
                workOrderType.setTitle("已派发", for: .normal)
                // workOderStutasLabel.text = "已派发"
                
            case 2:
                
                workOrderType.setTitle("已完成", for: .normal)
                // workOderStutasLabel.text = "已完成"
                
            case 3:
                
                workOrderType.setTitle("已关闭", for: .normal)
                // workOderStutasLabel.text = "已关闭"
                
            case 4:
                
                workOrderType.setTitle("待派发", for: .normal)
                // workOderStutasLabel.text = "待派发"
                
            case 5:
                
                workOrderType.setTitle("已接单", for: .normal)
                // workOderStutasLabel.text = "已接单"
                
            case 6:
                
                workOrderType.setTitle("处理中", for: .normal)
                // workOderStutasLabel.text = "处理中"
                
            case 7:
                
                workOrderType.setTitle("已处理", for: .normal)
                // workOderStutasLabel.text = "已处理"
                
            case 8:
                workOrderType.setTitle("已评价", for: .normal)
                // workOderStutasLabel.text = "已评价"
                
            default:
                
                workOrderType.setTitle("工单生成", for: .normal)
                // workOderStutasLabel.text = "工单生成"
            }
            
//            supervisePeopleLabel.text = model?.SUPERVISE_PERSON_NAMES
            
            
        }
    }


    func cellForHeight() -> CGFloat{
        
        return tempImageView.maxY
    }
    
    
}
