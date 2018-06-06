//
//  YQHomeTopView.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/6/4.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQHomeTopView: UIView {

    var topBtnViewArray = [HomeBtnView]()
    
    @IBOutlet weak var top1BtnView: HomeBtnView!
    
    @IBOutlet weak var top2BtnView: HomeBtnView!
    
    @IBOutlet weak var top3BtnView: HomeBtnView!
    
    @IBOutlet weak var top4BtnView: HomeBtnView!
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        topBtnViewArray = [top1BtnView,top2BtnView,top3BtnView,top4BtnView]
    }
    
}
