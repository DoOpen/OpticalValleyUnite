//
//  YQQuestionOptionView.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/6/26.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQQuestionOptionView: UIView {
    
    //单选view的实现逻辑
    @IBOutlet weak var Single1Label: UILabel!
    
    @IBOutlet weak var Single1Button: UIButton!
    
    @IBOutlet weak var Single2Label: UILabel!
    
    @IBOutlet weak var Single2Button: UIButton!
    
    @IBOutlet weak var Single3Label: UILabel!
    
    @IBOutlet weak var Single3Button: UIButton!
    
    @IBOutlet weak var Single4Label: UILabel!
    
    @IBOutlet weak var Single4Button: UIButton!
    
   
    var selectButtonArray = [UIButton]()
    var contentLabelArray = [UILabel]()
    
    var isEdit = true
  
    @IBAction func selectButtonClick(_ sender: UIButton) {
       
        for indexxx in 0..<self.selectButtonArray.count {
            
            let btn = self.selectButtonArray[indexxx]
            
            if sender.tag == indexxx {
                
                btn.isSelected = true
                
            }else{
                
                btn.isSelected = false
            }
        }
        
    }

    
    override func awakeFromNib() {
        
        self.selectButtonArray = [self.Single1Button,self.Single2Button,self.Single3Button,self.Single4Button]
        self.contentLabelArray = [self.Single1Label,self.Single2Label,self.Single3Label,self.Single4Label]
        
        for temp in self.selectButtonArray{
            
            temp.isUserInteractionEnabled = self.isEdit
            
        }
        
    }
    
    
}
