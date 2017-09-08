//
//  WorkOrderViewController.swift
//    OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/1/10.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh
import RealmSwift

class WorkOrderViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var didProcessedBtn: UIButton!
    @IBOutlet weak var waitProcessedBtn: UIButton!
    @IBOutlet weak var didCloseBtn: UIButton!
    var siftVc: WorkOrderSiftViewController?
    var siftParmat: [String: Any]?
    var isFirstLoad = true
    var currentDatas = [WorkOrderModel2]()

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
        statusBtnClick(waitProcessedBtn)
        addRefirsh()
//        getWorkOrder(type: currentIndex,indexPage: 0)
        
        let nib = UINib(nibName: "WorkOrder2Cell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
    }
    
    
    @IBAction func rightBtnClick(_ sender: UIBarButtonItem) {
        
        let vc = WorkOrderSiftViewController.loadFromStoryboard(name: "WorkOrder") as! WorkOrderSiftViewController
        vc.status =  ["DCL", "YCL","YGB"][currentIndex]
//        self.addChildViewController(vc)
        siftVc = vc
//        vc.didMove(toParentViewController: self)
        let subView = vc.view
        subView?.frame = CGRect(x: 100, y: 0, width: SJScreeW - 100, height: SJScreeH)
        CoverView.show(view: subView!)
        
        vc.doenBtnClickHandel = { parmat in
            self.isFirstLoad = true
            
            if parmat.isEmpty{
                self.siftParmat = parmat
            }else{
                self.siftParmat = nil
            }
            
            self.getWorkOrder(type: self.currentIndex,indexPage: 0,dic: parmat)
            self.siftParmat = parmat
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
        var array = ["DCL", "YCL", "YGB"];
        
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
        parmat["STATUS"] = array[type]
        
        SVProgressHUD.show(withStatus: "加载中...")
        
        HttpClient.instance.get(path: URLPath.getWorkunitList, parameters: parmat, success: { (response) in
            
            SVProgressHUD.dismiss()
            
            var temp = [WorkOrderModel2]()
            for dic in response["data"] as! Array<[String: Any]> {
                let model = WorkOrderModel2(parmart: dic)
                model.type = array[type]
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
//            SVProgressHUD.dismiss()
//            let models = self.getWorkOrderFormDataDB(type: array[type], indexPage: 0)
//            self.currentDatas = models
//            self.tableView.mj_header.endRefreshing()
//            self.tableView.reloadData()

        }
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
