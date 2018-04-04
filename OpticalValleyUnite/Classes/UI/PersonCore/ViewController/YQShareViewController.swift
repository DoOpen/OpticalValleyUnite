//
//  YQShareViewController.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/3/30.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQShareViewController: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.title = "分享"
        
        setupRightAndLeftBarItem()
    }

    
    // MARK: - 自定义的right_left barItem
    func setupRightAndLeftBarItem(){
        
        let right_add_Button = UIButton()
        
        right_add_Button.frame = CGRect(x : 0, y : 0, width : 40, height : 40)
        right_add_Button.setImage(UIImage(named: "分享"), for: .normal)
        right_add_Button.setTitle("分享", for: .normal)
        right_add_Button.addTarget(self, action: #selector(addRightBarItemButtonClick), for: .touchUpInside)
        
        let  right2Bar = UIBarButtonItem()
        right2Bar.customView = right_add_Button
        
        self.navigationItem.rightBarButtonItems = [right2Bar]
        
    }
    
    //MARK: - leftBarItemButtonClick方法
    func addRightBarItemButtonClick(){
        
        //调用setPreDefinePlatforms的示例
        UMSocialUIManager.setPreDefinePlatforms(
            [NSNumber(integerLiteral:UMSocialPlatformType.wechatSession.rawValue)
                ,NSNumber(integerLiteral:UMSocialPlatformType.QQ.rawValue)
                ,NSNumber(integerLiteral:UMSocialPlatformType.sina.rawValue)
            ]
        )

        UMShareSwiftInterface.showShareMenuViewInWindowWithPlatformSelectionBlock { (UMSocialPlatformType_UnKnown, nil) in
            
            
        }
        
    }

    

}
