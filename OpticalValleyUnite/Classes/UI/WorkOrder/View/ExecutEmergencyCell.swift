//
//  ExecutEmergencyCell.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/6/9.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit

class ExecutEmergencyCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var showImageviewHeithConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var showImageView: ShowImageView!
    
    @IBOutlet weak var remaskDetailLabel: UILabel!
    
    
    var detailModel :WorkOrderDetailModel?
    var model: WorkHistoryModel?{
        didSet{
            if let model = model{
                nameLabel.text = "执行人: " + model.person_name
                contentLabel.text = model.content
                timeLabel.text = model.time
                remaskDetailLabel.text = "备注:" + model.text
                
                var temp = [String]()
                for url in model.pictures{
                    
                    if url == ""{
                        continue
                    }
                    
                    let basicPath = URLPath.basicPath
                    let imageValue = basicPath.replacingOccurrences(of: "/api/", with: "") + url
                    temp.append(imageValue)
                }
                
                if temp.isEmpty{
                    showImageviewHeithConstraint.constant = 60.0
                    showImageView.setNeedsLayout()
                }else{
                    showImageviewHeithConstraint.constant = 70.0
                    showImageView.setNeedsLayout()
                    showImageView.showImageUrls(temp)
                    
                    showImageView.didClickHandle = { index, image in
                        CoverView.show(image: image)
                }
                
//                    for constraint in contentLabel.constraints{
//                        
//                    }
                

                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
    }

    

    
}
