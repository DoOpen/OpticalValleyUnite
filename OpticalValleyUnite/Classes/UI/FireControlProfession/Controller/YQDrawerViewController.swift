//
//  YQDrawerViewController.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/9/15.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit

class YQDrawerViewController: UIViewController {
    
    // MARK: - 各类属性的列表
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var joinNum: UIButton!

    @IBOutlet weak var fireNum: UIButton!
    
    @IBOutlet weak var falsePositerNum: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1.调用获取用户信息的接口
        
        
        //2.调用火警数量的接口
       
    }
    
    // MARK: - 各个按钮点击实现的方法
    /// 参与总单数详情
    @IBAction func joinTotallNum(_ sender: Any) {
        
        self.sendNoties(Notifaction: "join")
    }
    
    /// 火警单详情
    @IBAction func fireAlarm(_ sender: UITapGestureRecognizer) {
        
        self.sendNoties(Notifaction: "fireAlarm")
    }
   
    /// 误报单详情
    @IBAction func falsePositives(_ sender: UITapGestureRecognizer) {
        
        self.sendNoties(Notifaction: "falsePost")
        
    }
    
    /// 系统选择
    @IBAction func systemSelect(_ sender: UITapGestureRecognizer) {
        
        self.sendNoties(Notifaction: "system")
        
    }
    
    /// 修改密码
    @IBAction func pwdModify(_ sender: UITapGestureRecognizer) {
        
        self.sendNoties(Notifaction: "pwdModify")
        
    }
    
    /// 退出登录
    @IBAction func eixtLoyout(_ sender: UITapGestureRecognizer) {
        
       self.sendNoties(Notifaction: "eixt")
        
    }
    
    /// 发送通知的传参数的方法
    func sendNoties(Notifaction : String ){
        let center = NotificationCenter.default//创建通知
        
//        center.addObserver(self, selector: #selector(partsSelectionreceiveValue(info:)), name: NSNotification.Name(rawValue: "partsSelectionPassValue"), object: nil)//单个值得传递
//        
        let notiesName = NSNotification.Name(rawValue: "drawerDetailNoties")
        
        center.post(name: notiesName, object: nil, userInfo: ["notiesName": Notifaction])
    
    
    }
    
    

   
}
