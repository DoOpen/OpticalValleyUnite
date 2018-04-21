//
//  YQGenaralFeedBackDetailVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/4/21.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit
import SVProgressHUD
import SnapKit


class YQGenaralFeedBackDetailVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var showImageView: ShowImageView!

    
    //反馈id
    var id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1.init
        self.title = "反馈详情"
        
        //2.获取网络数据
        self.getGenaralFeedBackDetailData()
        
    }
    
    // MARK: - 获取反馈列表的数据
    func getGenaralFeedBackDetailData(){
        
        var par = [String : Any]()
        par["id"] = self.id
        
        SVProgressHUD.show()
        
        HttpClient.instance.post(path: URLPath.getgm_emailDetail, parameters: par, success: { (response) in
            
            SVProgressHUD.dismiss()
            let data = response["feedbackDetail"] as? [String : Any]
            
            if data == nil {
                SVProgressHUD.showError(withStatus: "没有更多数据!")
                return
            }
            
            self.titleLabel.text = data!["title"] as? String
            self.contentTextView.text = data!["content"] as? String
            self.timeLabel.text = data!["createTime"] as? String
            //回显图片
            let imageString = data!["images"] as? String
            //showimages组内容
            if imageString != nil {
                
                var photoImage = [Photo]()
                
                let images = imageString?.components(separatedBy: ",")
                
                var temp = [String]()
                
                for url in images!{
                    
                    var pUrl = Photo()
                    
                    if url.contains("http"){
                        
                        temp.append(url)
                        pUrl = Photo.init(urlString: url)
                        
                    }else{
                        
                        let basicPath = URLPath.systemSelectionURL
                        let imageValue = basicPath.replacingOccurrences(of: "/api/", with: "") + "/" + url
                        temp.append(imageValue)
                        pUrl = Photo.init(urlString: imageValue)
                        
                    }
                    
                    photoImage.append(pUrl)
                }
                
                self.showImageView.showImageUrls(temp)
                
                self.showImageView.didClickHandle = { index, image in
                    
                    //更换的框架; 添加, 滚动,缩放,下载保存
                    //CoverView.show(image: image)
                    
                    if imageString != "" {
                        
                        let pb = PhotoBrowser(photos: photoImage , currentIndex: 0)
                        pb.indicatorStyle = .pageControl
                        self.present(pb, animated: true, completion: nil)
                    }
                }
            }
            
            //动态加载xib批复内容:
            
            
            
        }) { (error) in
            
            SVProgressHUD.showError(withStatus: "数据加载失败,请检查网络!")
        }
        
    }
    
    

   

}
