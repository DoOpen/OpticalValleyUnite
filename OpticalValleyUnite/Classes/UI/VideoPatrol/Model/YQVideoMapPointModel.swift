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
    var insPointId : Int64 = 0
    
    //定位点type(室内,室外类型  1,室内 2,室外)
    var type : Int = 0
    
    //巡查点名称
    var name : String  = ""
    
    //经度
    var longitude : String = ""
    
    //纬度
    var latitude : String = ""
    
    //摄像头id
    var videoConfigId : Int = 0
    
    
    init(dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
        
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }

}
