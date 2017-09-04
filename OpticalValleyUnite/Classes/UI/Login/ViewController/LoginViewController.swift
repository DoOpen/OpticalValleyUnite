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

    // MARK: - 登录界面的按钮的点击
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
        Alamofire.request(URLPath.basicPath + URLPath.login, method: .post, parameters: parameters).responseJSON { (response) in
            SVProgressHUD.dismiss()
            switch response.result {
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
    
    // MARK: - 忘记密码的按钮点击
    @IBAction func forgotPasswordBtnClick(_ sender: Any) {
        //忘记密码的功能接口的
        
    
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
        
        let vc2 = UIStoryboard.instantiateInitialViewController(name: "PersonCore")
        
        tabVc.setViewControllers([vc1,vc2], animated: false)
        
        SJKeyWindow?.rootViewController = tabVc
    }

    
    class func chooseRootViewController(){
        if  ((UserDefaults.standard.value(forKey: Const.SJToken) as? String) != nil){
            
            let tabVc = UITabBarController()
            let vc1 = UIStoryboard.instantiateInitialViewController(name: "Home")
            let vc2 = UIStoryboard.instantiateInitialViewController(name: "PersonCore")
            
            tabVc.setViewControllers([vc1,vc2], animated: false)
            
            SJKeyWindow?.rootViewController = tabVc
            
        }else{
            let vc = LoginViewController(nibName: "LoginViewController", bundle: nil)
//            vc.view.backgroundColor = UIColor.red
            SJKeyWindow?.rootViewController = vc
        }
    }
    
    
    // MARK: - 退出登录按钮点击实现
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
