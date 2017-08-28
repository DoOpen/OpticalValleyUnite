//
//  ExecuteDetailSubCell.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/6/7.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit

class ExecuteDetailSubCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    var index = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var model: ExecChild?{
        didSet{
            if let model = model{
                titleLabel.text = "\(index))" + model.name
                contentLabel.text = model.value
            }
        }
    }
    
}
