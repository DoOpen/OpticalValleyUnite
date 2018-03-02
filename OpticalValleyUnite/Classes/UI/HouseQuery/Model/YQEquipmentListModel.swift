//
//  YQEquipmentListModel.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/2/26.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQEquipmentListModel: NSObject {
    
    //设备id
    var id : Int64 = 0
    
    //设备编码
    var equipName = ""
    
    //设备分类名称
    var typeName = ""
    
    //设备状态 [[1,"运行"],[2,"停用"],[3,"故障"],[4,"报废"]]
    var equipStatus = -1
    
    //设备状态名称
    var equipStatusName = ""
    
    //设备名称
    var name = ""
    
    init(dict : [String : Any] ) {
        
        super.init()
        
        setValuesForKeys(dict)
        
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }

    
}
