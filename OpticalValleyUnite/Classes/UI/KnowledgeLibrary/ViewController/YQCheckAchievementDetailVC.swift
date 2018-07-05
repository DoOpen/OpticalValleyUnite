//
//  YQCheckAchievementDetailVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/6/27.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQCheckAchievementDetailVC: UIViewController {

    //题目view
    @IBOutlet weak var scrollContentView: UIView!
    
    @IBOutlet weak var scrollContentHightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var answerTitleLabel: UILabel!
    
    @IBOutlet weak var answerLabel: UILabel!
    
    
    // MARK: - 底部按钮组
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var returnBtn: UIButton!
    
    @IBOutlet weak var bottomHightConstraint: NSLayoutConstraint!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1.init
        self.title = ""
        
    
    }


    // MARK: - 点击下一题
    @IBAction func nextButtonClick(_ sender: UIButton) {
        
        
    }
    
    // MARK: - 点击上一题
    @IBAction func upButtonClick(_ sender: UIButton) {
        
        
    }
    
    // MARK: - 最后点击返回按钮的情况
    @IBAction func returnButtonClick(_ sender: UIButton) {
        
        //达到最后一题之后点击,返回按钮
        self.navigationController?.popViewController(animated: true)

    }
    

}
