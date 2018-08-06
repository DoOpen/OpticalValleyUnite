//
//  YQMyAchievementsModel.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/7/5.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQMyAchievementsModel: NSObject {

    //试卷id
    var paperId = -1
    
    //考试得分
    var scoreContent = ""
    
    //试卷名称
    var name = ""
    
    var isEnd = -1
    //考试是否已经参加 0未参加 1已经参加
    var isAttend = -1
    
    
    init(dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
        
    }
    
    
    
}
