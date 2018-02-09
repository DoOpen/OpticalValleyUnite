//
//  YQDecorationHomeModel.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/2/6.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQDecorationHomeModel: NSObject {
    
    /*
     
     ▿ 0 : 2 elements
     - key : "DESCRIPTION"
     - value : 自动生成巡检工单
     ▿ 1 : 2 elements
     - key : "unitStatusNameW"
     - value : 待派发
     ▿ 2 : 2 elements
     - key : "SOURCE_PERSON"
     - value :
     ▿ 3 : 2 elements
     - key : "decoration_type"
     - value : 2
     ▿ 4 : 2 elements
     - key : "EXEC_PERSON_ID"
     - value :
     ▿ 5 : 2 elements
     - key : "unitStatusNameE"
     - value :
     ▿ 6 : 2 elements
     - key : "WORKUNIT_NAME"
     - value : 二楼办公室装修巡检小野2018-01-08 08:00:00
     ▿ 7 : 2 elements
     - key : "ID"
     - value : P2018010800008
     ▿ 8 : 2 elements
     - key : "WORKUNIT_TYPE"
     - value : 2
     ▿ 9 : 2 elements
     - key : "UNIT_STATUS"
     - value : 0
     ▿ 10 : 2 elements
     - key : "SOURCE_PERSON_NAME"
     - value :
     ▿ 11 : 2 elements
     - key : "IS_ASSISTANCE_PERSON"
     - value : 0
     ▿ 12 : 2 elements
     - key : "CREATE_DATE"
     - value : 2018-01-08 08:00:00
     
     */
    
    
    //工单名称
    var WORKUNIT_NAME = ""
    
    //工单类型 1计划 2应急(这里的是 都是应急的工单)
    var WORKUNIT_TYPE = -1
    
    //工单创建日期
    var CREATE_DATE = ""
    
    //工单发起人ID
    var SOURCE_PERSON = ""

    //工单发起人名称
    var SOURCE_PERSON_NAME = ""
    
    //工单状态
    var UNIT_STATUS = -1
    
    //工单描述
    var DESCRIPTION = ""
    
    //工单ID 唯一标示
    var ID = ""
    
    //未处理的工单类型
    var unitStatusNameW = ""
    
    //已处理的工单类型
    var unitStatusNameE = ""
    
    //装修实现类型
    var decoration_type = -1
    
    //执行人的id
    var EXEC_PERSON_ID = ""
    //是否协助人
    var IS_ASSISTANCE_PERSON = -1
    
    init(dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
        
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }

}
