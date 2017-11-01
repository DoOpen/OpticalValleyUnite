//
//  YQDepartmentTableViewController.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/10/30.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit
import SVProgressHUD

class YQDepartmentTableViewController: UITableViewController {

    var filerModel : YQFilterParkModel?
    
    var dataList : [YQFilterDeptModel]?{
        didSet{
            
            self.deptTableView.reloadData()
        }
    }
    
    @IBOutlet var deptTableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        
    }
    
    func getDeptDataList(){
        
        var paramet = [String : Any]()
        paramet["parkId"] = filerModel?.parkId
        
        SVProgressHUD.show(withStatus: "数据加载中")
        
        HttpClient.instance.get(path: URLPath.getFilterDeptList, parameters: paramet, success: { (respones) in
            SVProgressHUD.dismiss()
            //字典转模型,数据显示
            let array = respones["deptList"] as! NSArray
            
            var dic = [YQFilterDeptModel]()
            
            for temp in array{
                
                dic.append(YQFilterDeptModel.init(dic: temp as! [String : Any]))
                
            }
            
            self.dataList = dic
            
        }) { (error) in
            
            SVProgressHUD.showError(withStatus: error.debugDescription)
        }

    
    
    }


    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.dataList?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //思路是:传递模型,界面跳转
        let objectVC = UIStoryboard.instantiateInitialViewController(name: "YQObject") as! YQObjectTableViewController
        
        objectVC.departmentModel = self.dataList?[indexPath.row]
        objectVC.filterModel = self.filerModel
        
        self.navigationController?.pushViewController(objectVC, animated: true)
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "department", for: indexPath)
        
        cell.textLabel?.numberOfLines = 0
        
        let model = self.dataList?[indexPath.row]
        
        cell.textLabel?.text = model?.name
        
        return cell
        
    }
    
}
