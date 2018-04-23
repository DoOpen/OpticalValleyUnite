//
//  YQGenaralManagerCheckDetailVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/4/14.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit
import SVProgressHUD

class YQGenaralManagerCheckDetailVC: UIViewController {

    //用户的权限
    var id = ""
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var feedBackLabel: UILabel!
    
    @IBOutlet weak var projectLabel: UILabel!
    
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var showImageView: ShowImageView!
    
    @IBOutlet weak var replyTextView: UITextView!
    
    @IBOutlet weak var isOnGmSwitch: UISwitch!
    
    @IBOutlet weak var scrollViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lastView: UIView!
    
    @IBOutlet weak var mReplyContent: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1.显示的执行的未处理的界面,字段
        self.title = "反馈处理"
        
        //2.获取数据
        getGenaralFeedBackDetailData()
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
            
            
            self.scrollViewHeightConstraint.constant = self.lastView.maxY + 30
            self.view.setNeedsLayout()
            
        }) { (error) in
            
            SVProgressHUD.showError(withStatus: "数据加载失败,请检查网络!")
        }
        
    }
    
    // MARK: - 提交批复接口
    func getReplyToService(){
        
        var par = [String : Any]()
        par["id"] = self.id
        par["mReplyContent"] = self.mReplyContent.text
        /*
         0不推送 1推送
         */
        if self.isOnGmSwitch.isOn{
            
            par["isPush"] = 1 //推送
            
        }else{
            
            par["isPush"] = 0 //不推送

        }
            
        SVProgressHUD.show()
        
        HttpClient.instance.post(path: URLPath.getEmailReply, parameters: par, success: { (response) in
            SVProgressHUD.dismiss()
            SVProgressHUD.showSuccess(withStatus: "批复成功!")
            self.navigationController?.popViewController(animated: true)
            
        }) { (error) in
            SVProgressHUD.showError(withStatus: "数据加载失败,请检查网络!")
        }
        
    }
    
    
    // MARK: - buttonClick方法点击
    @IBAction func makeSureButtonClick(_ sender: UIButton) {
        
        self.getReplyToService()
    }

    @IBAction func cancelButtonClick(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    

}
