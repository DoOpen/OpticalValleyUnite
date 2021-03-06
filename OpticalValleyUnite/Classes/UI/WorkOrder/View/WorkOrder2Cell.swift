//
//  WorkOrder2Cell.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/7/13.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit

class WorkOrder2Cell: UITableViewCell {


    @IBOutlet weak var iconView: UIImageView!
    

    @IBOutlet weak var workOrderIdLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    //创建的人名(中间第二个)
    @IBOutlet weak var creatLabel: UILabel!
    @IBOutlet weak var typeBtn: UIButton!
    //设备类的标签
    @IBOutlet weak var deviceBtn: UIButton!
    
    @IBOutlet weak var addressLabel: UILabel!

    
    @IBOutlet weak var saveLabel: UILabel!
    @IBOutlet weak var compelteLabel: UILabel!

    
    var model: WorkOrderModel?{
        didSet{
            workOrderIdLabel.text = model?.workOrderId
            contentLabel.text = model?.content
            timeLabel.text = model?.time
            addressLabel.text = model?.reportPeopleName
            
            creatLabel.text = model?.WORKTYPE_NAME
            
            deviceBtn.isHidden =  model!.is_equip != 1
            
            switch model!.status {
            case 0://待派发

                statusLabel.text = "待派发"
                iconView.image = UIImage(name: "StayOut")
                
            case 1://待接收（已派发
                iconView.image = UIImage(name: "ToReceive")
                statusLabel.text = "待接收"
            case 4://已退回（==待派发
                iconView.image = UIImage(name: "StayOut")
                statusLabel.text = "已退回"
            case 5://待处理 （已接收）
                iconView.image = UIImage(name: "todo")
                statusLabel.text = "待处理"
            case 7://待评价（已处理）
                iconView.image = UIImage(name: "ToEvaluate")
                statusLabel.text = "待评价"
            case 8://已关闭 （已评价）
                iconView.image = UIImage(name: "Closed")
                statusLabel.text = "已关闭"
            default: break

            }
            
            
            if model!.statusCn == "" && model!.status == 4{
                iconView.image = UIImage(name: "StayOut")
                statusLabel.text = "待派发"
            }
            
            if model?.PERSONTYPE == 1{
                statusLabel.text = "协助查看"
                iconView.image = UIImage(name: "AssistToSee")

            }
            
            
            if model?.type2 == "1"{

                typeBtn.setTitle("计划工单", for: .normal)
                
                
            }else{

                typeBtn.setTitle("应急工单", for: .normal)
            }
            
        }
    }
    
    var model2: WorkOrderModel2?{
        
        didSet{
            
            //通过的是不同的type类型来进行的赋值不同的选项值!
            if model2?.type2 == "1"{
                
                typeBtn.setTitle("计划工单", for: .normal)
                
                creatLabel.text = model2?.WORKTASK_RATE

            }else{
                
                typeBtn.setTitle("应急工单", for: .normal)
                
                creatLabel.text = model2?.WORKTYPE_NAME
            }
            
            saveLabel.isHidden = true
            compelteLabel.isHidden = true
                
            workOrderIdLabel.text = model2?.workOrderId
            contentLabel.text = model2?.content
            
            timeLabel.text = model2?.time
            
            addressLabel.text = model2?.reportPeopleName
            // creatLabel.text = model2?.PARK_NAME
            
            deviceBtn.isHidden =  model2!.is_equip != 1
            
            if (model2?.save)! {
                
                saveLabel.isHidden = false
                compelteLabel.isHidden = true
            }
            
            if (model2?.complete)! {
                
                saveLabel.isHidden = true
                compelteLabel.isHidden = false
            }

            
            switch model2!.status {
            case 0://待派发
                statusLabel.text = "待派发"
                iconView.image = UIImage(name: "StayOut")
            case 1://待接收（已派发
                iconView.image = UIImage(name: "ToReceive")
                statusLabel.text = "待接收"
            case 4://已退回（==待派发
                iconView.image = UIImage(name: "StayOut")
                statusLabel.text = "已退回"
            case 5://待处理 （已接收）
                iconView.image = UIImage(name: "todo")
                statusLabel.text = "待执行"
            case 7://待评价（已处理）
                iconView.image = UIImage(name: "ToEvaluate")
                statusLabel.text = "待评价"
            case 8://已关闭 （已评价）
                iconView.image = UIImage(name: "Closed")
                statusLabel.text = "已关闭"
            default: break
                
            }
            
            
            if model2!.statusCn == "" && model2!.status == 4{
                iconView.image = UIImage(name: "StayOut")
                statusLabel.text = "待派发"
            }
            
            if model2?.PERSONTYPE == 1{
                statusLabel.text = "协助查看"
                iconView.image = UIImage(name: "AssistToSee")
                
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


}
