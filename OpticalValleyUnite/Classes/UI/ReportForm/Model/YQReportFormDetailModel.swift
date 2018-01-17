//
//  YQReportFormDetailModel.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/1/17.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQReportFormDetailModel: NSObject {

    var reportTitle = ""
    
    var personName = ""
    
    var createTime = ""
    
    var id : Int = -1
    
    var reportType : Int = -1
    
    var parkId = ""
    
    init(dict : [String : Any]) {
        
        super.init()
        
        personName = dict["personName"] as? String ?? ""
        createTime = dict["createTime"] as? String ?? ""
        reportTitle = dict["reportTitle"] as? String ?? ""
        id = dict["id"] as? Int ?? -1
        

    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    
}
