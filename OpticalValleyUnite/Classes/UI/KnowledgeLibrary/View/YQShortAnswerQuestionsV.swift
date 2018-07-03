//
//  YQShortAnswerQuestionsV.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/6/27.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQShortAnswerQuestionsV: UIView {

    
    @IBOutlet weak var shortAnswerTextView: UITextView!
    
    var isEdit = true
    
    override func awakeFromNib() {
        
        self.shortAnswerTextView.isEditable = isEdit
        
        
    }

    
}
