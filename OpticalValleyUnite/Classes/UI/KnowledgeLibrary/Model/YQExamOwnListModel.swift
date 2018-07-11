//
//  YQExamOwnListModel.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/6/29.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQExamOwnListModel: NSObject {
    //试卷id
    var id : Int64 = -1
    //试卷名称
    var name = ""
    //试卷总分
    var totalScore = -1
    //考试总时间
    var time = ""
    //考试是否结束 0未结束 1结束
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
