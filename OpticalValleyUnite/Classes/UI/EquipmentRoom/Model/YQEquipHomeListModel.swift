//
//  YQEquipHomeListModel.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/3/1.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQEquipHomeListModel: NSObject {
    
    //设备房id
    var equipHouseId : Int64 = -1
    
    //设备房名称
    var equipHouseName =  ""
    
    //空间id
    var houseId = ""
    
    
    
    var sensorData = Array<[String : Any]>()
    
    var sensorId = ""
    
    
    //参数名
    var name = ""
    //值
    var val = ""
    //单位
    var unit = ""
    //是否异常
    var isRegular = ""
    //图片集合
    var houseImgs = Array<[String : Any]>()
    
    
    //图片地址
    var screenUrl = ""
    //截图时间
    var screenTime = ""
    

    init(dict : [String : Any]) {
        
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }

}
