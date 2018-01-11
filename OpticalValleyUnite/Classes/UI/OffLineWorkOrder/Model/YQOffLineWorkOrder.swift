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

class WorkHistoryModel111: Object {
    
    var id = ""
    
    var childs = List<WorkHistoryModel222>()
    
    convenience init(parmart: [String: Any]) {
        self.init()
        id = parmart["id"] as? String ?? ""
        
        let temp = List<WorkHistoryModel222>()
        
        let array = parmart["list"] as? Array<[String: Any]>
        
        for dict in array! {
            
            let model = WorkHistoryModel222.init(parmart: dict)
            temp.append(model)
        
        }
        
        childs = temp
    }
    
}

class WorkHistoryModel222  : Object{

    var person_name = ""
    var status = -1
    var time = ""
    var content = ""
    var source = 10
    var type = "1"
//    var pictures = [String]()
    var text = ""
    var DESCRIPTION = ""
    
    
    convenience init(parmart: [String: Any]) {
        self.init()
        //系统自己派发的工单需要,histories ---> positon ---> personName中来拿到 发起人的详细信息!
        //注意 要求修改的bug 内容
        
        person_name = parmart["person_name"] as? String ?? ""
        status = parmart["unit_status"] as? Int ?? -1
        time = parmart["time"] as? String ?? ""
        source = parmart["EVALUATE_SCORE"] as? Int ?? 10
        text = parmart["text"] as? String ?? ""
        DESCRIPTION = parmart["content"] as? String ?? ""
        
        if let content = parmart["EVALUATE_TEXT"] as? String{
            self.content = content
        }
        
        //发起人评价1，管理人评价2
        type = parmart["EVALUATE_TYPE"] as? String ?? ""
        
        if let arry = parmart["tasks"] as? Array<[String: Any]>{
            for (index,dic) in arry.enumerated(){
                if let text = dic["WORKTASK_NAME"] as? String{
                    content += "任务\(index + 1): \(text)"
                    if index != arry.count - 1 {
                        content += "\n"
                    }
                }
            }
            
        }
    }
}






