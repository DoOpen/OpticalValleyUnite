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

class YQPatrolItemWeatherViewController: UIViewController {

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
    
    
    /// 数据模型设置数据传递参数
    var model : YQPatrolItemModel?{
        
        didSet{
            
            
        }
        
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置remarkView
        self.remarkView.placeHolder = "巡查意见"
        
        self.patrolTypeLabel.text = model?.insItemTypeName
        self.patrolItemLabel.text = model?.name
        self.descriptionLabel.text = model?.descriptionString
        if model?.imgPath != nil{
            
            self.addImageButton.kf.setImage(with: URL.init(string: (model?.imgPath)!), for: .normal )
        }
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        //加载底部的项目
        switch bottomType {
        case "last":
            
            let view = Bundle.main.loadNibNamed("YQPatrolBottomLastView", owner: nil, options: nil)?[0] as! YQPatrolBottomLastView
            view.frame = self.bottomView.bounds
            bottomView.addSubview(view)
            
            break
            
        case "next":
            
            let view = Bundle.main.loadNibNamed("YQPatrolBottomNextView", owner: nil, options: nil)?[0] as! YQPatrolBottomNextView
            view.frame = bottomView.bounds
            bottomView.addSubview(view)
            
            break
        default:
            break
        }

        
    }


}
