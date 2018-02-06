//
//  YQDecorationHomeModel.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/2/6.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQDecorationHomeModel: NSObject {
    
    //工单名称
    var WORKUNIT_NAME = ""
    
    //工单类型 1计划 2应急
    var WORKUNIT_TYPE = ""
    
    //工单创建日期
    var CREATE_DATE = ""
    
    //工单发起人ID
    var SOURCE_PERSON = ""

    //工单发起人名称
    var SOURCE_PERSON_NAME = ""
    
    //工单状态
    var UNIT_STATUS = ""
    
    //工单描述
    var DESCRIPTION = ""
    
    //工单ID 唯一标示
    var ID = ""
    
    init(dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
        
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }

}
