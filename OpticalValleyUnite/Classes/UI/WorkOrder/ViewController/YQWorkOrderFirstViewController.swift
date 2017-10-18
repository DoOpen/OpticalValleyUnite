//
//  YQWorkOrderFirstViewController.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/10/17.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh

class YQWorkOrderFirstViewController: UIViewController {
    
    //应急工单
    @IBOutlet weak var emergencyWorkOrder: UIButton!
    
    //计划工单
    @IBOutlet weak var planWorkOrder: UIButton!
    
    //数据tableView
    @IBOutlet weak var tableView: UITableView!
    
    //数据模型
    var currentDatas = [WorkOrderModel2]()
    
    var siftVc: WorkOrderSiftViewController?
    var siftParmat: [String: Any]?
    var isFirstLoad = true
    
    var currentIndex = 0{
        didSet{
            pageNo = 0
            getWorkOrder(type:currentIndex, indexPage: pageNo)
        }
    }
    
    var pageNo = 0
    
    var currentStatusBtn: UIButton?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "我的工单"
        
        //初始调用的方法
        selectButtonClick(emergencyWorkOrder)
        addRefirsh()
        
        //注册cell
        let nib = UINib(nibName: "WorkOrder2Cell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0

    }
    
    // MARK: - 按钮点击的方法
    @IBAction func selectButtonClick(_ sender: UIButton) {
    
        currentStatusBtn?.isSelected = false
        currentStatusBtn = sender
        currentIndex = sender.tag
        currentStatusBtn?.isSelected = true

    }
    
    // MARK: - rightBar点击实现的方法
    @IBAction func rightBarItemClick(_ sender: Any) {
        
        let vc = UIStoryboard(name: "WorkOrder", bundle: nil).instantiateInitialViewController() as! WorkOrderViewController
        var par = [String : Any]()
        par["WORKUNIT_TYPE"] = currentStatusBtn?.tag
        
        vc.siftParmat = par
        navigationController?.pushViewController(vc, animated: true)

    }
    
    

    // MARK: - 获取工单详情的数据 调用方法
    func getWorkOrder(type:Int, indexPage: Int = 0,dic: [String: Any] = [String: Any]() ){
        
        //调用 类型的参数的接口!
        /*
         1.以前的按钮类型 分为3类  (待处理  已处理  已关闭)
         2.现在新增改变的是: 待派发  待接受  待执行  待评价  已关闭  5大类的类型
         */
        //现在是 单个条件筛选,只应用到应急工单 和 计划工单
//        var array = ["DCL", "YCL", "YGB"];
        
        var parmat = [String: Any]()
        
        parmat["pageIndex"] = indexPage
        
        for (key,value) in dic{
            parmat[key] = value
        }
        
        if let dic = siftParmat{
            for (key,value) in dic{
                parmat[key] = value
            }
        }
        
//        let dic = ["待派发": 11,"待执行" : 22, "待评价": 31,"待接收": 21,"已处理": 7, "已接受": 5,"协助查看": 5]
//        let  string  = currentStatusBtn?.titleLabel?.text
        
        /*
         工单类型 :  2 - 应急工单  1 - 计划工单
         */
        parmat["WORKUNIT_TYPE"] = currentStatusBtn?.tag
        
        
        SVProgressHUD.show(withStatus: "加载中...")
        
        HttpClient.instance.get(path: URLPath.getWorkunitList, parameters: parmat, success: { (response) in
            
            SVProgressHUD.dismiss()
            
            var temp = [WorkOrderModel2]()
            for dic in response["data"] as! Array<[String: Any]> {
                let model = WorkOrderModel2(parmart: dic)
//                if type < array.count {
//                    
//                    model.type = array[type]
//                }
                
                temp.append(model)
            }
            
            if indexPage == 0{
                self.pageNo = 0
                self.currentDatas = temp
                self.tableView.mj_header.endRefreshing()
            }else{
                
                if temp.count > 0{
                    self.pageNo = indexPage + 1
                    self.currentDatas.append(contentsOf: temp)
                    self.tableView.mj_footer.endRefreshing()
                }else{
                    //                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                    self.tableView.mj_footer.endRefreshing()
                }
            }
            
            //            let realm = try! Realm()
            //            try! realm.write {
            //                realm.add(temp, update: true)
            //            }
            
            self.tableView.reloadData()
            
            
        }) { (error) in
            
            
        }
    }
    
    // MARK: - 上下拉刷新
    func addRefirsh(){
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.getWorkOrder(type: self.currentIndex )
        })
        
        
        
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            
            self.getWorkOrder(type: self.currentIndex , indexPage: self.pageNo + 1)
        })
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
