//
//  YQResultCellModel.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/12/10.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit

class YQResultCellModel: NSObject {
    
    ///巡查类型（1视频巡查 2人工巡查）
    var type : Int = 0
    
    ///巡查人id
    var creatorId : String = ""
    
    ///巡查时间
    var createTime : Double = -1.1
    
    ///巡查路线名称
    var insWayName : String = ""
    
    ///巡查路线点位名称
    var wayPointName : String = ""
    
    ///巡查人员名称
    var personName : String = ""
    
    ///id
    var id : Int64 = -1
    
    
    init(dict : [String : Any] ) {
        
        super.init()
        
        setValuesForKeys(dict)
        
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}
