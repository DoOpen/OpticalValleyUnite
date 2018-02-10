//
//  YQDecorationScreenModel.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/2/8.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQDecorationScreenModel: NSObject {

}


class YQDecorationStageModel : NSObject {
    //期ID
    var stageId = ""
    //期名称
    var stageName = ""

    init(dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}


class YQDecorationFloorModel : NSObject {
    
    //楼栋ID
    var floorId = ""
    //楼栋名称
    var floorName = ""
    //期ID
    var stageId = ""
    
    init(dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}


class YQDecorationUnitNoModel : NSObject {
    
    //楼层ID
//    var floorId = ""
    //单元号
    var unitNuName = ""
    //单元数
    var unitNu = -1
    
    init(dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}


class YQDecorationGroundNoModel : NSObject {
    
    //楼号id
    var groundNo = -1
    //楼
    var groundNoName = ""
    
    
    init(dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }

}


class YQDecorationHouseModel : NSObject {
    //房屋ID
    var houseId = ""
    //房屋名称
    var houseName = ""
    //楼层ID
    var floorId = ""
    //单元号
    var unitNo = ""
    
    init(dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
