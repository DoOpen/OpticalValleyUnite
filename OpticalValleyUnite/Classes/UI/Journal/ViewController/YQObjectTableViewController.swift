//
//  YQObjectTableViewController.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/10/30.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit

class YQObjectTableViewController: UITableViewController {

    var departmentModel : Any?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //添加rightbar的完成按钮
        let button = UIButton()
        button.frame = CGRect(x:0,y:0,width:40,height:40)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.setTitle("完成", for: .normal)
        button.addTarget(self, action: #selector(compeletedButtonClick), for: .touchUpInside)
        
        let rightBar = UIBarButtonItem()
        rightBar.customView = button
        self.navigationItem.rightBarButtonItem = rightBar
        
    }
    
    // MARK: - 完成按钮的点击实现
    func compeletedButtonClick() {
        //读取选择的数据
        
        //跳转到根控制器来执行
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    
    // MARK: - tableView 的代理方法和数据源方法
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 30
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "object", for: indexPath)
        cell.textLabel?.text = "对象的模拟数据 " + "\(indexPath.row)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //选择相应行号对应的数据 添加选择数据
        
        
    }
    

}
