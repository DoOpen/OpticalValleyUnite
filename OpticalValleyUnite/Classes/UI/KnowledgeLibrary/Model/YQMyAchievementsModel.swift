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
    var id = ""
    
    //考试得分
    var totalGrade = -1
    
    //试卷名称
    var name = ""
    
    init(dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
        
    }
    
    
    
}
