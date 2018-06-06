//
//  YQHomeContentView.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/6/5.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

protocol YQHomeContentViewDelegate {
    //全部按钮点击完成
    func homeContentViewAllButtonClick(view : UIView)
    
}

class YQHomeContentView: UIView {

    var downBtnViewArray = [HomeBtnView]()
    
    var delegate : YQHomeContentViewDelegate?
    
    @IBOutlet weak var donw1BtnView: HomeBtnView!
    
    @IBOutlet weak var donw2BtnView: HomeBtnView!
    
    @IBOutlet weak var donw3BtnView: HomeBtnView!
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
       
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        downBtnViewArray = [donw1BtnView,donw2BtnView,donw3BtnView]
    }
    
    @IBAction func allBtnClick(_ sender: UIButton) {
        
        self.delegate?.homeContentViewAllButtonClick(view: self)
        
    }
    

}
