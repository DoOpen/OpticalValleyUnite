//
//  YQVideoMapPointModel.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/12/4.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit

class YQVideoMapPointModel: NSObject {
    
    //定位点id
    
    //定位点type(室内,室外类型)
    
    //巡查点名称
    
    //经度
    
    //纬度
    
    //摄像头id
    
    
    init(dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
        
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }

}
