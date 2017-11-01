//
//  YQFilterPersonModel.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/11/1.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit

class YQFilterPersonModel: NSObject {
    
    //人员id
    var personId : String = ""
    //人名
    var name : String = ""
    //岗位
    var post : String = ""
    
    init(dic : [String : Any]) {
        
        super.init()
        
        setValuesForKeys(dic)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    
}
