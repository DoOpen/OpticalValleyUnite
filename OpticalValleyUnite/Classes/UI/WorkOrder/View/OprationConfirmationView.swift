//
//  OprationConfirmationView.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/2/21.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit
import SVProgressHUD

class OprationConfirmationView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var textView: SJTextView!
    @IBOutlet weak var takePhotoBtn: UIButton!
    
    var selectImage : UIImage?
    
    var textHandle: ((String?) -> ())?
    var imageHandle: ((UIImage?, String?) -> ())?
    
    deinit {
        print("OprationConfirmationView ---- deinit")
    }

    @IBAction func cancleBtnClick() {
        
        self.superview?.removeFromSuperview()
    }
    @IBAction func doneBtnClick() {
        
        if let block = textHandle{
            
            if textView.text == ""{
                SVProgressHUD.showError(withStatus: "必须输入退单原因")
                return
            }
            
            block(textView.text)
        }else if let block = imageHandle{
            block(selectImage, textView.text)
        }
        
        cancleBtnClick()
        
    }
    
    @IBAction func takePhotpBtnClick() {
        self.superview?.isHidden = true
        SJTakePhotoHandle.takePhoto(imageBlock: { (image) in
            self.superview?.isHidden = false
            self.takePhotoBtn.setBackgroundImage(image, for: .normal)

        }, viewController: (SJKeyWindow?.rootViewController as! UITabBarController).selectedViewController)
    }
    
    
    class func show(doneBtnClickHandel: ((String?) -> ())?){
        let view = OprationConfirmationView.loadFromXib() as! OprationConfirmationView
        view.frame = CGRect(x: 0, y: 0, width: 305, height: 256)
        view.center = (SJKeyWindow?.center)!
        
        
        view.textHandle = doneBtnClickHandel
        
        CoverView.show(view: view)
    }
    
    class func showConfirmationView(doneBtnClickHandel: ((UIImage?, String?) -> ())?){
        let view = OprationConfirmationView.loadFromXib() as! OprationConfirmationView
        view.frame = CGRect(x: 0, y: 0, width: 305, height: 256)
        view.center = (SJKeyWindow?.center)!
        
        view.titleLabel.text = "确认完成"
        view.tipLabel.text = "是否确认完成该项如确认,\n请点击上传成果."
        view.textView.placeHolder = "请输入工单备注"
//        view.textView.isHidden = true
        view.takePhotoBtn.isHidden = false
        
        view.imageHandle = doneBtnClickHandel
        
        CoverView.show(view: view)
    }
    

}
