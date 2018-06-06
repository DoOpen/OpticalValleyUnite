//
//  YQDefaultHomeNavView.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/6/5.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

protocol YQDefaultHomeNavViewDelegate  {
    
    func DefaultHomeNavViewProjectBtnClick()
    
    func DefaultHomeNavViewMessageBtnClick()
    
    func DefaultHomeNavViewWeatherBtnClick()
    
}

class YQDefaultHomeNavView: UIView {

    @IBOutlet weak var messageBtn: UIButton!
    
    @IBOutlet weak var weatherBtn: UIButton!
    
    @IBOutlet weak var projectBtn: UIButton!
    
    var delegate : YQDefaultHomeNavViewDelegate?
    
    // MARK: - 数据的按钮点击事件
    @IBAction func projectButtonClick(_ sender: UIButton) {
        
        self.delegate?.DefaultHomeNavViewProjectBtnClick()
    }
    
    @IBAction func weatherButtonClick(_ sender: UIButton) {
        
        self.delegate?.DefaultHomeNavViewWeatherBtnClick()
    }
    
    
    @IBAction func messageButtonClick(_ sender: UIButton) {
        
        self.delegate?.DefaultHomeNavViewMessageBtnClick()
        
    }
    
    
}
