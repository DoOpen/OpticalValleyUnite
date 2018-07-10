//
//  YQAnswerAndShortAnswerV.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/7/10.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQAnswerAndShortAnswerV: UIView {

    @IBOutlet weak var answerTextV: SJTextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.answerTextV.isEditable = false
        
    }
    
    
    
    

}
