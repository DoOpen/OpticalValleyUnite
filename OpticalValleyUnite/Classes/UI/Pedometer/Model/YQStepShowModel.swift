//
//  YQStepShowModel.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/11/14.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit

class YQStepShowModel: NSObject {
    
    var name : String = ""
    
    var department : String = ""
    
    var steps : String = ""
    
    var rankno : String = ""
    
    
    init(dict : [String : Any]){
        super.init()
        
        setValuesForKeys(dict)
    
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
        
    }
    

}
