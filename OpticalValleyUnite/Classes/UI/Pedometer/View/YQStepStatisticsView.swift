//
//  YQStepStatisticsView.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/11/13.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit
import Kingfisher

class YQStepStatisticsView: UITableViewCell {
    
    // MARK: - step的cell属性
    @IBOutlet weak var indexLabel: UILabel!
    
    @IBOutlet weak var indexHeadImageV: UIImageView!
    
    @IBOutlet weak var userHeadImageV: UIImageView!

    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var subTitleLabel: UILabel!
    
    @IBOutlet weak var stepTotallCountLabel: UILabel!
    
    // 显示开头排序图片的显示和隐藏
    var indexHeadImageHidde = true
    
    var type = -1
    
    var model : YQStepShowModel?{
        
        didSet{
            
            self.indexLabel.text = "\(String(describing: model?.rankno))"
            switch model!.rankno {
                case 1:
                    indexHeadImageHidde = false
                    self.indexHeadImageV.image = UIImage(named: "1_one")
                
                case 2:
                    indexHeadImageHidde = false
                    self.indexHeadImageV.image = UIImage(named: "2_one")
                
                case 3:
                    indexHeadImageHidde = false
                    self.indexHeadImageV.image = UIImage(named: "3_one")
                
                default:
                    break
            }
            
            self.indexHeadImageV.isHidden = indexHeadImageHidde
            
            //要求的imageView裁剪成为圆形
            let url = URL(string: (model?.avatar)!)
            
            self.userHeadImageV.kf.setImage(with: url, placeholder: UIImage.init(named: "userIcon"), options: nil
                , progressBlock: nil, completionHandler: nil)
            
            
            self.userNameLabel.text = model?.name
            
            //subTitle 是要求通过不同的type 来进行的赋值的
            switch self.type {
            case 1:
                self.subTitleLabel.text = model?.project
                
            case 2:
                self.subTitleLabel.text = model?.department

            case 3:
                self.subTitleLabel.text = model?.position
                
            default:
                break
            }
            
            self.stepTotallCountLabel.text = "\(String(describing: model?.steps))"
            
        }
        
    }
  
}
