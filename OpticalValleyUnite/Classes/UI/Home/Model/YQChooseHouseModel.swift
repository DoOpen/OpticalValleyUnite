//
//  YQChooseHouseModel.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/5/17.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQChooseHouseModel: NSObject {
    
    //分期ID
    var stageId = ""
    //分期名称
    var stageName = ""
    //楼栋id
    var buildId = ""
    //楼栋名称
    var buildName = ""
    
    //单元码
    var unitNo = ""
    
    //楼层码
    var groundNo = ""
    // 房号
    var houseCode = ""
    // 房屋名称
    var houseName = ""
    // 房屋编码
    var houseNo = ""
    //房id
    var id = ""
    
     init(dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }

}
