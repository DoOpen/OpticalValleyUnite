//
//  YQDecorationHomeCell.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/2/6.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQDecorationHomeCell: UITableViewCell {
    ///属性列表
    @IBOutlet weak var workTypeLabel: UILabel!
    
    @IBOutlet weak var workOrderNameLabel: UILabel!
    
    @IBOutlet weak var workStateLabel: UIButton!
    
    @IBOutlet weak var workDescribetionLabel: UITextView!
    
    @IBOutlet weak var projectNameLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    //项目
    var parkName = ""

    var model : YQDecorationHomeModel?{
        
        didSet{
            
            switch (model?.decoration_type)! {
            case 2://巡检工单
                workTypeLabel.text = "巡检"
                break
            case 3://验收工单
                workTypeLabel.text = "验收"
                break
            default:
                break

            }
            
            self.workOrderNameLabel.text = model?.WORKUNIT_NAME
            
            if model?.unitStatusNameE != ""{
                 self.workStateLabel.setTitle(model?.unitStatusNameE, for: .normal)
                
            }else if (model?.unitStatusNameW != ""){
                
                 self.workStateLabel.setTitle(model?.unitStatusNameW, for: .normal)
            }
            
            self.workDescribetionLabel.text = model?.DESCRIPTION
        
            self.projectNameLabel.text = parkName
            
            self.timeLabel.text = model?.CREATE_DATE
            self.nameLabel.text = model?.SOURCE_PERSON_NAME
            
        }
        
    }
    
       
}
