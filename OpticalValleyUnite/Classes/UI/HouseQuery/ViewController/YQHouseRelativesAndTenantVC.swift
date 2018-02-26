//
//  YQHouseRelativesAndTenantVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/2/19.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit
import SVProgressHUD


class YQHouseRelativesAndTenantVC: UIViewController {
    
    @IBOutlet weak var relativesButton: UIButton!
    
    @IBOutlet weak var tenantButton: UIButton!
    var currentSelectButton : UIButton?
    
    //houseID
    var houseID : String?
    
    var dataAarry = [YQHouseRelativeModel]()
    
    var currentIndex = 0
    
    var cellID = "tenantCell"
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.title = "业主亲属&租户"
        self.relativesButton.isSelected = true
        
        currentSelectButton = self.relativesButton
        
        //注册原型cell
        let nib = UINib.init(nibName: "YQOwnerAndTenantCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: cellID)
        
        getData(tag: (currentSelectButton?.tag)!)
        
    }

    // MARK: - 选择的按钮的点击事件
    @IBAction func selectButtonClick(_ sender: UIButton) {
        
        currentSelectButton?.isSelected = false
        sender.isSelected = true
        currentSelectButton = sender
        //调取的是网络数据接口(传递的是 对应的tag值的情况)
        getData(tag: (currentSelectButton?.tag)!)
        
    }
    
    
    func getData(pageIndex : Int = 0,pageSize : Int = 20,tag : Int){
        
        var parameter = [String : Any]()
        
        parameter["pageIndex"] = pageIndex
        parameter["pageSize"] = pageSize
        parameter["type"] = tag
        parameter["houseId"] = self.houseID
        
        SVProgressHUD.show()
        
        HttpClient.instance.post(path: URLPath.getRelativeList, parameters: parameter, success: { (response) in
            
            SVProgressHUD.dismiss()
            
            let data = response["data"] as? Array<[String : Any]>
            var tempData = [YQHouseRelativeModel]()
            if data == nil {
                
                SVProgressHUD.showError(withStatus: "没有更多数据")
                return
            }
            
            for dict in data! {
            
                tempData.append(YQHouseRelativeModel.init(dict: dict))
            
            }
            
            self.dataAarry = tempData
            self.tableView.reloadData()
            
            
        }) { (error) in
            
            SVProgressHUD.showError(withStatus: "数据查询失败,请检查网络!")
        }
    }
    
    

 
}

extension YQHouseRelativesAndTenantVC : UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataAarry.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as!
        YQOwnerAndTenantCell
        
        cell.model = self.dataAarry[indexPath.row]
        
        return cell
    }
    
    
}
