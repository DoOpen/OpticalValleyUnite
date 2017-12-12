//
//  YQScoreResult.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/12/12.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit
import Kingfisher

class YQScoreResult: UIView {

    @IBOutlet weak var patrolTypeLabel: UILabel!
    
    @IBOutlet weak var describeLabel: UILabel!
    
    @IBOutlet weak var pictureButton: UIButton!

    @IBOutlet weak var itemPictureView: SJAddView!
    
    @IBOutlet weak var remarkView: UITextView!
    
    
    //数据模型
    var model : YQResultDetailModel?{
        didSet{
            
            self.patrolTypeLabel.text = model?.insItemTypeName
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
