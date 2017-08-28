//
//  SiginCellView.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/7/31.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit
import LCNibBridge

class SiginCellView: UIView, LCNibBridge {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var projectLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!


    var model: SignModel?{
        didSet{
            if let model = model{
                timeLabel.text = model.SIGN_TIME
                projectLabel.text = model.ADDRESS
                statusLabel.text = model.SIGN_STATU
            }
        }
    }
}
