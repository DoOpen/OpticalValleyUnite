//
//  YQWorkListModel.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/2/27.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQWorkListModel: NSObject {
    
    ///属性列表
    
    //1.报事属性
    //报事ID
    var id = ""
    //报事名称
    var workunitName = ""
    //工单状态（待处理：1，完成：8）(前端 展示的不用)
    var unitStatus = -1
    //执行时间
    var createDate = ""
    //执行人
    var personName = ""
    //工单状态名称
    var unitStatusName = ""
    
    
    //2.报装属性
    var applyStatus = ""
    //审核状态名称
    var applyStatusName = ""
    
    //3.工单执行
    //项名称
    var parkName = ""
    //工单描述没有写
    
  
    
    init(dict : [String : Any] ) {
        
        super.init()
        
        setValuesForKeys(dict)
        
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }


}
