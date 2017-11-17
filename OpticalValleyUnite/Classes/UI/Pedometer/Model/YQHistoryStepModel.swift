//
//  YQHistoryStepModel.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/11/17.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit

class YQHistoryStepModel: NSObject {

    var step : Int = -1
    
    var date : String = ""
    
    
    init(dic : [String : Any] ) {
        super.init()
        
        setValuesForKeys(dic)
        
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    
}
