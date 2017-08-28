//
//  ExecutingSectionView.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/2/22.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit

class ExecutingSectionView: UIView {

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var iconBtn: UIButton!
    
    @IBOutlet weak var openBtn: UIButton!
    var didTouchHandle: (() -> ())?
    
    @IBAction func openBtnClick(_ sender: UIButton) {
//        sender.isSelected = !sender.isSelected

        if let block = didTouchHandle {
            block()
        }
        
    }
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let block = didTouchHandle {
//            block()
//        }
//    }
}
