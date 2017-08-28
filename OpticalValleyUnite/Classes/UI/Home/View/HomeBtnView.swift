//
//  HomeBtnView.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/5/3.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit
import LCNibBridge

class HomeBtnView: UIView, LCNibBridge {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!

    var clickHandle: (() -> ())?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let block = clickHandle{
            block()
        }
    }

}
