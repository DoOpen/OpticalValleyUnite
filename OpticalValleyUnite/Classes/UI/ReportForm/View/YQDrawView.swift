//
//  YQDrawView.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/1/17.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQDrawView: UIView {
    
    
    
    
    
    override func draw(_ rect: CGRect) {
        
        let color = UIColor.blue
        color.set() // 设置线条颜色
        
        let aPath = UIBezierPath.init(arcCenter: self.viewCenter, radius: 75,
                                      startAngle: CGFloat(3*Double.pi/2), endAngle: CGFloat(1*Double.pi/2), clockwise: true)
        aPath.lineWidth = 40.0 // 线条宽度
        
        aPath.stroke() // Draws line 根据坐标点连线，填充


    }
    
}
