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
    
    @IBOutlet weak var itemImageView: ShowImageView!
    
    @IBOutlet weak var remarkView: UITextView!
    
    
    //数据模型
    var model : YQResultDetailModel?{
        
        didSet{
            
            self.patrolType.text = model?.insItemTypeName
            self.describeLabel.text = model?.descriptionString
            
            if model?.imgPath != ""{
                
                var imageValue = ""
                
                if (model?.imgPath.contains("http"))!{
                    
                    imageValue = (model?.imgPath)!
                    
                }else{
                    
                    let basicPath = URLPath.basicPath
                    imageValue = basicPath.replacingOccurrences(of: "/api/", with: "") + "/" + (model?.imgPath)!
                }
                
                
                self.pictureButton.kf.setImage(with: URL.init(string: imageValue), for: .normal)
                
            }
            
            
            if model?.feedback != "" {
                
                self.remarkView.text =  model?.feedback
                
            }else{
                
                self.remarkView.text = "巡查意见:"
            }
            
            //showimages组内容
            if model?.itemImgPath != "" {
                
                let images = model?.itemImgPath.components(separatedBy: ",")
                
                var temp = [String]()
                
                for url in images!{
                    
                    let basicPath = URLPath.basicPath
                    let imageValue = basicPath.replacingOccurrences(of: "/api/", with: "") + "/" + url
                    temp.append(imageValue)
                }
                
                itemImageView.showImageUrls(temp)
                
                itemImageView.didClickHandle = { index, image in
                    
                    CoverView.show(image: image)
                    
                }

            }
            

        }
    
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.remarkView.isEditable = false
        
    }
}
