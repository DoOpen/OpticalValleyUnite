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
                        
                        let basicPath = URLPath.systemSelectionURL
                        
                        if url.contains("http") {
                            
                            return url
                            
                        }else{
                        
                            let imageValue = basicPath.replacingOccurrences(of: "/api/", with: "") + "/" + url
                            
                            return imageValue
                        
                        }
                        
                    }
                    
                    if arry.isEmpty {//数组为 空的情况
                        
                        let basicPath = URLPath.systemSelectionURL
                        
                        if model.imageValue.contains("http") {
                            
                            showImageView.showImageUrls([model.imageValue])
                            
                        }else{
                            
                            let imageValue = basicPath.replacingOccurrences(of: "/api/", with: "") + "/" + model.imageValue
                            
                            showImageView.showImageUrls([imageValue])
                            
                        }
                        
                    }else{// 数组不为 空的情况
                        
                        showImageView.showImageUrls(imagesUrls)
                    }
                    
                    var photo = [Photo]()
                    
                    for url in imagesUrls {
                        
                        let p = Photo.init(urlString: url)
                        photo.append(p)
                        
                    }
                    
                    showImageView.didClickHandle = { _,image in
                        
                        //框架的重换操作--> 切换到轮播滚动的下载的操作
                        //CoverView.show(image: image)
                        
                        let pb = PhotoBrowser(photos: photo , currentIndex: 0)
                        
                        pb.indicatorStyle = .pageControl
                        
                        SJKeyWindow?.rootViewController?.present(pb, animated: true, completion: nil)

                    }
                    

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
