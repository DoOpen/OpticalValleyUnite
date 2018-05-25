//
//  YQPatrolWayResultModel.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/5/25.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQPatrolWayResultModel: NSObject {
    
    //结果id
    var insResultId : Int64 = 0
    
    //点位名称
    var insPointName : String = ""
    
    //主键id
    var id : Int64 = 0
    
    init(dict : [String : Any] ) {
        
        super.init()
        
        setValuesForKeys(dict)
        
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }

}
