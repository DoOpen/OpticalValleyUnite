//
//  YQStudyListModel.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/6/28.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit


class YQStudyListModel: NSObject {
    
    //标题
    var title : String = ""
    //主键id
    var id : String = ""
    
    init(dic : [String : Any]) {
        super.init()
        
        setValuesForKeys(dic)
        
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }


}
