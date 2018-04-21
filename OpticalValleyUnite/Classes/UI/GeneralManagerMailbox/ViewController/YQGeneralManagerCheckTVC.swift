//
//  YQGeneralManagerCheckTVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/4/14.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQGeneralManagerCheckTVC: UITableViewController {

    //用户的权限
    var UserRule :Int64 = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //1.init
        self.title = "反馈"
       
    }


    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        
        return 10
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        return UITableViewCell()
        
    }



}
