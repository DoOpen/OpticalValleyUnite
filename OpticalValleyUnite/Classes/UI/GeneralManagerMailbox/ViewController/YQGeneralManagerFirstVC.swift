//
//  YQGeneralManagerFirstVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/4/14.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQGeneralManagerFirstVC: UIViewController {

    @IBOutlet weak var baseScrollViewHeightConstast: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "总经理邮箱"
        self.baseScrollViewHeightConstast.constant = SJScreeH + 10
        
    }

    // MARK: - 查看反馈用户项的点击的操作
    @IBAction func lookOutButtonClick(_ sender: UIButton) {
        
        let checkVC = UIStoryboard.init(name: "YQGeneralManagerCheck", bundle: nil).instantiateInitialViewController()
        self.navigationController?.pushViewController(checkVC!, animated: true)
        
    }
    
    @IBAction func feedbackButtonClick(_ sender: UIButton) {
        
        //跳转加载 个人中心的反馈的界面
        let feedVC = UIStoryboard.init(name: "YQFeedBackVC", bundle: nil).instantiateInitialViewController()
        
        self.navigationController?.pushViewController(feedVC!, animated: true)
    
    }
    

   
}
