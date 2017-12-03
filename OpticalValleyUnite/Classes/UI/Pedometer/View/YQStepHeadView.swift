//
//  YQStepHeadView.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/11/13.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit

protocol YQStepHeadViewDelegate : class {

    func stepHeadViewAllButtonClick(view : YQStepHeadView, button : UIButton)

}

class YQStepHeadView: UIView {

    // MARK: - 属性方法
    var currentSelectButton : UIButton?
    
    @IBOutlet weak var projectButton: UIButton!
    
    @IBOutlet weak var departmentButton: UIButton!
    
    @IBOutlet weak var groupButton: UIButton!
    
    weak var delegate : YQStepHeadViewDelegate?
    
    // MARK: - xib-cell的加载方法
    override func awakeFromNib() {
        
        self.backgroundColor = UIColor.init(red: 41/255.0, green: 177/255.0, blue: 255/255.0, alpha: 1.0)
        
        self.projectButton.isSelected = true
        currentSelectButton = projectButton
    
    }
    

    @IBAction func headAllButtonClick(_ sender: UIButton) {
        /*
         本项目tag : 0
         本部门tag : 1
         本集团tag : 2
         */
        if currentSelectButton == sender {
            return
        }
        
        currentSelectButton?.isSelected = false
        sender.isSelected = true
        currentSelectButton = sender
        
    }
    
    
    
}
