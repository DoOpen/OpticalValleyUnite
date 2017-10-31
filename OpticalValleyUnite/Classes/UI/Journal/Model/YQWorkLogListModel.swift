//
//  YQWorkLogListModel.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/10/31.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit

class YQWorkLogListModel: NSObject {
    // 日志id
    var worklogId : Int64 = -1
    // 人名
    var personName : String?
    // 头像
    var avatar : String?
    // 岗位
    var post : String?
    // 日志创建时间
    var createTime : String?
    // 待办事项数组
    var todoList : NSArray?
    
    init(dic : [String : Any] ) {
        
        super.init()
        setValuesForKeys(dic)
        
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}
