//
//  YQStepStatisticsView.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/11/13.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit

class YQStepStatisticsView: UITableViewCell {
    
    // MARK: - step的cell属性
    @IBOutlet weak var indexLabel: UILabel!
    
    @IBOutlet weak var indexHeadImageV: UIImageView!
    
    @IBOutlet weak var userHeadImageV: UIImageView!

    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var subTitleLabel: UILabel!
    
    @IBOutlet weak var stepTotallCountLabel: UILabel!
    
    
    var model : Any?{
        didSet{
        
        
        }
    
    }
  
}
