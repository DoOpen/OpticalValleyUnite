//
//  YQWorkRecordViewController.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/10/16.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit
import SVProgressHUD

class YQWorkRecordViewController: UIViewController {
    
    // MARK: - 属性列表
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    var workRecord = "workRecord"
    
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
        let nib = UINib.init(nibName: "YQWorkRecord", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: workRecord)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var dic = [String : Any]()
        dic["worklogId"] = ""
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
        
        
        //        let dic = ["待派发": 11,"待执行" : 22, "待评价": 31,"待接收": 21,"已处理": 7, "已接受": 5,"协助查看": 5]
        //        let  string  = currentStatusBtn?.titleLabel?.text
        
        /*
         工单类型 :  2 - 应急工单  1 - 计划工单
         */
        //        parmat["WORKUNIT_TYPE"] = currentStatusBtn?.tag
        
        //添加默认的选择项目 筛选条件
        
        
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

}
