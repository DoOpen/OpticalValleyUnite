//
//  YQStarServiceVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/4/5.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit
import SVProgressHUD

class YQStarServiceVC: UIViewController {

    ///属性数据
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var useLabel: UILabel!
    
    @IBOutlet weak var starsView: UIView!
    
    @IBOutlet weak var beatContentLabel: UILabel!
    @IBOutlet weak var increaseContentLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var lastScoreLabel: UILabel!
    
    //二星到四星的label选项
    @IBOutlet weak var star2Label: UILabel!
    
    @IBOutlet weak var star3Label: UILabel!
    
    @IBOutlet weak var star4Label: UILabel!
    
    @IBOutlet weak var star5Label: UILabel!
    
    // MARK: - 控制器的生命周期方法
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //1.初始设置
        self.title = "星级分"
        self.iconImageView.layer.cornerRadius = 60
        self.iconImageView.layer.borderColor = UIColor.black.cgColor
        self.iconImageView.layer.borderWidth = 1.0
        self.iconImageView.layer.masksToBounds = true
        //2.数据加载
        setUpDataForService()
        
        setUpCurrentUser()
    }


    // MARK: - 加载网络数据
    func setUpDataForService(){
        
        SVProgressHUD.show()
        
        HttpClient.instance.post(path: URLPath.getScoreDetail, parameters: nil, success: { (response) in
            
            SVProgressHUD.dismiss()
            
            let data = response["scoreDetail"] as? [String : Any]
            
            if data == nil {
                SVProgressHUD.showError(withStatus: "没有更多数据!")
                return
            }
            
            //距离下一星级还差多少分
            let sequentialScore = data!["sequentialScore"] as? Int64 ?? 0
            self.increaseContentLabel.text = "比上次增长" + "\(sequentialScore)" + "分"
            
            //打败同仁
            let percent = data!["percent"] as? String ?? ""
            self.beatContentLabel.text = "恭喜你,您打败了" + percent + "的同仁!"
            
            //我的星级分
            let scoreNow = data!["scoreNow"] as? String ?? ""
            self.scoreLabel.text = scoreNow + "分"
            
            //距离下一个星级
            let needScore = data!["needScore"] as? Int ?? 0
            self.lastScoreLabel.text = "距离下一个星级还需要" + "\(needScore)" + "分"
            
            //显示的星级 数量(设置星级的数量)
            let star = data!["star"] as? Int ?? 0
            self.setStarView(index: star)
            
            //设置评分项 选项
            let rule = data!["rule"] as! [String : Any]
            let score1 = rule["score1"] as? String ?? ""
            let score2 = rule["score2"] as? String ?? ""
            let score3 = rule["score3"] as? String ?? ""
            let score4 = rule["score4"] as? String ?? ""
            
            self.star2Label.text = score1 + "分"
            self.star3Label.text = score2 + "分"
            self.star4Label.text = score3 + "分"
            self.star5Label.text = score4 + "分"
            
        }) { (error) in
            
            SVProgressHUD.showError(withStatus: "网络加载失败,请检查网络!")
        }
        
        
    }
    
    // MARK: - 执行starView的通用设置方法
    func setStarView(index : Int){
        
        var star = index
        if (star) <= 0 {
            //解决model.source 的逻辑bug的 情况
            star = 1
        }else if (star) > 5{
            star =  (star) / 2
        }
        
        for i in 0...((star) - 1){
            
            let starBtn = self.starsView.subviews[i] as! UIButton
            starBtn.isSelected = true
        }
        
    }
    
    // MARK: - 设置useIcon的内容信息
    func setUpCurrentUser(){

        let user = User.currentUser()
        
        if let user = user{
            
            useLabel.text = user.nickname
            
            if let url = user.avatar,url != ""{

                if url.contains("http") {
                    
                    iconImageView.kf.setImage(with: URL(string: url), placeholder: UIImage.init(name: "userIcon"), options: nil, progressBlock: nil, completionHandler: nil)
                    
                }else{
                    
                    let basicPath = URLPath.systemSelectionURL
                    let imageValue = basicPath.replacingOccurrences(of: "/api/", with: "") + "/" + url
                    
                    iconImageView.kf.setImage(with: URL(string: imageValue), placeholder: UIImage.init(name: "userIcon"), options: nil, progressBlock: nil, completionHandler: nil)
                }
            }
        }
    }
}
