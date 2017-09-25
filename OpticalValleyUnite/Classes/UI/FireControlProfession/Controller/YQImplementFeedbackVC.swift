//
//  YQImplementFeedbackVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/9/21.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit

class YQImplementFeedbackVC: UIViewController {
    
    //火警模型的情况
    var fireModel : YQFireLocationModel!

    @IBOutlet weak var resolveButton: UIButton!
    
    @IBOutlet weak var falsePositivesButton: UIButton!
    
    @IBOutlet weak var contentView: UIView!
    
    //误报View
    lazy var falsePositive: YQFalsePositiveView = {
        () -> UIView
        in
        
        let falseV = Bundle.main.loadNibNamed("YQFalsePositive", owner: nil, options: nil)?[0] as! YQFalsePositiveView
        falseV.frame = self.contentView.bounds
        return falseV
        
    }() as! YQFalsePositiveView
    
    //已解决View
    lazy var resolve: YQResolvedView = {
        () -> UIView
        in
        
        let resolvedV = Bundle.main.loadNibNamed("YQResolved", owner: nil, options: nil)?[0] as! YQResolvedView
        resolvedV.frame = self.contentView.bounds
        return resolvedV
        
    }() as! YQResolvedView
    
    
    // MARK: - 视图生命周期的方法
    override func viewDidLoad() {
        super.viewDidLoad()

        self.resolveButton.isSelected = true
        
        self.contentView.addSubview(resolve)
        
    }

    // MARK: - 已解决按钮的点击
    @IBAction func resolveButtonClick(_ sender: Any) {
        
        self.resolveButton.isSelected = true
        self.falsePositivesButton.isSelected = false
        
        //移除添加
        self.falsePositive.removeFromSuperview()
        contentView.addSubview(resolve)
        
    }
    
    // MARK: - 误报按钮的点击
    @IBAction func falsePositivesClick(_ sender: Any) {
        
        self.falsePositivesButton.isSelected = true
        self.resolveButton.isSelected = false
        
        //移除添加
        self.resolve.removeFromSuperview()
        contentView.addSubview(falsePositive)
        
    }
    
    // MARK: - 保存数据的调用的接口方法
    func saveButtonClickWithBackStage(){
        
        var parmert = [String : Any]()
        parmert["token"] = ""
        parmert["firePointId"] = ""
        parmert["type"] =
        parmert["execPersonId"] = ""
        parmert["coopPersonIds"] = ""
        parmert["reason"] = ""
        parmert["imgPaths"] = ""
        
        HttpClient.instance.post(path: URLPath.getFirefeedback, parameters: parmert, success: { (respose) in
            
            
        }) { (error) in
            
            
        }
        
    
    }
    

}
