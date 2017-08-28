//
//  SJNavigationController.swift
//  SJMianWo-Swfit
//
//  Created by 贺思佳 on 16/4/4.
//  Copyright © 2016年 贺思佳. All rights reserved.
//

import UIKit

class SJNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.barTintColor = UIColor.white
    }
    
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if(self.viewControllers.count != 0){//当导航控制器不是push根控制器的时候
            //设置左边按钮
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image:UIImage(named:"ic_return"),
                style:.plain, target:self, action:#selector(SJNavigationController.popViewController as (SJNavigationController) -> () -> ()))
            
                viewController.hidesBottomBarWhenPushed = true
        }else{
            
        }
        super.pushViewController(viewController, animated:animated)
        
    }
    
    func popViewController()
    {
        if let vc =  self.childViewControllers.last as? ShloudPopType {
            vc.viewShloudPop()
        }else{
            self.popViewController(animated: true)
        }
        
        
        
    }
}
