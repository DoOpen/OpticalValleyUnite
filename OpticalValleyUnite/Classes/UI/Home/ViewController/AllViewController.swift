//
//  AllViewController.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/5/4.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
class AllViewController: UIViewController {

    var btnViews = [HomeBtnView]()
    
    var models = [PermissionModel](){
        didSet{
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for index in 1...12{
            
            let btnView = view.sj_viewWithTag(tag: index) as! HomeBtnView
            btnViews.append(btnView)
           btnView.isHidden = true
            
        }
        
        let count = [models.count, 12].min()!
        let imageDic = ["报事": "baoshi2","工单": "工单2","签到": "签到2","扫描": "扫描2","定位": "dingwei","待办事项": "daiban", "督办": "btn_duban","智能开门": "ic_door","丽岛学院": "xueyuan"]
        for index in 0..<count{
            let imageName = imageDic[models[index].aPPMODULENAME] ?? ""
            btnViews[index].imageView.image = UIImage(named:imageName)
            btnViews[index].textLabel.text = models[index].aPPMODULENAME
//            btnViews[index].textLabel.textColor = UIColor.white
            btnViews[index].isHidden = false
            btnViews[index].clickHandle = { [weak self] in
                self?.actionPush(text: (self?.models[index].aPPMODULENAME)!)
            }

        }
    }


    

    func actionPush(text:String){
        switch text {
        case "报事":
            let vc = UIStoryboard(name: "ReportMaster", bundle: nil).instantiateInitialViewController()
            navigationController?.pushViewController(vc!, animated: true)
        //            surveillanceWorkOrderBtnClick()
        case "工单":
            let vc = UIStoryboard(name: "WorkOrder", bundle: nil).instantiateInitialViewController()
            navigationController?.pushViewController(vc!, animated: true)
        case "签到":
            let vc = UIStoryboard(name: "SignIn", bundle: nil).instantiateInitialViewController()
            navigationController?.pushViewController(vc!, animated: true)
        case "定位":
            let vc = UIStoryboard(name: "Map", bundle: nil).instantiateInitialViewController()
            navigationController?.pushViewController(vc!, animated: true)
        case "扫描":
            scanBtnClick()
        //            surveillanceWorkOrderBtnClick()
        case "督办":
            surveillanceWorkOrderBtnClick()
        default: break
            
        }
    }
    
    func scanBtnClick() {
        
        if Const.SJIsSIMULATOR {
            alert(message: "模拟器不能使用扫描")
            return
        }
        
        let device = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
        if device != nil {
            let status = PHPhotoLibrary.authorizationStatus()
            if status == .authorized{
                let vc = SGScanningQRCodeVC()
                navigationController?.pushViewController(vc, animated: true)
            }else if status == .notDetermined{
                PHPhotoLibrary.requestAuthorization({ (authorizationStatus) in
                    
                })
            }else{
                self.alert(message: "授权失败")
            }
        }
    }
    
    
    func surveillanceWorkOrderBtnClick() {
        let vc = SurveillanceWorkOrderViewController.loadFromStoryboard(name: "WorkOrder")
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension UIView{
    func sj_viewWithTag(tag: Int) -> UIView?{
        if self.tag == tag{
           return self
        }
        for subView in subviews{
            if subView.tag == tag{
                return subView
            }
            let reslutView = subView.sj_viewWithTag(tag: tag)
            if let reslutView = reslutView,reslutView.tag == tag{
                return reslutView
            }
        }
        return nil
    }
}
