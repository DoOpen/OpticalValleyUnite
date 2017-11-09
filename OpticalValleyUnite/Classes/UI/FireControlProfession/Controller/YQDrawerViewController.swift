//
//  YQDrawerViewController.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/9/15.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class YQDrawerViewController: UIViewController {
    
    // MARK: - 各类属性的列表
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var joinNum: UIButton!

    @IBOutlet weak var fireNum: UIButton!
    
    @IBOutlet weak var falsePositerNum: UIButton!
    
//    var amountArray : NSArray = {NSArray()}()
    
    
    @IBOutlet weak var contentScrollView: UIScrollView!
    
    @IBOutlet weak var lastView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1.调用获取用户信息的接口
        let user = User.currentUser()
        if let user = user{
            userName.text = user.userName!
    
            if let url = user.avatar,url != ""{
                
                if url.contains("http"){
                
                    userImageView.kf.setImage(with: URL(string: url))

                }else{
                
                    let basicPath = URLPath.basicPath
                    let imageValue = basicPath.replacingOccurrences(of: "/api/", with: "") + url
                    
                    userImageView.kf.setImage(with: URL(string: imageValue))
                
                }
                
            }
        }
        
        //2.调用火警数量的接口
        requestData()
        
        //3.设置可以滚动(验证调试失败)
        let point = CGPoint( x: 0, y: self.lastView.bounds.origin.y + 800)
        self.contentScrollView.contentSize = CGSize(width: self.view.bounds.width, height: point.y)
       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
    }
    
    // MARK: - 懒加载方法
    lazy var amountArray:[String : Any] = {
        () ->[String : Any]
        in
    
        return["total" : self.joinNum, "firetotal" : self.fireNum,  "misinfoTotal" : self.falsePositerNum]
    
    }()
    
    
    // MARK: - 各个按钮点击实现的方法
    /// 参与总单数详情
    @IBAction func joinTotallNum(_ sender: Any) {
        
        self.sendNoties(Notifaction: "join")
    }
    
    /// 火警单详情
    @IBAction func fireAlarm(_ sender: UITapGestureRecognizer) {
        
        self.sendNoties(Notifaction: "fireAlarm")
    }
    
    /// 签到按钮执行的详情
    @IBAction func SignTapClick(_ sender: Any) {
        
      self.sendNoties(Notifaction: "signTap")
        
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
    
    @IBAction func personalProfileButtonClick(_ sender: Any) {
        
        self.sendNoties(Notifaction: "personalProfile")
        
    }
    
    func requestData(){
        
        var parameters = [String : Any]()
        
        let token = UserDefaults.standard.object(forKey: Const.SJToken)
        parameters["token"] = token
        
//        let url = NSURL(string : "http://192.168.0.18:8080/ovu-pcos/api/fire/workunit/amount.do")!
        SVProgressHUD.show(withStatus: "加载中...")
        
        Alamofire.request(URLPath.basicPath + URLPath.getFireAmount , method: .post, parameters: parameters).responseJSON { (response) in
            SVProgressHUD.dismiss()
            
            switch response.result {
                
            case .success(_):
                
                if let value = response.result.value as? [String: Any] {
                    
                    guard value["CODE"] as! String == "0" else{
                        let message = value["MSG"] as! String
                        
                        self.alert(message: message)
                        return
                    }
                    
                    
                    if let data = value["data"] as? NSDictionary{
                        
                        let array = data["amount"] as! NSDictionary
                        for (index,value) in array {
                            
                            let btn =  self.amountArray[index as! String
                                ] as! UIButton
                            btn.setTitle("\(value)", for: .normal)
                            
                        }
                    }
                    
                    break
                }
                
                break
            case .failure(let error):
                
                debugPrint(error)
                self.alert(message: "请求失败!")
                break
            }
        }

//        HttpClient.instance.post(path: "http://192.168.0.18:8080/fire/workunit/amount.do", parameters: nil, success: { (response) in
//            /*
//             "data": {
//             "amount": {
//             "total": 100,
//             "fireTotal": 50,
//             "misinfoTotal": 50
//             }
//             */
//            
//            
//        }) { (error) in
//            
//            self.alert(message: "请求失败!")
//        }
        
    }
    

   
}
