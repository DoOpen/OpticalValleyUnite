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
import KYDrawerController

class AllViewController: UIViewController {
    
    var totalCount = 16

    var btnViews = [HomeBtnView]()
    
    var models = [PermissionModel](){
        didSet{
            
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        for index in 1...totalCount{
            
            let btnView = view.sj_viewWithTag(tag: index) as! HomeBtnView
            btnViews.append(btnView)
            btnView.isHidden = true
            
        }
        
        let count = [models.count, totalCount].min()!
        
        let imageDic = ["报事": "baoshi","工单": "工单2","签到": "签到2","扫描": "扫描2","定位": "dingwei","待办事项": "daiban", "督办": "btn_duban","门禁": "intodoor","丽岛学院": "xueyuan","电梯报事":"baoshi","日志":"日志","计步器":"step","视频巡查" : "xuncha","巡查结果" : "xunguan","工作报告" : "more_icon_work_report","房屋管理" : "房屋查询","设备房" : "设备房","装修管理" : "装修管理"]
        for index in 0..<count{
            
            let imageName = imageDic[models[index].aPPMODULENAME] ?? ""
            btnViews[index].imageView.image = UIImage(named:imageName)
            
            if models[index].aPPMODULENAME == "电梯报事"{
                btnViews[index].textLabel.text = "报事"
                
            }else{
                
                btnViews[index].textLabel.text = models[index].aPPMODULENAME
            
            }
            
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
            
        case "电梯报事":
            
            let vc = UIStoryboard(name: "ReportMaster", bundle: nil).instantiateInitialViewController()
            
            navigationController?.pushViewController(vc!, animated: true)
            
        case "工单":
            
            let vc = UIStoryboard(name: "YQWorkOrderFirst", bundle: nil).instantiateInitialViewController()
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
            
        case "日志":
            //测试日志模块
            let journa = UIStoryboard.instantiateInitialViewController(name: "YQJournal")
            self.present(journa, animated: true, completion: nil)
            
        case "计步器":
            
            let step = UIStoryboard.instantiateInitialViewController(name: "YQPedometerVC")
            self.present(step, animated: true, completion: nil)
            
        case "视频巡查":
            // 调试视频巡查的内容
            let Video = UIStoryboard.instantiateInitialViewController(name: "YQVideoPatrol")
            let mainViewController   = Video
            let drawerViewController = YQVideoDrawerViewController()
            // 初始化drawer抽屉的情况
            let drawerController     = KYDrawerController(drawerDirection: .right, drawerWidth: 300)
            drawerController.mainViewController =  mainViewController

            drawerController.drawerViewController = drawerViewController
            self.present(drawerController, animated: true, completion: nil)
            
        case "巡查结果":
            let videoResult = UIStoryboard.instantiateInitialViewController(name: "YQPatrolResult")
            self.present(videoResult, animated: true, completion: nil)
            
            
        case "门禁":
            let door = UIStoryboard.instantiateInitialViewController(name: "YQIntoDoor")
            self.present(door, animated: true, completion: nil)
            
        case "工作报告":
            
            let report = YQReportFormFirstVC.init(nibName: "YQReportFormFirstVC", bundle: nil)
            self.navigationController?.pushViewController(report, animated: true)

        case "房屋管理" :
            let house = UIStoryboard.instantiateInitialViewController(name: "YQHouseHome")
            self.navigationController?.pushViewController(house, animated: true)
            
        case "装修管理" :
            let decoration = UIStoryboard.instantiateInitialViewController(name: "YQDecorationHome")
            self.navigationController?.pushViewController(decoration, animated: true)
            
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
                //设置代理
                vc.delegate = self
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
    
    // MARK: - 跳转到设备详情扫描的界面
    fileprivate func pushToDeviceViewController(equipmentId: String){
        
        let vc = DeviceViewController.loadFromStoryboard(name: "Home") as! DeviceViewController
        vc.equipmentId = equipmentId
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

extension AllViewController :SGScanningQRCodeVCDelegate{
    
    
    func didScanningText(_ text: String!) {
        
        if text.contains("设备"){//区分是否是自己的二维码的情况
            
            let str = text.components(separatedBy: ":").last
            if let str = str{
                
                self.navigationController?.popViewController(animated: false)
                pushToDeviceViewController(equipmentId: str)
                
            }
            
        }else{
            
            self.alert(message: "非可识别二维码!")
        }
    }
    
    
}

