//
//  YQImplementFeedbackVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/9/21.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit
import SVProgressHUD

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
        resolvedV.frame = self.contentView.bounds
        resolvedV.delegate = self as YQResolvedViewDelegate
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
                    
                    self.resolve.ImplementPersonTextField.text = self.resolve.ImplementPersonTextField.text! + model.name + ","
                }
                
            }else if self.tempView.isKind(of: YQFalsePositiveView.self){
                
                for model in models {
                    
                    self.falsePositive.addNameTextField.text = self.falsePositive.addNameTextField.text! + model.name + ","
                    
                }
            }
        }
        
        if type == 1 {
            
            for model in models {
                
                self.resolve.cooperatePersonTextField.text = self.resolve.cooperatePersonTextField.text! + model.name + ","
            }

        }
        
    }

    
    
}

extension YQImplementFeedbackVC : YQResolvedViewDelegate{
    
    // MARK: - resolve保存按钮点击
    func resolvedViewSaveButtonClick(view :YQResolvedView ,images : NSArray) {
        
        //已解决:   误报:  1:已解决 2:误报
        if resolve.ImplementPersonTextField.text == nil {
            SVProgressHUD.showError(withStatus: "请选择执行人")
            return
        }
        
        if resolve.reasonTextField.text == nil {
            SVProgressHUD.showError(withStatus: "请输入原因")
            return
        }
        
        if resolve.proofImageAddView == nil {
            SVProgressHUD.showError(withStatus: "请输图片")
            return
        }
        
        var par = [String : Any]()
        par["firePointId"] = fireModel.firePointId
        par["type"] = 1
        par["execPersonId"] = resolve.ImplementPersonTextField.text
        par["coopPersonIds"] = resolve.cooperatePersonTextField.text
        par["reason"] = resolve.reasonTextField.text
        par["imgPaths"] = ""
        
        if images.count > 0 {
            
            self.upDataImage(images as! [UIImage], complit: { (url) in
                if par["imgPaths"] as! String == "" {
                    
                    par["imgPaths"] =  url
                    
                }else{
                    
                     par["imgPaths"] =   par["imgPaths"] as! String + "," + url
                }
                
            })
        }

        SVProgressHUD.show(withStatus: "正在保存中...")
        HttpClient.instance.post(path: URLPath.getFirefeedback, parameters: par, success: { (respose) in
            
            SVProgressHUD.dismiss()
            self.navigationController?.popViewController(animated: true)
            
        }) { (error) in
            SVProgressHUD.showError(withStatus: "保存失败!")
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
        
        self.pushPersonListVC(type: 1)
        
    }

}

extension YQImplementFeedbackVC : YQFalsePositiveViewDelegate{
    
    // MARK: - false添加执行人
    func falsePositiveViewAddPersonClick(view: YQFalsePositiveView) {
        
        self.pushPersonListVC(type: 0)
        self.tempView = view
    }
    
    // MARK: - false保存按钮的点击
    func falsePositiveViewSaveButtonClick(view :YQFalsePositiveView, images: NSArray) {
        //已解决:   误报:  1:已解决 2:误报
        if falsePositive.addNameTextField.text == nil {
            SVProgressHUD.showError(withStatus: "请选择执行人")
            return
        }
        
        if falsePositive.reasonTextField.text == nil {
            SVProgressHUD.showError(withStatus: "请输入原因")
            return
        }
        
        if falsePositive.proofPictureAddView == nil {
            SVProgressHUD.showError(withStatus: "请输图片")
            return
        }
        
        var par = [String : Any]()
        
        par["firePointId"] = fireModel.firePointId
        par["type"] = 0
        par["execPersonId"] = falsePositive.addNameTextField.text
        par["reason"] = falsePositive.reasonTextField.text
        par["imgPaths"] = ""
        
        if images.count > 0 {
            
            self.upDataImage(images as! [UIImage], complit: { (url) in
                if par["imgPaths"] as! String == "" {
                    
                    par["imgPaths"] =  url
                    
                }else{
                    
                    par["imgPaths"] =   par["imgPaths"] as! String + "," + url
                }
                
            })
        }

        SVProgressHUD.show(withStatus: "正在保存中...")
        HttpClient.instance.post(path: URLPath.getFirefeedback, parameters: par, success: { (respose) in
            
            SVProgressHUD.dismiss()
            self.navigationController?.popViewController(animated: true)
            
        }) { (error) in
            SVProgressHUD.showError(withStatus: "保存失败!")
        }
        
    }

}

