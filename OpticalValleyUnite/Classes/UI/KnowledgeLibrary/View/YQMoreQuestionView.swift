//
//  YQMoreQuestionView.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/6/26.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQMoreQuestionView: UIView {

    @IBOutlet weak var moreLabel1: UILabel!
    @IBOutlet weak var moreButton1: UIButton!
    
    @IBOutlet weak var moreLabel2: UILabel!
    @IBOutlet weak var moreButton2: UIButton!
    
    @IBOutlet weak var moreLabel3: UILabel!
    @IBOutlet weak var moreButton3: UIButton!
    
    @IBOutlet weak var moreLabel4: UILabel!
    @IBOutlet weak var moreButton4: UIButton!
    
    
    var selectButtonArray = [UIButton]()
    
    var isEdit = true

    
    @IBAction func more1ButtonClick(_ sender: UIButton) {
        
        moreButton1.isSelected = !moreButton1.isSelected
    }
    
    @IBAction func more2ButtonClick(_ sender: UIButton) {
        
        moreButton2.isSelected = !moreButton2.isSelected
    }
    
    @IBAction func more3ButtonClick(_ sender: UIButton) {
        
        moreButton3.isSelected = !moreButton3.isSelected
    }
    
    
    @IBAction func more4ButtonClick(_ sender: UIButton) {
        
        moreButton4.isSelected = !moreButton4.isSelected
    }
    
    
    
    override func awakeFromNib() {
        
        self.moreButton1.isUserInteractionEnabled = self.isEdit
       
    }
    
    
}
