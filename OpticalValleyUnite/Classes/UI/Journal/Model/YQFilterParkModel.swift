//
//  YQFilterParkModel.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/11/1.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit

class YQFilterParkModel: NSObject {
    
    //项目id
    var parkId : String = ""
    
    //项目名
    var name : String = ""
    
    init(dic : [String : Any] ) {
        super.init()
        
        setValuesForKeys(dic)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}
