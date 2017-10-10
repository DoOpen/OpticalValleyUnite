//
//  YQResolvedView.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/9/21.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit


protocol YQResolvedViewDelegate : class{
    
    func resolvedViewAddImplementPerson(view :YQResolvedView )
    
    func resolvedViewAddCooperatePerson(view :YQResolvedView )
    
    func resolvedViewSaveButtonClick(view :YQResolvedView ,images : NSArray)
    
}

class YQResolvedView: UIView {
    
    //执行人的textField
    @IBOutlet weak var ImplementPersonTextField: UITextField!
    
    //配合人的textField
    @IBOutlet weak var cooperatePersonTextField: UITextField!
    
    //原因 textField
    @IBOutlet weak var reasonTextField: UITextField!
    
    @IBOutlet weak var proofImageAddView: SJAddView!
    
    //定义代理
    weak var delegate : YQResolvedViewDelegate?
    
    // MARK: - 添加执行人的按钮点击
    @IBAction func addImplementPersonClick(_ sender: Any) {
        
        self.delegate?.resolvedViewAddImplementPerson(view: self)
        
    }
    
    // MARK: - 添加协助人的按钮点击
    @IBAction func addCooperateClick(_ sender: Any) {
        self.delegate?.resolvedViewAddCooperatePerson(view: self)
        
    }
    
    
    // MARK: - 整体的按钮 保存的点击
    @IBAction func saveButtonClick(_ sender: Any) {
        
        let images = proofImageAddView.photos.map { (image) -> UIImage in
            return image.image
        }
        
        
        self.delegate?.resolvedViewSaveButtonClick(view: self, images: images as NSArray)
        
    }
    
}
