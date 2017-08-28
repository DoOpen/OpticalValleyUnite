//
//  CallBackCell.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/6/6.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit

class CallBackCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var upLineView: UIImageView!
    @IBOutlet weak var downLineView: UIImageView!
    @IBOutlet weak var circleView: UIImageView!
    
    var model: CallbackModel?{
        didSet{
            if let model = model{
                nameLabel.text = "回访人: " + model.name
                timeLabel.text = "回访时间: " + model.time
                contentLabel.text = "回访理由: " + model.content
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }



}
