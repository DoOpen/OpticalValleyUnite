//
//  YQFalsePositiveView.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/9/21.
//  Copyright © 2017年 yangqing. All rights reserved.
//

// 注意的是:这里的整体的后台接口逻辑是: 处理配合人为空的话,其余的参数都是必填的参数!

import UIKit

protocol YQFalsePositiveViewDelegate : class{
    
    func falsePositiveViewAddPersonClick(view :YQFalsePositiveView)
    
    func falsePositiveViewSaveButtonClick(view :YQFalsePositiveView)
}

class YQFalsePositiveView: UIView {
    
    //定义一个 personList的人名的数据回调的函数
    //定义代理
    weak var delegate : YQFalsePositiveViewDelegate?
    
    //添加执行人的name
    @IBOutlet weak var addNameTextField: UITextField!
    
    //执行原因
    @IBOutlet weak var reasonTextField: UITextField!
    
    //执行的图片上传
    @IBOutlet weak var proofPictureAddView: SJAddView!
    
    
    // MARK: - 添加按钮的点击
    @IBAction func addButtonClick(_ sender: Any) {
        
        self.delegate?.falsePositiveViewAddPersonClick(view: self)
        
    }

    
    // MARK: - 保存按钮点击情况
    @IBAction func saveButtonClick(_ sender: Any) {
        
        
        self.delegate?.falsePositiveViewSaveButtonClick(view: self)
    
    }
    
    
}
