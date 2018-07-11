//
//  YQExaminationRecordsModel.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/7/5.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQExaminationRecordsModel: NSObject {
    
    //主键id
    var id : Int64 = -1
    //试卷总分
    var totalScore = -1
    //总得分
    var scoreContent = ""
    //考试总时间
    var time = ""
    //试卷名称
    var name = ""
    
    init(dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forKeyPath keyPath: String) {
        
    }
    

}
