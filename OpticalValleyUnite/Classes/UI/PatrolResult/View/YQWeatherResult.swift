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

    @IBOutlet weak var pictureShowImageView: ShowImageView!
    
    @IBOutlet weak var yesBtn: UIButton!
    
    @IBOutlet weak var noBtn: UIButton!
    
    @IBOutlet weak var itemImageView: ShowImageView!
    
    @IBOutlet weak var remarkView: UITextView!
    
    @IBOutlet weak var scrollViewHeightConstraint: NSLayoutConstraint!
    
    
    //要求得到控制器的指针:
    var superVC : UIViewController?

    //数据模型
    var model : YQResultDetailModel?{
        
        didSet{
            
            self.patrolType.text = model?.insItemTypeName
            self.describeLabel.text = model?.descriptionString
            
            if model?.imgPath != "" {
                
                var photoImage = [Photo]()
                var pUrl = Photo()
                var imageValue = ""
                
                if (model?.imgPath.contains("http"))!{
                    
                    imageValue = (model?.imgPath)!
                    
                    pUrl = Photo.init(urlString: model?.imgPath)
                    
                }else{
                    
                    let basicPath = URLPath.systemSelectionURL
                    imageValue = basicPath.replacingOccurrences(of: "/api/", with: "") + "/" + (model?.imgPath)!
                    pUrl = Photo.init(urlString: imageValue)
                }
                
                var temp = [String]()
                temp.append(imageValue)
                photoImage.append(pUrl)
                
                pictureShowImageView.showImageUrls(temp)
                
                pictureShowImageView.didClickHandle = { index, image in
                    
                    //图片显示的框架的更新; 使用的是 下载保存, 缩放, 滚动
                    //CoverView.show(image: image)
                    if self.model?.imgPath != "" {
                        
                        let pb = PhotoBrowser(photos: photoImage , currentIndex: 0)
                        pb.indicatorStyle = .pageControl
                        self.superVC?.present(pb, animated: true, completion: nil)
                    }
                }

            }
            
            
            if model?.feedback != "" {
                
                self.remarkView.text =  model?.feedback
                
            }else{
                
                self.remarkView.text = "巡查意见:"
            }
            
            //showimages组内容
            if model?.itemImgPath != "" {
                
                var photoImage = [Photo]()
                var pUrl = Photo()

                let images = model?.itemImgPath.components(separatedBy: ",")
                
                var temp = [String]()
                
                for url in images!{
                    
                    if url.contains("http"){
                        
                        //空格转义情况!bug添加
                        let bUrl = url.replacingOccurrences(of: " ", with: "%20")
                        temp.append(bUrl)
                        pUrl = Photo.init(urlString: bUrl)
                        
                    }else{
                        
                        let basicPath = URLPath.systemSelectionURL
                        let imageValue = basicPath.replacingOccurrences(of: "/api/", with: "") + "/" + url
                        temp.append(imageValue)
                        pUrl = Photo.init(urlString: url)

                    }
                    
                    photoImage.append(pUrl)
                }
                
                itemImageView.showImageUrls(temp)
                
                itemImageView.didClickHandle = { index, image in
                    
                    //更换框架,使用的是 滚动,下载保存, 缩放
                    //CoverView.show(image: image)
                    if self.model?.itemImgPath != "" {
                        
                        let pb = PhotoBrowser(photos: photoImage , currentIndex: 0)
                        pb.indicatorStyle = .pageControl
                        self.superVC?.present(pb, animated: true, completion: nil)
                    }
                }
            }
            
            //设置评分的工作内容
            if model?.score == 1 {//显示的是 选中的情况
                self.yesBtn.isSelected = true
                self.noBtn.isSelected = false
            
            }else{//默认都是显示的 否
                self.yesBtn.isSelected = true
                self.noBtn.isSelected = false
                
            }

            self.setNeedsLayout()
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.remarkView.isEditable = false
        
    }
    
    
}
