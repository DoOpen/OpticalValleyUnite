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
    
    /// 添加底部type项
    var bottomType = ""
    
    var selectStarsBtn : UIButton?{
        didSet{
            //设置打分label的情况
            
        
        }
    
    }
    
    
    /// 数据模型设置数据传递参数
    var model : YQPatrolItemModel?{
        
        didSet{
            //这里最开始的时候数据没有显示加载出来
        
        }
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
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
            

            bottomView.addSubview(view)
            view.snp.makeConstraints({ (make) in
                
                make.top.left.right.bottom.equalToSuperview()
            })

            
            break
            
        case "next":
            
            let view = Bundle.main.loadNibNamed("YQPatrolBottomNextView", owner: nil, options: nil)?[0] as! YQPatrolBottomNextView

            bottomView.addSubview(view)
            view.snp.makeConstraints({ (make) in
                
                make.top.left.right.bottom.equalToSuperview()
            })

            
            break
            
        default:
            break
        }

        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
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




}
