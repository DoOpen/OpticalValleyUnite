//
//  YQProjectSelectFooterView.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/10/20.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit

protocol YQProjectTableViewCellDelegate : class{
    
    func projectSelectCompletedClick()
    
}

class YQProjectSelectFooterView: UIView {

    
    weak var delegate :YQProjectTableViewCellDelegate?
    
    @IBAction func selectCompletedClick(_ sender: Any) {
        
        self.delegate?.projectSelectCompletedClick()
        
    }
    
}
