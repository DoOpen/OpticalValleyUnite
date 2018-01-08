//
//  YQOffLineFirstWorkOrderVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/1/5.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit
import RealmSwift


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
        clickButtonEvent(emergencyWorkOrderButton)
        
    }

    
    // MARK: - buttonClick的事件列表
    @IBAction func clickButtonEvent(_ sender: UIButton) {
        
        currentStatusBtn?.isSelected = false
        currentStatusBtn = sender
        currentIndex = sender.tag
        currentStatusBtn?.isSelected = true
        
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
        
//        let vc = WorkOrderProgressViewController.loadFromStoryboard(name: "WorkOrder") as! WorkOrderProgressViewController
//        //        vc.workModelId = currentDatas[indexPath.row].workOrderId
//        let model = currentDatas[indexPath.row]
//        
//        var parmat = [String: Any]()
//        parmat["UNIT_STATUS"] = model.status
//        parmat["PERSONTYPE"] = model.PERSONTYPE
//        parmat["EXEC_PERSON_ID"] = model.execPersionId
//        parmat["WORKUNIT_ID"] = model.workOrderId
//        
//        vc.parmate = parmat
//        // 执行的工单的 回退之后 进行的list的刷新, 要求的补全逻辑的代码
//        //    vc.listVc = self
//        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}


