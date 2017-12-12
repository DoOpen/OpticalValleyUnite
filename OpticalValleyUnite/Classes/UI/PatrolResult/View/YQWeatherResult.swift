//
//  YQWeatherResult.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/12/12.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit

class YQWeatherResult: UIView {

    @IBOutlet weak var patrolType: UILabel!

    @IBOutlet weak var describeLabel: UILabel!

    @IBOutlet weak var pictureButton: UIButton!
    
    @IBOutlet weak var yesBtn: UIButton!
    
    @IBOutlet weak var noBtn: UIButton!
    
    @IBOutlet weak var itemImageView: SJAddView!
    
    @IBOutlet weak var remarkView: UITextView!
    
    
    //数据模型
    var model : YQResultDetailModel?{
        
        didSet{
            
            self.patrolType.text = model?.insItemTypeName
            self.describeLabel.text = model?.descriptionString
            if model?.imgPath != ""{
                
                self.pictureButton.kf.setImage(with: URL.init(string: (model?.imgPath)!), for: .normal)
                
            }
            
            if model?.feedback != "" {
                
                self.remarkView.text =  model?.feedback
                
            }else{
                
                self.remarkView.text = "巡查意见:"
            }

        }
    
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.remarkView.isEditable = false
        
    }
}
