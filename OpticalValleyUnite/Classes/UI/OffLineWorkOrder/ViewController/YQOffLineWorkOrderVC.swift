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
        
        let reachability = Reachability()!
        
        reachability.whenReachable = { reachability in
            if reachability.connection == .none {
                print("Reachable via Cellular")
                //最后.再转工单详情的模型数据列表
                let offlineFirst = UIStoryboard.instantiateInitialViewController(name: "YQOffLineFirst")
                self.navigationController?.pushViewController(offlineFirst, animated: true)
                
            } else {
                
                print("Reachable via 有网的情况下,更新数据库的情况")
                
                self.updateDataForDB()
            }
        }
        
        
        
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
         
         */
        
//        let realm = try! Realm()
//        let result =  realm.objects(WorkOrderModel2.self)
//        
//        
//        print(result.count)
//        
//        print(result)

               
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
