//
//  YQWorkOrderFirstViewController.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/10/17.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit

class YQWorkOrderFirstViewController: UIViewController {
    //应急工单
    @IBOutlet weak var emergencyWorkOrder: UIButton!
    
    //计划工单
    @IBOutlet weak var planWorkOrder: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    //数据模型
    var currentDatas = [WorkOrderModel2]()
    
    var siftVc: WorkOrderSiftViewController?
    var siftParmat: [String: Any]?
    var isFirstLoad = true
    
    var currentIndex = 0{
        didSet{
            pageNo = 0
//            getWorkOrder(type:currentIndex, indexPage: pageNo)
        }
    }
    
    var pageNo = 0
    
    var currentStatusBtn: UIButton?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "我的工单"
        

    }



}


extension YQWorkOrderFirstViewController: UITableViewDataSource, UITableViewDelegate{
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
        //        vc.workModelId = currentDatas[indexPath.row].workOrderId
        let model = currentDatas[indexPath.row]
        
        var parmat = [String: Any]()
        parmat["UNIT_STATUS"] = model.status
        parmat["PERSONTYPE"] = model.PERSONTYPE
        parmat["EXEC_PERSON_ID"] = model.execPersionId
        parmat["WORKUNIT_ID"] = model.workOrderId
        
        vc.parmate = parmat
        // 执行的工单的 回退之后 进行的list的刷新, 要求的补全逻辑的代码
        //    vc.listVc = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
