//
//  YQKnowledgeStudyCell.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/5/3.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQKnowledgeStudyCell: UITableViewCell {

    @IBOutlet weak var trainLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    
    }
    
    var model : YQStudyListModel?{
        didSet{
            
            self.trainLabel.text = model?.title
            
        }
    }

    
}
