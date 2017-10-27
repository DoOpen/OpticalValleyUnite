//
//  YQWorkRecordViewController.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/10/16.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit

class YQWorkRecordViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //设置 
        self.title = "工作记录"
        
        let rightB = UIButton()
        rightB.frame = CGRect(x:0,y:0,width:40,height:40)
        rightB.setTitle("完成", for: .normal)
        rightB.setTitleColor(UIColor.blue, for: .normal)
        
        let rightbar = UIBarButtonItem()
        rightbar.customView = rightB
        
        self.navigationItem.rightBarButtonItem = rightbar
        
        
    }

    
    

}
