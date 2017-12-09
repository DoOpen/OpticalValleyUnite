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
    
    /// 数据模型设置数据传递参数
    var model : YQPatrolItemModel?{
        
        didSet{
            
            self.patrolTypeLabel.text = model?.insItemTypeName
            self.patrolItemLabel.text = model?.name
            self.descriptionLabel.text = model?.descriptionString
            if model?.imgPath != ""{
                
                self.addImageButton.kf.setImage(with: URL.init(string: (model?.imgPath)!), for: .normal )
            }
            
        }
        
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置remarkView
        self.remarkView.placeHolder = "巡查意见"
        
    }


}
