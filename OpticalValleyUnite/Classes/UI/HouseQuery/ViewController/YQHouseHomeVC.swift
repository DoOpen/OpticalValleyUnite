//
//  YQHouseHomeVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/2/9.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit
import MJRefresh
import SVProgressHUD

class YQHouseHomeVC: UIViewController {

    var currentIndex = -1
    
    var dataArray = [YQHouseQueryHomeModel](){
        
        didSet {
            
            self.tableView.reloadData()
        }
        
    }
    
    var cellID = "houseHomeCell"
    
    var notiesPramert : [String : Any]?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "房屋查询"
        self.automaticallyAdjustsScrollViewInsets = false

        //1.添加左右bar
        addRightBarButtonItem()
        
        //2.上拉下拉
        addRefirsh()
        
        //3.获取list数据
        getDataForList()
        
        //4.接受通知的方法
        getNotes()
    
    }

 
    // MARK: - 添加rightBarbutton选项
    func addRightBarButtonItem(){
        
        let button = UIButton()
        button.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        button.setTitle("查询", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.sizeToFit()
        button.addTarget(self, action: #selector(screenToHouseVC), for: .touchUpInside)
        
        let barItem = UIBarButtonItem()
        barItem.customView = button
        
        navigationItem.rightBarButtonItem = barItem
        
    }
    
    // MARK: - 筛选界面的跳转执行
    func screenToHouseVC(){
        
        let screenHouse = YQHouseScreenVC.init(nibName: "YQHouseScreenVC", bundle: nil)
        navigationController?.pushViewController(screenHouse, animated: true)
        
    }
    
    // MARK: - 获取list的数据的接口
    func getDataForList(pageIndex : Int = 0,pageSize : Int = 20 ,par : [String : Any] = [String : Any]()){

        var parmeter = [String : Any]()
        parmeter["pageSize"] = pageSize
        parmeter["pageIndex"] = pageIndex
        
        for (key,value) in par {
            
            parmeter[key] = value
        }
        
        SVProgressHUD.show()
        
        HttpClient.instance.post(path: URLPath.getHouseList, parameters: parmeter, success: { (reponse) in
            
            SVProgressHUD.dismiss()
            
            let data = reponse["data"] as? Array<[String : Any]>
            
            var tempModel = [YQHouseQueryHomeModel]()
            
            for dict in data! {
            
                tempModel.append(YQHouseQueryHomeModel.init(dict: dict))
            }
            
            //添加上拉下拉刷新的情况
            if pageIndex == 0 {
                
                if reponse["data"] as? NSArray == nil {
                    
                    self.dataArray.removeAll()
                    self.tableView.mj_header.endRefreshing()
                    self.tableView.mj_footer.endRefreshing()
                    
                    return
                }
                
                self.dataArray = tempModel
                self.tableView.mj_header.endRefreshing()
                
            }else{
                
                if tempModel.count > 0{
                    
                    self.currentIndex = pageIndex
                    
                    self.dataArray.append(contentsOf: tempModel)
                    
                }
                
                self.tableView.mj_footer.endRefreshing()
                
            }

            
        }) { (error) in
            
            SVProgressHUD.showError(withStatus: error.description)
        }
        
    
    }
    
    
    // MARK: - 上下拉的刷新的界面情况
    func addRefirsh(){
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            
            var par = [String : Any]()
            
            if self.notiesPramert != nil{
                
                for (key,value) in self.notiesPramert! {
                    par[key] = value
                }
            }
            
            self.getDataForList( par: par)
            
        })
        
        
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            
            var par = [String : Any]()
            if self.notiesPramert != nil{
                
                for (key,value) in self.notiesPramert! {
                    
                    par[key] = value
                }
            }

            self.getDataForList( pageIndex: self.currentIndex + 1,par: par)
            
        })
        
    }
    
    // MARK: - 接受通知的方法
    func getNotes(){
    
        let center = NotificationCenter.default
        let notiesName = NSNotification.Name(rawValue: "screenConditionNoties")
        center.addObserver(self, selector: #selector(screenToData(info :)), name: notiesName, object: nil)
        
    }
    
    func screenToData(info : NSNotification){
        
        let dict = info.userInfo as! [String : Any]
        let stage = dict["stage"] as? YQDecorationStageModel
        let floor = dict["floor"] as? YQDecorationFloorModel
        let unitNo = dict["unitNo"] as? YQDecorationUnitNoModel
        let groupNo = dict["groupNo"] as? YQDecorationGroundNoModel
        let house = dict["house"] as? YQDecorationHouseModel
        
        var par = [String : Any]()
        par["stageId"] = stage?.stageId
        par["floorId"] = floor?.floorId
        par["unitNu"] = unitNo?.unitNu
        par["groundNo"] = groupNo?.groundNo
        par["houseId"] = house?.houseId
        
        self.notiesPramert = par
        
        self.getDataForList( par: par)

    }
    
    deinit {
        
       NotificationCenter.default.removeObserver(self)
        
    }

}

extension YQHouseHomeVC : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? YQHouseHomeCell
        
        cell?.model = self.dataArray[indexPath.row]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let model = self.dataArray[indexPath.row]
        
        if model.ownerIds != "" {
            
            return 200
            
        }else{
            
            return 60
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //界面的跳转到 业主信息的详情
        let houseDetail = UIStoryboard.instantiateInitialViewController(name: "YQHouseHomeDetail") as! YQHouseHomeDetailVC
        houseDetail.houseModel = self.dataArray[indexPath.row]
        navigationController?.pushViewController(houseDetail, animated: true)
        
    }
    
    
}
