//
//  YQAllViewController.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/6/7.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import KYDrawerController
import SVProgressHUD

class YQAllViewController: UIViewController {

    let cell = "collectionCell"
    let headCell =  "headCell"
    let footCell = "footCell"
    
    //数据源的方法
    var topArray = [PermissionModel]()
    
    var bottomArray = [PermissionModel]()
    
    var moduleId = ""
    
    var flishUpDateBtnClickHandel: (([String: Any]) -> ())?
    
    lazy var collectionView : UICollectionView = {
        
        let collectionV = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: SJScreeW, height: SJScreeH), collectionViewLayout: self.flowLayout)
        collectionV.dataSource = self
        collectionV.delegate = self
        collectionV.backgroundColor = UIColor.white
        collectionV.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(UInt8(UIViewAutoresizing.flexibleHeight.rawValue) | UInt8(UIViewAutoresizing.flexibleWidth.rawValue)))
        
        let nib = UINib.init(nibName: "YQBtnViewCollectionCell", bundle: nil)
        //注册cell
        collectionV.register(nib, forCellWithReuseIdentifier: self.cell)
        
        //注册header
        collectionV.register(SYLifeManagerHeaderView.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: self.headCell)
        
        //注册footer
        collectionV.register(SYLIfeManagerFooterView.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: self.footCell)
        
        return collectionV
    }()
    
    
    lazy var flowLayout: SYLifeManagerLayout = {
        
        let width  = CGFloat((SJScreeW - 40) / 4)
        
        let flayout = SYLifeManagerLayout()
        flayout.delegate = self;
        //设置每个图片的大小
        flayout.itemSize = CGSize.init(width: width, height: 80)
        //设置滚动方向的间距
        flayout.minimumLineSpacing = 5
        //设置上方的反方向
        flayout.minimumInteritemSpacing = 0
        //设置collectionView整体的上下左右之间的间距
        flayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        //设置滚动方向
        flayout.scrollDirection = UICollectionViewScrollDirection.vertical
        
        return flayout
    }()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //1.init
        self.view.addSubview(self.collectionView)
        self.title = "全部"
        
        //2.rightAndLeftBar
        addRightBarButtonItem()
    
        //3.添加right,leftbar
        addRightBarButtonItem()
    }
    
    // MARK: - 添加rightBarbutton选项
    func addRightBarButtonItem(){
        
        let button = UIButton()
        button.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        button.setTitle("完成", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.sizeToFit()
        button.addTarget(self, action: #selector(FinishEditorsButtonClick(btn :)), for: .touchUpInside)
        
        let barItem = UIBarButtonItem()
        barItem.customView = button
        
        navigationItem.rightBarButtonItem = barItem
        
    }
    
    func FinishEditorsButtonClick(btn : UIButton){
        
        btn.isUserInteractionEnabled = false
        
        var stringID = ""
        for model in self.bottomArray{
            
            if stringID == "" {
                
                stringID = model.iD
            }else{
                stringID = stringID + "," + model.iD
            }
            
        }
        
        var par = [String : Any]()
        par["moduleId"] = self.moduleId
        par["appModuleIds"] = stringID
        
        SVProgressHUD.show()
        
        HttpClient.instance.post(path: URLPath.saveUserModules, parameters: par, success: { (response) in
            
            SVProgressHUD.dismiss()
            SVProgressHUD.showSuccess(withStatus: "保存成功!")
            
            if let block = self.flishUpDateBtnClickHandel{
                
                block(["bottomArray" : self.bottomArray])
            }
            self.navigationController?.popViewController(animated: true)
            
            
        }) { (error) in
            
            SVProgressHUD.showError(withStatus: "保存失败,请检查网络!")
            
            btn.isUserInteractionEnabled = true
        }
        
        //重新传值,归档解档(通知赋值,解决通知的多次的传值的swift bug)
//        let center = NotificationCenter.default
//        let notiesName = NSNotification.Name(rawValue: "upDateUserModules")
//        center.post(name: notiesName, object: nil, userInfo: ["bottomArray" : self.bottomArray])
        
        
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
            
        case "设备房" :
            let equipVC = YQEquipmentFristVC.init(nibName: "YQEquipmentFristVC", bundle: nil)
            self.navigationController?.pushViewController(equipVC, animated: true)
            
        case "工单查询" :
            let allWorkUnit = UIStoryboard.instantiateInitialViewController(name: "YQAllWorkUnitHome")
            self.navigationController?.pushViewController(allWorkUnit, animated: true)
            
        case "总经理邮箱" :
            
            let generalMailVC = YQGeneralManagerFirstVC.init(nibName: "YQGeneralManagerFirstVC", bundle: nil)
            self.navigationController?.pushViewController(generalMailVC, animated: true)
            
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

extension YQAllViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SYLifeManagerDelegate{
   
    // MARK: - CollectionViewDataSource,Delegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 2
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            
            return self.topArray.count
            
        }else{
            
            return self.bottomArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cell, for: indexPath) as? YQBtnViewCollectionCell
        
    
        if (indexPath.section == 0) {
            
            cell?.model = self.topArray[indexPath.item]
            
        } else {
            
            cell?.model = self.bottomArray[indexPath.item]
        }
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var name = ""
        
        if indexPath.section == 0 {
            
           name  = self.topArray[indexPath.item].aPPMODULENAME
            
        }else {
            
            name  = self.bottomArray[indexPath.item].aPPMODULENAME
        }
        
        self.actionPush(text: name)
        
    }
    
    // MARK: - SYLifeManagerDelegate
    /// 更新数据源的方法
    func moveItem(at formPath: IndexPath!, to toPath: IndexPath!) {
        
        let model  = self.bottomArray[formPath.row];
        //先把移动的这个model移除
        self.bottomArray.remove(at: formPath.row)
        
        //let toPathModel = self.bottomArray[toPath.row]
        
        //再把这个移动的model插入到相应的位置
        self.bottomArray.insert(model, at: toPath.row)
        
    }
    
    func didChangeEditState(_ inEditState: Bool) {
        
        
    }
    
    // MARK: - HeaderAndFooter
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if (kind == UICollectionElementKindSectionHeader) {
            
            let headView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headCell, for: indexPath) as! SYLifeManagerHeaderView
            
            if (indexPath.section == 0) {
                headView.headLabel.text = "顶部模块 (不可编辑)";
            } else {
                headView.headLabel.text = "底部模块 (可编辑)";
            }
            
            return headView
            
        } else if (kind  == UICollectionElementKindSectionFooter){
            
            let footView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footCell, for: indexPath)
            
            return footView
        }
        
        return UICollectionReusableView()
    }
    //注意的是swift的delegate方法的拆分的库的改变,导致的坑
    //footer
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        if (section == 0) {
            
            return CGSize.init(width: SJScreeW, height: 10);
            
        } else {
            
            return CGSize.init(width: SJScreeW, height: 0.5);
        }
    }
    
    //header
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize.init(width: SJScreeW, height: 25)
       
    }
    
}

extension YQAllViewController :SGScanningQRCodeVCDelegate{
    
    
    func didScanningText(_ text: String!) {
        
        if text.contains("equipment"){//区分是否是自己的二维码的情况
            
            let str = text.components(separatedBy: ":").last
            if let str = str{
                
                self.navigationController?.popViewController(animated: false)
                self.pushToDeviceViewController(equipmentId: str)
                
            }
            
        }else{
            
            self.alert(message: "非可识别二维码!")
        }
    }
    
    
}

