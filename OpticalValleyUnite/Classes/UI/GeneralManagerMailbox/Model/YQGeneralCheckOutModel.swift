//
//  YQGeneralCheckOutModel.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/4/23.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQGeneralCheckOutModel: NSObject {
    //id
    var id = ""
    //创建时间
    var createTime = ""
    //总经理批复状态 0 未批复 1批复
    var gmReplyStatus = ""
    
    //经理批复状态 0 未批复 1批复
    var mReplyStatus = ""
    
    //反馈最终状态
    var status = -1
    
    //标题
    var title = ""
    
    //项目
    var parkName = ""
    
    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}
