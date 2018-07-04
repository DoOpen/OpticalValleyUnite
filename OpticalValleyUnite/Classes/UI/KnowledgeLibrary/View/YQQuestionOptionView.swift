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
    
    var isEdit = true
  
    @IBAction func selectButtonClick(_ sender: UIButton) {
        
//        switch sender.tag {
//            case 0:
//
//                break
//            case 1:
//
//                break
//            case 2:
//
//                break
//            case 3:
//
//                break
//            default:
//                break
//        }
        
       
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
        
        for temp in self.selectButtonArray{
            
            temp.isUserInteractionEnabled = self.isEdit
            
        }
        
    }
    
    
}
