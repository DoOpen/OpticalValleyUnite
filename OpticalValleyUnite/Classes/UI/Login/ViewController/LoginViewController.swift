//
//  LoginViewController.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/1/24.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class LoginViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func loginBtnClick() {
        
        let user = userNameTextField.text
        let password = passwordTextField.text
        
        guard user != "" else {
            SVProgressHUD.showError(withStatus: "请输入账号")
            return
        }
        guard password != "" else {
            SVProgressHUD.showError(withStatus: "请输入密码")
            return
        }
        
        var parameters = [String : Any]()
//        parameters["token"] = "123"
        parameters["LOGIN_NAME"] = user
        parameters["PASSWORD"] = password?.md5()
        
        if let token = UserDefaults.standard.object(forKey: "SJDeviceToken") as? String{
            
            parameters["UMENG_TOKEN"] = token
            
        }
        
        SVProgressHUD.show(withStatus: "登录中")
        
        //alamofire 的网络请求:
        Alamofire.request(URLPath.basicPath + URLPath.login, method: .post, parameters: parameters).responseJSON { (response) in
            SVProgressHUD.dismiss()
            
            print(response.result)
            
            switch response.result {
            //打印出相应的 报事的 情况:
                
            case .success(_):
                
                if let value = response.result.value as? [String: Any] {
                    
                    guard value["CODE"] as! String == "0" else{
                        
                        let message = value["MSG"] as! String

                        self.alert(message: message)
   
                        return
                    }
//                    let token = (value["data"] as!  [String: Any])["TOKEN"] as! String
                   
                    if let data = value["data"] as? [String: Any]{
                        
                        let token = data["TOKEN"] as! String
                        
                        UserDefaults.standard.set(token, forKey: Const.SJToken)
                        let user = User(data:data)
                        user?.saveUser()
                        self.getDate()
                    }
                    
                    self.pushToHomeViewController()
                    
                    break
                }
                
                break
                
                
            case .failure(let error):
               
                debugPrint(error)
                break
            }
        }
        
    }
    
    
    private func getDate(){
        HttpClient.instance.get(path: URLPath.getPersonInfo, parameters: nil, success: { (response) in
            
            if let dic = (response as? Array<[String: Any]>)?.first{
                let model = PersonInfo(parmart: dic)
                let user = User.currentUser()
                user?.nickname = model.name
                user?.saveUser()
                
            }
            
        }) { (error) in
            
        }
    }
    
    func pushToHomeViewController(){
//        let vc = UIStoryboard.instantiateInitialViewController(name: "Main")
//        SJKeyWindow?.rootViewController = vc
        
        let tabVc = UITabBarController()
        let vc1 = UIStoryboard.instantiateInitialViewController(name: "Home")
        vc1.tabBarItem = UITabBarItem(title: "首页", image: UIImage(named:"home_normal"), selectedImage: UIImage(named:"home_active"))
        let vc2 = UIStoryboard.instantiateInitialViewController(name: "PersonCore")
        vc1.tabBarItem = UITabBarItem(title: "我的", image: UIImage(named:"me_normal"), selectedImage: UIImage(named:"me_active"))
        
//        tabVc.setViewControllers([vc1,vc2], animated: false)
        tabVc.addChildViewController(vc1)
        tabVc.addChildViewController(vc2)
        
        
        SJKeyWindow?.rootViewController = tabVc
    }

    class func chooseRootViewController(){
        //在login 的控制器中来加载tabbar的子控制器
        //首先的是: 判断 用户偏好中是否有值的情况!
        if  ((UserDefaults.standard.value(forKey: Const.SJToken) as? String) != nil){
            
            
//            let vc = UIStoryboard.instantiateInitialViewController(name: "Main")
            let tabVc = UITabBarController()
            let vc1 = UIStoryboard.instantiateInitialViewController(name: "Home")
            let vc2 = UIStoryboard.instantiateInitialViewController(name: "PersonCore")
            
//            tabVc.setViewControllers([vc1,vc2], animated: true) //会产生控制器加载出现bug的问题
            // 给tabbar 的vc添加子控制器! 注意的是两种的方法,有一定的区别的!
            tabVc.addChildViewController(vc1)
            tabVc.addChildViewController(vc2)
            
            SJKeyWindow?.rootViewController = tabVc
            
        }else{
            
            // 如果没有就还是显示的 登录的界面!
            let vc = LoginViewController(nibName: "LoginViewController", bundle: nil)
//            vc.view.backgroundColor = UIColor.red
            SJKeyWindow?.rootViewController = vc
        }
    }
    
    
    class func loginOut(){
        
        var paramet = [String: Any]()
        if let token = UserDefaults.standard.object(forKey: "SJDeviceToken") as? String{
            paramet["UMENG_TOKEN"] = token
        }
        HttpClient.instance.post(path: URLPath.logOut, parameters: paramet, success: { (data) in
            
//            SVProgressHUD.dismiss()

            
        }) { (error) in
            print(error)
        }
        
        UserDefaults.standard.removeObject(forKey: "SJlongitude")
        UserDefaults.standard.removeObject(forKey: "SJlatitude")
//        "SJlatitude") as? CLLocationDegrees,let longitude = .object(forKey: "SJlongitude")
        
        User.removeUser()
        
        UserDefaults.standard.set(nil, forKey: Const.SJToken)
        
        chooseRootViewController()
        

    }
    

}
