//
//  YQFeedDetailVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/4/2.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit
import SVProgressHUD

class YQFeedDetailVC: UIViewController {
    
    var feedDetailID : String = ""

    @IBOutlet weak var headViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var showImageView: ShowImageView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //1.init设置
        self.title = "反馈详情"
        
        //2.获取详情数据
        getDetailDataForService()

    }
    
    // MARK: - 获取的详情的界面数据
    func getDetailDataForService(){
        
        var par = [String : Any]()
        par["id"] = self.feedDetailID
        
        SVProgressHUD.show()
        
        HttpClient.instance.post(path: URLPath.getFeedbackDetail, parameters: par, success: { (response) in
            
            SVProgressHUD.dismiss()
            //获取相应的数据显示
            let data = response["feedbackDetail"] as? [String : Any]
            
            if data == nil {
                
                SVProgressHUD.showError(withStatus: "没有加载更多数据!")
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
            
            //约束回归
            self.headViewConstraint.constant = self.timeLabel.maxY + 10
            self.view.setNeedsDisplay()
            
        }) { (error) in
            
            SVProgressHUD.showError(withStatus: "网络数据加载失败,请检查网络!")
        }
    }
    


}
