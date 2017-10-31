//
//  YQWorkRecordViewController.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/10/16.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit

class YQWorkRecordViewController: UIViewController {
    
    // MARK: - 属性列表
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    var workRecord = "workRecord"
    
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
    
    // MARK: - 完成按钮的点击
    func completeButtonClick(){
        
        //传参调接口
        
        //控制器的释放
        self.navigationController?.popViewController(animated: true)
    
    }
    

}

extension YQWorkRecordViewController: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: workRecord, for: indexPath) as! YQWorkRecordTableViewCell
        
        cell.model = ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}
