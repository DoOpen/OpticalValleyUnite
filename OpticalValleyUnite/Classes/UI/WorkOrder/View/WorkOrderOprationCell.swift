//
//  WorkOrderOprationCell.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/1/14.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit

class WorkOrderOprationCell: UITableViewCell {

    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var ResidualTimeBtn: UIButton!
    @IBOutlet weak var leftBtnWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var lineView: UIImageView!
    
    var timer: Timer?

    
    var leftBtnClickBlock: (()->())?
    var rightBtnClickBlock: (()->())?
    
    var model: WorkOrderDetailModel?{
        didSet{
            if let model = model {
                timeLabel.text = model.time
                
                
                
            }
        }
    }
    
    
    
    var type = OperationType.none{
        didSet{
            
            var leftText = ""
            var rightText = ""
            var title = ""
            
            switch type {
            case .waitDistribution:
                leftText = "派发"
                rightText = "退回"
                title = "待派发"
                let newConstraint = leftBtnWidthConstraint.constraintWithMultiplier(multiplier: 1.0)
                contentView.removeConstraint(leftBtnWidthConstraint)
                contentView.addConstraint(newConstraint)
                contentView.layoutIfNeeded()
                rightBtn.isHidden = true
                lineView.isHidden = true
            case .waitMeetsList:
                leftText = "接单"
                rightText = "退回"
                title = "待接单"
                

            case .waitProcessing:
                leftText = "处理"
                rightText = "退回"
                title = "待处理"
            case .waitExecuting, .waitDone:
                leftText = "执行"
                rightText = "退回"
                title = "待执行"
            case .waitAppraise:
                leftText = "评价"
                rightText = "退回"
                title = "待评价"
                
                let newConstraint = leftBtnWidthConstraint.constraintWithMultiplier(multiplier: 1.0)
                contentView.removeConstraint(leftBtnWidthConstraint)
                contentView.addConstraint(newConstraint)
                contentView.layoutIfNeeded()
                rightBtn.isHidden = true
                lineView.isHidden = true
                
            default:
                break
            }
            
            leftBtn.setTitle(leftText, for: .normal)
            rightBtn.setTitle(rightText, for: .normal)
            titleLabel.text = title
        }
    }
    


    
    
    
    func oneSecond(){
        
        if let model = model, model.RESPONSETIME != ""{
            let date = Date.dateFromString(dateStr: model.RESPONSETIME, formetStr: "yyyy-MM-dd HH:mm:ss")
            
          
            
            if date.timeIntervalSinceNow > 0{
                
                ResidualTimeBtn.isHidden = false
                
                let time = date.timeIntervalSinceNow
                
                let hour = Int(time / 3600.0)
                let minut = Int(time.truncatingRemainder(dividingBy: 3600) / 60.0)
                let ss = Int(time.truncatingRemainder(dividingBy: 60.0))
                
                var text = ""
                if hour > 0 {
                    text = NSString.init(format: "%02d:%02d:%02d", hour,minut,ss) as String
                }else{
                    text = NSString.init(format: "%02d:%02d",minut,ss) as String
                }
                text = "剩余时间:" + text
                ResidualTimeBtn.setTitle(text, for: .normal)
            }
            

        }
        


    }
    
    func beginTime(_ date: Date){

    }


    
    @IBAction func leftBtnClick() {
        if let leftBtnClickBlock = leftBtnClickBlock{
            leftBtnClickBlock()
        }
    }
    @IBAction func rightBtnClick() {
        if let rightBtnClickBlock = rightBtnClickBlock{
            rightBtnClickBlock()
        }
    }

    
}

extension NSLayoutConstraint {
    func constraintWithMultiplier(multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}
