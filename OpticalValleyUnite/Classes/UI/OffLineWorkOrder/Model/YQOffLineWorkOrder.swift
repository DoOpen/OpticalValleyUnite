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
    
    dynamic var REMARKS = ""
    dynamic var type = ""
    dynamic var ID = ""
    
    convenience init(parmart: [String: Any]) {
        
        self.init()
        
        setValuesForKeys(parmart)
        
       
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }

}

class WorkHistoryModel111: Object {
    
    dynamic var id = ""
    
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

    dynamic var person_name = ""
    dynamic var status = -1
    dynamic var time = ""
    dynamic var content = ""
    dynamic var source = 10
    dynamic var type = "1"
//    var pictures = [String]()
    dynamic var text = ""
    dynamic var DESCRIPTION = ""
    
    
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


class offLineWorkOrderUpDatePictrueModel : Object {
    
    //图片data
    @objc dynamic var pictureData : Data?
    
    //工单id
    dynamic var id  = ""
    
    //工作步序 步骤
    dynamic var stepId = ""
    
    //类别（1：工单 2：步骤）
    dynamic var type = -1
    
    
    convenience init(parmart: [String: Any]) {
        
        self.init()
        pictureData = parmart["data"] as? Data
        
        setValuesForKeys(parmart)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}

class saveAndCompelteWorkIDModel : Object{

    //工单id
    dynamic var WORKUNIT_ID  = ""
    dynamic var stepId = ""
    
    convenience init(parmart: [String: Any]) {
        
        self.init()
        
        setValuesForKeys(parmart)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }

}






