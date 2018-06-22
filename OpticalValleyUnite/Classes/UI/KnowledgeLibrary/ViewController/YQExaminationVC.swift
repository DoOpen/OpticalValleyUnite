//
//  YQExaminationVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/5/3.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQExaminationVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1.init
        self.title = "考试"
        

    }
    
    // MARK: - 各个按钮点击的方法
    //参加考试
    @IBAction func joinExaminationButtonClick(_ sender: UIButton) {
        
        let vc = YQPublicExaminationTVC.init(nibName: "YQPublicExaminationTVC", bundle: nil)
        vc.cellType = 1
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    //我的成绩
    @IBAction func myScoreButtonClick(_ sender: UIButton) {
        
        let vc = YQPublicExaminationTVC.init(nibName: "YQPublicExaminationTVC", bundle: nil)
        vc.cellType = 2
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    //考试记录
    @IBAction func examRecordsButtonClick(_ sender: UIButton) {
        
        let vc = YQPublicExaminationTVC.init(nibName: "YQPublicExaminationTVC", bundle: nil)
        vc.cellType = 3
        
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    


}
