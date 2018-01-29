//
//  WorkOderCell.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/7/13.
//  Copyright © 2017年 贺思佳. All rights reserved.
//


import UIKit
import SVProgressHUD

class WorkOrderCell: UITableViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var workOrderIdLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var creatLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    ///新添加的离线的已经保存和 已经完成选项
    @IBOutlet weak var alreadySave: UILabel!
    @IBOutlet weak var alreadyCompelte: UILabel!
    
    var model: WorkOrderModel?{
        didSet{
            workOrderIdLabel.text = model?.workOrderId
            contentLabel.text = model?.content
            timeLabel.text = model?.time
            
            creatLabel.text = model?.reportPeopleName
            
                       
            switch model!.status {
            case 0://待派发
                backView.backgroundColor = UIColor.red
                statusLabel.text = "待派发"
                
            case 1://待接收（已派发
                backView.backgroundColor = UIColor.orange
                statusLabel.text = "待接收"
            case 4://已退回（==待派发
                backView.backgroundColor = UIColor.purple
                statusLabel.text = "已退回"
            case 5://待处理 （已接收）
                backView.backgroundColor = UIColor.green
                statusLabel.text = "待处理"
            case 7://待评价（已处理）
                backView.backgroundColor = UIColor.lightGray
                statusLabel.text = "待评价"
            case 8://已关闭 （已评价）
                backView.backgroundColor = UIColor.yellow
                statusLabel.text = "已关闭"
            default:
                backView.backgroundColor = UIColor.white
            }

            
            if model!.statusCn == "" && model!.status == 4{
                backView.backgroundColor = UIColor.red
                statusLabel.text = "待派发"
            }
            
            if model?.PERSONTYPE == 1{
                statusLabel.text = "协助查看"
                backView.backgroundColor = UIColor.magenta
            }
            
            
            if model?.type2 == "1"{
                typeLabel.text = "计划工单"
            }else{
                typeLabel.text = "应急工单"
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

class SurveillanceWorkOrderCell: UITableViewCell {
    
    @IBOutlet weak var workOrderIdLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var surveillanceBtn: UIButton!
    @IBOutlet weak var creatLabel: UILabel!
    
    let status = ["待派发","已派发","已完成","已取消","已退回","已接受","处理中","已执行","已评价","关闭","督办"]
    
    
    
    var model: WorkOrderModel?{
        didSet{
            workOrderIdLabel.text = model?.workOrderId
            contentLabel.text = model?.content
            timeLabel.text = model?.dubanTime
            statusLabel.text = (model?.isSupervise)! ? "已督办" : "未督办"
            if (model?.isSupervise)! {
                surveillanceBtn.setTitle("已督办", for: .normal)
                surveillanceBtn.isEnabled = false
            }else{
                surveillanceBtn.setTitle("督办", for: .normal)
                surveillanceBtn.isEnabled = true
            }
            creatLabel.text = model?.reportPeopleName
            
        }
    }
    
    override func awakeFromNib() {
        //        self.selectionStyle = .none
    }
    
    var surveillanceBtnClickHandle: (() -> ())?
    
    @IBAction func surveillanceBtnClick() {
        
        if let block = surveillanceBtnClickHandle{
            block()
        }
    }
    
}
