//
//  YQBtnViewCollectionCell.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/6/7.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQBtnViewCollectionCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var textLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        
    }
    
    let imageDic = ["报事": "baoshi","工单": "工单2","签到": "签到2","扫描": "扫描2","定位": "dingwei","待办事项": "daiban", "督办": "btn_duban","门禁": "intodoor","丽岛学院": "xueyuan","电梯报事":"baoshi","日志":"日志","计步器":"step","视频巡查" : "xuncha","巡查结果" : "xunguan","工作报告" : "more_icon_work_report","房屋管理" : "房屋查询","设备房" : "设备房","装修管理" : "装修管理","工单查询" : "more_icon_demand","总经理邮箱" : "gmMail"]
    
    var model : PermissionModel?{
        
        didSet{
            
            let imageName = imageDic[(model?.aPPMODULENAME)!] ?? ""
            
            self.imageView.image = UIImage(named:imageName)
        
            if model?.aPPMODULENAME == "电梯报事"{
                
                self.textLabel.text = "报事"
                
            }else{
                
                self.textLabel.text = model?.aPPMODULENAME
                
            }
        }
        
    }
    

}
