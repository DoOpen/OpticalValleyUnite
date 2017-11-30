//
//  AppraisalCell.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/6/3.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit

class AppraisalCell: UITableViewCell {

    @IBOutlet weak var sourceLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var photoView: ShowImageView!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var starsViews: UIView!
    
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        photoView.isUserInteractionEnabled = false
    }

    var model: WorkHistoryModel?{
        
        didSet{
            
            if let model = model{
                
                if model.type == "1"{ //发起人评价1，管理人评价2
                    sourceLabel.text = "报事人评价: "
                    nameLabel.text = "报事人: " + model.person_name
                    
                }else{
                    sourceLabel.text = "管理人评价: "
                    nameLabel.text = "管理人: " + model.person_name
                }
                
                contentLabel.text = "评价理由: " + model.content
                
                timeLabel.text = model.time
                
                photoView.isHidden = model.pictures.count == 0
                
                if model.pictures.count == 0{
                    
                    heightConstraint.constant = 0.0
                    
                }else{
                    
                    heightConstraint.constant = 50.0
                    
                }
                
                
                if model.source <= 0 {
                    
                    //解决model.source 的逻辑bug的 情况
                    model.source = 1
                    
                }else if model.source > 5{
                    
                    model.source =  model.source / 2
                }
                
                for i in 0...(model.source - 1){
                    
                    let star = starsViews.subviews[i] as! UIButton
                    star.isSelected = true
                }
                
                var temp = [String]()
                
                for url in model.pictures{
                    let basicPath = URLPath.basicPath
                    let imageValue = basicPath.replacingOccurrences(of: "/api/", with: "") + "/" + url
                    temp.append(imageValue)
                }
                
                
                photoView.showImageUrls(temp)
                
                photoView.didClickHandle = { index, image in
                    
                    CoverView.show(image: image)
                    
                }
                
            }
            
            setNeedsLayout()
            
            setNeedsDisplay()
            
        }
    }
    
}
