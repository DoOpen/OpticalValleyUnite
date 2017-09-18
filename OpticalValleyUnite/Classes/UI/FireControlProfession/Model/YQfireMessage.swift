//
//  YQfireMessage.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/9/18.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit

class YQfireMessage: NSObject {
    
    /*
     "workunitId": 1,
     "type": "火警单",
     "time": "2017-09-13 19:10:17.0",
     "location": "九运大厦 1期 1栋 103"
     */
    
    //定义属性,字典转模型
    var workunitId : Int = -1
    
    var type : String?
    
    var time : String?
    
    var location : String?
    
    // MARK: - 初始化init的方法
    init(dict: [String : Any]){
        super.init()
        setValuesForKeys(dict)
    
    }
    
    //调用任意 转化方法
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    

}
