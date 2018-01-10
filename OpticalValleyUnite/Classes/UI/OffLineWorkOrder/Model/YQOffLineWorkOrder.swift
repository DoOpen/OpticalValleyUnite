//
//  YQOffLineWorkOrder.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/1/9.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit
import RealmSwift

class YQOffLineWorkOrder: NSObject {
    
    
}

class offLineWorkOrderDetailModel  : Object {
    
    var REMARKS = ""
    var type = ""
    var ID = "" 
    
    convenience init(parmart: [String: Any]) {
        
        self.init()
        
        setValuesForKeys(parmart)
        
       
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }

}






