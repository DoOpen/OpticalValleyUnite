//
//  YQHouseRelativeModel.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/2/26.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQHouseRelativeModel: NSObject {
    
    // 业主id
    var id = -1
    // 与业主关系 0、父母：1、子女：2、其他
    var relationRole = -1
    // 亲属姓名
    var relationName = ""
    // 亲属电话
    var relationTel = ""
    // 与业主关系
    var relationRoleName = ""
    
    // 租户的信息的查询情况
    // 与业主的关系
    var typeName = ""
    // 租户电话
    var tenantTel = ""
    // 租户姓名
    var tenantName = ""
    
    
    init(dict : [String : Any] ) {
        
        super.init()
        
        setValuesForKeys(dict)
        
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}
