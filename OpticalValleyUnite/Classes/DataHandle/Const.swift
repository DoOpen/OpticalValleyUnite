//
//  Const.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/1/11.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit

//swift 中的全局的宏的情况
//是否是 bate环境
let isProjectBate = false


struct Const {

    static let SJThemeColor = UIColor.colorFromRGB(rgbValue: 0x31A5EC)
    
    //OVU-EMS 的push 和 map 的值key的情况
    //    static let SJMapKey = "76287f8a7e4a212f4f7328add915f7ca" //com.test
    static let SJMapKey = "beb488178cddd4da0ff7183b079fa24e"  //企业打包
    
    //    static let SJUMPushKey = "5979b30eaed1793e5d0002c1" //com.test
    
    static let SJUMPushKey = "5976ad34677baa2de60006dc"//企业打包
    //    static let SJUMPushKey = "598ad9d5aed17922bc001225"
    

    //OVU-BATE 的push 和 map 的值key的情况
    static let YQMapKey = "9af215c7fb21b6b2eb61009e31fa6763" //企业打包
    
    static let YQUMPushKey = "5abcbc02f29d982d7700011b" //企业打包
    
    
    static let SJToken = "SJToken"
    static let YQParkID = "YQParkID"
    static let YQTotallData = "YQTotallData"
    static let YQSystemSelectData = "YQSystemSelectData"
    static let YQIs_Group = "YQIs_Group"
    
    static let YQProjectModel = "YQProjectModel"
    static let YQAllProjectModel = "YQAllProjectModel"
    
    static let YQReportName = "YQReportName"
    
    static let YQBadgeNumber = "YQBadgeNumber"
    
    //用户名和 密码(加密)
    static let standardUserName = "YQstandardUserName"
    
    static let standardUserPwd = "YQstandardUserPwd"

    #if TARGET_IPHONE_SIMULATOR
    static let SJIsSIMULATOR = true //真机
    #else
    static let SJIsSIMULATOR = false //模拟器
    #endif
    
}
