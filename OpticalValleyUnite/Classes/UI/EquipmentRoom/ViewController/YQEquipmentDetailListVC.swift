//
//  YQEquipmentDetailListVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/2/27.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQEquipmentDetailListVC: UIViewController {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "设备房详情"
        
        
    }

    // MARK: - button点击的事件
    @IBAction func equipTypeClick(_ sender: UIButton) {
        
        
        
    }
    
    @IBAction func searchButtonClick(_ sender: UIButton) {
        
        
        
    }
    
    @IBAction func lookOutVideoClick(_ sender: UIButton) {
        
        //跳转到 视频相应的界面
        let video = YQWebVideoVC.init(nibName: "YQWebVideoVC", bundle: nil)
        navigationController?.pushViewController(video, animated: true)
        
    }
    
  
    
}
