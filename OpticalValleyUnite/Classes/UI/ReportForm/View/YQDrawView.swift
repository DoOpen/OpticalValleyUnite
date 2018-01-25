//
//  YQDrawView.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/1/17.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQDrawView: UIView {
    
    var planScale : CGFloat = 0
    var emergencyScale : CGFloat = 0
    var sourceScale : CGFloat = 0
    
    override func draw(_ rect: CGRect) {
        
        //拿到数据进行的重绘的方法
        let bool1 = planScale == 0
        let bool2 = emergencyScale == 0
        let bool3 = sourceScale == 0
        
        if bool1 && bool2 && bool3 {
            //没有数据不重绘
            
            
            return
        }
        
        UIView.animate(withDuration: 0.3) { 
            //画图的顺序是 计划, 自发, 应急的执行的顺序!
            let center = CGPoint.init(x: self.viewCenter.x, y: self.viewCenter.y - 25)
            let radius = 50
            
            var startAngle =  CGFloat(3*Double.pi/2)
            //画 计划
            var color = UIColor.init(red: 103 / 255.0, green: 201 / 255.0, blue: 250 / 255.0, alpha: 1)
            color.set() // 设置线条颜色
            
            var aPath = UIBezierPath.init(arcCenter: center, radius: CGFloat(radius),startAngle: startAngle, endAngle: startAngle + CGFloat(2*Double.pi) * self.planScale, clockwise: true)
            
            aPath.lineWidth = 23.0 // 线条宽度
            aPath.stroke() // Draws line 根据坐标点连线，填充
            
            startAngle += CGFloat(2*Double.pi) * self.planScale
            
            //画 自发
            color = UIColor.orange
            color.set()
            
            aPath = UIBezierPath.init(arcCenter: center, radius: CGFloat(radius), startAngle: startAngle, endAngle: startAngle + CGFloat(2*Double.pi) * self.sourceScale, clockwise: true)
            aPath.lineWidth = 23.0
            aPath.stroke()
            
            startAngle += CGFloat(2*Double.pi) * self.sourceScale
            
            //画 应急
            
            color = UIColor.red
            color.set()
            
            aPath = UIBezierPath.init(arcCenter: center, radius: CGFloat(radius), startAngle: startAngle, endAngle: startAngle + CGFloat(2*Double.pi) * self.emergencyScale, clockwise: true)
            
            aPath.lineWidth = 23.0
            aPath.stroke()

            
             startAngle += CGFloat(2*Double.pi) * self.emergencyScale
            
            //未完成
//            color = UIColor.gray
//            color.set()
//            
//            aPath = UIBezierPath.init(arcCenter: center, radius: CGFloat(radius), startAngle: startAngle, endAngle: CGFloat(3*Double.pi / 2), clockwise: true)
//            
//            aPath.lineWidth = 23.0
//            aPath.stroke()

            
        }
    

    }
    
}
