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
        
        
        //注册原型cell
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        let nib = UINib.init(nibName: "YQWorkRecord", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: workRecord)
        
        //添加刷新
        addRefirsh()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        dic["worklogId"] = self.workLogID
        // 工作记录 传递 自发工单
        dic["self"] = "1"
        
        getWorkOrder(dic: dic)
        
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
        
        //传参调接口
        
        //控制器的释放
        self.navigationController?.popViewController(animated: true)
    
    }
    

}

extension YQWorkRecordViewController: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.currentDatas.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: workRecord, for: indexPath) as! YQWorkRecordTableViewCell
        
        cell.model = self.currentDatas[indexPath.row]
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
    }
    
}
