//
//  YQBluetooth.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/12/18.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit

class YQBluetooth: NSObject {
    //门禁设备ID
    var id : Int64 = 0
    
    //设备名称
    var name : String = ""
    
    //设备类型
    var equipType : String = ""
    
    //设备ID
    var equipmentId : String = ""
    
    //蓝牙 MAC地址
    var deviceBlueMac : String = ""
    
    //32位密钥 蓝牙开门的密钥
    var deviceKey : String = ""
    
    //打开表示
    var openTag : Int64 = 0
    
    init(dic : [String : Any]) {
        super.init()
        
        setValuesForKeys(dic)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    
}
