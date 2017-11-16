//
//  YQPedometerHistoryViewController.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/11/16.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit

class YQPedometerHistoryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - 获取历史的整体整体数据
    func getHistoryStepData(){
    
        HttpClient.instance.post(path: URLPath.getHistorysteps, parameters: nil, success: { (reponse) in
            
            
        }) { (error) in
            
            
        }
    
    }

}
