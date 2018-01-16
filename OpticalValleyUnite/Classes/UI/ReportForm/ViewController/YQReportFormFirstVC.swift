//
//  YQReportFormFirstVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/1/16.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQReportFormFirstVC: UIViewController {

    var parkID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "工作日志"
        
        //获取项目parkID的情况
        let _ = setUpProjectNameLable()
        
        if self.parkID == "" {
            
            let project = UIStoryboard.instantiateInitialViewController(name: "YQAllProjectSelect")
            navigationController?.pushViewController(project, animated: true)
        }

    }
    
    @IBAction func reportFormSelectClick(_ sender: UIButton) {
        
        switch sender.tag {
        case 0://日报的界面列表
            
            break
        case 1://周报的界面列表
            
            break
        case 2://月报的界面列表
            
            break
        default:
            break
        }
        
        
    }
    
    // MARK: - 添加默认的项目选择方法
    func setUpProjectNameLable() -> String{
        
        let dic = UserDefaults.standard.object(forKey: Const.YQProjectModel) as? [String : Any]
        
        var projectName  = ""
        
        if dic != nil {
            
            projectName = dic?["PARK_NAME"] as! String
            self.parkID = dic?["ID"] as! String
            
        }else{
            
            projectName = "请选择默认项目"
        }
        
        return projectName
    }

    

  
}
