//
//  YQPatrolItemWeatherViewController.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/12/8.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit
import Kingfisher
import SVProgressHUD
import SnapKit

class YQPatrolItemWeatherViewController: UIViewController {
    
    ///属性列表情况
    
    @IBOutlet weak var constraintViewHeight: NSLayoutConstraint!

    @IBOutlet weak var patrolItemLabel: UILabel!
    
    @IBOutlet weak var itemNumLabel: UILabel!
    
    @IBOutlet weak var patrolTypeLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var yesButton: UIButton!
    
    @IBOutlet weak var noButton: UIButton!
    
    @IBOutlet weak var addImageButton: UIButton!
    
    @IBOutlet weak var addImageView: YQAddView!
    
    @IBOutlet weak var remarkView: SJTextView!
    
    @IBOutlet weak var bottomView: UIView!
    
    /// 添加底部type项
    var bottomType = ""
    
    var contentIndex : Int?
    
    var prameterDict : NSDictionary?
    
    /// 数据模型设置数据传递参数
    var model : YQPatrolItemModel?
    
    /// 保存图片的属性列表
    var pictureImageString = ""
    var pictureItemImageString = ""
    
    /// 获取parkID
    var parkId = ""
    
    var insResultId : Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addImageView.superVC = self
        
        //设置remarkView
        self.remarkView.placeHolder = "巡查意见"
        
        self.constraintViewHeight.constant = 800
        
        let _ = setUpProjectNameLable()
        
        self.patrolTypeLabel.text = model?.insItemTypeName
        self.patrolItemLabel.text = model?.name
        self.descriptionLabel.text = model?.descriptionString
        if model?.imgPath != nil{
            
            var imageValue = ""
            
            if (model?.imgPath.contains("http"))!{
                
                imageValue = (model?.imgPath)!
                
            }else{
                
                let basicPath = URLPath.systemSelectionURL
                imageValue = basicPath.replacingOccurrences(of: "/api/", with: "") + "/" + (model?.imgPath)!
            }
        
            self.addImageButton.kf.setImage(with: URL.init(string: (imageValue)), for: .normal )
        }
        
        //加载底部的项目
        switch bottomType {
        case "last":
            
            let view = Bundle.main.loadNibNamed("YQPatrolBottomLastView", owner: nil, options: nil)?[0] as! YQPatrolBottomLastView
//            view.frame = self.bottomView.bounds
            bottomView.addSubview(view)
            view.delegate = self
            view.snp.makeConstraints({ (make) in
                
                make.top.left.right.bottom.equalToSuperview()
            })
            
            break
            
        case "next":
            
            let view = Bundle.main.loadNibNamed("YQPatrolBottomNextView", owner: nil, options: nil)?[0] as! YQPatrolBottomNextView
//            view.frame = bottomView.bounds
            view.delegate = self
            
            bottomView.addSubview(view)
            view.snp.makeConstraints({ (make) in
                
                make.top.left.right.bottom.equalToSuperview()
            })

            break
        default:
            break
        }

    }
    
    // MARK: - 选择buttonclick的点击事件
    @IBAction func yesButtonClick(_ sender: UIButton) {
        sender.isSelected = true
        self.noButton.isSelected = false
        
    }
    
    @IBAction func noButtonClick(_ sender: UIButton) {
        sender.isSelected = true
        self.yesButton.isSelected = false
        
    }
    
    @IBAction func addPictureButtonClick(_ sender: UIButton) {
        //调用相册选择图片
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

extension YQPatrolItemWeatherViewController : YQPatrolBottomNextViewDelegate{
    
    func PatrolBottomNextViewCancel() {
        
        //现在 暂时没有处理
        
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
        if self.yesButton.isSelected {
            par["score"] = 1
            
        }else{
            
            par["score"] = 0
        }
        
        
        par["feedback"] = self.remarkView.text
        
        par["parkId"] = self.parkId
        
        par["insItemId"] = self.model?.insItemId
        
        par["insResultId"] = self.insResultId
        
        let images = addImageView.photos.map{$0.image}
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

extension YQPatrolItemWeatherViewController : YQPatrolBottomLastViewDelegate{
    
    func PatrolBottomLastViewUpward() {
        
        let center = NotificationCenter.default
        let notiesName = NSNotification.Name(rawValue: "NextViewNextNoties")
        center.post(name: notiesName, object: nil, userInfo:
            ["currentContentSize" : self.contentIndex! - 1])
        
        
    }
    
    func PatrolBottomLastViewCancel() {
        //取消,暂时不做处理
        
    }
    
    func PatrolBottomLastViewSubmit() {
        //保存当前页的图片,文本的信息
        //保存当前页的图片,文本的信息
        var par = [String : Any]()
        //有就可传项
        par["orbitId"] = prameterDict?["orbitId"]
        par["insWayId"] = prameterDict?["insWayId"]
        par["insPointId"] = prameterDict?["insPointId"]
        par["pointType"] = prameterDict?["pointType"]
        
        par["checkType"] = self.model?.checkType
        if self.yesButton.isSelected {
            par["score"] = 1
            
        }else{
            
            par["score"] = 0
        }
        
        
        par["feedback"] = self.remarkView.text
        par["parkId"] = self.parkId
        
        par["insItemId"] = self.model?.insItemId
        
        par["insResultId"] = self.insResultId
        //        par["id"] =

        let images = addImageView.photos.map{$0.image}
        self.upDataImage(images , complit: { (url) in
            //重新进行图片的下载,赋值
            self.pictureImageString = url
            par["imgPaths"] = self.pictureImageString

            SVProgressHUD.show()
            
            HttpClient.instance.post(path: URLPath.getVideoItemSaveResult, parameters: par, success: { (response) in
                
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

