//
//  YQGeneralManagerFirstVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/4/14.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit
import SVProgressHUD

class YQGeneralManagerFirstVC: UIViewController {

    @IBOutlet weak var baseScrollViewHeightConstast: NSLayoutConstraint!
    @IBOutlet weak var checkOutView: UIView!
    @IBOutlet weak var checkOutViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var feedBackView: UIView!
    
    
    //用户的权限
    var UserRule :Int64 = 2
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.title = "总经理邮箱"
        self.baseScrollViewHeightConstast.constant = SJScreeH - 54
        
        getGeneralRuleForService()
        
        
    }
    
    // MARK: - 获取角色权限的问题
    func getGeneralRuleForService(){
        
        SVProgressHUD.show()
        
        HttpClient.instance.post(path: URLPath.getgm_emailRule
            , parameters: nil, success: { (response) in
                
                SVProgressHUD.dismiss()
                
                let ruleNum = response["role"] as? Int64 ?? 2
                
                if (ruleNum == 3){//其他只有反馈功能
                    
                    self.checkOutView.isHidden = true
                    self.checkOutViewHeight.constant = 1
                    
                }else{//经理和总经理 只有查看权限
                    self.feedBackView.isHidden = true
                    
                }
                
                self.UserRule = ruleNum

        }) { (error) in

            SVProgressHUD.showError(withStatus: "获取网络数据失败,请检查网络!")
        }
        
    }
    

    // MARK: - 查看反馈用户项的点击的操作
    @IBAction func lookOutButtonClick(_ sender: UIButton) {
        
        let checkVC = UIStoryboard.init(name: "YQGeneralManagerCheck", bundle: nil).instantiateInitialViewController() as! YQGeneralManagerCheckTVC
        
        checkVC.UserRule = self.UserRule
        self.navigationController?.pushViewController(checkVC, animated: true)
        
    }
    
    @IBAction func feedbackButtonClick(_ sender: UIButton) {
        
        //跳转加载 个人中心的反馈的界面
        let feedVC = UIStoryboard.init(name: "YQFeedBackVC", bundle: nil).instantiateInitialViewController() as! YQFeedBackViewController
        
        feedVC.UserRule = self.UserRule
        
        self.navigationController?.pushViewController(feedVC, animated: true)
    
    }
    

   
}
