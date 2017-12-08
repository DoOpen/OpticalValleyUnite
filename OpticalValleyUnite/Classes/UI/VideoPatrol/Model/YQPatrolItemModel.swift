//
//  YQPatrolItemModel.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/12/8.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit

class YQPatrolItemModel: NSObject {
    //巡查项id
    var insItemId : Int = -1
    
    //巡查项类型名称
    var insItemTypeName : String = ""
    
    //巡查项名称
    var name : String = ""
    
    //巡查标准描述
    var descriptionString : String = ""
    
    //考评类型(1:是否达标 2:评分)
    var checkType : Int = -1
    
    //标准图片路径
    var imgPath : String = ""
    
    init( dict : [String : Any] ) {
        super.init()
        
        setValuesForKeys(dict)
        
        let string = dict["description"] as? String
        
        if string != "" {
            
            self.descriptionString = string!
        }
        
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }

}
