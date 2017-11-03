//
//  YQWorkRecordTableViewCell.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/10/30.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit

class YQWorkRecordTableViewCell: UITableViewCell {
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!

    @IBOutlet weak var selectButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var model : WorkOrderModel2? {
    
        didSet{
            
            contentLabel.text = model?.content
            timeLabel.text = model?.time
            selectButton.isSelected = (model?.selected)!
            
        }
    
    }
    
    // MARK: - 返回非等高cell的height方法
    func cellForHeight() -> CGFloat {
        // detailLabel.frame.maxY + detailLabel.frame.width + 10
        
        return timeLabel.frame.maxY + 25
        
    }

    

}
