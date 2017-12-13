//
//  YQPatrolBottomLastView.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/12/9.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit

protocol YQPatrolBottomLastViewDelegate : class {
    
    func PatrolBottomLastViewUpward()
    
    func PatrolBottomLastViewSubmit()
    
    func PatrolBottomLastViewCancel()
}

class YQPatrolBottomLastView: UIView {
    
    weak var delegate : YQPatrolBottomLastViewDelegate?
    
    /// 向上按钮
    @IBAction func lastViewUpward(_ sender: UIButton) {
        
        self.delegate?.PatrolBottomLastViewUpward()
    }
    
    
    /// 提交按钮点击
    @IBAction func lastViewSubmit(_ sender: UIButton) {
        
        self.delegate?.PatrolBottomLastViewSubmit()
        
    }
    
    
    /// 取消按钮点击
    @IBAction func lastViewCancel(_ sender: UIButton) {
        
        self.delegate?.PatrolBottomLastViewCancel()
    }
    
    
    
}
