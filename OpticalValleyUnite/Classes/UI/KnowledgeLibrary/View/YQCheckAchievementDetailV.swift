//
//  YQCheckAchievementDetailV.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/6/27.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQCheckAchievementDetailV: UIView {

    //思路是: 添加这个view的边框边线,并且设置属性参数
    @IBOutlet weak var optionLabel: UILabel!
    
    @IBOutlet weak var selectButton: UIButton!
    
    
    var isRight : Bool?{
        didSet{
          
            if isRight == false{
                
                self.backgroundColor = UIColor.init(red: 118/255.0, green: 32.4/255.0, blue: 32.4/255.0, alpha: 1.0)
                //UIColor colorWithRed:118/255.0 green:32.4/255.0 blue:32.4/255.0 alpha:1
                
            }else{//答对的
                
                self.backgroundColor = UIColor.init(red: 2.3/255.0, green: 97.5/255.0, blue: 0.01/255.0, alpha: 1.0)
                //colorWithRed:2.3/255.0 green:97.5/255.0 blue:0/255.0 alpha:1]
            }
        }
    }
    
    
    

}
