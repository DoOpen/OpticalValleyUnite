//
//  YQDynamicPasswordCell.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/12/19.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit


protocol  YQDynamicPasswordCellDelegate : class {
    
    func dynamicPasswordCellPwdClick(indexPath : IndexPath)
    
}

class YQDynamicPasswordCell: UITableViewCell {

    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var pwdButton: UIButton!
    
    var indexPath : IndexPath?
    
    weak var delegate : YQDynamicPasswordCellDelegate?
    
    var model : YQBluetooth?{
        
        didSet{
            
            self.textView.text = model?.name
        
        }
    }

    @IBAction func pwdButtonClick(_ sender: UIButton) {
        
        self.delegate?.dynamicPasswordCellPwdClick(indexPath: self
        .indexPath!)
        
    }
    
}
