//
//  YQPhoneScreenView.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/2/9.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

protocol YQPhoneScreenViewDelegate : class {
    
    func phoneScreenViewCheckOutClick()

}

class YQPhoneScreenView: UIView {

    @IBOutlet weak var phoneText: UITextField!
    
    var delegate : YQPhoneScreenViewDelegate?
    
    @IBAction func checkoutButtonClick(_ sender: UIButton) {
        
        self.delegate?.phoneScreenViewCheckOutClick()
        
    }
    
}
