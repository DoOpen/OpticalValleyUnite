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
                
                var photoImage = [Photo]()
                
                for url in model.pictures{
                    
                    if url == ""{
                        
                        continue
                    }
                    
                    var photo = Photo()
                    
                    let basicPath = URLPath.systemSelectionURL
                    
                    if url.contains("http") {
                        
                        temp.append(url)
                        photo = Photo.init(urlString: url)
                        
                    }else{
                        
                        let imageValue = basicPath.replacingOccurrences(of: "/api/", with: "") + "/" + url
                        
                        temp.append(imageValue)
                        
                        photo = Photo.init(urlString: imageValue)
                    }
                    
                    photoImage.append(photo)
                    
                }
                
                if temp.isEmpty{
                    
                    showImageviewHeithConstraint.constant = 60.0
                    showImageView.setNeedsLayout()
                    
                }else{
                    
                    showImageviewHeithConstraint.constant = 70.0
                    showImageView.setNeedsLayout()
                    showImageView.showImageUrls(temp)
                    
                    showImageView.didClickHandle = { index, image in
                        
                        //框架替换_功能
                        //CoverView.show(image: image)
                        let pb = PhotoBrowser(photos: photoImage , currentIndex: 0)
                        pb.indicatorStyle = .pageControl
                        SJKeyWindow?.rootViewController?.present(pb, animated: true, completion: nil)
                    }
                
                }
                
                setNeedsLayout()
                setNeedsDisplay()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
    }

    

    
}
