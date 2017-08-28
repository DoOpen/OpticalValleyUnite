//
//  SigninCell.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/3/27.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit

class SigninCell: UITableViewCell {
    
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    
    var model: SignModel?{
        didSet{
            if let model = model {
                indexLabel.text = "\(model.index + 1)"
                timeLabel.text = ((model.SIGN_TIME as NSString).substring(from: 10) as NSString).substring(to: 6)
                addressLabel.text = model.ADDRESS
                addressLabel.sizeToFit()
            }
        }
    }
    
}
