//
//  YQFeedBackViewController.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/3/30.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQFeedBackViewController: UIViewController {
    
    //主题
    @IBOutlet weak var titleTextField: UITextField!
    //内容
    @IBOutlet weak var contentTextView: UITextView!
    
    //图片
    @IBOutlet weak var addImageView: SJAddView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "意见反馈"

        //添加rightBar
        setupRightAndLeftBarItem()
        
    }
    
    
    // MARK: - 自定义的right_left barItem
    func setupRightAndLeftBarItem(){
        
        let right_add_Button = UIButton()
        
        right_add_Button.frame = CGRect(x : 0, y : 0, width : 40, height : 40)
        right_add_Button.setImage(UIImage(named: "反馈"), for: .normal)
        right_add_Button.setTitle("我的反馈", for: .normal)
        right_add_Button.addTarget(self, action: #selector(addRightBarItemButtonClick), for: .touchUpInside)
        
        let  right2Bar = UIBarButtonItem()
        right2Bar.customView = right_add_Button
        
        self.navigationItem.rightBarButtonItems = [right2Bar]
        
    }
    
    //MARK: - leftBarItemButtonClick方法
    func addRightBarItemButtonClick(){
        
        //跳转到反馈的界面
        let vc = UIStoryboard.instantiateInitialViewController(name: "YQMyFeedList")
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

    
    
    // MARK: - 确定和取消按钮的点击事件方法
    @IBAction func cancelButtonClick(_ sender: UIButton) {
        
        
    }
    
    @IBAction func makeSureButtonClick(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }


}
