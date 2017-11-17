//
//  YQPedometerHistoryViewController.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/11/16.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit

class YQPedometerHistoryViewController: UIViewController {
    
    
    var dataArray : [YQHistoryStepModel]?{
        didSet{
            //整体的重绘
        
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1.获取历史的数据
        getHistoryStepData()

    }
    
    // MARK: - 获取历史的整体整体数据
    func getHistoryStepData(){
    
        //参数传递的是,只用传递token,直接的返回的是所有的历史的数据的数组
        HttpClient.instance.post(path: URLPath.getHistorysteps, parameters: nil, success: { (reponse) in
            
            
        }) { (error) in
            
            
        }
    
    }

}
