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
    var id = ""
    //期名称
    var stageName = ""
    //分期编码
    var stageNo = ""
    

    init(dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}


class YQDecorationFloorModel : NSObject {
    
    //楼栋ID
    var id = ""
    //楼栋名称
    var buildName = ""
    //楼栋编码
    var buildNo = ""
    
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
//    var unitNoName = ""
    
    //单元数(单元码)
    var unitNo = ""
    
    init(dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}


class YQDecorationGroundNoModel : NSObject {
    
    //楼号id
    var groundNo = ""
    //楼
    //var groundNoName = ""
    
    
    init(dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }

}


class YQDecorationHouseModel : NSObject {
    //房屋ID
    var id = ""
    //房号
    var houseCode = ""
    
    //房屋名称
    var houseName = ""
    
    //房屋编码
    var houseNo = ""
    
    //楼层ID
    var groundNo = ""
    
    //单元号
    var unitNo = ""
    
    init(dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
