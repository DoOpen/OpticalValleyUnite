//
//  YQDepartmentTableViewController.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/10/30.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit

class YQDepartmentTableViewController: UITableViewController {

    var filerModel : Any?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        
    }


    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 30
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //思路是:传递模型,界面跳转
        let objectVC = UIStoryboard.instantiateInitialViewController(name: "YQObject") as! YQObjectTableViewController
        objectVC.departmentModel = indexPath.row
        
        self.navigationController?.pushViewController(objectVC, animated: true)
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "department", for: indexPath)
        cell.textLabel?.text = "部门模拟数据" + "\(indexPath.row)"
        
        return cell
        
    }
    
}
