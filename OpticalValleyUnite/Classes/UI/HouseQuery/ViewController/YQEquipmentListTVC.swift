//
//  YQEquipmentListTVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/2/19.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh

class YQEquipmentListTVC: UIViewController {
    
    var houseID : String?
    
    @IBOutlet weak var tableView: UITableView!
    
    var cellID = "EquipmentListCell"
    
    var dataArray = [YQEquipmentListModel](){
        didSet{
        
            self.tableView.reloadData()
        }
    
    }
    
    var currentIndex = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "设备清单"
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        let nib = UINib.init(nibName: "YQEquipmentListCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: cellID)
        
        getData()
        
        //上拉,下拉刷新
        addRefirsh()

        
    }
    
    func getData(pageIndex : Int = 0 , pageSize : Int = 20){
        
        var par = [String : Any]()
        par["houseId"] = self.houseID
        par["pageIndex"] = pageIndex
        par["pageSize"] = 20
        
        HttpClient.instance.post(path: URLPath.getEquipList, parameters: par, success: { (response) in
            
            let data = response["data"] as? Array<[String : Any]>
            
            var tempData = [YQEquipmentListModel]()
            
            if data == nil {
                
                SVProgressHUD.showError(withStatus: "没有更多数据")
                self.dataArray.removeAll()
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.endRefreshing()

                return
            }

            for dict in data! {
                
                tempData.append(YQEquipmentListModel.init(dict: dict))
                
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

    // MARK: - 上下拉的刷新的界面情况
    func addRefirsh(){
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            
            self.getData()
            
        })
        
        
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            
            self.getData(pageIndex: self.currentIndex + 1)
          
        })
        
    }

   
    
}

extension YQEquipmentListTVC : UITableViewDelegate,UITableViewDataSource{

    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArray.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! YQEquipmentListCell
        
        cell.model = self.dataArray[indexPath.row]
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 180
    }


}
