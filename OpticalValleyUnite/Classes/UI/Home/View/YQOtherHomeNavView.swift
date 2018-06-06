
//
//  YQOtherHomeNavView.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/6/4.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

protocol YQOtherHomeNavViewDelegate {
    
    func OtherHomeNavViewMessageBtnClick()
    
}

class YQOtherHomeNavView: UIView {

    @IBOutlet weak var top1BtnView: HomeBtnView!
    
    @IBOutlet weak var top2BtnView: HomeBtnView!
    
    @IBOutlet weak var top3BtnView: HomeBtnView!
    
    @IBOutlet weak var top4BtnView: HomeBtnView!
    
    @IBOutlet weak var messageBtn: UIButton!
    
    
    var delegate : YQOtherHomeNavViewDelegate?
    
    var otherHomeNavArray = [HomeBtnView]()
    
    @IBAction func messageBtnClick(_ sender: UIButton) {
        
        self.delegate?.OtherHomeNavViewMessageBtnClick()
        
    }
    
    
    override func awakeFromNib() {
        
        self.otherHomeNavArray = [top1BtnView,top2BtnView,top3BtnView,top4BtnView]
    }
    

}
