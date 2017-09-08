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


    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "我的设置"
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")!
        bundleVersionLabel.text = bundleVersionLabel.text! + "(\(version))"
        
        let user = User.currentUser()
        if let user = user{
            nickNameLabel.text = user.nickname
            userNameLabel.text = "账号: " + user.userName!
            
            if let url = user.avatar,url != ""{
                let basicPath = URLPath.basicPath
                let imageValue = basicPath.replacingOccurrences(of: "/api/", with: "") + url
                
                photoImageView.kf.setImage(with: URL(string: imageValue))
            }
        }
        
        
        
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