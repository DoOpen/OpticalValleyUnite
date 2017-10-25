//
//  MessageView.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/1/11.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit

class MessageView: UIView {
    @IBOutlet weak var surveillanceWorkOrderBtn: UIButton!
    @IBOutlet weak var workOrderBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 6
    }
    
    @IBAction func workOrderBtnClick() {
        
//        APPHandle.tabBarControllerSelected(index: 1)
        
        if let vc = UIStoryboard(name: "YQWorkOrderFirst", bundle: nil).instantiateInitialViewController() as? YQWorkOrderFirstViewController{
            
//            APPHandle.currentRootViewController()?.present(vc, animated: true, completion: {
//            })
            
            APPHandle.currentRootViewController()?.pushViewController(vc, animated: true)
            
            self.closeBtnClick()
        }
    }

    @IBAction func surveillanceWorkOrderBtnClick() {
        
        let vc = SurveillanceWorkOrderViewController.loadFromStoryboard(name: "WorkOrder") 
            APPHandle.rootVcPush(vc)
        
        closeBtnClick()
    }
    
    class func show(workOrderCount: Int,surveillanceWorkOrder: Int ){
        
        let view = MessageView.loadFromXib() as! MessageView
        
        if workOrderCount > 0 {
            
            view.workOrderBtn.badge(text: "\(workOrderCount)")
        }
        if surveillanceWorkOrder > 0 {
            
            view.surveillanceWorkOrderBtn.badge(text: "\(surveillanceWorkOrder)")
        }
        
        view.center = CGPoint(x: SJScreeW * 0.5, y: 343.0)
        CoverView.show(view: view)
    }
    
    
    @IBAction func closeBtnClick() {
        self.superview?.removeFromSuperview()
    }


}
