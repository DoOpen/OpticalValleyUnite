//
//  YQResultCellModel.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/12/10.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit

class YQResultCellModel: NSObject {

    var insResultId : Int = 0
    
    var insPointName : String = ""
    
    var personName : String = ""
    
    init(dict : [String : Any] ) {
        
        super.init()
        
        setValuesForKeys(dict)
        
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}
