//
//  YQVideoIndoorPatorlModel.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/12/5.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit

class YQVideoIndoorPatorlModel: NSObject {
    
    // 巡查点id
    var insPointId : Int = 0
    
    // 巡查点名称
    var name : String = ""
    
    // 摄像头ID
//    var videoConfigId : Int = 0
    
    // 摄像头设备ID
    var equipmentId : Int = 0
    
    
    init(dic : [String : Any]) {
        super.init()
        
         setValuesForKeys(dic)
        
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }


}
