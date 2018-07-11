//
//  YQMyScoreCell.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/6/21.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQMyScoreCell: UITableViewCell {

    
    @IBOutlet weak var examTitleLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    
    }

    
    var model : YQMyAchievementsModel?{
        
        didSet{
            
            self.examTitleLabel.text = model?.name
            
            self.scoreLabel.text = model?.scoreContent
            
        }
        
    }
   
    
}
