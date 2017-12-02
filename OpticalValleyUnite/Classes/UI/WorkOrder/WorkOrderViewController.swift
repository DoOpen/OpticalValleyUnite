//
//  WorkOrderViewController.swift
//    OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/1/10.
//  Copyright © 2017年 贺思佳. All rights reserved.

import UIKit
import SVProgressHUD
import MJRefresh
import RealmSwift

class WorkOrderViewController: UIViewController {
    

    @IBOutlet weak var tableView: UITableView!
    
    /*
     已处理按钮 (以前)
     待接受按钮 (现在)
     */
    @IBOutlet weak var didProcessedBtn: UIButton!
    
    /*
     待处理按钮 (以前)
     待派发按钮 (现在)
     */
    @IBOutlet weak var waitProcessedBtn: UIButton!
    
    /*
     现在和以前的都是  已关闭状态
     */
    @IBOutlet weak var didCloseBtn: UIButton!
    
    /*
     新增的 待执行 按钮
     */
    @IBOutlet weak var waitExecutiveBtn: UIButton!
    
    /*
     新增的 待评价 按钮
     */
    @IBOutlet weak var waitEvaluateBtn: UIButton!
    
    var siftVc: WorkOrderSiftViewController?
    var siftParmat: [String: Any]?
    var siftsiftParmat : [String : Any]?
    
    
    var isFirstLoad = true
    var currentDatas = [WorkOrderModel2]()
    
    var currentIndex = 0{
        didSet{
            pageNo = 0
            getWorkOrder(type:currentIndex, indexPage: pageNo,dic: siftParmat!)
        }
    }
    
    var pageNo = 0
    
    var currentStatusBtn: UIButton?
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationItem.title = "我的工单"
    
        
        statusBtnClick(waitProcessedBtn)
        addRefirsh()
//        getWorkOrder(type: currentIndex,indexPage: 0)
        
        let nib = UINib(nibName: "WorkOrder2Cell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        
    }
    
    
    // MARK: - rightButtonBar的click方法
    @IBAction func rightBtnClick(_ sender: UIBarButtonItem) {
        
        let vc = WorkOrderSiftViewController.loadFromStoryboard(name: "WorkOrder") as! WorkOrderSiftViewController
        
        //传递筛选条件,进行缓存和保存
        vc.siftParmat = self.siftsiftParmat
        
        if currentIndex < 3 {
        
            vc.status =  ["DCL", "YCL","YGB"][currentIndex]
        }
        
        
//        self.addChildViewController(vc)
        siftVc = vc
//        vc.didMove(toParentViewController: self)
        
        let subView = vc.view
        subView?.frame = CGRect(x: 100, y: 0, width: SJScreeW - 100, height: SJScreeH)
        CoverView.show(view: subView!)
        
        //点击筛选的完成的 block的回调的情况
        /*
         实现的思路是: 综合拼接响应的筛选的结果
         */
        vc.doenBtnClickHandel = { parmat in
            
            self.isFirstLoad = true
            
            if parmat.isEmpty{//为空的话
                
                //在闭包的 回调中 拿到了选择的参数, 进行重新的网络请求,数据的刷新
                self.getWorkOrder(type: self.currentIndex,indexPage: 0,dic: self.siftParmat!)

            }else{
                
                self.getWorkOrder(type: self.currentIndex,indexPage: 0,dic: parmat)
                
                self.siftsiftParmat = parmat
                
            }
            
            subView?.superview?.removeFromSuperview()
            self.siftVc = nil
        }
        
//        view?.addSubview(subView!)
        
    }
    
    
    func reload(){
        
        getWorkOrder(type: currentIndex,indexPage: 0)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if isFirstLoad {
            
            isFirstLoad = false
        }else{
            
            getWorkOrder(type: currentIndex,indexPage: 0)
        }
        
    }
    
//    func rightBtnClick(){
//        let vc = worksif
//    }

    @IBAction func statusBtnClick(_ sender: UIButton) {
        
        currentStatusBtn?.isSelected = false
        currentStatusBtn = sender
        currentIndex = sender.tag
        currentStatusBtn?.isSelected = true
        
    }
    

    func getWorkOrderFormDataDB(type:String, indexPage: Int = 0) -> [WorkOrderModel2]{
        let realm = try! Realm()
        let result =  realm.objects(WorkOrderModel2.self)
 
        var tempArray = [WorkOrderModel2]()
        for model in result {
            let model = model as WorkOrderModel2
            if model.type == type{
                tempArray.append(model)
            }
            
        }
        return tempArray
    }
    
    
    func getWorkOrder(type:Int, indexPage: Int = 0,dic: [String: Any] = [String: Any]() ){
        
        //调用 类型的参数的接口!
        /*
         1.以前的按钮类型 分为3类  (待处理  已处理  已关闭)
         2.现在新增改变的是: 待派发  待接受  待执行  待评价  已关闭  5大类的类型   
         */
        var array = ["DCL", "YCL", "YGB"];
        
        var parmat = [String: Any]()
        
        parmat["pageIndex"] = indexPage
        
        for (key,value) in dic{
           parmat[key] = value
        }
        
        //父控件传递的筛选的条件
        if let dic = siftParmat{
            for (key,value) in dic{
                parmat[key] = value
            }
        }
        
        //经过筛选项,筛选的条件
        if let dic = siftsiftParmat{
            for (key,value) in dic{
                parmat[key] = value
            }
        }

        
        if type < array.count {
            
            parmat["STATUS"] = array[type]
        }
        
        let dic = ["待派发": 11,"待执行" : 22, "待评价": 31,"待接收": 21,"已处理": 7, "已接受": 5,"协助查看": 5]
        let  string  = currentStatusBtn?.titleLabel?.text
        
        parmat["operateType"] = dic[string!]

        //添加默认的选择项目 筛选条件
        parmat["PARK_ID"] = getUserDefaultsProject()
        
        
        
        SVProgressHUD.show(withStatus: "加载中...")
        
        HttpClient.instance.get(path: URLPath.getWorkunitList, parameters: parmat, success: { (response) in
            
            SVProgressHUD.dismiss()
            
            var temp = [WorkOrderModel2]()
            for dic in response["data"] as! Array<[String: Any]> {
                let model = WorkOrderModel2(parmart: dic)
                if type < array.count {
                    
                    model.type = array[type]
                }
                
                temp.append(model)
            }
            
            if indexPage == 0{
                
                self.pageNo = 0
                self.currentDatas = temp
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.resetNoMoreData()
                
            }else{
                
                if temp.count > 0{
                    
                    self.pageNo = indexPage
                    self.currentDatas.append(contentsOf: temp)
                    self.tableView.mj_footer.endRefreshing()
                    
                }else{
                    
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                   
                }
            }
            
//            let realm = try! Realm()
//            try! realm.write {
//                realm.add(temp, update: true)
//            }
            
            self.tableView.reloadData()

            
        }) { (error) in
            
//            SVProgressHUD.dismiss()
//            let models = self.getWorkOrderFormDataDB(type: array[type], indexPage: 0)
//            self.currentDatas = models
//            self.tableView.mj_header.endRefreshing()
//            self.tableView.reloadData()

        }
    }
    
    
    // MARK: - 获取默认的项目的值来显示
    func getUserDefaultsProject() -> String {
        
        let dic = UserDefaults.standard.object(forKey: Const.YQProjectModel) as? [String : Any]
        
        var projectID  = ""
        
        if dic != nil {
            projectID = dic?["ID"] as! String
        }
        
        return projectID
        
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? WorkOrderScreeningViewController{
            vc.type = currentIndex
            vc.doneBtnClickHandel = { parmat in
                self.isFirstLoad = true
                self.getWorkOrder(type: self.currentIndex,indexPage: 0,dic: parmat)
                
            }
        }
    }
    
    
    
    func addRefirsh(){
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.getWorkOrder(type: self.currentIndex )
        })
        
        
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            
            self.getWorkOrder(type: self.currentIndex , indexPage: self.pageNo + 1)
        })
    }
    

}


extension WorkOrderViewController: UITableViewDataSource, UITableViewDelegate{
    
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
        vc.listVc = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
