//
//  YQExamRecordsCell.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/6/21.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQExamRecordsCell: UITableViewCell {

    @IBOutlet weak var examTilteLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var examTimeLabel: UILabel!
    
    @IBOutlet weak var examScoreLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

    
    }
    
    var model : YQExaminationRecordsModel?{
        
        didSet{
            
            self.examTilteLabel.text = model?.name
            self.scoreLabel.text = model?.scoreContent
            self.examScoreLabel.text = "考试分数  " + "\(model?.totalScore ?? 0)"
            self.examTimeLabel.text = "考试时间 " +  (model?.time)!
            
        }
        
    }

    
  
}
