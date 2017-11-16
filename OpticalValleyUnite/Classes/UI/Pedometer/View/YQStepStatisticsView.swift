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
            
            self.userHeadImageV.image = self.toCircle()
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
    
    // MARK: - 定义的圆形图框的内容
    func toCircle() -> UIImage {
        //取最短边长
        let shotest = min(self.userHeadImageV.size.width, self.userHeadImageV.size.height)
        //输出尺寸
        let outputRect = CGRect(x: 0, y: 0, width: shotest, height: shotest)
        
        //开始图片处理上下文（由于输出的图不会进行缩放，所以缩放因子等于屏幕的scale即可）
        UIGraphicsBeginImageContextWithOptions(outputRect.size, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        //添加圆形裁剪区域
        context.addEllipse(in: outputRect)
        context.clip()
        //绘制图片
        self.draw(CGRect(x: (shotest-self.size.width)/2,
                             y: (shotest-self.size.height)/2,
                             width: self.size.width,
                             height: self.size.height))
        //获得处理后的图片
        let maskedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return maskedImage
        
    }
  
}
