//
//  YQPatrolBottomNextView.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/12/9.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit

protocol YQPatrolBottomNextViewDelegate : class {
    
    func PatrolBottomNextViewSaveAndNext()
    
    func PatrolBottomNextViewCancel()
    
}

class YQPatrolBottomNextView: UIView {
    
    weak var  delegate : YQPatrolBottomNextViewDelegate?
    
    /// 保存并评价下一项
    @IBAction func nextViewSaveAndNext(_ sender: UIButton) {
        
        self.delegate?.PatrolBottomNextViewSaveAndNext()
        
    }
    
    
    /// 取消 按钮点击
    @IBAction func nextViewCancel(_ sender: UIButton) {
        
        self.delegate?.PatrolBottomNextViewCancel()
    }

   
}
