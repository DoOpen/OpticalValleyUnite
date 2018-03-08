//
//  YQWorkRecordViewController.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/10/16.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh

class YQWorkRecordViewController: UIViewController {
    
    // MARK: - 属性列表
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    var workRecord = "workRecord"
    
    //日志ID
    var workLogID = ""
    
    //工单IDstring 列表
    var workunitIds = ""
    
    //是否是添加事项
    var isAddWorkLog : Bool? = false
    
    //项目id
    var parkID : String = ""
    
    
//    var currentData : [WorkOrderModel2]?{
//        
//        didSet{
//            
//            self.tableView.reloadData()
//        }
//    }
    
    var currentDatas = [WorkOrderModel2]()
    
    var currentIndex = 0{
        didSet{
            pageNo = 0
            //            getWorkOrder(type:currentIndex, indexPage: pageNo)
        }
    }
    
    var pageNo = 0

    var dic = [String : Any]()
    
    var currentSelecIndex : IndexPath?
    
    // MARK: - swift懒加载方法
    lazy var heightDic = {
        () -> NSMutableDictionary
        
        in
        
        return NSMutableDictionary()
    }()

    
    // MARK: - 视图生命周期方法
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //设置 
        self.title = "工作记录"
        
        let rightB = UIButton()
        rightB.frame = CGRect(x:0,y:0,width:40,height:40)
        rightB.setTitle("完成", for: .normal)
        rightB.setTitleColor(UIColor.blue, for: .normal)
        rightB.addTarget(self, action: #selector(completeButtonClick), for: .touchUpInside)
        
        let rightbar = UIBarButtonItem()
        rightbar.customView = rightB
        
        self.navigationItem.rightBarButtonItem = rightbar
        
        
        //注册原型cell,提前注册cell的话,不能动态加载预估行高
//        self.tableView.rowHeight = UITableViewAutomaticDimension;
//        let nib = UINib.init(nibName: "YQWorkRecord", bundle: nil)
//        self.tableView.register(nib, forCellReuseIdentifier: workRecord)
        
        //添加刷新
        addRefirsh()
        
        //获取数据list
        
        dic["worklogId"] = self.workLogID
        // 工作记录 传递 自发工单
        dic["self"] = "1"
        
        getWorkOrder(dic: dic)

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        
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
        parmat["PARK_ID"] = self.parkID
        parmat["pageSize"] = 20
        
        
        for (key,value) in dic{
            parmat[key] = value
        }
        
        //添加默认的选择项目 筛选条件
        SVProgressHUD.show(withStatus: "加载中...")
        
        HttpClient.instance.get(path: URLPath.getWorkunitList2, parameters: parmat, success: { (response) in
            
            SVProgressHUD.dismiss()
            
            var temp = [WorkOrderModel2]()
            
            for dic in response["data"] as! Array<[String: Any]> {
                
                let model = WorkOrderModel2(parmart: dic)
                let workunitIds = model.id
                
                
                if self.workunitIds != ""{
                    
                    
                    if self.workunitIds.contains(workunitIds) {
                        //更改设置模型的属性的情况
                        model.selected = true
                    }
                    
                }
                
                
                if self.isAddWorkLog! {
                    
                    model.selected = true
                    
                }else{
                    
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem()
                    
                }
                
                temp.append(model)
                
            }
            
            if indexPage == 0{
                
                self.pageNo = 0
                self.currentDatas = temp
                self.tableView.mj_header.endRefreshing()
                
            }else{
                
                if temp.count > 0{
                    
                    self.pageNo = indexPage
                    self.currentDatas.append(contentsOf: temp)
                    self.tableView.mj_footer.endRefreshing()
                    
                }else{
                    
                    self.tableView.mj_footer.endRefreshing()
                }
            }
            
            self.tableView.reloadData()
            
            
        }) { (error) in
            
            SVProgressHUD.showError(withStatus: "数据加载失败,请重试!")
        }
        
    }
    
    // MARK: - 上下拉刷新
    func addRefirsh(){
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            
            self.getWorkOrder(type: self.currentIndex ,dic : self.dic)
        })
        
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            
            self.getWorkOrder(type: self.currentIndex , indexPage: self.pageNo + 1, dic : self.dic)
        })
    }


    
    // MARK: - 完成按钮的点击
    func completeButtonClick(){
        //获取调用
        let strID = self.getAllWorkunitIdsFunction()
        
        //控制器的释放
        self.navigationController?.popViewController(animated: true)
    
        //传参调接口,发送通知到super
        let center = NotificationCenter.default
        let name = NSNotification.Name(rawValue: "workRecordToSuper")
        center.post(name: name, object: nil, userInfo: ["YQWorkRecordTo" : strID ])
    }
    
    // MARK: - 获取调用所有的workunitIds
    func getAllWorkunitIdsFunction() -> String{
        
        if self.currentDatas.count < 1 {
            
            return ""
        }
        
        var selectCurrentDatas = [WorkOrderModel2]()
        
        for select in self.currentDatas{
            
            if select.selected {
                
                selectCurrentDatas.append(select)
            }

        }
        
        
        var str = ""
        
        
        for team in 0 ..< selectCurrentDatas.count{
            
            let model = selectCurrentDatas[team]
            
            if team == 0 {
                
                str = model.workOrderId
            }else{
            
                str = str + "," + model.workOrderId
            }
        
        }
        
        
        
        return str
    }

}


extension YQWorkRecordViewController: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.currentDatas.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: workRecord) as? YQWorkRecordTableViewCell
        
        if cell == nil {
            
            cell = Bundle.main.loadNibNamed("YQWorkRecord", owner: nil, options: nil)?[0] as? YQWorkRecordTableViewCell
        }
        
        cell?.model = self.currentDatas[indexPath.row]
        
        cell?.layoutIfNeeded()
        
        //添加行高 缓存
        if  heightDic["\(indexPath.row)"] != nil {
            
            return cell!
        }
        
        heightDic["\(indexPath.row)"] = cell?.cellForHeight()
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if isAddWorkLog! {
            
            //直接编辑模型 设置数据
            let model = self.currentDatas[indexPath.row]
            
            model.selected = !model.selected
            //tableV 重刷数据
            self.tableView.reloadRows(at: [indexPath], with: .none)
            
            self.currentDatas.replaceSubrange((indexPath.row)...(indexPath.row), with: [model])

        }
        
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
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        let height = heightDic["\(indexPath.row)"] as! CGFloat
        
        return height
    }
    
}

extension YQWorkRecordViewController : UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let text = searchBar.text{
            //模糊查询的方法
            print(text)
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.view.endEditing(true)
        
        searchBar.text = nil
        
    }

    
}
