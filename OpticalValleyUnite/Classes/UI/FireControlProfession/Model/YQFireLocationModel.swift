//
//  YQFireLocationModel.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/9/19.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit

class YQFireLocationModel: NSObject {
    /*
     "data": {
     "firePointList": [
     {
     "firePointId": 1,
     "name": "创意天地一期一号楼",
     "location": "创意天地一期一号楼",
     "longitude": "114.327699",
     "latitude": "30.469259",
     "detail": "温度过高",
     "status": 1  (1: 火警 2: 正常)
     },
     */
    
    var firePointId : Int = -1
    
    var name : String = ""
    
    var location : String = ""
    
    var longitude : Float = 0
    
    var latitude : Float = 0
    
    var detail : String = ""
    
    var status : Int =  0
    
    init(dic : [String : Any]){
        super.init()
        
        setValuesForKeys(dic)
        
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    

}
