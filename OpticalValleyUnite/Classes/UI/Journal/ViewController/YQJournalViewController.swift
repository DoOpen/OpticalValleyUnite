//
//  YQJournalViewController.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/10/11.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit

class YQJournalViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //1.添加设置barItem
        setupRightAndLeftBarItem()
        

        }
    
    // MARK: - 自定义的right_left barItem
    func setupRightAndLeftBarItem(){
        
        // 自定义的navigetion right left barItem情况
        // left
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "icon_fire_return"), for: .normal)
        leftButton.addTarget(self, action: #selector(leftBarItemButtonClick), for: .touchUpInside)
        
        let leftBarItem = UIBarButtonItem()
        leftBarItem.customView = leftButton
        
        self.navigationItem.leftBarButtonItem = leftBarItem
        
        //right
        let right_select_Button = UIButton()
        right_select_Button.setImage(UIImage(named: "筛选"), for: .normal)
        right_select_Button.addTarget(self, action: #selector(selectRightBarItemButtonClick), for: .touchUpInside)
        
        let right_add_Button = UIButton()
        right_add_Button.setImage(UIImage(named: "发布"), for: .normal)
        right_add_Button.addTarget(self, action: #selector(addRightBarItemButtonClick), for: .touchUpInside)
        
        let  right1Bar = UIBarButtonItem()
        right1Bar.customView = right_select_Button
        let  right2Bar = UIBarButtonItem()
        right2Bar.customView = right_add_Button
        
        self.navigationItem.rightBarButtonItems = [right1Bar,right2Bar]
        
    }
    
    //MARK: - leftBarItemButtonClick方法
    func leftBarItemButtonClick(){
        //返回子系统选择的界面
        
    }
    
    //MARK: - RightBarItemButtonClick(选择和添加)方法
    func selectRightBarItemButtonClick(){
        //筛选的界面弹窗的效果
    
    }
    
    func addRightBarItemButtonClick(){
        //添加发布界面弹窗的效果
        
    }

}
