//
//  YQFilterDeptModel.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/11/1.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit

class YQFilterDeptModel: NSObject {
    
    //部门id
    var deptId : String = ""
    //部门名
    var name : String = ""
    
    init(dic : [String : Any] ) {
        super.init()
        
        setValuesForKeys(dic)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}
