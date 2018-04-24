//
//  YQGenaralManagerCheckAlreadyDetailVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/4/23.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit
import SVProgressHUD

class YQGenaralManagerCheckAlreadyDetailVC: UIViewController {

    //用户的权限
    var id = ""
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var feedBackLabel: UILabel!
    
    @IBOutlet weak var projectLabel: UILabel!
    
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var showImageView: ShowImageView!
    
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var scrollViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var scrollContentView: UIView!
    
    @IBOutlet weak var contentViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var gmReplyContent: SJTextView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //1.显示的是 已处理的 执行界面
        self.title = "反馈处理"
        self.gmReplyContent.placeHolder = "意见已收到，已紧急处理，感谢您的反馈。"
        
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
            self.projectLabel.text = data!["parkName"] as? String
            self.feedBackLabel.text = data!["personName"] as? String
            
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

            let mID = data!["mId"] as? String ?? ""//经理
            //添加的是经理和总经理的批复内容的情况
            //动态加载xib批复内容:
            if (mID != ""){
                //只有经理批复
                //经理
                let mName = data!["mName"] as! String
                let mReplyContent = data!["mReplyContent"] as! String
                let mReplyTime = data!["mReplyTime"] as! String
                let v = Bundle.main.loadNibNamed("YQGeneralManagerReplyView", owner: nil, options: nil)?[0] as! YQGeneralManagerReplyView
                
                v.contentTitleTextV.text = mReplyContent
                v.nameLabel.text = "处理人: " +  mName
                v.timeLabel.text = "处理时间: " + mReplyTime
                
                self.scrollContentView.addSubview(v)
                
                v.snp.makeConstraints({ (maker) in
                    
                maker.top.equalTo(self.showImageView.snp.bottom).offset(20)
                    maker.left.right.equalToSuperview().offset(10)
                    maker.right.equalToSuperview().offset(-10)
                    maker.height.equalTo(200)
                    
                })
                
                self.contentViewTopConstraint.constant = 220 + 5
            }
            
            self.view.setNeedsLayout()
            
            self.scrollViewHeightConstraint.constant = self.contentView.maxY + 200
            
        }) { (error) in
            
            SVProgressHUD.showError(withStatus: "数据加载失败,请检查网络!")
        }
        
    }
    
    // MARK: - 提交批复接口
    func getReplyToService(){
        
        var par = [String : Any]()
        par["id"] = self.id
        par["gmReplyContent"] = self.gmReplyContent.text
        
        SVProgressHUD.show()
        
        HttpClient.instance.post(path: URLPath.getEmailReply, parameters: par, success: { (response) in
            SVProgressHUD.dismiss()
            SVProgressHUD.showSuccess(withStatus: "批复成功!")
            self.navigationController?.popViewController(animated: true)
            
        }) { (error) in
            
            SVProgressHUD.showError(withStatus: "数据加载失败,请检查网络!")
        }

    }
    
    // MARK: - buttonClick方法
    @IBAction func makeSureButtonClick(_ sender: UIButton) {
        
        //上传保存
        self.getReplyToService()
        
    }
    

    @IBAction func cancelButtonClick(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    


}
