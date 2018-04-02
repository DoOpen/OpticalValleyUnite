//
//  YQMyFeedListTVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/4/2.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQMyFeedListTVC: UITableViewController {

    var cellID = "feedBackCell"
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "我的反馈"
        
        
    }


    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)


        return cell
    }
 


}
