//
//  YQQuestionCollectionCell.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/6/22.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQQuestionCollectionCell: UICollectionViewCell {

    @IBOutlet weak var questionBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let width  = CGFloat((SJScreeW - 40) / 10)
        
        //设置button的属性
        //剪切圆角的属性设置
        self.questionBtn.layer.cornerRadius = width
        self.questionBtn.layer.masksToBounds = true
        // self.questionBtn.clipsToBounds = true
        self.questionBtn.backgroundColor = UIColor.clear
        
        let image = UIImage.init(named: "错题背景")
        self.questionBtn.setBackgroundImage(image, for: .selected)
        self.questionBtn.setTitleColor(UIColor.gray, for: .normal)
        self.questionBtn.setTitleColor(UIColor.white, for: .selected)
        
        
    }
    
    

}
