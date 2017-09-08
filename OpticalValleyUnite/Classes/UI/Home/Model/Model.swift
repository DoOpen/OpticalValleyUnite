
//
//  Model.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/1/23.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit
import RealmSwift
class Model: NSObject {

}

/// 应用:系统消息的模型
class SystemMessageModel{

    var department = ""
    var time = ""
    var title = ""
    var content = ""
    
    convenience init(parmart: [String: Any]) {
        self.init()
        department = parmart["USER_ID"] as? String ?? ""
        time = parmart["CREATE_TIME"] as? String ?? ""
        title = parmart["TITLE"] as? String ?? ""
        content = parmart["CONTENT"] as? String ?? ""
    }
}


/// 项目模型类
class ProjectModel: NSObject{
    
    var projectName = ""
    var projectId = ""
    convenience init(parmart: [String: Any]) {
        self.init()
        projectName = parmart["PARK_NAME"] as? String ?? ""
        projectId = parmart["ID"] as? String ?? ""

    }
    
}


extension ProjectModel: SJHasNameType{
    public var title: String! {
        return projectName
    }
}


class WorkOrderModel: Object {
    //UNIT_STATUS
//    0：待派发  1：已派发
//    2：已完成  3：已取消
//    4：已退回  5：已接受
//    6：处理中 7：已执行
//    8：已评价  9：关闭                    
//    10：督办
    dynamic var id = ""
    dynamic var time = ""
    dynamic var status = -1
    dynamic var content = ""
    dynamic var workOrderId = ""
    dynamic var isSupervise = false
    dynamic var execPersionId = ""
    dynamic var PERSONTYPE = 0
    dynamic var EXEC_PERSON_ID = ""
    dynamic var statusCn = ""
    dynamic var dubanTime = ""
    dynamic var reportPeopleName = ""
    var PARK_NAME = ""
    var equipment_id = -1
    var equipment_name = ""
    var is_equip = -1
    dynamic var type = ""
    dynamic var type2 = ""
    
    convenience init(parmart: [String: Any]) {
        self.init()
        content = parmart["DESCRIPTION"] as? String ?? ""
        
        if content == ""{
            content = parmart["WORKUNIT_NAME"] as? String ?? ""
        }
        if content == ""{
            content = parmart["NAME"] as? String ?? ""
        }
        
        time = parmart["CREATE_DATE"] as? String ?? ""
        status = parmart["UNIT_STATUS"] as? Int ?? -1
        execPersionId = parmart["EXEC_PERSON_ID"] as? String ?? ""
        PERSONTYPE = parmart["IS_ASSISTANCE_PERSON"] as? Int ?? 0
        statusCn = parmart["UNIT_STATUS_CN"] as? String ?? ""
        reportPeopleName = parmart["SOURCE_PERSON_NAME"] as? String ?? ""
        if let text = parmart["ISSUPERVISE"] as? String{
            isSupervise = text == "FALSE"
        }
        if reportPeopleName == "" {
            reportPeopleName = parmart["SOURCE_PERSON_NAME"] as? String ?? ""
        }
        
        if let _ = parmart["ID"] as? String ,((parmart["WORKUNIT_ID"] as? String) != nil){
            workOrderId = parmart["WORKUNIT_ID"] as? String ?? ""
            
        }else{
            workOrderId = parmart["ID"] as? String ?? ""
        }
        
        dubanTime = parmart["CREATE_DATE"] as? String ?? ""
        id = parmart["ID"] as? String ?? ""
        type2 = parmart["WORKUNIT_TYPE"] as? String ?? "1"
        
        PARK_NAME = parmart["PARK_NAME"] as? String ?? ""
        
        equipment_id = parmart["equipment_id"] as? Int ?? -1
        equipment_name = parmart["equipment_name"] as? String ?? ""
        
        is_equip = parmart["is_equip"] as? Int ?? -1
        
    }
    
    override static func primaryKey() -> String? {
        return "workOrderId"
    }
}

class PersonModel{
    var name = ""
    var icon = ""
    var id = ""
    var selected = false
    
    convenience init(parmart: [String: Any]) {
        self.init()
        name = parmart["NAME"] as? String ?? ""
        icon = parmart["PICTURE"] as? String ?? ""
        id = parmart["ID"] as? String ?? ""

    }
}

class WorkStaticModel{
    ///退单
    var drawsBackCount = 0
    var starOrderCount = 0
    var totalCount = 0
    var percentage = ""
    var dubanCount = 0
    
    convenience init(parmart: [String: Any]) {
        self.init()
        starOrderCount = parmart["TOTAL_YPX"] as? Int ?? 0
        drawsBackCount = parmart["TOTAL_YTH"] as? Int ?? 0
        totalCount = parmart["TOTAL_ALL"] as? Int ?? 0
        percentage = parmart["PERCENTAGE"] as? String ?? ""
        dubanCount = parmart["TOTAL_BDB"] as? Int ?? 0
    }
}


class WorkHistoryModel{
//    //执行人名称
//    var executerName = ""
//    //工单类型名称
//    var workTypeName = ""
//    var workName = ""
    var person_name = ""
    var status = -1
    var time = ""
    var content = ""
    var source = 10
    var type = "1"
    var pictures = [String]()
    var text = ""
//    var icon = ""
//    var content = ""
//    
//    var exexName = ""
//    var execPictrue = ""
//    var assesNamae = ""
//    var assesPictrue = ""
//    var managerNmae = ""
//    var managerPictrue = ""
    
    convenience init(parmart: [String: Any]) {
        self.init()
        person_name = parmart["person_name"] as? String ?? ""
        status = parmart["unit_status"] as? Int ?? -1
        time = parmart["time"] as? String ?? ""
        source = parmart["EVALUATE_SCORE"] as? Int ?? 10
        text = parmart["text"] as? String ?? ""
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
        
        if let arry = parmart["pictures"] as? Array<String>{

            pictures = arry
        }
        
        if let arry = parmart["photos"] as? Array<String>{
            if arry.count > 0{
                pictures = arry
            }
            
        }
        
        
    }
}

class WorkOrderDetailModel: Object{
    ///工单内容
    dynamic var content = ""
    ///工单类型
    dynamic var workTypeName = ""
    ///工单名字
    dynamic var workName = ""
    dynamic var status = -1
    dynamic var time = ""
    ///报事人名字
    dynamic var reportPeopleName = ""
    ///报事人电话
    dynamic var reportPeoplePhone = ""
    dynamic var reportPeopleIcon = ""
    dynamic var foundType = ""
    dynamic var orderType = ""
    ///紧急程度
    dynamic var importentLivel = 0
    dynamic var GROUPID = ""
    dynamic var TASKID = ""
    dynamic var id = ""
    dynamic var RESPONSETIME = ""
    dynamic var address = ""
    dynamic var address2 = ""
    dynamic var projectName = ""
    dynamic var EXEC_PERSON_NAME = ""
    dynamic var EXEC_PICTURE = ""
    dynamic var EXEC_DATE = ""
    dynamic var PARK_ID = ""
    
    dynamic var exexName = ""
    dynamic var assesNamae = ""
    dynamic var managerNmae = ""

    
    dynamic var statu = ""
    dynamic var picture = ""
    dynamic var PARK_NAME = ""
    dynamic var equipment_id = -1
    
    dynamic var isOpen = false
    var SUPERVISE_PERSON_NAMES = ""
    
    convenience init(parmart: [String: Any]) {
        self.init()
        content = parmart["DESCRIPTION"] as? String ?? ""
        workTypeName = parmart["WORKTYPE_NAME"] as? String ?? ""
        status = parmart["UNIT_STATUS"] as? Int ?? -1
        importentLivel = parmart["IMPORTENT_LEVEL"] as? Int ?? 0
        workName = parmart["WORKUNIT_NAME"] as? String ?? ""
        time = parmart["CREATE_DATE"] as? String ?? ""
        reportPeopleName = parmart["SOURCE_PERSON_NAME"] as? String ?? ""
        reportPeopleIcon = parmart["SOURCE_PICTURE"] as? String ?? ""
        foundType = parmart["EVENT_TYPE"] as? String ?? ""
        EXEC_DATE = parmart["EXEC_DATE"] as? String ?? ""
        EXEC_PICTURE = parmart["EXEC_PICTURE"] as? String ?? ""
        EXEC_PERSON_NAME = parmart["EXEC_PERSON_NAME"] as? String ?? ""
        PARK_ID = parmart["PARK_ID"] as? String ?? ""
        if let type = parmart["WORKUNIT_TYPE"] as? String{
            if type == "1"{
                orderType = "计划工单"
                if let arry = parmart["tasks"] as? Array<[String: Any]> {
                    equipment_id = arry.first?["equipment_id"] as? Int ?? -1
                }else{
                    equipment_id = -1
                }
                
            }else if type == "2" {
                orderType = "应急工单"
                equipment_id = parmart["equipment_id"] as? Int ?? -1
            }
        }else{
            orderType = ""
        }
        
        GROUPID = parmart["GROUPID"] as? String ?? ""
        picture = parmart["PICTURE"] as? String ?? ""
        TASKID = parmart["TASKID"] as? String ?? ""
        id = parmart["ID"] as? String ?? ""
        RESPONSETIME = parmart["RESPONSETIME"] as? String ?? ""
        address = parmart["reportLoc"] as? String ?? ""
        address2 = parmart["ADDRESS"] as? String ?? ""
        projectName = parmart["PARK_NAME"] as? String ?? ""
        
        exexName = parmart["EXEC_PERSON_NAME"] as? String ?? ""
        assesNamae = parmart["ASSIST_PERSON_NAMES"] as? String ?? ""

        managerNmae = parmart["MANAGE_PERSON_NAME"] as? String ?? ""

        statu = parmart["statu"] as? String ?? ""
        
        PARK_NAME = parmart["PARK_NAME"] as? String ?? ""
        
        SUPERVISE_PERSON_NAMES = parmart["SUPERVISE_PERSON_NAMES"] as? String ?? ""
    }
}

class WorkDetailModel{
    //执行人名称
    var executerName = ""
    //工单类型名称
    var workTypeName = ""
    var workName = ""
    var status = -1
    var time = ""
    
    convenience init(parmart: [String: Any]) {
        self.init()
        executerName = parmart["NAME"] as? String ?? ""
        workTypeName = parmart["WORKTYPE_NAME"] as? String ?? ""
        status = parmart["UNIT_STATUS"] as? Int ?? -1
        workName = parmart["WORKUNIT_NAME"] as? String ?? ""
    }
}

class EquimentModel{
    
    var type_name = ""
    var park_name = ""
    var floor_name = ""
    var stage_name = ""
    var brand = ""
    var produce_date = ""
    var model_name = ""
    var manufacturer = ""
    var madeIn = ""
    var use_company = ""
    var name = ""
    var parkAddress = ""
    var comment = ""
    
    var regi_code = ""
    var reform_company = ""
    var install_company = ""
    var install_date = ""
    var maintain_company = ""
    var maintain_person = ""
    var frist_maintain_date = ""
    var next_maintain_date = ""
    var year_maintain_date = ""
    convenience init(parmart: [String: Any]) {
        self.init()
        type_name = parmart["type_name"] as? String ?? ""
        name = parmart["name"] as? String ?? ""
        park_name = parmart["park_name"] as? String ?? ""
        floor_name = parmart["floor_name"] as? String ?? ""
        brand = parmart["brand"] as? String ?? ""
        stage_name = parmart["stage_name"] as? String ?? ""
        produce_date = parmart["produce_date"] as? String ?? ""
        model_name = parmart["model_name"] as? String ?? ""
    
        manufacturer = parmart["manufacturer"] as? String ?? ""
        madeIn = parmart["madeIn"] as? String ?? ""
        use_company = parmart["use_company"] as? String ?? ""
        comment = parmart["comment"] as? String ?? ""
        if let stage_name = parmart["stage_name"] as? String,let house_name = parmart["house_name"] as? String,let floor_name = parmart["floor_name"] as? String{
           parkAddress = stage_name + house_name + floor_name
        }
        
        regi_code = parmart["regi_code"] as? String ?? ""
        reform_company = parmart["reform_company"] as? String ?? ""
        install_company = parmart["install_company"] as? String ?? ""
        install_date = parmart["install_date"] as? String ?? ""
        maintain_company = parmart["maintain_company"] as? String ?? ""
        maintain_person = parmart["maintain_person"] as? String ?? ""
        frist_maintain_date = parmart["frist_maintain_date"] as? String ?? ""
        next_maintain_date = parmart["next_maintain_date"] as? String ?? ""
        year_maintain_date = parmart["year_maintain_date"] as? String ?? ""
        
    }
//    type_name: "摄像头",
//    ground_num: 2,
//    is_model: 1,
//    park_name: "创意天地",
//    domain_id: "14bdbea59d2c4b0a96594fb94382901e",
//    floor_name: "2号高层写字楼",
//    equip_code: "3333",
//    model_name: "222",
//    stage_name: "一期",
//    unit_num: 1,
//    id: 33,
//    brand: "佳能",
//    defs: [ ],
//    optime: "2017-06-22 17:04:19",
//    stage_id: "0c849c3e11bc4a8d8e48553ae5220187",
//    park_id: "af98a32c9b4d490297cadc2d85faf797",
//    model_id: 28,
//    params: [ ],
//    attrs: [ ],
//    produce_date: "2017-06-22",
//    name: "摄像头-1",
//    floor_id: "dea78e4c7bc640b4b33558e74260e177",
//    pids: "19"
}

class WorkTypeModel{
    var id = ""
    var name = ""
    
    convenience init(parmart: [String: Any]) {
        self.init()
        id = parmart["ID"] as? String ?? ""
        name = parmart["WORKTYPE_NAME"] as? String ?? ""
    }
}

class ParkInfoModel{
    var id = ""
    var name = ""
    var child: [ParkInfoModel]?
    var text = ""
    var STAGE_ID = ""
    var FLOOR_ID = ""
    var STAGE_Name = ""
    var FLOOR_Name = ""
    convenience init(parmart: [String: Any]) {
        self.init()
        id = parmart["id"] as? String ?? ""
        name = parmart["text"] as? String ?? ""
        STAGE_ID = parmart["app_need_stage"] as? String ?? ""
        FLOOR_ID = parmart["app_need_floor"] as? String ?? ""
//        STAGE_Name = name
        if let arry = parmart["floorChild"] as? Array<[String: Any]> {
            var temp = [ParkInfoModel]()
            for dic in arry{
               let model = ParkInfoModel(parmart: dic)
//                model.text = name + model.name
                model.STAGE_ID = id
                model.STAGE_Name = name
                temp.append(model)
            }
            child = temp
        }
        
        if let arry = parmart["houseChild"] as? Array<[String: Any]> {
            var temp = [ParkInfoModel]()
            for dic in arry{
                let model = ParkInfoModel(parmart: dic)
                model.text = name + model.name
//                model.FLOOR_ID = id
//                model.STAGE_ID = STAGE_ID
//                model.STAGE_Name = STAGE_Name
                model.FLOOR_Name = name
                temp.append(model)
            }
            child = temp
            
        }
    }
}


class ExecSectionModel: Object{
    dynamic var name = ""
    dynamic var id = ""
    var childs = List<ExecChild>()
    dynamic var DESCRIPTION_ID = ""
//    dynamic var DESCRIPTI = Array<[String: Any]>()
    dynamic var workOrderId = ""
    dynamic var isOpen = false
    dynamic var TASK_DESCRIPTION = ""
    
    convenience init(parmart: [String: Any]) {
        self.init()
        id = parmart["WORKTASK_ID"] as? String ?? ""
        TASK_DESCRIPTION = parmart["TASK_DESCRIPTION"] as? String ?? ""
        name = parmart["WORKTASK_NAME"] as? String ?? ""
        DESCRIPTION_ID = parmart["DESCRIPTION_ID"] as? String ?? ""
        if let arry = parmart["stepChild"] as? Array<[String: Any]>{
            let temp = List<ExecChild>()
            var index = 0
            
            var arry3:Array<[String: Any]>? = nil
            if let arry2 =  parmart["DESCRIPTION"] as? String{
                let data = arry2.data(using: .utf8)!
                let json = try? JSONSerialization.jsonObject(with: data)
                arry3 = json as? Array<[String: Any]>
            }
            
            for dic in arry{
                let model = ExecChild(parmart: dic)
                model.taskId = id
                if let arry3 = arry3,arry3.count > 0{
                    if arry3.count > index{
                        if let array = arry3[index]["photos"] as? [String]{
                            if  let path = array.first{
                                model.value = path
                            }else{
                                if let text = arry3[index]["value"] as? String{
                                    model.value = text
                                }
                            }
                            
                        }else if let text = arry3[index]["value"] as? String{
                            model.value = text
                        }
                        
                    }
                }
                
                temp.append(model)
                index += 1
            }
            childs = temp
        }
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func toDic() -> [String: Any] {
        var taskDic = [String: Any]()
        taskDic["WORKUNIT_ID"] = workOrderId
        taskDic["WORKTASK_ID"] = id
        taskDic["UNIT_STATUS"] = 5
        taskDic["ID"] = DESCRIPTION_ID
        var arry = Array<[String: Any]>()
        for model in childs{
            arry.append(model.toDic())
        }
        
        do {
            //Convert to Data
            let jsonData = try JSONSerialization.data(withJSONObject: arry, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            //Do this for print data only otherwise skip
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                print(JSONString)
                taskDic["DESCRIPTION"] = JSONString
            }
        } catch  {
            print("转换错误 ")
        }
        
        return taskDic
    }
}

class ExecChild: Object{
    dynamic var name = ""
    dynamic var id = ""
    dynamic var isDone = false
    dynamic var type = "-1"
    dynamic var taskId = ""
    
    dynamic var value = "" {
        didSet{
            if value.contains("ovu-pcos"){
                let basicPath = URLPath.basicPath
                imageValue = basicPath.replacingOccurrences(of: "/api/", with: "") + value
            }else{
                imageValue = value
            }
            
        }
    }
   dynamic var imageValue = ""
//    dynamic var image: UIImage?
//    dynamic var OPTIONS_LIST:[String] = []
    let _OPTIONS_LIST = List<RealmString>()
    var OPTIONS_LIST: [String] {
        get {
            return _OPTIONS_LIST.map { $0.stringValue }
        }
        set {
            _OPTIONS_LIST.removeAll()
            _OPTIONS_LIST.append(objectsIn: newValue.map({ RealmString(value: [$0]) }))
        }
    }
    
    override static func ignoredProperties() -> [String] {
        return ["OPTIONS_LIST"]
    }
    convenience init(parmart: [String: Any]) {
        self.init()
        id = parmart["WORKSTEP_ID"] as? String ?? ""
        name = parmart["DESCRIPTION"] as? String ?? ""
        isDone = parmart["COMPLETE"] as? Bool ?? false
        type = parmart["OPERATION_TYPE"] as? String ?? "-1"
        if let str = parmart["OPTIONS_LIST"] as? String{
            if str.contains(";"){
                OPTIONS_LIST = str.components(separatedBy: ";")
            }else if str.contains(","){
                OPTIONS_LIST = str.components(separatedBy: ",")
            }else{
                OPTIONS_LIST = str.components(separatedBy: "，")
            }
            
        }
    }
    
    func toDic() -> [String: Any]{
        var dic = [String: Any]()
        dic["id"] = id
//        dic["taskId"] = taskId
//        dic["filename"] = ""
        if type == "1"{
            dic["photos"] = [value]
//            dic["value"] = ""
        }else if type == "3"{
            dic["value"] = value
        }else{
            dic["value"] = value
        }
        
        return dic
    }
}

class RealmString: Object {
    dynamic var stringValue = ""
}


class SignModel{
    var MAP_LNG = ""
    var MAP_LAT = ""
    var ADDRESS = ""
    var SIGN_TIME = ""
    var SIGN_STATU = ""
    var index = 0
    convenience init(parmart: [String: Any]) {
        self.init()
        MAP_LNG = parmart["MAP_LNG"] as? String ?? ""
        MAP_LAT = parmart["MAP_LAT"] as? String ?? ""
        ADDRESS = parmart["ADDRESS"] as? String ?? ""
        SIGN_TIME = parmart["SIGN_TIME"] as? String ?? ""
        SIGN_STATU = parmart["SIGN_STATU"] as? String ?? ""
        
        if SIGN_TIME == ""{
            SIGN_TIME = parmart["POSITION_TIME"] as? String ?? ""
        }
        
        if ADDRESS == ""{
            ADDRESS = parmart["RESERVER"] as? String ?? ""
        }
    }
}

class PermissionModel {
    let iD: String
    let sORT: Int
    let dESCRIPTION: String
    let iSTOP: Int
    let aPPMODULENAME: String
    let oPENSTATUS: Int
    init(iD: String, sORT: Int, dESCRIPTION: String, iSTOP: Int, aPPMODULENAME: String, oPENSTATUS: Int) {
        self.iD = iD
        self.sORT = sORT
        self.dESCRIPTION = dESCRIPTION
        self.iSTOP = iSTOP
        self.aPPMODULENAME = aPPMODULENAME
        self.oPENSTATUS = oPENSTATUS
    }
    convenience init?(json: [String: Any]) {
        guard let iD = json["ID"] as? String else { return nil }
        guard let sORT = json["SORT"] as? Int else { return nil }
        guard let dESCRIPTION = json["DESCRIPTION"] as? String else { return nil }
        guard let iSTOP = json["IS_TOP"] as? Int else { return nil }
        guard let aPPMODULENAME = json["APP_MODULE_NAME"] as? String else { return nil }
        guard let oPENSTATUS = json["OPEN_STATUS"] as? Int else { return nil }
        self.init(iD: iD, sORT: sORT, dESCRIPTION: dESCRIPTION, iSTOP: iSTOP, aPPMODULENAME: aPPMODULENAME, oPENSTATUS: oPENSTATUS)
    }
}

class CallbackModel {
    var time = ""
    var content = ""
    var name = ""

    convenience init(parmart: [String: Any]) {
        self.init()
        time = parmart["BACK_TIME"] as? String ?? ""
        content = parmart["BACK_TEXT"] as? String ?? ""
        name = parmart["BACK_NAME"] as? String ?? ""

    }
}

class PersonInfo {
    var picture = ""
    var sex = ""
    var name = ""
    var job_code = ""
    var partin_day = ""
    var birthday = ""
//    var name = ""
    
    convenience init(parmart: [String: Any]) {
        self.init()
        picture = parmart["USER_ICON"] as? String ?? ""
        sex = parmart["sex"] as? String ?? ""
        name = parmart["name"] as? String ?? ""
        job_code = parmart["job_code"] as? String ?? ""
        partin_day = parmart["partin_day"] as? String ?? ""
        birthday = parmart["birthday"] as? String ?? ""
        
    }
}

class Equipment {
    var equip_code = ""
    var type_name = ""
    var model_name = ""
    var brand = ""
    var name = ""
    var stage_name = ""
    var floor_name = ""
    var unit_num = ""
    var ground_num = ""
    var address = ""
    var id = 0
    convenience init(parmart: [String: Any]) {
        self.init()
        equip_code = parmart["equip_code"] as? String ?? ""
        type_name = parmart["type_name"] as? String ?? ""
        model_name = parmart["model_name"] as? String ?? ""
        brand = parmart["brand"] as? String ?? ""
        name = parmart["name"] as? String ?? ""
        stage_name = parmart["stage_name"] as? String ?? ""
        floor_name = parmart["floor_name"] as? String ?? ""
        if let num = parmart["unit_num"] as? Int{
            unit_num = String(num) + "单元"
        }
        if let num = parmart["floor_name"] as? Int{
            floor_name = String(num) + "层"
        }
        address = stage_name + floor_name + unit_num + ground_num
        id = parmart["id"] as? Int ?? -1
    }
}