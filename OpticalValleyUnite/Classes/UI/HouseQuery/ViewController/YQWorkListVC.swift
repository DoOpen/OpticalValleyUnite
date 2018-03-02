//
//  YQWorkListVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/2/19.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh

class YQWorkListVC: UIViewController {

    
    var houseID : String?
    
    var parkID : String?
    
    @IBOutlet weak var reportBtn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    var currentSelecte : UIButton?
    
    var dataArray = [YQWorkListModel](){
        
        didSet{
            
            self.tableView.reloadData()
        }
    
    }
    
    var cellID = "WorkListCell"
    
    var currentIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "工单列表"
        
        //注册cell
        let nib = UINib.init(nibName: "YQWorkListCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: cellID)
        
        //默认选择的是 第一个报事的类型
        self.reportBtn.isSelected = true
        currentSelecte = self.reportBtn
        getData(tag: (currentSelecte?.tag)!)
        
        
        //上拉,下拉刷新
        addRefirsh()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let _ = setUpProjectNameLable()
        
    }
    
    @IBAction func selecteButtonClick(_ sender: UIButton) {
        
        self.currentSelecte?.isSelected = false
        sender.isSelected = true
        self.currentSelecte = sender
        
        self.dataArray.removeAll()
        //刷新数据
        getData(tag: sender.tag)
        
    }
    
    func getData(pageIndex : Int = 0, pageSize : Int = 20, tag : Int){
        
        var par = [String : Any]()
        
        par["parkId"] = self.parkID
        
        if self.parkID == "" {
            
            let project = UIStoryboard.instantiateInitialViewController(name: "YQAllProjectSelect")
            self.navigationController?.pushViewController(project, animated: true)
            return
            
        }
            
        par["pageIndex"] = pageIndex
        par["pageSize"] = pageSize
            
        par["houseId"] = self.houseID
        par["type"] = tag
        
        SVProgressHUD.show()
        
        HttpClient.instance.post(path: URLPath.getSourchUnit, parameters: par, success: { (response) in
            
            SVProgressHUD.dismiss()
            
            let data = response["data"] as? Array<[String : Any]>
            
            if data == nil {
                
                SVProgressHUD.showError(withStatus: "没有更多数据!")
                self.dataArray.removeAll()
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.endRefreshing()
                return
            }
            //字典转模型的操作
            var tempData = [YQWorkListModel]()
            
            for dict in data! {
            
                tempData.append(YQWorkListModel.init(dict: dict))
            }
            
            
            //添加上拉下拉刷新的情况
            if pageIndex == 0 {
                
                self.dataArray = tempData
                self.tableView.mj_header.endRefreshing()
                
            }else{
                
                if tempData.count > 0{
                    
                    self.currentIndex = pageIndex
                    
                    self.dataArray.append(contentsOf: tempData)
                    
                }
                
                self.tableView.mj_footer.endRefreshing()
                
            }

            
            
        }) { (error) in
            
             SVProgressHUD.showError(withStatus: "数据查询失败,请检查网络!")
        }
    
    }
    
    // MARK: - 添加默认的项目选择方法
    func setUpProjectNameLable() -> String{
        
        let dic = UserDefaults.standard.object(forKey: Const.YQProjectModel) as? [String : Any]
        
        var projectName  = ""
        
        if dic != nil {
            
            projectName = dic?["PARK_NAME"] as! String
            self.parkID = dic?["ID"] as? String
            
        }else{
            
            projectName = "请选择默认项目"
        }
        
        return projectName
    }

    
    // MARK: - 上下拉的刷新的界面情况
    func addRefirsh(){
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            
            self.getData(tag: (self.currentSelecte?.tag)!)
        })
        
        
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            
            self.getData(pageIndex: self.currentIndex + 1,  tag: (self.currentSelecte?.tag)!)
        })
        
    }

    
}

extension YQWorkListVC : UITableViewDelegate,UITableViewDataSource{
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! YQWorkListCell
        
        cell.model = self.dataArray[indexPath.row]
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 120
    }

    
}
