//
//  YQWorkHighlightsDetailCell.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/1/19.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQWorkHighlightsDetailCell: UITableViewCell {
    
    /// 属性列表
    @IBOutlet weak var highlightImageV: UIImageView!
    
    @IBOutlet weak var highlightLabel: UILabel!
    
    @IBOutlet weak var workHighlightImage: ShowImageView!
    
    @IBOutlet weak var lightspotTitleLabel: UILabel!
    
    @IBOutlet weak var lightspotContentText: SJTextView!
    
    @IBOutlet weak var lightsportBottomLabel: UILabel!
    
    @IBOutlet weak var createTimeLabel: UILabel!
    
    //传索引
    var indexPath : IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        
    }
    
    var model : YQWorkHighlightsDetailShowModel?{
        
        didSet{
            //1.设置亮点的图片
            self.highlightImageV.image = UIImage.init(name: "img_light")
            highlightLabel.text = "亮点" + "\((indexPath?.row)! + 1)"
            
            if model?.imgPaths != "" {
                
                var temp = [String]()
                
                let array =  model?.imgPaths.components(separatedBy: ",")
                
                for tempIndex in array!{
                    
                    if (tempIndex.contains("http")){
                        
                        temp.append((tempIndex))
                        
                    }else {
                        
                        let basicPath = URLPath.systemSelectionURL
                        let imageValue = basicPath.replacingOccurrences(of: "/api/", with: "") + "/" + (tempIndex)
                        temp.append(imageValue)
                    }
                    
                }
                
                workHighlightImage.showImageUrls(temp)
                
                workHighlightImage.didClickHandle = { index, image in
                    
                    CoverView.show(image: image)
                }

            }
            
            lightspotTitleLabel.text = model?.lightspotTitle
            
            lightspotContentText.text = model?.lightspotContent
            
            //直接填写的是项目的id
            lightsportBottomLabel.text = model?.parkName
            
            createTimeLabel.text = model?.createTime
        }
        
    }

  
}
