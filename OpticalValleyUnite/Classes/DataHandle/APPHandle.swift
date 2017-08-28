//
//  APPHandle.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/1/12.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit
import SVProgressHUD

class APPHandle {

    static func currentRootViewController() -> UINavigationController?{
        let tabVc = SJKeyWindow?.rootViewController
        
        if let tabVc = tabVc as? UITabBarController {
            if let nav = tabVc.selectedViewController as? UINavigationController{
                return nav
            }else{
                return nil
            }
            
        }else if let tabVc = tabVc as? UINavigationController {
            return tabVc
        }else{
            return nil
        }

    }

    static func rootVcPush(_ vc: UIViewController){
        currentRootViewController()?.pushViewController(vc, animated: true)
    }
    
    static func tabBarControllerSelected(index: Int){
        let tabVc = SJKeyWindow?.rootViewController
        
        if let tabVc = tabVc as? UITabBarController {
            tabVc.selectedIndex = index
        }
    }

     
}
