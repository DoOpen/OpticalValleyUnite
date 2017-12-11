//
//  YQPatrolResultViewController.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/12/9.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit

class YQPatrolResultViewController: UIViewController {
    ///属性列表
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    /// 模型数组
    var dataArray = [YQResultCellModel](){
        
        didSet{
            
            self.tableView.reloadData()
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //1.获取数据
        
        
    }
    
    
    func makeUpData() {
        
        
        
    }

    
    // MARK: - 巡查轨迹ButtonItem的点击事件
    @IBAction func patrolResultClick(_ sender: UIBarButtonItem) {
        
        
        
    }
    
    

}

extension YQPatrolResultViewController : UITableViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }

}
