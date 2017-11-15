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
import CoreMotion

class LoginViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //首先读取的是systemSelection的数据
    var systemDataArray:NSArray = { return NSArray() }(){
        didSet{
            
            self.pushToSystemSelectionVC()
        }
        
    }
    
    ///计步器的功能模块属性
    //设置注册 计步设备的
    lazy var counter = { () -> CMPedometer
        
        in
        
        return CMPedometer()
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.stepFunctionDidStart()
    }
    

    // MARK: - 登录界面的按钮的点击
    @IBAction func loginBtnClick() {
        
        //计步器的数据存储
        stepFunctionDidStart()
        
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
                        
                        //直接调用的是 工具的分类来完成的
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
                
                debugPrint(error)
                
                break
            }
        }
    }
    
    
    // MARK: - 忘记密码的按钮点击
    @IBAction func forgotPasswordBtnClick(_ sender: Any) {
        //忘记密码的功能接口的
        
    
    }
    
    // MARK: - 计步功能的模块实现
    func stepFunctionDidStart() {
        
        //获取昨天 和 前天的时间数据
        //        let date = NSDate()
        //        let formatter = DateFormatter()
        //        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //
        //        var dateString = formatter.string(from: date as Date)
        //
        ////        let index =  dateString.index( (dateString.startIndex)!, offsetBy: 10)
        ////        dateString.remove(at: dateString.index(after: 8))
        //
        ////        let replaceRangeAll = dateString.index(after: " ")...dateString.index(before:dateString.endIndex)
        ////
        ////        dateString.replaceSubrange(replaceRangeAll, with: "08:00:00")
        //
        //        let dateNow = formatter.date(from: dateString)
        //
        //        //            let yesterday = NSDate.init(timeInterval: -60*60*24*1, since: date as Date)
        //        let byesterday = NSDate.init(timeInterval: -60*60*24*1, since: dateNow!)
        
        
        
        if !CMPedometer.isStepCountingAvailable() {
            
            self.alert(message: "设备不可用! 支持5s及以上的机型")
            
        }else{
            
            //获取昨天 和 前天的时间数据
            let date = NSDate()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            let dateString = formatter.string(from: date as Date)
            
            _ = formatter.date(from: dateString)
            
            //            let yesterday = NSDate.init(timeInterval: -60*60*24*1, since: date as Date)
            let byesterday = NSDate.init(timeInterval: -60*60*24*1, since: date as Date)
            
            //直接应用的是 CMPedometer 获取系统的健康的应用
            self.counter.queryPedometerData(from: byesterday as Date, to: date as Date , withHandler: { (pedometerData, error) in
                
                let num = pedometerData?.numberOfSteps ?? 0
//                let distance = pedometerData?.distance ?? 0
                //上传前一天的步数
                var parameter = [String : Any]()
                parameter["date"] = formatter.string(from: byesterday as Date)
                parameter["steps"] = num
                
                HttpClient.instance.post(path: URLPath.getSavePedometerData, parameters: parameter, success: { (respose) in
                    
                }, failure: { (error) in
                    
                })
                
            })
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
        
        Alamofire.request(URLPath.basicPath + URLPath.getSystemSelection, method: .post, parameters: parameters).responseJSON { (response) in
            
            switch response.result {
                
            case .success(_):
                
                if let value = response.result.value as? [String: Any] {
                    
                    guard value["CODE"] as! String == "0" else{
                        let message = value["MSG"] as! String
                        
                        self.alert(message: message)
                        
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
        
        //缓存的清理
        UserDefaults.standard.removeObject(forKey: Const.YQTotallData)
        UserDefaults.standard.removeObject(forKey: Const.YQSystemSelectData)
//        UserDefaults.standard.removeObject(forKey: Const.YQTotallData)
//        "SJlatitude") as? CLLocationDegrees,let longitude = .object(forKey: "SJlongitude")
        UserDefaults.standard.removeObject(forKey: Const.YQIs_Group)
        UserDefaults.standard.removeObject(forKey: Const.YQProjectModel)
        UserDefaults.standard.removeObject(forKey: Const.YQReportName)
        
        User.removeUser()
        UserDefaults.standard.set(nil, forKey: Const.SJToken)
        chooseRootViewController()
        
    }
    

}
