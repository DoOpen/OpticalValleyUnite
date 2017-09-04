//
//  YQSystemSelectionVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/9/1.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit
import Alamofire


var parameters = [String : Any]()

class YQSystemSelectionVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.systemSelectionNetworkInterface()
        
        
        
    }
    
    
    // MARK: - 子系统的选择的接口调用
    func systemSelectionNetworkInterface(){
        
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
                    
                    
                    if let data = value["data"] {//注意区分这里的值的类型,不要定死是字典和数组
                        
//                        let token = data["TOKEN"] as! String
//                        UserDefaults.standard.set(token, forKey: Const.SJToken)
//                        let user = User(data:data)
//                        user?.saveUser()
                        
                        print(data)
                        //进行UI界面的hide的设置 和 更新
                        
                        
                    }
                    
                    break
                }
                
                break
            case .failure(let error):
                
                debugPrint(error)
                break
            }
        }
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let tabVc = UITabBarController()
        
        let vc1 = UIStoryboard.instantiateInitialViewController(name: "Home")
        let vc2 = UIStoryboard.instantiateInitialViewController(name: "PersonCore")
        
        tabVc.setViewControllers([vc1,vc2], animated: false)
        
        SJKeyWindow?.rootViewController = tabVc
        
    }
    

}
