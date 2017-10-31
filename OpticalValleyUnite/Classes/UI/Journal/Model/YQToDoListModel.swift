//
//  YQToDoListModel.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/10/31.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit

class YQToDoListModel: NSObject {
    
    var todoId : Int64 = -1
    
    var title : String?
    
    init(dic: [String : Any]) {
        
        super.init()
        setValuesForKeys(dic)
        
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }

}
