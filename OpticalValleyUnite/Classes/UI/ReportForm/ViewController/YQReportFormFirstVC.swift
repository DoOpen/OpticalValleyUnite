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

        self.title = "工作报告"
        
        //获取项目parkID的情况
        let _ = setUpProjectNameLable()
        
        if self.parkID == "" {
            
            let project = UIStoryboard.instantiateInitialViewController(name: "YQAllProjectSelect")
            navigationController?.pushViewController(project, animated: true)
        }

    }
    
    @IBAction func reportFormSelectClick(_ sender: UIButton) {
        
        let reportVC = UIStoryboard.instantiateInitialViewController(name: "YQReportForm") as? YQReportFromViewController
        reportVC?.type = sender.tag
        
        switch sender.tag {
        case 1://日报的界面列表
            reportVC?.selectTitle = "日报"
            break
        case 2://周报的界面列表
            reportVC?.selectTitle = "周报"
            break
        case 3://月报的界面列表
            reportVC?.selectTitle = "月报"
            break
        default:
            break
        }
        
        
        
        navigationController?.pushViewController(reportVC!, animated: true)
    
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
