//
//  YQOffLineFirstWorkOrderVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/1/5.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit
import RealmSwift
import SVProgressHUD


class YQOffLineFirstWorkOrderVC: UIViewController {

    /// 属性列表
    @IBOutlet weak var emergencyWorkOrderButton: UIButton!
    
    @IBOutlet weak var planWorkOrderButton: UIButton!
    
    var currentStatusBtn : UIButton?
    
    @IBOutlet weak var tableView: UITableView!
    
    var currentIndex = 0{
        didSet{
            //重新查表,赋值currentDatas
            screenWithDataFromRealm()
        }
    }

    //数据模型
    var currentDatas = [WorkOrderModel2](){
        
        didSet{
            
            tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationItem.title = "我的离线工单"
        
        //默认设置为应急工单
        self.currentStatusBtn = emergencyWorkOrderButton
       
        //注册cell
        let nib = UINib(nibName: "WorkOrder2Cell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        
        //数据库来拿数据的列表
        screenWithDataFromRealm()
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        //初始调用的方法
        clickButtonEvent(currentStatusBtn!)
        
    }

    
    // MARK: - buttonClick的事件列表
    @IBAction func clickButtonEvent(_ sender: UIButton) {
        
        currentStatusBtn?.isSelected = false
        currentStatusBtn = sender
        currentIndex = sender.tag
        currentStatusBtn?.isSelected = true
        
    }
    
    // MARK: - 工单上传的button点击
    @IBAction func workOrderUpButtonClick(_ sender: UIButton) {
        
        let realm = try! Realm()
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
            
            parmart["type"] = "1" //应急工单
            var filerArray = [UIImage]()
            
            //先区分应急和计划, 再查看应急工单中相同和不同的 工单ID的情况
            let emergency = realm.objects(offLineWorkOrderUpDatePictrueModel.self)
            
            if !emergency.isEmpty {
                
                let emergencyResult = realm.objects(offLineWorkOrderUpDatePictrueModel.self).filter("stepId == %@","yingji")
                
                var id = emergencyResult.first?.id
                
                parmart["id"] = id
                
                for emergenyIndex in 0..<emergencyResult.count {
                    
                    let model = emergencyResult[emergenyIndex]
                    
                    if id != model.id {
                        
                        //上传一次应急工单了,//点击上传来,清空数据已上传的图片数据
                        HttpClient.instance.uploadOffWorkLineImages(filerArray , param: parmart, succses: { (url) in
                            
                            SVProgressHUD.showSuccess(withStatus: "上传图片中!")
                            
                        }, failure: { (error) in
                            
                            
                            SVProgressHUD.showError(withStatus: "图片上传失败,请检查网络!")
                            
                        })
                        
                        id = model.id
                        filerArray.removeAll()
                        
                    }else{
                        
                        let data = model.pictureData
                        let image = UIImage.init(data: data!)
                        filerArray.append(image!)
                        
                        if emergenyIndex == emergencyResult.count - 1 {
                            
                            //上传一次应急工单了
                            HttpClient.instance.uploadOffWorkLineImages(filerArray , param: parmart, succses: { (url) in
                                
                                SVProgressHUD.dismiss()
                                SVProgressHUD.showSuccess(withStatus: "上传图片成功!")
                                
                                
                            }, failure: { (error) in
                                
                                SVProgressHUD.showError(withStatus: "图片上传失败,请检查网络!")
                                
                            })
                            
                            
                        }
                    }
                }
            }
            
            parmart["type"] = "2" //计划工单
            filerArray.removeAll()
            
            let plan = realm.objects(offLineWorkOrderUpDatePictrueModel.self)
            
            if !plan.isEmpty {
                
                let planResult =  realm.objects(offLineWorkOrderUpDatePictrueModel.self).filter("stepId == %@","yingji")
                //注意的是: 计划工单的多个执行步骤要求分开上传
                var stepID = planResult.first?.stepId
                parmart["stepId"] = stepID
                
                //应急工单直接上传
                for planWorkOIndex in 0..<planResult.count {
                    
                    let model = planResult[planWorkOIndex]
                    parmart["id"] = model.id

                    if stepID != model.stepId {
                        
//                        parmart["files"] = filerArray
                        HttpClient.instance.uploadOffWorkLineImages(filerArray , param: parmart, succses: { (url) in
                            
                            SVProgressHUD.dismiss()
                            
                            SVProgressHUD.showSuccess(withStatus: "上传图片成功!")
                        }, failure: { (error) in
                            
                             SVProgressHUD.showError(withStatus: "图片上传失败,请检查网络!")
                            
                        })
                        
                        stepID = model.stepId
                        parmart["stepId"] = stepID
                        filerArray.removeAll()
                        
                    }else{
                        
                        let data = model.pictureData
                        let image = UIImage.init(data: data!)
                        filerArray.append(image!)
                        
                        if planWorkOIndex == planResult.count - 1 {
                            
                            //上传一次应急工单了
                            HttpClient.instance.uploadOffWorkLineImages(filerArray , param: parmart, succses: { (url) in
                                SVProgressHUD.dismiss()

                                SVProgressHUD.showSuccess(withStatus: "上传图片成功!")
                            }, failure: { (error) in
                                
                                 SVProgressHUD.showError(withStatus: "图片上传失败,请检查网络!")
                            })
                        }
                    }
                }
            }
            
            return
            
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
                    
                    //移除上传完成的工单
                    try! realm.write {
                        
                        //清空所有,然后再进行的添加
                        realm.delete(compelte)
                    }

                    
                }, failure: { (error) in
                    
                    SVProgressHUD.showError(withStatus: "工单保存失败,请检查网络!")
                })
            }
            
        }
        
    }
 
    
    // MARK: - 工单下载的button点击
    @IBAction func workOrderDownButtonClick(_ sender: UIButton) {
        
        self.alert(message: "请确认工单已经上传了!下载会清空所有离线工单数据!") { (action) in
            
            let reachability = Reachability()!
            
            if reachability.connection == .none {
                
                print("Reachable via Cellular")
                
                SVProgressHUD.showError(withStatus: "没有可用的网络!")
                
                return
                
            } else {
                
                print("Reachable via 有网的情况下,更新数据库的情况")
                self.updateDataForDB()
                
            }
        }
    }
   
    
    func updateDataForDB(){
        
        let realm = try! Realm()
        
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
            
            DispatchQueue.main.async {
                
                print("数据库地址:")
                print(realm.configuration.fileURL ?? "")
                
                try! realm.write {
                    
                    //清空所有,然后再进行的添加
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
                
                //最后:重新刷新一下数据
                self.screenWithDataFromRealm()
                
            }
            
        }) { (error) in
            
            SVProgressHUD.showError(withStatus: "离线工单下载失败,请重试!")
        }
        
    }
    
    // MARK: - 筛选查询本地的数据库data的方法
    func screenWithDataFromRealm(){
        
        //遍历所有的第一级的模型表里面的数据
        let realm = try! Realm()
        let result =  realm.objects(WorkOrderModel2.self)
        var tempDataArray = [WorkOrderModel2]()
        
        for model in result {
            
            let temp = model as WorkOrderModel2
            
            if model.type2 == "\(currentIndex)" {
                
                tempDataArray.append(temp)
            }
            
        }
        
        self.currentDatas = tempDataArray
    }

    
}

extension YQOffLineFirstWorkOrderVC: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return currentDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: WorkOrder2Cell //注意的是,细小的bug 两个的cell是不同的模型
        
        cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! WorkOrder2Cell
        cell.model2 = currentDatas[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = WorkOrderProgressViewController.loadFromStoryboard(name: "WorkOrder") as! WorkOrderProgressViewController
        let model = currentDatas[indexPath.row]
        
        var parmat = [String: Any]()
        parmat["UNIT_STATUS"] = model.status
        parmat["PERSONTYPE"] = model.PERSONTYPE
        parmat["EXEC_PERSON_ID"] = model.execPersionId
        parmat["WORKUNIT_ID"] = model.workOrderId
        
        vc.parmate = parmat
        // 执行的工单的 回退之后 进行的list的刷新, 要求的补全逻辑的代码
        //    vc.listVc = self
        // 属性列表的判断
        vc.backDB = true
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}


