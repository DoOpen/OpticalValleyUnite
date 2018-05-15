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
import RealmSwift


class LoginViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    //记住密码
    @IBOutlet weak var selectRememberPWDBtn: UIButton!
    
    //是否记住密码
    var isRemember = false
    //是否已经保存md5
    var isMd5 = false
    
    
    //首先读取的是systemSelection的数据
    var systemDataArray:NSArray = { return NSArray() }(){
        
        didSet{
            
            self.pushToSystemSelectionVC()
        }
        
    }
    
    
        
    // MARK: - 视图生命周期的方法
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //1.获取偏好设置的用户名和 密码
        userNameTextField.text = UserDefaults.standard.object(forKey: Const.standardUserName) as? String ?? ""
        
        passwordTextField.text = UserDefaults.standard.object(forKey: Const.standardUserPwd) as? String ?? ""
        
        if passwordTextField.text != "" {
            
            //1.设置按钮状态
            isRemember = true
            self.selectRememberPWDBtn.isSelected = true
            
            //2.有md5
            isMd5 = true
            
            //3.只显示六位数
            passwordTextField.text = "xxxxxx"//模拟的加密密码
            
        }
        
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
        parameters["loginName"] = user

        
        //保存用户名和密码的情况
        UserDefaults.standard.set(user, forKey: Const.standardUserName)
        
        if self.isRemember {
        
            if self.isMd5 {
            
                parameters["password"] = UserDefaults.standard.object(forKey: Const.standardUserPwd)
                
                self.isMd5 = false
                
            }else{
            
                parameters["password"] = password?.md5()
                
                UserDefaults.standard.set(password?.md5(), forKey: Const.standardUserPwd)
            }
            
        }else{
        
            
            if self.isMd5 {
                
                parameters["password"] = UserDefaults.standard.object(forKey: Const.standardUserPwd)
                
            }else{
                
                parameters["password"] = password?.md5()
            
            }
            
            UserDefaults.standard.removeObject(forKey: Const.standardUserPwd)
        }
        
        
        if let token = UserDefaults.standard.object(forKey: "SJDeviceToken") as? String{
            
            parameters["umengToken"] = token
            
        }
        
        parameters["deviceToken"] = ""
        
        print(parameters)
        print(URLPath.newbasicPath + URLPath.login)
        
        SVProgressHUD.show(withStatus: "登录中")

        Alamofire.request(URLPath.newbasicPath + URLPath.login, method: .post, parameters: parameters).responseJSON { (response) in
            SVProgressHUD.dismiss()
            switch response.result {
                
            case .success(_):
                
                if let value = response.result.value as? [String: Any] {
                    
                    guard value["CODE"] as! String == "0" else{
                        let message = value["MSG"] as! String
                        
                        //直接调用的是 工具的分类来完成的
                        self.alert(message: message)
   
                        return
                    }
//                    let token = (value["data"] as!  [String: Any])["TOKEN"] as! String
                    if let data = value["data"] as? [String: Any]{
                        
                        let token = data["token"] as! String
                        
                        UserDefaults.standard.set(token, forKey: Const.SJToken)
                        
                        let user = User(data:data)
                        
                        user?.saveUser()
                        
                        self.getDate()
                    }
                    
                    /// 直接跳转到home的主页
                    //  self.pushToHomeViewController()
                    // 正版的跳转到子系统选择的界面
                     self.systemSelectionNetworkInterface()
                    // 跳转到日志的测试的模块
                    // self.pushToJournalViewController()

                    break
                }
                break
                
            case .failure(let error):
                
                SVProgressHUD.showError(withStatus: "网络连接失败,请重试!")
                self.isMd5 = false

                debugPrint(error)
                
                break
            }
        }
    }
    
    
    // MARK: - 忘记密码的按钮点击
    @IBAction func forgotPasswordBtnClick(_ sender: Any) {
        //忘记密码的功能接口的
        
    }
    
    // MARK: - 记住密码的点击功能的实现
    @IBAction func rememberPWDClick(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
//        if sender.isSelected {//记住密码
//  
//            
//        }else{//不记住,清空密码单
//        
//        
//        }
        
        self.isRemember = sender.isSelected
        
    }
    

    private func getDate(){
        
        HttpClient.instance.get(path: URLPath.getPersonInfo, parameters: nil, success: { (response) in
            
            if let dic = (response as? [String: Any]){
                
                let model = PersonInfo(parmart: dic)
                let user = User.currentUser()
                user?.nickname = model.name
                user?.saveUser()
                
            }
            
        }) { (error) in
            
        }
    }
    
    // MARK: - 跳转到子界面选择的
    func pushToSystemSelectionVC(){
        //添加整体的逻辑处理(重复调用一下接口,如果是有值的话替换 缓存)
    
        if  self.systemDataArray.count == 0{
            //显示登录失败
            SVProgressHUD.showError(withStatus: "登录失败,请检查!")
            
        }else{
            
            let systemVC = YQSystemSelectionVC(nibName: "YQSystemSelectionVC", bundle: nil)
            SJKeyWindow?.rootViewController = systemVC

        }
    
    }
    
    // MARK: - 跳转到home主界面的代码
    func pushToHomeViewController(){
        
        let tabVc = UITabBarController()
        
        let vc1 = UIStoryboard.instantiateInitialViewController(name: "Home")
        let vc2 = UIStoryboard.instantiateInitialViewController(name: "PersonCore")
        
        tabVc.setViewControllers([vc1,vc2], animated: false)
        
        SJKeyWindow?.rootViewController = tabVc
    }
    
    
    // MARK: - 跳转到日志的界面的模块
    func pushToJournalViewController(){
        //测试日志模块
        let journa = UIStoryboard.instantiateInitialViewController(name: "YQJournal")
        
        SJKeyWindow!.rootViewController = journa
        
    }
    
    
    // MARK: - 子系统的选择的接口调用
    func systemSelectionNetworkInterface(){
        
        var parameters = [String : Any]()
        
        let token = UserDefaults.standard.object(forKey: Const.SJToken)
        parameters["token"] = token
        
        Alamofire.request(URLPath.newbasicPath + URLPath.getSystemSelection, method: .post, parameters: parameters).responseJSON { (response) in
            
            switch response.result {
                
            case .success(_):
                
                if let value = response.result.value as? [String: Any] {
                    
                    guard value["CODE"] as! String == "0" else{
                        let message = value["MSG"] as! String
                        
//                        self.alert(message: message)
                        print(message)
                        
                        return
                    }
                    
                    if let data = value["data"] as? NSArray{//注意区分这里的值的类型,不要定死是字典和数组
                        
                        //进行数据的缓存
                        UserDefaults.standard.set(data, forKey: Const.YQTotallData)
                        
                        //进行UI界面赋值添加
                        self.systemDataArray = data
                    }
                    
                    break
                }
                
                break
            case .failure(let error):
                
                SVProgressHUD.showError(withStatus: "网络连接失败,请重试!")
                
                debugPrint(error)
                
                break
            }
        }
    }
    


    // MARK: - 免登陆的界面的情况
    class func chooseRootViewController(){
        
        if  ((UserDefaults.standard.value(forKey: Const.SJToken) as? String) != nil){
            
            
            let tabVc = UITabBarController()
            let vc1 = UIStoryboard.instantiateInitialViewController(name: "Home")
            let vc2 = UIStoryboard.instantiateInitialViewController(name: "PersonCore")
            
            tabVc.setViewControllers([vc1,vc2], animated: false)
            
            SJKeyWindow?.rootViewController = tabVc
            
        }else{
            
            let vc = LoginViewController(nibName: "LoginViewController", bundle: nil)
            SJKeyWindow?.rootViewController = vc
        }
    }
    
    
    // MARK: - 退出登录按钮点击实现
    class func loginOut(){
        
        var paramet = [String: Any]()
        if let token = UserDefaults.standard.object(forKey: "SJDeviceToken") as? String{
            paramet["token"] = token
        }
        
        HttpClient.instance.post(path: URLPath.logOut, parameters: paramet, success: { (data) in
            
            UIApplication.shared.applicationIconBadgeNumber = 0

        }) { (error) in
            
            print(error)
        }
        
        UserDefaults.standard.removeObject(forKey: "SJlongitude")
        UserDefaults.standard.removeObject(forKey: "SJlatitude")
        
        //缓存的清理
        UserDefaults.standard.removeObject(forKey: Const.YQTotallData)
        UserDefaults.standard.removeObject(forKey: Const.YQSystemSelectData)
//        UserDefaults.standard.removeObject(forKey: Const.YQTotallData)
//        "SJlatitude") as? CLLocationDegrees,let longitude = .object(forKey: "SJlongitude")
        UserDefaults.standard.removeObject(forKey: Const.YQIs_Group)
        UserDefaults.standard.removeObject(forKey: Const.YQProjectModel)
        UserDefaults.standard.removeObject(forKey: Const.YQReportName)
        
        UserDefaults.standard.removeObject(forKey: Const.YQBadgeNumber)
        
        User.removeUser()
        UserDefaults.standard.set(nil, forKey: Const.SJToken)
        chooseRootViewController()
        
        let realm = try! Realm()
        try! realm.write {

            realm.deleteAll()
        }
        
        //报事 - 信息保存 退出移除plist的文件
        //操作文件管理器的类
        let fileManager = FileManager.default
        let myReport1 = NSHomeDirectory() + "/Documents/lists.plist"
        let myReport2 = NSHomeDirectory() + "/Documents/images.plist"
        
        do {
            
            _ = try fileManager.removeItem(atPath: myReport1)
            _ = try fileManager.removeItem(atPath: myReport2)
            
        } catch  {
            
            print("文件不存在!")
        }

    }
    

}
