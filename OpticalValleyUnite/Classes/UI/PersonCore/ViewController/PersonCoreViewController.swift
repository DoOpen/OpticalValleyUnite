//
//  PersonCoreViewController.swift
//    OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/1/10.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit

class PersonCoreViewController: UIViewController,CheckNewBundleVersionProtocol {

    @IBOutlet weak var bundleVersionLabel: UILabel!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    // MARK: - 项目选择项目的传递
    @IBOutlet weak var projectSelectName: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "我的设置"
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")!
        //写死的项目发版的时间
        bundleVersionLabel.text = bundleVersionLabel.text! + "(\(version))"
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        //设置项目选择的lable
        self.projectSelectName.text = setUpProjectNameLable()
        
        //解决bug 上传不能更新的头像
        let user = User.currentUser()
        
        if let user = user{
            
            nickNameLabel.text = user.nickname
            userNameLabel.text = "账号: " + user.userName!
            
            
            if let url = user.avatar,url != ""{
                
                if url.contains("http") {
                    
                    photoImageView.kf.setImage(with: URL(string: url))

                }else{
                
                    let basicPath = URLPath.basicPath
                    let imageValue = basicPath.replacingOccurrences(of: "/api/", with: "") + url
                    
                    photoImageView.kf.setImage(with: URL(string: imageValue))
                
                }
                
                
            }
            
            
        }

        
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
    

    @IBAction func checkNewBtnClick() {
        
        self.checkNewBundleVersion(isBlack: false)
    }
    
    @IBAction func loginOutBtnClick() {
        
        LoginViewController.loginOut()
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
