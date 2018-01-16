//
//  YQOffLineWorkOrderVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/1/4.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit
import RealmSwift
import SVProgressHUD

class YQOffLineWorkOrderVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "离线工单"
    }
    
    // MARK: - 离线工单的操作
    @IBAction func offLineButtonDownLoad(_ sender: UIButton) {
        //思路:
        /*
         1.调用离线工单的下载的接口
         2.数据解压,base64转json
         3.relam写入数据库的操作
         4.读取进行渲染,拿到数据,进行操作
         */
        
        //模拟器可能不适用
        let reachability = Reachability()!
        
        if reachability.connection == .none {
            
            print("Reachable via Cellular")
            
            //最后.再转工单详情的模型数据列表
            let offlineFirst = UIStoryboard.instantiateInitialViewController(name: "YQOffLineFirst")
            self.navigationController?.pushViewController(offlineFirst, animated: true)
            
        } else {
            
            print("Reachable via 有网的情况下,更新数据库的情况")
            self.updateDataForDB()
            
        }
        
        
//        reachability.whenReachable = { reachability in //当网络可用的情况下
//            
//        }
        
        //测试数据的调用显示
        /*
         //        /// 测试数据库的代码情况
         //        var tempData = [WorkOrderModel2]()
         //
         //        var dict = [String : Any]()
         //        dict["id"] = "8980980"
         //        dict["status"] = 1
         //        dict["content"] = "都帮songodjodn"
         //        dict["EXEC_PERSON_ID"] = "jsongodijdojfdof"
         //        dict["statusCn"] = "jsongdoufbdo"
         //        dict["reportPeopleName"] = "eionfoaohgd"
         //        dict["WORKUNIT_TYPE"] = "1"
         //
         //        for xxxx in 0...4 {
         //
         //            if xxxx == 0 {
         //                dict["id"] = "898098009080q"
         //                dict["WORKUNIT_TYPE"] = "1"
         //
         //            }else if (xxxx == 1){
         //                dict["id"] = "898098009sefe080q"
         //                dict["WORKUNIT_TYPE"] = "2"
         //
         //            }else if (xxxx == 2){
         //                dict["id"] = "980091224080q"
         //                dict["WORKUNIT_TYPE"] = "1"
         //
         //            }else if (xxxx == 3){
         //                dict["id"] = "8980980045459080q"
         //                dict["WORKUNIT_TYPE"] = "2"
         //
         //            }
         //
         //            let model = WorkOrderModel2.init(parmart: dict)
         //            tempData.append(model)
         //        }
         //        
         //        
         //        let realm = try! Realm()
         //        try! realm.write {
         //            
         //            realm.add(tempData, update: true)
         //            
         //        }
*/

    }
    
    // MARK: - 离线工单的上传
    @IBAction func offLineButtonUP(_ sender: UIButton) {
        //上传思路:
        /*
         1.读取对应的工单进行上传
         2.对应的数据表的图片上传的情况
         */
        
        let realm = try! Realm()
        
//        print(result.count)
//        
//        print(result)
        
        
        // 上传图片和上传工单
        //模拟器可能不适用
        let reachability = Reachability()!
        
        if reachability.connection == .none {
            
            SVProgressHUD.showError(withStatus: "检测不到网络,无法上传!")

        } else {
            
            let toallPictrue = realm.objects(offLineWorkOrderUpDatePictrueModel.self)
            
            if toallPictrue.isEmpty {
                
                return
            }
            
            SVProgressHUD.show(withStatus: "上传图片中...")
            var parmart = [String : Any]()
           
            parmart["type"] = 1 //应急工单
            let filerArray = NSMutableArray()
            
            //先区分应急和计划, 再查看应急工单中相同和不同的 工单ID的情况
            let emergency = realm.objects(offLineWorkOrderUpDatePictrueModel.self)
            
            if !emergency.isEmpty {
                
                let emergencyResult = realm.objects(offLineWorkOrderUpDatePictrueModel.self).filter("stepId == %@","yingji")
                
                var id = emergencyResult.first?.id
                
                parmart["id"] = id
                
                for emergenyIndex in 0..<emergencyResult.count {
                    
                    let model = emergencyResult[emergenyIndex]
                    
                    if id != model.id {
                        
                        parmart["files"] = filerArray
                        //上传一次应急工单了
//                        HttpClient.instance.uploadOffWorkLineImages(filerArray as! [UIImage], succses: { (url) in
//                            SVProgressHUD.showSuccess(withStatus: "上传图片成功!")
//                        }, failure: { (error) in
//                            
//                            SVProgressHUD.show(withStatus: "图片上传失败,请检查网络!")
//                            
//                        })
                        
                        id = model.id
                        filerArray.removeAllObjects()
                        
                    }else{
                        
                        let data = model.pictureData
                        let image = UIImage.init(data: data!)
                        filerArray.adding(image!)
                        
                        if emergenyIndex == emergencyResult.count - 1 {
                            
                            //上传一次应急工单了
//                            HttpClient.instance.uploadOffWorkLineImages(filerArray as! [UIImage], succses: { (url) in
//                                SVProgressHUD.showSuccess(withStatus: "上传图片成功!")
//                            }, failure: { (error) in
//                                
//                                SVProgressHUD.show(withStatus: "图片上传失败,请检查网络!")
//                                
//                            })
//                            

                        }
                    }
                }
            }
            
            parmart["type"] = 2 //计划工单
            filerArray.removeAllObjects()
            
            let plan = realm.objects(offLineWorkOrderUpDatePictrueModel.self)
            
            if !plan.isEmpty {
                
                let planResult =  realm.objects(offLineWorkOrderUpDatePictrueModel.self).filter("stepId == %@","yingji")
                //注意的是: 计划工单的多个执行步骤要求分开上传
                let stepID = planResult.first?.stepId
                parmart["stepId"] = stepID
                //应急工单直接上传
                for planWorkOIndex in 0..<planResult.count {
                    
                    let model = planResult[planWorkOIndex]
                    
                    if stepID != model.stepId {
                        
                        parmart["files"] = filerArray
                        //上传一次应急工单了
                        HttpClient.instance.uploadOffWorkLineImages(filerArray as! [UIImage], succses: { (url) in
                            
                            SVProgressHUD.showSuccess(withStatus: "上传图片成功!")
                        }, failure: { (error) in
                            
                            SVProgressHUD.show(withStatus: "图片上传失败,请检查网络!")
                            
                        })
                        
                        parmart["stepId"] = stepID
                        filerArray.removeAllObjects()
                        
                    }else{
                        
                        let data = model.pictureData
                        let image = UIImage.init(data: data!)
                        filerArray.adding(image!)
                        
                        if planWorkOIndex == planResult.count - 1 {
                            
                            //上传一次应急工单了
//                            HttpClient.instance.uploadOffWorkLineImages(filerArray as! [UIImage], succses: { (url) in
//                                 SVProgressHUD.showSuccess(withStatus: "上传图片成功!")
//                            }, failure: { (error) in
//                                
//                                SVProgressHUD.show(withStatus: "图片上传失败,请检查网络!")
//                                
//                            })
                        }
                    }
                }
            }
            
            //上传离线的工单的情况,根据保存和完成项的工单来进行的取值判断!
            //有图片的工单肯定上传,点击保存和完成的工单ID也是要进行的上传
            // parmat["SUCCESS_TEXT"] = self.RemarksTextView.text
            let compelte = realm.objects(saveAndCompelteWorkIDModel.self)
            
            if !compelte.isEmpty {
                
                SVProgressHUD.show(withStatus: "正在保存工单")
//                let id = toallPictrue
                
                var arrayDict = Array<[String: Any]>()
                var parmat = [String: Any]()

                for model in compelte {
                    
                    let id = model.WORKUNIT_ID
                    let stepid = model.stepId
                    
                    if stepid == "yingji" {
                        
                        var par = [String: Any]()
                        par["WORKUNIT_ID"] = model.WORKUNIT_ID
//                        par["UNIT_STATUS"] = 7
                        par["SUCCESS_TEXT"] = ""
                        par["FINISH_STATUS"] = 1 //应急工单只有完成
                        
                        arrayDict.append(par)
                        
                        continue
                    }
                    
                    var models = [ExecSectionModel]()
                    
                    autoreleasepool {
                        
                        let realm = try! Realm()
                        
                        let model = realm.objects(ExecSectionModel.self).filter("workOrderId == %@", id)
                        
                        for temp in model{
                            
                            models.append(temp)
                        }
                        
                    }
                    var arry = Array<[String: Any]>()
                    
                    for model in models{
                        
//                        model.workOrderId = id
                        
                        let taskDic = model.toDic()
                        
                        arry.append(taskDic)
                    }
                    
                    //调整接口的数据的类型,上传数据类型调整
                    let json0 = arry[0] 
                    
                    parmat["WORKUNIT_ID"] = json0["WORKUNIT_ID"]
                    parmat["WORKTASK_ID"] = json0["WORKTASK_ID"]
//                    parmat["UNIT_STATUS"] = json0["UNIT_STATUS"]
                    parmat["ID"] = json0["ID"]
                    parmat["DESCRIPTION"] = json0["DESCRIPTION"]
                    
                    arrayDict.append(parmat)
                }
                
                var parameters = [String : Any]()
                
                do{
                    
                    let jsonData = try JSONSerialization.data(withJSONObject: arrayDict, options: JSONSerialization.WritingOptions.prettyPrinted)
                    
                    if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8){
                        
                        //格式化的json字典的情况
                        print(JSONString)
                        
                        //注意的是这里的par 要求序列化json
                        parameters["jsonData"] = JSONString
                        
                    }
                    
                } catch {
                    
                    print("转换错误 ")
                }

                
                HttpClient.instance.post(path: URLPath.getUploadOfflineUnits, parameters: parameters, success: { (response) in
                    
                    SVProgressHUD.dismiss()
                    SVProgressHUD.showSuccess(withStatus: "工单保存成功!")
                    
                }, failure: { (error) in
                    
                })
            }

        }


               
    }
    
    func updateDataForDB(){
        
        SVProgressHUD.show()
        
        HttpClient.instance.post(path: URLPath.getDownloadOfflineUnits, parameters: nil, success: { (response) in
            
            SVProgressHUD.dismiss()
            //大数据的处理情况
            let data = response["data"] as? NSArray
            
            //1.先转工单首页的模型数据表
            var tempWOModel2Data = [WorkOrderModel2]()
            
            for temp in data! {
                
                let model = WorkOrderModel2.init(parmart: temp as! [String : Any])
                tempWOModel2Data.append(model)
            }
            
            //1.1工单详细的模型数据表
            var tempDetailM = [WorkOrderDetailModel]()
            for temp in data! {
                
                let dic = temp as? NSDictionary
                let detail = dic?["detail"] as? [String : Any]
                //                detail?["ID"] = dic?["ID"] as? String
                
                if detail != nil {
                    
                    let model = WorkOrderDetailModel.init(parmart: detail!)
                    
                    tempDetailM.append(model)
                }
                
            }
            
            let realm = try! Realm()
            print("数据库地址:")
            print(realm.configuration.fileURL ?? "")
            
            try! realm.write {
                
                realm.deleteAll()
                
                realm.add(tempWOModel2Data, update: true)
                realm.add(tempDetailM)
                
            }
            
            //2.工单详情的界面的模型数据表
            var tempESectionM = [ExecSectionModel]()
            for temp in data!{
                
                let dic = temp as? NSDictionary
                let detail = dic?["detail"] as? NSDictionary
                var section = detail?["task"] as? [String : Any]
                
                section?["ID"] = dic?["ID"] as? String
                
                if section != nil {
                    
                    let model = ExecSectionModel(parmart: section!)
                    
                    tempESectionM.append(model)
                }
            }
            
            if !tempESectionM.isEmpty {
                
                try! realm.write {
                    
                    realm.add(tempESectionM)
                }
            }
            
            
            //3.工单详情histories的数据表
            var tempHistoriesM = [WorkHistoryModel111]()
            for temp in data!{
                
                let dic = temp as? NSDictionary
                let detail = dic?["detail"] as? NSDictionary
                let histories = detail?["histories"] as? NSArray
                
                if histories != nil {
                    var tempDict = [String : Any]()
                    tempDict["id"] = dic?["ID"] as? String
                    tempDict["list"] = histories
                    
                    let model = WorkHistoryModel111.init(parmart: tempDict)
                    
                    tempHistoriesM.append(model)
                }
            }
            if !tempHistoriesM.isEmpty {
                
                try! realm.write {
                    
                    realm.add(tempHistoriesM)
                    
                }
            }
            
            //            var tempHistoriesM = [WorkHistoryModel]()
            //
            //            for temp in data!{
            //                let dic = temp as? NSDictionary
            //                let detail = dic?["detail"] as? NSDictionary
            //                let histories = detail?["histories"] as? NSArray
            //
            //                if histories != nil {
            //
            //                    var tempDict = [String : Any]()
            //                    tempDict["id"] = dic?["ID"] as? String
            //                    tempDict["list"] = histories
            //
            //                    let model = WorkHistoryModel.init(parmart: tempDict)
            //
            //                    tempHistoriesM.append(model)
            //
            //                }
            //            }
            //
            //            if !tempHistoriesM.isEmpty {
            //                try! realm.write {
            //                    realm.add(tempHistoriesM)
            //                }
            //            }
            
            
            //4.工单详情callbacks的数据表
            var tempCallbsM = [CallbackModel]()
            for temp in data!{
                
                let dic = temp as? NSDictionary
                let detail = dic?["detail"] as? NSDictionary
                var callbacks = detail?["callbacks"] as? [String : Any]
                callbacks?["id"] = dic?["ID"] as? String
                
                if callbacks != nil {
                    
                    let model = CallbackModel(parmart: callbacks!)
                    
                    tempCallbsM.append(model)
                }
                
            }
            if !tempCallbsM.isEmpty {
                
                try! realm.write {
                    
                    realm.add(tempCallbsM)
                }
            }
            
            
            
            //5.拿到设备设置的接口,这里的是要求存储增加的是设备的id,通过设备ID来进行的筛选查找
            var tempEquimentModel = [EquimentModel]()
            
            for temp in data!{
                
                let dic = temp as? NSDictionary
                let detail = dic?["detail"] as? NSDictionary
                var equipment = detail?["equipment"] as? [String : Any]
                equipment?["id"] = dic?["ID"] as? String
                
                if equipment != nil {
                    
                    let model = EquimentModel(parmart: equipment!)
                    
                    tempEquimentModel.append(model)
                }
                
            }
            
            if !tempEquimentModel.isEmpty {
                
                try! realm.write {
                    
                    realm.add(tempEquimentModel)
                    
                }
                
            }
            
            
            //最后.再转工单详情的模型数据列表
            let offlineFirst = UIStoryboard.instantiateInitialViewController(name: "YQOffLineFirst")
            self.navigationController?.pushViewController(offlineFirst, animated: true)
            
            
        }) { (error) in
            
            SVProgressHUD.showError(withStatus: "离线工单下载失败,请重试!")
        }

        
    }

}
