//
//  ExecuteDetailSubImageCell.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/6/7.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit
import Kingfisher

class ExecuteDetailSubImageCell: UITableViewCell {

    @IBOutlet weak var showImageView: ShowImageView!
   
    
    @IBOutlet weak var imageHeightConstrait: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pictureView: UIImageView!
    var index = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tap = UITapGestureRecognizer(target: self, action: #selector(ExecuteDetailSubImageCell.imageViewClick))
        pictureView.addGestureRecognizer(tap)
        pictureView.isUserInteractionEnabled = true
    }
    
    var model: ExecChild?{
        didSet{
            if let model = model{
                titleLabel.text = "\(index))" + model.name
                if model.imageValue != "" {
                    
                    let arry = model.imageValue.components(separatedBy: ",")
                    let imagesUrls = arry.map{ (url) -> String in
                        let basicPath = URLPath.basicPath
                        let imageValue = basicPath.replacingOccurrences(of: "/api/", with: "") + url
                        return imageValue
                    }
                    if arry.isEmpty{
                        let basicPath = URLPath.basicPath
                        let imageValue = basicPath.replacingOccurrences(of: "/api/", with: "") + model.imageValue
                        showImageView.showImageUrls([imageValue])
                    }else{
                        showImageView.showImageUrls(imagesUrls)
                    }
                    showImageView.didClickHandle = { _,image in
                        CoverView.show(image: image)
                        
                    }
                    
                    
//                    pictureView.kf.setImage(with: URL(string: imageValue))
                    imageHeightConstrait.constant = 76.0
                }else{
                    imageHeightConstrait.constant = 0.0
                }
                
                setNeedsLayout()
                setNeedsDisplay()
            }
        }
    }
    
    
    func imageViewClick() {
        if let image = pictureView.image{
            CoverView.show(image: image)
        }
        
    }
    
}
