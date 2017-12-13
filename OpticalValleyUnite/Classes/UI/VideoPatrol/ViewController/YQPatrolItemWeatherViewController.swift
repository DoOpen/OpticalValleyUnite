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
    
    @IBOutlet weak var addImageView: SJAddView!
    
    @IBOutlet weak var remarkView: SJTextView!
    
    @IBOutlet weak var bottomView: UIView!
    
    /// 添加底部type项
    var bottomType = ""
    
    var contentIndex : Int?
    
    /// 数据模型设置数据传递参数
    var model : YQPatrolItemModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置remarkView
        self.remarkView.placeHolder = "巡查意见"
        
        self.constraintViewHeight.constant = 800
        
        self.patrolTypeLabel.text = model?.insItemTypeName
        self.patrolItemLabel.text = model?.name
        self.descriptionLabel.text = model?.descriptionString
        if model?.imgPath != nil{
            
            self.addImageButton.kf.setImage(with: URL.init(string: (model?.imgPath)!), for: .normal )
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
            
            DispatchQueue.main.async {
                
                sender.setImage(image, for: .normal)
            }

            
        }, viewController: (SJKeyWindow?.rootViewController ))
        
    }

}

extension YQPatrolItemWeatherViewController : YQPatrolBottomNextViewDelegate{
    
    func PatrolBottomNextViewCancel() {
        
    }
    
    
    func PatrolBottomNextViewSaveAndNext() {
        
        let center = NotificationCenter.default
        let notiesName = NSNotification.Name(rawValue: "NextViewNextNoties")
        center.post(name: notiesName, object: nil, userInfo:
            ["currentContentSize" : self.contentIndex! + 1])
        
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
        
        
    }
    
    func PatrolBottomLastViewSubmit() {
        
        
    }
    
    
}

