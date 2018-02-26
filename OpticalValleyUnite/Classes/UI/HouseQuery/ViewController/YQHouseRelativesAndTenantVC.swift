//
//  YQHouseRelativesAndTenantVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/2/19.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQHouseRelativesAndTenantVC: UIViewController {
    
    @IBOutlet weak var relativesButton: UIButton!
    
    @IBOutlet weak var tenantButton: UIButton!
    var currentSelectButton : UIButton?
    
    //houseID
    var houseID : String?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.title = "业主亲属&租户"
        

    }

    // MARK: - 选择的按钮的点击事件
    @IBAction func selectButtonClick(_ sender: UIButton) {
        
        currentSelectButton?.isSelected = false
        sender.isSelected = true
        currentSelectButton = sender
        //调取的是网络数据接口(传递的是 对应的tag值的情况)
        
        
        
    }
    
    

 
}
