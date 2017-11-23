//
//  AppraisalViewController.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/1/16.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit
import SVProgressHUD

class AppraisalViewController: UIViewController {
   
    @IBOutlet weak var textView: SJTextView!

    @IBOutlet weak var addPhotoView: SJAddView!
    
    @IBOutlet weak var startView: UIView!
    
    var selectStatBtn: UIButton?
    
    //提交评价按钮的点击的事件
    @IBOutlet weak var putEvaluateButton: UIButton!
    
    
    
    var model: WorkOrderDetailModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "工单评价"
        setupStartView()
    }

    func setupStartView(){
        
        for btn in startView.subviews as! [UIButton]{
            btn.addTarget(self, action:  #selector(AppraisalViewController.startBtnClick(sender:)), for: .touchUpInside)
        }
    }
    
    func startBtnClick(sender: UIButton){
        selectStatBtn = sender
        for btn in startView.subviews as! [UIButton]{
            btn.isSelected = btn.tag < sender.tag + 1
        }
    }
    
    // MARK: - 提交评价按钮的点击
    @IBAction func doneBtnClick() {
        
        
        self.putEvaluateButton.isUserInteractionEnabled = false
        
        var parmat = [String: Any]()
        parmat["WORKUNIT_ID"] = model?.id
        parmat["EVALUATE_TEXT"] = textView.text
        
        if let btn = selectStatBtn {
            parmat["EVALUATE_SCORE"] = (btn.tag + 1)
        }else{
            //代码修改,逻辑调整, 不打分也能提交评价
//            SVProgressHUD.showError(withStatus: "请先打分...")
            
            parmat["EVALUATE_SCORE"] = 1
            
//            return
        }
        
//        guard textView.text != "" else {
//            SVProgressHUD.showError(withStatus: "必须输入评价内容")
//            return
//        }     
        
        //添加设置断点续传的功能!!
        let images = addPhotoView.photos.map{$0.image}
        
        if images.count > 0 {
            
            HttpClient.instance.upDataImages(images, complit: { (url) in
                
                parmat["PICTURE"] = url
                
                HttpClient.instance.post(path: URLPath.evaluateSave, parameters: parmat, success: { (response) in
                    
                    SVProgressHUD.showSuccess(withStatus: "评价成功")
                    _ = self.navigationController?.popViewController(animated: true)
                    
                }) { (error) in
                    
                }
                
            })
            
            return
        }
        
        HttpClient.instance.post(path: URLPath.evaluateSave, parameters: parmat, success: { (response) in
            
            SVProgressHUD.showSuccess(withStatus: "评价成功")
            _ = self.navigationController?.popViewController(animated: true)
            self.putEvaluateButton.isUserInteractionEnabled = true

            
        }) { (error) in
            
            SVProgressHUD.showError(withStatus: "评论失败,请重试!")
            
            self.putEvaluateButton.isUserInteractionEnabled = true

        }
        
        
    }
}
