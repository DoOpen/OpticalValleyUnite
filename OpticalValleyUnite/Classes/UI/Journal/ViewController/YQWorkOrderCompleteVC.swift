//
//  YQWorkOrderCompleteVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/11/1.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh

class YQWorkOrderCompleteVC: UIViewController {

    // MARK: - 属性列表
    @IBOutlet weak var alreadlyCompletedButton: UIButton!
    
    @IBOutlet weak var notFinishedButton: UIButton!
    
    @IBOutlet weak var alreadlyLabel: UILabel!
    
    @IBOutlet weak var notFinishLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    // 日志ID
    var workLogID = ""
    
    var currentDatas = [WorkOrderModel2]()
    
    var currentIndex = 0{
        didSet{
            pageNo = 0
//            getWorkOrder(type:currentIndex, indexPage: pageNo)
        }
    }
    
    var pageNo = 0

    var currentSelectButton : UIButton?
    
    lazy var dic : [String : Any] = { () -> [String : Any]
        in
        
        var dict = [String : Any]()
        dict["worklogId"] = self.workLogID
        dict["self"] = "0"

        return dict
        }()
    
    // MARK: - 视图生命周期方法
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //属性赋值
        self.automaticallyAdjustsScrollViewInsets = false
        
        //上拉,下拉刷新
        addRefirsh()
        
        //注册cell
        let nib = UINib(nibName: "WorkOrder2Cell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        
        //默认选择未完成
        self.alreadyCompletedButtonClick()
        
    }
    
    
    // MARK: - 工单详情的数据
    func getWorkOrder(type:Int = 0, indexPage: Int = 0,dic: [String: Any] = [String: Any]() ){
        
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
        
        //添加默认的选择项目 筛选条件
        SVProgressHUD.show(withStatus: "加载中...")
        
        HttpClient.instance.get(path: URLPath.getWorkunitList2, parameters: parmat, success: { (response) in
            
            SVProgressHUD.dismiss()
            
            let totalCount = response["totalCount"] as? Int
            self.setSelectButton(selectBnt: self.currentSelectButton!, totalCount: totalCount!)
            
            var temp = [WorkOrderModel2]()
            
            for dic in response["data"] as! Array<[String: Any]> {
                
                let model = WorkOrderModel2(parmart: dic)
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
                    
                    self.tableView.mj_footer.endRefreshing()
                }
            }
            
            self.tableView.reloadData()
            
        }) { (error) in
            
            SVProgressHUD.showError(withStatus: error.debugDescription)
        }
        
    }
    
    // MARK: - 所有按钮的点击
    //已完成按钮的点击
    @IBAction func alreadyCompletedButtonClick() {
        
        self.alreadlyCompletedButton.isSelected = true
        self.notFinishedButton.isSelected = false
        self.alreadlyLabel.textColor = UIColor.blue
        self.notFinishLabel.textColor = UIColor.gray
        
        currentSelectButton = self.alreadlyCompletedButton
        
        //传递的是四个参数
        dic["STATUS"] = "YCL"
        
        getWorkOrder(dic: dic)
    }
    
    
    //未完成按钮的点击
    @IBAction func notFinisedButtonClick() {
        
        self.alreadlyCompletedButton.isSelected = false
        self.notFinishedButton.isSelected = true
        self.alreadlyLabel.textColor = UIColor.gray
        self.notFinishLabel.textColor = UIColor.blue
        
        currentSelectButton = self.notFinishedButton
        
        dic["STATUS"] = "DCL"
        
        getWorkOrder(dic: dic)
    }
    
    // MARK: - 上下拉刷新
    func addRefirsh(){
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            
            self.getWorkOrder(type: self.currentIndex , dic: self.dic)
        })
        
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            
            self.getWorkOrder(type: self.currentIndex , indexPage: self.pageNo + 1 , dic: self.dic)
        })
    }

    // MARK: - 设置加载数据button展示
    func setSelectButton(selectBnt : UIButton, totalCount : Int){
        
        if selectBnt.tag == 0 {//已完成
            
            self.alreadlyLabel.text = "\(totalCount)"
            
        }else{//未完成
            
            self.notFinishLabel.text = "\(totalCount)"
        
        }
    }
    

}

extension YQWorkOrderCompleteVC: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return currentDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: WorkOrder2Cell //注意的是,细小的bug 两个的cell是不同的模型
        
        
        cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! WorkOrder2Cell
        cell.model2 = currentDatas[indexPath.row]
        
        return cell
    }
    
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
//    }

}
