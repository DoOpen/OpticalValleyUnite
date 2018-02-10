//
//  YQHouseLocationScreenView.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/2/9.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQHouseLocationScreenView: UIView {

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func checkoutButtonClick(_ sender: UIButton) {
        
        
    }
    
}

extension YQHouseLocationScreenView : UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
    
}
