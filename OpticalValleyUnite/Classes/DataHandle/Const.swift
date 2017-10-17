//
//  Const.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/1/11.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit

struct Const {
    
    static let SJThemeColor = UIColor.colorFromRGB(rgbValue: 0x31A5EC)

    
//    static let SJMapKey = "76287f8a7e4a212f4f7328add915f7ca" //com.test
    static let SJMapKey = "beb488178cddd4da0ff7183b079fa24e"  //企业打包
    
    //    static let SJUMPushKey = "5979b30eaed1793e5d0002c1" //com.test

    static let SJUMPushKey = "5976ad34677baa2de60006dc"//企业打包
    
    static let SJToken = "SJToken"
    static let YQParkID = "YQParkID"
    static let YQTotallData = "YQTotallData"
    static let YQSystemSelectData = "YQSystemSelectData"
    
    static let YQIs_Group = "YQIs_Group"
    

    #if TARGET_IPHONE_SIMULATOR
    
    static let SJIsSIMULATOR = true
    #else
    static let SJIsSIMULATOR = false
    #endif
    
}
