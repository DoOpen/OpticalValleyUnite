//
//  YQEquipmentFristVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/2/27.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQEquipmentFristVC: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "设备房"

    }

    @IBAction func equipmentListButtonClick(_ sender: UIButton) {
        
        let list = UIStoryboard.instantiateInitialViewController(name: "YQEquipmentList")
        
        self.navigationController?.pushViewController(list, animated: true)
    }

    @IBAction func equipmentWorkOrderClick(_ sender: UIButton) {
        
        let workOrder = UIStoryboard.instantiateInitialViewController(name: "YQEquipmentWO")
        
        self.navigationController?.pushViewController(workOrder, animated: true)
        
    }

}
