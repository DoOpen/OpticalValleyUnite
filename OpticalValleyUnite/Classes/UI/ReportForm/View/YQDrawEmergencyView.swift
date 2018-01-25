//
//  YQDrawEmergencyView.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/1/21.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQDrawEmergencyView: UIView {

    
    var emergencyScale : CGFloat = 0

    
    override func draw(_ rect: CGRect) {
        
        //拿到数据进行的重绘的方法
        let bool2 = emergencyScale == 0
        
        //画图的顺序是 计划, 自发, 应急的执行的顺序!
        let center = CGPoint.init(x: self.viewCenter.x, y: self.viewCenter.y - 25)
        let radius = 50
        
        var startAngle =  CGFloat(3*Double.pi/2)

        
        if  bool2 {
            //没有数据不重绘
            //画 整圆弧的情况
            let color = UIColor.orange
            color.set() // 设置线条颜色
            
            let aPath = UIBezierPath.init(arcCenter: center, radius: CGFloat(radius),startAngle: startAngle, endAngle: startAngle - 0.0001 , clockwise: true)
            
            aPath.lineWidth = 23.0 // 线条宽度
            aPath.stroke() // Draws line 根据坐标点连线，填充

        
            return
        }
        
        UIView.animate(withDuration: 0.3) {
            
            var endAngle = CGFloat(2*Double.pi) * self.emergencyScale
            var clockwise = true
            
            if self.emergencyScale >= 1.0 {
                
                endAngle = 0.0001
                clockwise = false
            }
            
            //画 完成
            var color = UIColor.init(red: 103 / 255.0, green: 201 / 255.0, blue: 250 / 255.0, alpha: 1)
            color.set() // 设置线条颜色
            
            var aPath = UIBezierPath.init(arcCenter: center, radius: CGFloat(radius),startAngle: startAngle, endAngle: startAngle + endAngle, clockwise: clockwise)
            
            aPath.lineWidth = 23.0 // 线条宽度
            aPath.stroke() // Draws line 根据坐标点连线，填充
            
            startAngle += endAngle
            
            //画 未完成
            color = UIColor.orange
            color.set()
            
            aPath = UIBezierPath.init(arcCenter: center, radius: CGFloat(radius), startAngle: startAngle, endAngle: CGFloat(3*Double.pi/2) , clockwise: clockwise)
            aPath.lineWidth = 23.0
            aPath.stroke()
            
        }
        
        
    }


}
