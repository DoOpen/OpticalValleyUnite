//
//  YQEquipmentListTVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/2/19.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit
import SVProgressHUD

class YQEquipmentListTVC: UIViewController {
    
    var houseID : String?
    
    @IBOutlet weak var tableView: UITableView!
    
    var cellID = "EquipmentListCell"
    
    var dataArray = [YQEquipmentListModel]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "设备清单"
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        let nib = UINib.init(nibName: "YQEquipmentListCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: cellID)
        
        getData()
        
        
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
                return
            }

            for dict in data! {
                
                tempData.append(YQEquipmentListModel.init(dict: dict))
                
            }
            
            self.dataArray = tempData
            self.tableView.reloadData()
            
            
        }) { (error) in
            
             SVProgressHUD.showError(withStatus: "数据查询失败,请检查网络!")
        }
    
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
        
        return 80
    }


}
