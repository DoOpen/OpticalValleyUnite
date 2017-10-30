//
//  YQFilterJournalViewController.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/10/13.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit

class YQFilterJournalViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.title = "选择项目"
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        
    }

}

extension YQFilterJournalViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "filterJournal", for: indexPath)
        
        cell.textLabel?.text = "模拟数据" + "\(indexPath.row)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //传递模型,跳转到(项目 -->  部门 --> 对象)
        let department = UIStoryboard.instantiateInitialViewController(name: "YQFilterDepartment") as? YQDepartmentTableViewController
        department?.filerModel = indexPath.row
        
        self.navigationController?.pushViewController(department!, animated: true)
        
    }

}
