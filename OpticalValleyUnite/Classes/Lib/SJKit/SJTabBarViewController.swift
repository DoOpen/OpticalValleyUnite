//
//  SJTabBarViewController.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/1/11.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit

class SJTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        UITabBarItem.appearance().setTitleTextAttributes(NSDictionary.init(object:Const.SJThemeColor, forKey: NSForegroundColorAttributeName as NSCopying) as? [String : AnyObject], for: .selected)
        
    }



}
