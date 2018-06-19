//
//  YQScoreResult.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/12/12.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit
import Kingfisher

class YQScoreResult: UIView {

    @IBOutlet weak var patrolTypeLabel: UILabel!
    
    @IBOutlet weak var describeLabel: UILabel!
    
    @IBOutlet weak var pictureShowImageView: ShowImageView!
   
    @IBOutlet weak var itemPictureView: ShowImageView!
    
    @IBOutlet weak var remarkView: UITextView!
    
    @IBOutlet weak var starsViews: UIView!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    //要求得到控制器的指针:
    var superVC : UIViewController?
    
    
    //数据模型
    var model : YQResultDetailModel?{
        didSet{
            
            self.patrolTypeLabel.text = model?.insItemTypeName
            self.describeLabel.text = model?.descriptionString
            
            if model?.imgPath != ""{
                
                var photoImage = [Photo]()
                
                var pUrl = Photo()

                
                var imageValue = ""
                
                if (model?.imgPath.contains("http"))!{
                    
                    imageValue = (model?.imgPath)!
                    
                }else{
                    
                    let basicPath = URLPath.systemSelectionURL
                    imageValue = basicPath.replacingOccurrences(of: "/api/", with: "") + "/" + (model?.imgPath)!
                }
                
                var temp = [String]()
                temp.append(imageValue)
                pUrl = Photo.init(urlString: imageValue)
                photoImage.append(pUrl)
                
                pictureShowImageView.showImageUrls(temp)
                
                pictureShowImageView.didClickHandle = { index, image in
                    
                    //更换框架,添加的是 缩放,滚动,下载保存的框架
                    //CoverView.show(image: image)
                    
                    if self.model?.imgPath != ""{
                        
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
            
            //设置starsView的显示情况
            if (model?.score)! <= 0 {
                
                //解决model.source 的逻辑bug的 情况
                model?.score = 5
                
            }else if (model?.score)! > 5{
                
                model?.score =  (model?.score)! / 2
            }
            
            for i in 0...((model?.score)! - 1){
                
                let star = starsViews.subviews[i] as! UIButton
                star.isSelected = true
                
            }
            
            self.scoreLabel.text = "\((model?.score)! * 20)" + "分"

            //showimages组内容
            if model?.itemImgPath != "" {
                
                var photoImage = [Photo]()
                
                let images = model?.itemImgPath.components(separatedBy: ",")
                
                var temp = [String]()
                
                for url in images!{
                    
                    var pUrl = Photo()
                    
                    if url.contains("http"){
                        
                        //空格转义情况!bug添加
                        let bUrl=url.replacingOccurrences(of: " ", with: "%20")
                        
                        temp.append(bUrl)
                        pUrl = Photo.init(urlString: bUrl)
                        
                    }else{
                        
                        let basicPath = URLPath.systemSelectionURL
                        let imageValue = basicPath.replacingOccurrences(of: "/api/", with: "") + "/" + url
                        temp.append(imageValue)
                        pUrl = Photo.init(urlString: imageValue)

                    }
                    
                    photoImage.append(pUrl)
                }
                
                itemPictureView.showImageUrls(temp)
                
                itemPictureView.didClickHandle = { index, image in
                    
                    //更换的框架; 添加, 滚动,缩放,下载保存
                    //CoverView.show(image: image)
                    
                    if self.model?.itemImgPath != "" {
                    
                        let pb = PhotoBrowser(photos: photoImage , currentIndex: 0)
                        pb.indicatorStyle = .pageControl
                        self.superVC?.present(pb, animated: true, completion: nil)
                    
                    }

                }
            }
        }
    }
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.remarkView.isEditable = false
        
    }

    
}
