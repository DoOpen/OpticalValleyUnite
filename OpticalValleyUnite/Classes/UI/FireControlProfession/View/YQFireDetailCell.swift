//
//  YQFireDetailCell.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/9/18.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit


protocol YQFireDetailCellDeleage  : class {
    
    func fireDetailCellDetailClickDeleage(model : YQfireMessage)

}

class YQFireDetailCell: UITableViewCell {
    
    
    @IBOutlet weak var orderTypeLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var detailMessageLable: UILabel!
    
    @IBOutlet weak var detailButton: UIButton!
    
    @IBOutlet weak var typeImageView: UIImageView!
    
    // 定义一个获取详情的workunitId
    var workunitId: Int = -1

    // 定义代理
    weak var deleage :  YQFireDetailCellDeleage?
    
    
    //创建模型属性
    var fireMessage : YQfireMessage?{
        didSet{
            
            self.orderTypeLabel.text = fireMessage?.type
            self.timeLabel.text = fireMessage?.time
            self.detailMessageLable.text = fireMessage?.location
            //设置图片
            setTypeImage(type: (fireMessage?.type)!)
            
            self.workunitId = (fireMessage?.workunitId)!
        }
    }

    
    // MARK: - type_imageView设置图片
    func setTypeImage(type : String){
        
        switch type {
            case "火警单":
                self.typeImageView.image = UIImage(named : "tag_fire")
            case "误报单":
                self.typeImageView.image = UIImage(named : "tag_False")
            
            default:
                break
        }
    
    }

    // MARK: - 详情按钮的点击事件
    @IBAction func detailButtonClick(_ sender: Any) {
        //传递模型进行获取详情界面,设置代理,传递模型
        self.deleage?.fireDetailCellDetailClickDeleage(model: fireMessage!)
    
    }
    
    
}
