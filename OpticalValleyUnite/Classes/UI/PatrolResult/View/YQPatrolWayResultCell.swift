//
//  YQPatrolWayResultCell.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/5/25.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQPatrolWayResultCell: UITableViewCell {

    @IBOutlet weak var titileLabel: UILabel!
    
    
    var model : YQPatrolWayResultModel?{
        
        didSet{
            
           self.titileLabel.text = model?.insPointName
            
        }
        
    }

  
}
