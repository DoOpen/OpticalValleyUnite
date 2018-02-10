//
//  YQHouseQueryHomeModel.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/2/10.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQHouseQueryHomeModel: NSObject {
    
    //房屋id
    var id = ""
    //房间号（项目下房屋时返回）
    var houseCode = ""
    //房间名称（项目下房屋时返回）
    var houseName = ""
    
    
    //业主id
    var ownerIds = ""
    //业主地址
    var address = ""
    //业主电话,多个用,号拼接
    var phone = ""
    //业主名称,多个用,号拼接
    var ownerName = ""
    
    init(dict : [String : Any]) {
        
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    

}
