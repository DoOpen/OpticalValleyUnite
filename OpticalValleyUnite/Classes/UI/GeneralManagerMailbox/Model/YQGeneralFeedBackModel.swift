//
//  YQGeneralFeedBackModel.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/4/21.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQGeneralFeedBackModel: NSObject {
    //创建时间
    var createTime = ""
    //标题
    var title = ""
    //状态
    var status = -1
    //ID
    var id = ""
    
    init(dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}
