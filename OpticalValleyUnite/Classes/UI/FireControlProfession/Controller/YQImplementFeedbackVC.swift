//
//  YQImplementFeedbackVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/9/21.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit
import SVProgressHUD
import SnapKit

class YQImplementFeedbackVC: UIViewController {
    
    //火警模型的情况
    var fireModel : YQFireLocationModel!

    @IBOutlet weak var resolveButton: UIButton!
    
    @IBOutlet weak var falsePositivesButton: UIButton!
    
    @IBOutlet weak var contentView: UIView!
    
    var tempView : UIView!
    
    //误报View
    lazy var falsePositive: YQFalsePositiveView = {
        () -> UIView
        in
        
        let falseV = Bundle.main.loadNibNamed("YQFalsePositive", owner: nil, options: nil)?[0] as! YQFalsePositiveView
        falseV.frame = self.contentView.bounds
        falseV.delegate = self as YQFalsePositiveViewDelegate
        return falseV
        
    }() as! YQFalsePositiveView
    
    //已解决View
    lazy var resolve: YQResolvedView = {
        () -> UIView
        in
        
        let resolvedV = Bundle.main.loadNibNamed("YQResolved", owner: nil, options: nil)?[0] as! YQResolvedView
        
        resolvedV.delegate = self as YQResolvedViewDelegate
        return resolvedV
        
    }() as! YQResolvedView
    
    
    // MARK: - 视图生命周期的方法
    override func viewDidLoad() {
        super.viewDidLoad()

        self.resolveButton.isSelected = true
        
        self.contentView.addSubview(resolve)
        
        resolve.snp.makeConstraints { (maker) in
            
            maker.left.bottom.right.top.equalToSuperview()
        }
        
        
    }

    // MARK: - 已解决按钮的点击
    @IBAction func resolveButtonClick(_ sender: Any) {
        
        self.resolveButton.isSelected = true
        self.falsePositivesButton.isSelected = false
        
        //移除添加
        self.falsePositive.removeFromSuperview()
        
        contentView.addSubview(resolve)
        resolve.snp.makeConstraints { (maker) in
            
            maker.left.bottom.right.top.equalToSuperview()
        }

        
    }
    
    // MARK: - 误报按钮的点击
    @IBAction func falsePositivesClick(_ sender: Any) {
        
        self.falsePositivesButton.isSelected = true
        self.resolveButton.isSelected = false
        
        //移除添加
        self.resolve.removeFromSuperview()
        contentView.addSubview(falsePositive)
        
    }
    
        
    //MARK: - 上传图片的专门的接口
    func upDataImage(_ images: [UIImage], complit: @escaping ((String) -> ()),errorHandle: (() -> ())? = nil){
        
        SVProgressHUD.show(withStatus: "上传图片中...")
        HttpClient.instance.upLoadImages(images, succses: { (url) in
            SVProgressHUD.dismiss()
            
            complit(url!)
            
        }) { (error) in
            SVProgressHUD.dismiss()
            if let errorHandle = errorHandle{
                errorHandle()
            }
        }
    }

    
    func pushPersonListVC(type : Int){
        
        let vc = PeopleListViewController.loadFromStoryboard(name: "WorkOrder") as! PeopleListViewController
        //传递的是执行人的type,通过type来设置相应的 是 执行人还是协助人
        vc.type = type // "选择执行人" 的 type值
        
        vc.parkId = "" // 传值为 空
        vc.doneBtnClickHandel = didSelecte
        
        navigationController?.pushViewController(vc, animated: true)
    
    }
    
    
    func didSelecte(type: Int, models: [PersonModel]){
        
//        if type == 0 {
//            
//            execPeopleBtn.setTitle(models.first?.name, for: .normal)
//            
//            if let url = URL(string: (models.first?.icon)!){
//                execPeopleBtn.kf.setImage(with: url, for: .normal)
//                
//            }else{
//                
//                execPeopleBtn.setImage(UIImage.normalImageIcon(), for: .normal)
//            }
//            
//            execPeopleBtn.isHidden = false
//            execPeopleModel = models.first
//            
//        }else if type == 1 {
//            
//            managePeopleBtn.kf.setImage(with: URL(string: (models.first?.icon)!), for: .normal)
//            managePeopleBtn.isHidden = false
//            managePeopleModel = models.first
//            
//            if let url = URL(string: (models.first?.icon)!){
//                managePeopleBtn.kf.setImage(with: url, for: .normal)
//            }else{
//                managePeopleBtn.setImage(UIImage.normalImageIcon(), for: .normal)
//            }
//            
//        }else if type == 2 {
//            addManageerView.models = models
//            assePeopleModel = models
//        }
        
        
        if type == 0 {
            
            if self.tempView .isKind(of: YQResolvedView.self) {
                
                for model in models {
                    
                    self.resolve.ImplementPersonTextField.text = model.name
                    
                    self.resolve.implementPersonID = model.id
                    
//                    if self.resolve.ImplementPersonTextField.text == "" {
//
//
//                    }else {
//
//                        self.resolve.ImplementPersonTextField.text = self.resolve.ImplementPersonTextField.text! + "," + model.name
//
//                        self.resolve.implementPersonID = self.resolve.implementPersonID + "," + model.id
//
//                    }
                    
                }
                
            }else if self.tempView.isKind(of: YQFalsePositiveView.self){
                
                for model in models {
                    
                    self.falsePositive.addNameTextField.text = model.name
                    self.falsePositive.implementPersonID = model.id
                    
//                    if self.falsePositive.addNameTextField.text == "" {
//
//
//                    }else {
//
//                        self.falsePositive.addNameTextField.text = self.falsePositive.addNameTextField.text! + "," + model.name
//                        self.falsePositive.implementPersonID = self.falsePositive.implementPersonID + "," + model.id
//
//                    }
                    
                }
            }
        }
        
        
        if type == 2 {
            
            for model in models {
                
                if self.resolve.cooperatePersonTextField.text == "" {
                    
                    self.resolve.cooperatePersonTextField.text = model.name
                    self.resolve.cooperatePersonID = model.id
                    
                }else {
                    //bug 修复,要求避免重复的人员添加
                    
                    if (self.resolve.cooperatePersonTextField.text?.contains(model.name))!{
                        //相同的过掉
                    }else{
                        
                        self.resolve.cooperatePersonTextField.text = self.resolve.cooperatePersonTextField.text! + "," + model.name
                        
                        self.resolve.cooperatePersonID = self.resolve.cooperatePersonID + "," + model.id
                        
                    }
                    
                }
            }
        }
    }

    
    
}

extension YQImplementFeedbackVC : YQResolvedViewDelegate{
    
    // MARK: - resolve保存按钮点击
    func resolvedViewSaveButtonClick(view :YQResolvedView ,images : NSArray,type : Int) {
        
        //已解决:   误报:  1:已解决 2:误报
        if resolve.ImplementPersonTextField.text == "" || resolve.ImplementPersonTextField.text == "添加一个" {
            SVProgressHUD.showError(withStatus: "请选择执行人")
            return
        }
        
        if resolve.reasonTextField.text == "" {
            SVProgressHUD.showError(withStatus: "请输入原因")
            return
        }
        
        if resolve.proofImageAddView.photoImages.isEmpty {
            SVProgressHUD.showError(withStatus: "请输图片")
            return
        }
        
        var par = [String : Any]()
        par["firePointId"] = fireModel.firePointId
        par["type"] = type
        par["execPersonId"] = resolve.implementPersonID
        par["coopPersonIds"] = resolve.cooperatePersonID
        par["reason"] = resolve.reasonTextField.text
        par["imgPaths"] = ""
        
        if images.count > 0 {
            
            self.upDataImage(images as! [UIImage], complit: { (url) in
                if par["imgPaths"] as! String == "" {
                    
                    par["imgPaths"] =  url
                    
                }else{
                    
                     par["imgPaths"] =   par["imgPaths"] as! String + "," + url
                }
                
                SVProgressHUD.show(withStatus: "正在保存中...")
                
                HttpClient.instance.post(path: URLPath.getFirefeedback, parameters: par, success: { (respose) in
                    
                    SVProgressHUD.dismiss()
                    SVProgressHUD.showSuccess(withStatus: "保存成功!")
                    
                    self.navigationController?.popToRootViewController(animated: true)
                    //通知super的关闭弹出执行
                    let center = NotificationCenter.default
                    let notiesName = NSNotification.Name(rawValue: "surperFeedbackNoties")
                    center.post(name: notiesName, object: nil)
                    
                    
                }) { (error) in
                    
                    SVProgressHUD.showError(withStatus: "保存失败!")
                }

            })
            
        }else{
        
            SVProgressHUD.show(withStatus: "正在保存中...")
            
            HttpClient.instance.post(path: URLPath.getFirefeedback, parameters: par, success: { (respose) in
                
                SVProgressHUD.dismiss()
                SVProgressHUD.showSuccess(withStatus: "保存成功!")

                self.navigationController?.popToRootViewController(animated: true)
                //通知super的关闭弹出执行
                let center = NotificationCenter.default
                let notiesName = NSNotification.Name(rawValue: "surperFeedbackNoties")
                center.post(name: notiesName, object: nil)
                
                
            }) { (error) in
                SVProgressHUD.showError(withStatus: "保存失败!")
            }
        
        }


    }
    
    // MARK: - resolve添加执行人
    func resolvedViewAddImplementPerson(view: YQResolvedView) {
        
        /*
         0 -->选择执行人
         
         1 -->选择配合人
         */
        self.pushPersonListVC(type: 0)
        self.tempView = view
        
    }
    
    // MARK: - resolve添加配合人
    func resolvedViewAddCooperatePerson(view: YQResolvedView) {
        
        self.pushPersonListVC(type: 2)
        
    }

}

extension YQImplementFeedbackVC : YQFalsePositiveViewDelegate{
    
    // MARK: - false添加执行人
    func falsePositiveViewAddPersonClick(view: YQFalsePositiveView) {
        
        self.pushPersonListVC(type: 0)
        self.tempView = view
        
    }
    
    // MARK: - false保存按钮的点击
    func falsePositiveViewSaveButtonClick(view :YQFalsePositiveView, images: NSArray,type : Int ) {
        //已解决:   误报:  1:已解决 2:误报
        if falsePositive.addNameTextField.text == "" || falsePositive.addNameTextField.text == "添加一个" {
            SVProgressHUD.showError(withStatus: "请选择执行人")
            return
        }
        
        if falsePositive.reasonTextField.text == "" {
            SVProgressHUD.showError(withStatus: "请输入原因")
            return
        }
        
        if falsePositive.proofPictureAddView.photoImages.isEmpty {
            SVProgressHUD.showError(withStatus: "请输图片")
            return
        }
        
        var par = [String : Any]()
        
        par["firePointId"] = fireModel.firePointId
        par["type"] = type
        par["execPersonId"] = falsePositive.implementPersonID
        par["reason"] = falsePositive.reasonTextField.text
        par["imgPaths"] = ""
        
        if images.count > 0 {
            
            self.upDataImage(images as! [UIImage], complit: { (url) in
                if par["imgPaths"] as! String == "" {
                    
                    par["imgPaths"] =  url
                    
                }else{
                    
                    par["imgPaths"] =   par["imgPaths"] as! String + "," + url
                }
                
                SVProgressHUD.show(withStatus: "正在保存中...")
                
                HttpClient.instance.post(path: URLPath.getFirefeedback, parameters: par, success: { (respose) in
                    
                    SVProgressHUD.dismiss()
                    SVProgressHUD.showSuccess(withStatus: "保存成功!")
                    
                    self.navigationController?.popToRootViewController(animated: true)
                    
                    //通知super的关闭弹出执行
                    let center = NotificationCenter.default
                    let notiesName = NSNotification.Name(rawValue: "surperFeedbackNoties")
                    center.post(name: notiesName, object: nil)
                    
                }) { (error) in
                    SVProgressHUD.showError(withStatus: "保存失败!")
                }

            })
            
        }else{
        
            SVProgressHUD.show(withStatus: "正在保存中...")
            HttpClient.instance.post(path: URLPath.getFirefeedback, parameters: par, success: { (respose) in
                
                SVProgressHUD.dismiss()
                
                SVProgressHUD.showSuccess(withStatus: "保存成功!")
                
                self.navigationController?.popToRootViewController(animated: true)
                //通知super的关闭弹出执行
                let center = NotificationCenter.default
                let notiesName = NSNotification.Name(rawValue: "surperFeedbackNoties")
                center.post(name: notiesName, object: nil)
                
            }) { (error) in
                
                SVProgressHUD.showError(withStatus: "保存失败!")
            }
        
        }
    }

}

