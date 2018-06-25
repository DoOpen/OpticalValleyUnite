//
//  YQStartExamDetailVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/6/25.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQStartExamDetailVC: UIViewController {

    //属性添加title和定时器的显示
    //默认是第一题
    var titleIndes: Int = 1
    
    var secondStr = ""
    var minitStr = ""
    var hourStr = ""
    var dayStr = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //init
        self.title = "题号: " + "\(self.titleIndes)"
        
        //1.添加right
        setupRightAndLeftBarItem()

    }
    
    func setupRightAndLeftBarItem(){
        
        let imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 13, height: 13))
        imageView.image = UIImage.init(name: "clock")
        
        let right_add_Button = UIButton()
        right_add_Button.frame = CGRect(x : 0, y : 0, width : 60, height : 40)
        
        //设置font
        right_add_Button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        right_add_Button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        right_add_Button.setTitleColor(UIColor.init(red: 255/255.0, green: 144.001/255.0, blue: 0.01/255.0, alpha: 1), for: .normal)
        //设置时间,单位是s
        //总的时间是 1个小时
        right_add_Button.countDown(count: 60 * 60)
       
       
        let right1Bar = UIBarButtonItem()
        right1Bar.customView = imageView
        
        let  right2Bar = UIBarButtonItem()
        right2Bar.customView = right_add_Button
        
        self.navigationItem.rightBarButtonItems = [right2Bar,right1Bar]
    }
    
   
    
    
  

 

}
