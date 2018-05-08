//
//  PersonCoreViewController.swift
//    OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/1/10.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit
import CoreMotion


class PersonCoreViewController: UIViewController,CheckNewBundleVersionProtocol {

    @IBOutlet weak var bundleVersionLabel: UILabel!
    @IBOutlet weak var nickNameLabel: UILabel!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var headViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var starView: UIView!
    
    @IBOutlet weak var starLabel: UILabel!
    
    
    var userNameMaxY : CGFloat = 0{
        
        didSet{
            //赋值
            self.headViewConstraint.constant = userNameLabel.maxY > photoImageView.maxY ?  userNameLabel.maxY + 10 : self.headViewConstraint.constant
            
            self.view.setNeedsLayout()
        }
        
    }

    // MARK: - 项目选择项目的传递
    @IBOutlet weak var projectSelectName: UILabel!
    
    ///计步器的功能模块属性
    //设置注册 计步设备的
    lazy var counter = { () -> CMPedometer
        
        in
        
        return CMPedometer()
    }()

    // MARK: - 生命周期方法
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.navigationItem.title = "我的设置"
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")!
        //写死的项目发版的时间
        bundleVersionLabel.text = bundleVersionLabel.text! + "(\(version))"
        
        //添加leftRightBar功能
        setupRightAndLeftBarItem()
        
        //设置星级服务
        setupStarViewData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        //设置项目选择的lable
        self.projectSelectName.text = setUpProjectNameLable()
        
        //设置用户信息
        setupUserData()
      
    }
    
    override func viewWillLayoutSubviews() {

        super.viewWillLayoutSubviews()

        if (self.userNameMaxY != userNameLabel.maxY){
            
            self.userNameMaxY = userNameLabel.maxY
        }
    }
    
    
    // MARK: - 添加设置用户信息
    func setupUserData(){
        
        //解决bug 上传不能更新的头像
        let user = User.currentUser()
        
        if let user = user{
            
            nickNameLabel.text = user.nickname
            userNameLabel.text = "账号: " + (user.userName ?? "")
            
            if let url = user.avatar,url != ""{
                
                if url.contains("http") {
                    
                    photoImageView.kf.setImage(with: URL(string: url), placeholder: UIImage.init(name: "userIcon"), options: nil, progressBlock: nil, completionHandler: nil)
                    
                }else{
                    
                    let basicPath = URLPath.systemSelectionURL
                    let imageValue = basicPath.replacingOccurrences(of: "/api/", with: "") + "/" + url
                    
                    photoImageView.kf.setImage(with: URL(string: imageValue), placeholder: UIImage.init(name: "userIcon"), options: nil, progressBlock: nil, completionHandler: nil)
                    
                }
            }
        }
    }
    
    
    // MARK: - 获取添加执行星级管家内容
    func setupStarViewData(){
        
        HttpClient.instance.post(path: URLPath.getScoreDetail, parameters: nil, success: { (response) in
            
            let data = response["scoreDetail"] as? [String : Any]
            
            if data == nil {

                return
            }
            
            //显示的星级 数量(设置星级的数量)
            var star = data!["star"] as? Int ?? 0
            if (star) <= 0 {
                //解决model.source 的逻辑bug的 情况
                star = 1
            }else if (star) > 5{
                
                star =  (star) / 2
            }
            
            for i in 0...((star) - 1){
                
                let starBtn = self.starView.subviews[i] as! UIButton
                starBtn.isSelected = true
            }
            
            switch star {
                case 1:
                    self.starLabel.text = "一星管家"
                    break
                case 2:
                    self.starLabel.text = "二星管家"
                    break
                case 3:
                    self.starLabel.text = "三星管家"
                    break
                case 4:
                    self.starLabel.text = "四星管家"
                    break
                case 5:
                    self.starLabel.text = "五星管家"
                    break
                default:
                    break
            }

        }) { (error) in
            
        }
    }
    
    // MARK: - 自定义的right_left barItem
    func setupRightAndLeftBarItem(){
        
        let right_add_Button = UIButton()
        
        right_add_Button.frame = CGRect(x : 0, y : 0, width : 40, height : 40)
        right_add_Button.setImage(UIImage(named: "反馈"), for: .normal)
        right_add_Button.setTitle("反馈", for: .normal)
        //设置font
        right_add_Button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        right_add_Button.setTitleColor(UIColor.blue, for: .normal)
        right_add_Button.addTarget(self, action: #selector(addRightBarItemButtonClick), for: .touchUpInside)
        
        let  right2Bar = UIBarButtonItem()
        right2Bar.customView = right_add_Button
        
        self.navigationItem.rightBarButtonItems = [right2Bar]
        
    }
    
    //MARK: - leftBarItemButtonClick方法
    func addRightBarItemButtonClick(){
        
        //跳转到反馈的界面
        let vc = UIStoryboard.instantiateInitialViewController(name: "YQFeedBackVC")
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    //MARK: - star星级评分的按钮点击的事件
    @IBAction func starServicerButtonClick(_ sender: UIButton) {
        
        //界面跳转到
        let starVc = YQStarServiceVC.init(nibName: "YQStarServiceVC", bundle: nil)
        
        self.navigationController?.pushViewController(starVc, animated: true)

    }

    
    // MARK: - 添加默认的项目选择方法
    func setUpProjectNameLable() -> String{
        
        let dic = UserDefaults.standard.object(forKey: Const.YQProjectModel) as? [String : Any]
        
        var projectName  = ""
        
        if dic != nil {
            
            projectName = dic?["PARK_NAME"] as! String
        }else{
         
            projectName = "项目选择"
        }
        
        return projectName
    }
    
    // MARK: - 修改密码按钮点击功能实现
    @IBAction func modifyPassWordClick(_ sender: Any) {
        //修改密码的界面
        let vc = UIStoryboard.instantiateInitialViewController(name: "YQUpdataPSW")

        navigationController?.pushViewController(vc, animated: true)
        vc.title = "修改密码"
    }
    
    // MARK: - 跳转到离线工单的界面
    @IBAction func offLineButtonClick(_ sender: Any) {
        
        let offlineVC = UIStoryboard.instantiateInitialViewController(name: "YQOffLineFirst") as? YQOffLineFirstWorkOrderVC
        
        self.navigationController?.pushViewController(offlineVC!, animated: true)

    }
    
    // MARK: - 个人详情信息的界面跳转
    @IBAction func PersonDetailButtonClick(_ sender: Any) {
        
        let vc = UIStoryboard.instantiateInitialViewController(name: "YQPersonDetail")
        navigationController?.pushViewController(vc, animated: true)
        vc.title = "个人资料"

    }
    
    // MARK: - 选择全局项目的按钮的点击
    @IBAction func allProjectSelectClick(_ sender: Any) {
        
        let project = UIStoryboard.instantiateInitialViewController(name: "YQAllProjectSelect")
        navigationController?.pushViewController(project, animated: true)

    }
    
    // MARK: - 分享界面的点击和跳转
    @IBAction func shareButtonClick(_ sender: UIButton) {
        
        let vc = YQShareViewController.init(nibName: "YQShareViewController", bundle: nil)
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    

    @IBAction func checkNewBtnClick() {
        
        self.checkNewBundleVersion(isBlack: false)
    }
    
    @IBAction func loginOutBtnClick() {
        
        stepFunctionDidStart()
        
        LoginViewController.loginOut()
    }

    
    // MARK: - 计步功能的模块实现
    func stepFunctionDidStart() {
        
        if !CMPedometer.isStepCountingAvailable() {
            
            //设备不可用的情况下是在登录界面,不需要提示的
            //            self.alert(message: "设备不可用! 支持5s及以上的机型")
            return
            
        }else{
            
            //获取昨天 和 前天的时间数据
            let date = NSDate()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let formatter1 = DateFormatter()
            formatter1.dateFormat = "yyyy-MM-dd"
            let temp = formatter1.string(from: date as Date)
            let tempstring = temp.appending(" 00:00:00")
            
            let nowdate = formatter.date(from: tempstring)
            
            //直接应用的是 CMPedometer 获取系统的健康的应用
            self.counter.queryPedometerData(from: nowdate!, to: date as Date , withHandler: { (pedometerData, error) in
                
                let num = pedometerData?.numberOfSteps ?? 0
                
                //上传前一天的步数
                DispatchQueue.main.async {
                    
                    var parameter = [String : Any]()
                    parameter["date"] = temp
                    
                    parameter["steps"] = num
                    
                    HttpClient.instance.post(path: URLPath.getSavePedometerData, parameters: parameter, success: { (respose) in
                        
                        
                    }, failure: { (error) in
                        
                    })
                }
                
            })
        }
    }

    
}

protocol CheckNewBundleVersionProtocol {
    
    func checkNewBundleVersion(isBlack:Bool) -> ()
}

extension CheckNewBundleVersionProtocol{
    
    func checkNewBundleVersion(isBlack:Bool) -> (){
        
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        print(" 当前版本号为：\(version)")
        var parmat = [String: Any]()
        parmat["version"] = version
        parmat["type"] = "iOS"
        parmat["appCode"] = "ems" // beta的新的接口添加,调试!
        
        
        HttpClient.instance.post(path: URLPath.getVersion, parameters: parmat, success: { (response) in
            
            if let response = response as? String{
                
                SJKeyWindow?.rootViewController?.alert(message: "有新的版本,点击确认下载最新版本", doneBlock: { (action) in
                    
                    let urlString = response
                    
                    if let url = URL(string: urlString) {
                        //根据iOS系统版本，分别处理
                        if #available(iOS 10, *) {
                            
                            UIApplication.shared.open(url, options: [:],
                                                      completionHandler: {
                                                        (success) in
                            })
                            
                        } else {
                            
                            UIApplication.shared.openURL(url)
                        }
                        
                    }
                    
                }, cancleBlock: {
                    (action) in
                })

            }else{
                
                if !isBlack{
                    SJKeyWindow?.rootViewController?.alert(message: "您的版本已经是最新的版本了");
                }
                
            }

        }) { (error) in
            
            print(error)
        }

    }
}
