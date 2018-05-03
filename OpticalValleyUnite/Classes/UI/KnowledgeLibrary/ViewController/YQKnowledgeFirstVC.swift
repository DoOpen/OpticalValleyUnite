//
//  YQKnowledgeFirstVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/5/3.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQKnowledgeFirstVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1.init
        self.title = "知识库"
        

    }

    // MARK: - buttonClick跳转界面的方法
    // 培训
    @IBAction func trainButtonClick(_ sender: Any) {
        let vc = YQStudyContentVC.init(nibName: "YQStudyContentVC", bundle: nil)
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    // 考试
    @IBAction func examButtonClick(_ sender: UIButton) {
        
        let vc = YQExaminationVC.init(nibName: "YQExaminationVC", bundle: nil)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    


}


