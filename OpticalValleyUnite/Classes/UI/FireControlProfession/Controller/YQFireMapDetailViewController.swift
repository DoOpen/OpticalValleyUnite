//
//  YQFireMapDetailViewController.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/9/21.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit


class YQFireMapDetailViewController: UIViewController {

    // MARK: - 视图属性
    // 传递的fireModel,监听set方法
    var fireModel  : YQFireLocationModel!{
        didSet{
        
        
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var locationMapView: MAMapView!
    
    
    // MARK: - 视图生命周期的方法
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
    // MARK: - 执行界面(implementView)系列buttonClick
    //立即反馈
    @IBAction func atOnceFeedBackClick(_ sender: Any) {
        
        //跳转到立即反馈的界面进行操作
        let feedBack = UIStoryboard.instantiateInitialViewController(name: "YQImplementFeedback") as! YQImplementFeedbackVC
        
        self.navigationController?.pushViewController(feedBack, animated: true)
        
    }
    
    //立即执行
    @IBAction func atOnceImplementClick(_ sender: Any) {
        
        
    }
    
    
    //放弃执行
    @IBAction func giveUpImplementClick(_ sender: Any) {
        
        
    }
  
    

}
