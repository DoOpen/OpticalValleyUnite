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

    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var scrollViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var NOReplyTextVIEW: SJTextView!
    
    @IBOutlet weak var scrollContentView: UIView!
    
    var gmV : UIView?
    var mV : UIView?
    
    
    //反馈id
    var id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1.init
        self.title = "反馈详情"
        self.contentView.isHidden = true
        
        //2.获取网络数据
        self.getGenaralFeedBackDetailData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
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
            
            let gmID = data!["gmId"] as? String ?? "" //总经理
            
            let mID = data!["mId"] as? String ?? ""//经理
            
            //添加的是经理和总经理的批复内容的情况
            //动态加载xib批复内容:
            if(mID != "" && gmID != "" ){//经理 + 总经理
                //经理
                let mName = data!["mName"] as! String
                let mReplyContent = data!["mReplyContent"] as! String
                let mReplyTime = data!["mReplyTime"] as! String
                //总经理
                let gmName = data!["gmName"] as! String
                let gmReplyContent = data!["gmReplyContent"] as? String ?? ""
                let gmReplyTime = data!["gmReplyTime"] as? String ?? ""
                
                let v = Bundle.main.loadNibNamed("YQGeneralManagerReplyView", owner: nil, options: nil)?[0] as! YQGeneralManagerReplyView
                
                v.contentTitleTextV.text = mReplyContent
                v.nameLabel.text = "处理人: " + mName
                v.timeLabel.text = "处理时间: " + mReplyTime
                
                self.scrollContentView.addSubview(v)
                
                v.snp.makeConstraints({ (maker) in
                    
                    maker.top.equalTo(self.contentView.snp.top)
                    maker.left.equalTo(self.contentView.snp.left)
                    maker.right.equalTo(self.contentView.snp.right)
                    maker.height.equalTo(200)
                    
                })
                
                self.mV = v
                
                let gmv = Bundle.main.loadNibNamed("YQGeneralManagerReplyView", owner: nil, options: nil)?[0] as! YQGeneralManagerReplyView
                gmv.contentTitleTextV.text = gmReplyContent
                gmv.nameLabel.text = "处理人: " +  gmName
                gmv.timeLabel.text = "处理时间: " + gmReplyTime
                
                self.scrollContentView.addSubview(gmv)
                
                gmv.snp.makeConstraints({ (maker) in
                    
                    maker.top.equalTo(self.contentView.snp.bottom).offset(40)
                    maker.left.right.equalToSuperview().offset(5)
                    maker.right.equalToSuperview().offset(-5)
                    maker.height.equalTo(200)
                    
                })
                
                self.gmV = gmv
                
                self.view.setNeedsLayout()

            } else if (mID != ""){
                //只有经理批复
                //经理
                let mName = data!["mName"] as? String ?? ""
                let mReplyContent = data!["mReplyContent"] as? String ?? ""
                let mReplyTime = data!["mReplyTime"] as? String ?? ""
                let v = Bundle.main.loadNibNamed("YQGeneralManagerReplyView", owner: nil, options: nil)?[0] as! YQGeneralManagerReplyView
                
                v.contentTitleTextV.text = mReplyContent
                v.nameLabel.text = "处理人: " +  mName
                v.timeLabel.text = "处理时间: " + mReplyTime
                
                self.scrollContentView.addSubview(v)
                
                v.snp.makeConstraints({ (maker) in
                    maker.top.equalTo(self.contentView.snp.top)
                    maker.left.equalTo(self.contentView.snp.left)
                    maker.right.equalTo(self.contentView.snp.right)
                    maker.height.equalTo(200)
                })
                
                self.view.setNeedsLayout()
                
                self.mV = v

            }else if (gmID != ""){
                //只有总经理批复
                //总经理
                let gmName = data!["gmName"] as? String ?? ""
                let gmReplyContent = data!["gmReplyContent"] as? String ?? ""
                let gmReplyTime = data!["gmReplyTime"] as? String ?? ""
                
                let gmv = Bundle.main.loadNibNamed("YQGeneralManagerReplyView", owner: nil, options: nil)?[0] as! YQGeneralManagerReplyView
                gmv.contentTitleTextV.text = gmReplyContent
                gmv.nameLabel.text = "处理人: " +  gmName
                gmv.timeLabel.text = "处理时间: " + gmReplyTime
                
                self.scrollContentView.addSubview(gmv)
                
                gmv.snp.makeConstraints({ (maker) in
                    
                    maker.top.equalTo(self.contentView.snp.top)
                    maker.left.equalTo(self.contentView.snp.left)
                    maker.right.equalTo(self.contentView.snp.right)
                    maker.height.equalTo(200)
                    
                })
                
                self.gmV = gmv
                
                self.view.setNeedsLayout()

            }else if (mID != "" && gmID != ""){
                
                //都没有批复的情况
                self.contentView.isHidden = false
                self.NOReplyTextVIEW.placeHolder = "等待处理，未答复，请耐心等候，感谢您的反馈"
                self.view.setNeedsLayout()
                self.scrollViewHeightConstraint.constant = self.contentView.maxY + 20
            }
            

        }) { (error) in
            
            SVProgressHUD.showError(withStatus: "数据加载失败,请检查网络!")
        }
        
    }
    
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        if mV != nil && gmV != nil{
            
            self.scrollViewHeightConstraint.constant = contentView.maxY + 200 + 70
            
        }else if ( mV != nil){
            
            self.scrollViewHeightConstraint.constant = contentView.maxY + 70
            
        }else if (gmV != nil){
            
            self.scrollViewHeightConstraint.constant = contentView.maxY + 70
        }

    }
    
    

}
