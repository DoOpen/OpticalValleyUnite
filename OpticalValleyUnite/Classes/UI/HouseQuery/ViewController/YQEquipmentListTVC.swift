//
//  YQEquipmentListTVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/2/19.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQEquipmentListTVC: UIViewController {
    
    var houseID : String?
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "设备清单"
        
        self.automaticallyAdjustsScrollViewInsets = false
        
    
        
    }

 
   
    
}

extension YQEquipmentListTVC : UITableViewDelegate,UITableViewDataSource{

    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 13
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        return UITableViewCell()
        
    }


}
