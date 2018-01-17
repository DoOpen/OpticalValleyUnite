//
//  YQReportFormDetailVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/1/16.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQReportFormDetailVC: UIViewController {

    @IBOutlet weak var planLabel: UILabel!
    
    @IBOutlet weak var emergencyLabel: UILabel!
    
    @IBOutlet weak var spontaneousLabel: UILabel!
    
    @IBOutlet weak var darwView: YQDrawView!
    
    
    var selectTitle = ""
    var type : Int!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = selectTitle
        addRightBarButtonItem()
        
        
    }

    func addRightBarButtonItem(){
        
        switch type {
        case 1://日报
            let button = UIButton()
            button.frame = CGRect.init(x: 0, y: 0, width: 50, height: 40)
            button.setTitle("工作计划", for: .normal)
            button.setTitleColor(UIColor.gray, for: .normal)
            button.sizeToFit()
//            button.addTarget(<#T##target: Any?##Any?#>, action: <#T##Selector#>, for: <#T##UIControlEvents#>)
            
            let barItem = UIBarButtonItem()
            barItem.customView = button
            
            navigationItem.rightBarButtonItem = barItem
            
            break
        case 2://周报
            
            let button = UIButton()
            button.frame = CGRect.init(x: 0, y: 0, width: 50, height: 40)
            button.setTitle("工作亮点", for: .normal)
            button.setTitleColor(UIColor.gray, for: .normal)
            button.sizeToFit()
            
            //            button.addTarget(<#T##target: Any?##Any?#>, action: <#T##Selector#>, for: <#T##UIControlEvents#>)
            
            let barItem = UIBarButtonItem()
            barItem.customView = button
            
            navigationItem.rightBarButtonItem = barItem
            
            break
        case 3://月报
            
            let button = UIButton()
            button.frame = CGRect.init(x: 0, y: 0, width: 50, height: 40)
            button.setTitle("工作亮点", for: .normal)
            button.setTitleColor(UIColor.gray, for: .normal)
            button.sizeToFit()
            
            //            button.addTarget(<#T##target: Any?##Any?#>, action: <#T##Selector#>, for: <#T##UIControlEvents#>)
            
            let barItem = UIBarButtonItem()
            barItem.customView = button
            
            navigationItem.rightBarButtonItem = barItem
            
            break
        default:
            
            break
            
        }
    }
    
    
    
 
}
