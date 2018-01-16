//
//  YQReportFormDetailVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/1/16.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQReportFormDetailVC: UIViewController {

    @IBOutlet weak var planLabel: UILabel!
    
    @IBOutlet weak var emergencyLabel: UILabel!
    
    @IBOutlet weak var spontaneousLabel: UILabel!
    
    @IBOutlet weak var darwView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - 绘图的核心的方法
    // 弧线
    func drawRect(rect: CGRect) {
        
        let color = UIColor.red
        color.set() // 设置线条颜色
        
        let aPath = UIBezierPath.init(arcCenter: darwView.center, radius: 75,
                                      startAngle: 0, endAngle: CGFloat(Double.pi/2), clockwise: true)
        
        aPath.lineWidth = 20.0 // 线条宽度
       
        aPath.fill() // Draws line 根据坐标点连线，填充
    }
    
 
}
