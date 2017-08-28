//
//  SystemMessageCell.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/1/23.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit

class SystemMessageCell: UITableViewCell {
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    var model: SystemMessageModel?{
        didSet{
            titleView.text = model?.department
            timeLabel.text = model?.time
            contentLabel.text = model?.title
            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


}
