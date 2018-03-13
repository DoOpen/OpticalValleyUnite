//
//  YQEquipDetailListModel.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/3/2.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQEquipDetailListModel: NSObject {
    
    var equipId = -1
    
    var equipName = ""
    
    
    
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
    var houseImgs = Array<String>()


    var equipCode = ""
    
    //图片地址:
    var logUrl = ""
    
    
    init(dict : [String : Any]) {
        
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }


}
