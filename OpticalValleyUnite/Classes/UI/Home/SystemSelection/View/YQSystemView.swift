//
//  YQSystemView.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/9/6.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit
import SnapKit

class YQSystemView: UIView {
    
    
    var logoTitileLabel: UILabel!

    var logoImageView: UIImageView!
    
    
    override func awakeFromNib() {
        
        logoTitileLabel = UILabel()
        logoImageView = UIImageView()
        
        addSubview(logoImageView)
        addSubview(logoTitileLabel)
        
        logoImageView.snp.makeConstraints { (make
            ) in
            
            make.centerX.equalToSuperview()
            make.top.equalTo(20)
            make.width.equalTo(43)
            make.height.equalTo(38)
            
        }
        
        logoTitileLabel.snp.makeConstraints { (make) in
            
            make.centerX.equalToSuperview()
            make.top.equalTo(logoImageView.snp.bottom).offset(10)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            
        }
        
        logoTitileLabel.textAlignment = NSTextAlignment.center
        logoTitileLabel.numberOfLines = 0
//        logoTitileLabel.tintColor = UIColor.gray
        logoTitileLabel.font = UIFont.systemFont(ofSize: 11)
        
    }
    
    
}
