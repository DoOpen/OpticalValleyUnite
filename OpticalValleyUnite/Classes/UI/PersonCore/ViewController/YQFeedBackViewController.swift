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

    }
    
    // MARK: - 确定和取消按钮的点击事件方法
    @IBAction func cancelButtonClick(_ sender: UIButton) {
        
        
    }
    
    @IBAction func makeSureButtonClick(_ sender: UIButton) {
        
        
        
    }


}
