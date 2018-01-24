//
//  YQWorkHighlightsDetailShowModel.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/1/21.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQWorkHighlightsDetailShowModel: NSObject {
    
    /// 工作亮点主键id
    var lightspotId = -1
    
    /// 工作亮点标题
    var lightspotTitle = ""
    
    /// 工作亮点图片
    var imgPaths = ""
    
    /// 工作亮点创建时间
    var createTime = ""
    
    /// 工作亮点内容
    var lightspotContent = ""
    
    /// 工作计划内容
    var jobContent = ""
    
    /// 项目名
    var parkName = ""
    
    init(dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
        
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }

}
