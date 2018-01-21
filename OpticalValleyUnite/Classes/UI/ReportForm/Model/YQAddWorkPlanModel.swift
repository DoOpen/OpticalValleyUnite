//
//  YQAddWorkPlanModel.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/1/18.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQAddWorkPlanModel: NSObject {
    
    var time = ""
    var backlog = ""
    var backLogDetail = ""
    
    init(dic : [String : Any]) {
        
        super.init()
        
        setValuesForKeys(dic)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }

}

class YQWorkHighlightsModel: NSObject {
    
    
    
}
