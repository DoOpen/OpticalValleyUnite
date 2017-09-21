//
//  YQStateListModel.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/9/21.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit

class YQStateListModel: NSObject {
    
    var content : String = ""
    
    init(dic : [String : Any]){
        super.init()
        setValuesForKeys(dic)
    
    }
    
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }

}
