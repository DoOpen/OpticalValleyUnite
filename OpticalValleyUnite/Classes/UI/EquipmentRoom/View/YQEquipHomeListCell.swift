//
//  YQEquipHomeListCell.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/2/27.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQEquipHomeListCell: UITableViewCell {
    
    ///属性列表项
    @IBOutlet weak var showImageView: ShowImageView!
    
    @IBOutlet weak var showContentView: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    var model : YQEquipHomeListModel?{
        didSet{
            
            //文本
            showContentView.text = model?.equipHouseName
            //图片
            
            if model?.screenUrl != "" {//数组为 空的情况
                
                let basicPath = URLPath.systemSelectionURL
                
                if (model?.screenUrl.contains("http"))! {
                    
                    showImageView.showImageUrls([(model?.screenUrl)!])
                    
                }else{
                    
                    let imageValue = basicPath.replacingOccurrences(of: "/api/", with: "") + "/" + (model?.screenUrl)!
                    
                    showImageView.showImageUrls([imageValue])
                    
                }
                
            }else{// 数组不为 空的情况
                
                showImageView.showImageUrls([(model?.screenUrl)!])
            }
            
            showImageView.didClickHandle = { _,image in
                
                CoverView.show(image: image)
            }
            
            
            if (model?.sensorData.isEmpty)! {
                //没有传感器数据
                return
                
            }else{
                
                //动态添加传感器的数据值
                for indexxxx in 0..<(model?.sensorData.count)! {
                    
//                    if indexxxx % 2 {
//                        
//                        let sensorV = Bundle.main.loadNibNamed( "YQSensorPart", owner: nil, options: nil)?[0] as! YQSensorPart
//                        
//                    }
                    
                }
                
                
            }
            

            

            
        }
        
        
    }

    
    
}
