//
//  YQFeedbackListModel.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/4/18.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQFeedbackListModel: NSObject {
    
    var createTime = ""
    var id  : Int64 = 0
    var title = ""
    
    init(dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }

}
