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
    
    @IBOutlet weak var itemNumLabel: UILabel!
    
    @IBOutlet weak var patrolTypeLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var imageButton: UIButton!
    
    @IBOutlet weak var starsView: UIView!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var addImageView: SJAddView!
    
    @IBOutlet weak var textView: SJTextView!
    
    @IBOutlet weak var bottomView: UIView!
    
    var contentIndex : Int?
    
    /// 添加底部type项
    var bottomType = ""
    
    var selectStarsBtn : UIButton?{
        didSet{
            //设置打分label的情况
            self.scoreLabel.text = "\(((selectStarsBtn?.tag)! + 1) * 20)" + "分"
        
        }
    
    }
    
    
    /// 数据模型设置数据传递参数
    var model : YQPatrolItemModel?
    
    
    // MARK: - 视图生命周期的方法
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.constraintHeight.constant = 800
//        self.scrollVIEW.contentSize = CGSize.init(width: 0, height: self.constraintHeight.constant)
        
        
        self.textView.placeHolder = "巡查意见"
        
        self.patrolTypeLabel.text = model?.insItemTypeName
        self.patrolItemLabel.text = model?.name
        self.descriptionLabel.text = model?.descriptionString
        
        if model?.imgPath != nil{
            
            self.imageButton.kf.setImage(with: URL.init(string: (model?.imgPath)!), for: .normal )
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
            
            
            DispatchQueue.main.async {
                
                sender.setImage(image, for: .normal)
            }
            
        }, viewController: (SJKeyWindow?.rootViewController ))
        
    }
}

extension YQPatrolItemScoreViewController : YQPatrolBottomNextViewDelegate{
    
    func PatrolBottomNextViewCancel() {
        
    }
    

    func PatrolBottomNextViewSaveAndNext() {
        
        let center = NotificationCenter.default
        let notiesName = NSNotification.Name(rawValue: "NextViewNextNoties")
        center.post(name: notiesName, object: nil, userInfo:
            ["currentContentSize" : self.contentIndex! + 1])
        
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
        
        
    }
    
    func PatrolBottomLastViewSubmit() {
        
        
    }
    
    
}
