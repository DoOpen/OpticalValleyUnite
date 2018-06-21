//
//  YQPublicExaminationTVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/6/21.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQPublicExaminationTVC: UITableViewController {
    
    var cellType = -1
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
       
    }


    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 20
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        return cell
    }
 

    
    
}
