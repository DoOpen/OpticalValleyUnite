//
//  YQPatrolItemScoreViewController.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/12/8.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit
import Kingfisher
import SVProgressHUD
import SnapKit


class YQPatrolItemScoreViewController: UIViewController {
    
    ///属性的列表的情况
    @IBOutlet weak var scrollVIEW: UIScrollView!
    
    @IBOutlet weak var constraintHeight: NSLayoutConstraint!

    @IBOutlet weak var patrolItemLabel: UILabel!
    
    //总共项数
    @IBOutlet weak var itemNumLabel: UILabel!
    
    @IBOutlet weak var patrolTypeLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var imageButton: ShowImageView!
    
    @IBOutlet weak var starsView: UIView!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var addImageView: YQAddView!
    
    @IBOutlet weak var textView: SJTextView!
    
    @IBOutlet weak var bottomView: UIView!
    
    var contentIndex : Int?
    
    /// 保存图片的属性列表
    var pictureImageString = ""
    var pictureItemImageString = ""
    
    /// 添加底部type项
    var bottomType = ""
    
    var prameterDict : NSDictionary?
    
    var insResultId : Int?
    
    /// 获取parkID
    var parkId = ""
    
    var selectStarsBtn : UIButton?{
        didSet{
            //设置打分label的情况
            self.scoreLabel.text = "\(((selectStarsBtn?.tag)! + 1) * 20)" + "分"
        
        }
    
    }
    
    
    /// 数据模型设置数据传递参数
    var model : YQPatrolItemModel?
    var count : Int = 0
    
    // MARK: - 视图生命周期的方法
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.addImageView.superVC = self
        
        self.constraintHeight.constant = 800
//        self.scrollVIEW.contentSize = CGSize.init(width: 0, height: self.constraintHeight.constant)
        let _ = setUpProjectNameLable()
        
        self.textView.placeHolder = "巡查意见"
        
        self.patrolTypeLabel.text = model?.insItemTypeName
        self.patrolItemLabel.text = model?.name
        self.descriptionLabel.text = model?.descriptionString
        self.itemNumLabel.text = "共" + "\(count)" + "项"
        
        if model?.imgPath != nil{
            
            var imageValue = ""
            
            if (model?.imgPath.contains("http"))!{
                
                imageValue = (model?.imgPath)!
                
            }else{
                
                let basicPath = URLPath.systemSelectionURL
                imageValue = basicPath.replacingOccurrences(of: "/api/", with: "") + "/" + (model?.imgPath)!
            }

            
            self.imageButton.showImageUrls([imageValue])
            
            self.imageButton.didClickHandle = { index, image in
                
                CoverView.show(image: image)
            }

        }

        //加载底部的项目
        switch bottomType {
            
        case "last":
            
            let view = Bundle.main.loadNibNamed("YQPatrolBottomLastView", owner: nil, options: nil)?[0] as! YQPatrolBottomLastView
            
            view.delegate = self
            bottomView.addSubview(view)
            view.snp.makeConstraints({ (make) in
                
                make.top.left.right.bottom.equalToSuperview()
            })

            break
            
        case "next":
            
            let view = Bundle.main.loadNibNamed("YQPatrolBottomNextView", owner: nil, options: nil)?[0] as! YQPatrolBottomNextView
            //设置代理
            view.delegate = self
            
            bottomView.addSubview(view)
            view.snp.makeConstraints({ (make) in
                
                make.top.left.right.bottom.equalToSuperview()
            })
            
            break
            
        default:
            break
        }
        
        //评价按钮的点击情况
        setupStartView()
        
        //接受通知情况
        
        
    }
    
    
    // MARK: - 点击评分按钮的执行系列的方法
    func setupStartView(){
        
        for btn in starsView.subviews as! [UIButton]{
            btn.addTarget(self, action:  #selector(startBtnClick(sender:)), for: .touchUpInside)
        }
        
    }
    
    func startBtnClick(sender: UIButton){
        
        selectStarsBtn = sender
        for btn in starsView.subviews as! [UIButton]{
            btn.isSelected = btn.tag < sender.tag + 1
        }
    }

    // MARK: - buttonClick的方法
    @IBAction func pictureButtonClick(_ sender: UIButton) {
        
        SJTakePhotoHandle.takePhoto(imageBlock: { (image) in
            
            //直接的上传相应图片
            let images = [image]
            
            self.upDataImage(images as! [UIImage], complit: { (url) in
                //重新进行图片的下载,赋值
                let basicPath = URLPath.systemSelectionURL
                let imageValue = basicPath.replacingOccurrences(of: "/api/", with: "") + "/" + (url)
                
                self.pictureImageString = imageValue
                
                sender.kf.setImage(with: URL.init(string: imageValue), for: .normal)
                
            })
            
        }, viewController: (SJKeyWindow?.rootViewController ))
        
    }
    
    //MARK: - 上传图片的专门的接口
    func upDataImage(_ images: [UIImage], complit: @escaping ((String) -> ()),errorHandle: (() -> ())? = nil){
        
        SVProgressHUD.show(withStatus: "上传图片中...")
        
        HttpClient.instance.upLoadImages(images, succses: { (url) in
            
            SVProgressHUD.dismiss()
            
            complit(url!)
            
        }) { (error) in
            
            SVProgressHUD.dismiss()
            
            if let errorHandle = errorHandle{
                
                errorHandle()
            }
        }
    }

    // MARK: - 添加默认的项目选择方法
    func setUpProjectNameLable() -> String{
        
        let dic = UserDefaults.standard.object(forKey: Const.YQProjectModel) as? [String : Any]
        
        var projectName  = ""
        
        if dic != nil {
            
            projectName = dic?["PARK_NAME"] as! String
            self.parkId = dic?["ID"] as! String
            
            
        }else{
            
            projectName = "请选择默认项目"
        }
        
        return projectName
    }

    
    
}

extension YQPatrolItemScoreViewController : YQPatrolBottomNextViewDelegate{
    
    func PatrolBottomNextViewCancel() {
        //暂时不做处理,
        self.navigationController?.popViewController(animated: true)
        
    }
    

    func PatrolBottomNextViewSaveAndNext() {
        
        //保存当前页的图片,文本的信息
        var par = [String : Any]()
        //有就可传项
        par["orbitId"] = prameterDict?["orbitId"]
        par["insWayId"] = prameterDict?["insWayId"]
        par["insPointId"] = prameterDict?["insPointId"]
        par["pointType"] = prameterDict?["pointType"]
            
        par["checkType"] = self.model?.checkType
        if self.selectStarsBtn == nil {
            par["score"] = 1
            
        }else{
        
            par["score"] = (self.selectStarsBtn?.tag)! + 1
        }
        
        
        par["feedback"] = self.textView.text
        
        par["parkId"] = self.parkId
            
        par["insItemId"] = self.model?.insItemId
       
        par["insResultId"] = self.insResultId
//        par["id"] =

        let images = addImageView.photos.map{$0.image}
        
        if images.isEmpty {
            
            self.alert(message: "请添加上传图片")
            return
        }
        if self.textView.text == "" {
            
            self.alert(message: "请输入巡查意见")
            return
        }
        
        self.upDataImage(images , complit: { (url) in
            //重新进行图片的下载,赋值
            self.pictureImageString = url
            par["imgPaths"] = self.pictureImageString
            
            SVProgressHUD.show()
            
            HttpClient.instance.post(path: URLPath.getVideoItemSaveResult, parameters: par, success: { (response) in
                
                self.insResultId = response["insResultId"] as? Int ?? 0
                
                SVProgressHUD.showSuccess(withStatus: "保存成功!")
                SVProgressHUD.dismiss()
                
                DispatchQueue.main.async {
                    let center = NotificationCenter.default
                    let notiesName = NSNotification.Name(rawValue: "NextViewNextNoties")
                    center.post(name: notiesName, object: nil, userInfo:
                        ["currentContentSize" : self.contentIndex! + 1,"insResultId" : self.insResultId!])
                    
                }
                
            }) { (error) in
                
                SVProgressHUD.showError(withStatus: "提交保存失败,请检查网络!")
            }
            
        })
    }
    
    
}

extension YQPatrolItemScoreViewController : YQPatrolBottomLastViewDelegate{
    
    func PatrolBottomLastViewUpward() {
        
        let center = NotificationCenter.default
        let notiesName = NSNotification.Name(rawValue: "NextViewNextNoties")
        center.post(name: notiesName, object: nil, userInfo:
            ["currentContentSize" : self.contentIndex! - 1])

        
    }
    
    func PatrolBottomLastViewCancel() {
        //暂时不做处理
//        self.textView.text = ""
//        addImageView.photos.removeAll()
//        self.selectStarsBtn = nil
        self.navigationController?.popViewController(animated: true)

    }
    
    func PatrolBottomLastViewSubmit() {
        //保存当前页的图片,文本的信息
        var par = [String : Any]()
        //有就可传项
        par["orbitId"] = prameterDict?["orbitId"]
        par["insWayId"] = prameterDict?["insWayId"]
        par["insPointId"] = prameterDict?["insPointId"]
        par["pointType"] = prameterDict?["pointType"]
        
        par["checkType"] = self.model?.checkType
        if self.selectStarsBtn == nil {
            par["score"] = 1
            
        }else{
            
            par["score"] = (self.selectStarsBtn?.tag)! + 1
        }
        
        
        par["feedback"] = self.textView.text
        par["parkId"] = self.parkId
        
        par["insItemId"] = self.model?.insItemId
        
        par["insResultId"] = self.insResultId
        //        par["id"] =
        let images = addImageView.photos.map{$0.image}
        
        if images.isEmpty {
            
            self.alert(message: "请添加上传图片")
            return
        }
        
        if self.textView.text == "" {
            
            self.alert(message: "请输入巡查意见")
            return
        }
        
        self.upDataImage(images , complit: { (url) in
            //重新进行图片的下载,赋值
            self.pictureImageString = url
            par["imgPaths"] = self.pictureImageString

            SVProgressHUD.show()
            
            HttpClient.instance.post(path: URLPath.getVideoItemSaveResult, parameters: par, success: { (response) in
                
                self.insResultId = response["insResultId"] as? Int
                
                SVProgressHUD.showSuccess(withStatus: "保存成功!")
                SVProgressHUD.dismiss()
                //跳转到首页
                self.navigationController?.popViewController(animated: true)
                
            }) { (error) in
                
                SVProgressHUD.showError(withStatus: "提交保存失败,请检查网络!")
            }
        
        })
        
    }
    
    
    
}
