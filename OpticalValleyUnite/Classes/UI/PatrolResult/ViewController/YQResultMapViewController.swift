//
//  YQResultMapViewController.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/12/9.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit
import KYDrawerController
import SVProgressHUD


class YQResultMapViewController: UIViewController {

    ///属性列表
    @IBOutlet weak var timeView: UIView!
    
    @IBOutlet weak var mapView: MAMapView!
    
    // MAMap单例
    var locationManager = AMapLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //地图定位
        mapViewSetup()
        
        addLeftRightBarButtonFunction()
        
        //默认打开弹窗
        rightBarButtonClick()
        
        //获取项目筛选的数据,接受通知
        receiveNotiesData()
        
        
    }
    
    // MARK: - 添加左右barItem的情况
    func addLeftRightBarButtonFunction(){
        
        let leftBtn = UIButton()
        leftBtn.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        leftBtn.setImage(UIImage(named: "icon_fire_return"), for: .normal)
        leftBtn.addTarget(self, action: #selector(leftBarButtonClick), for: .touchUpInside)
        
        let barItem = UIBarButtonItem()
        barItem.customView = leftBtn
        
        self.navigationItem.leftBarButtonItem = barItem
        
        let rightBtn = UIButton()
        rightBtn.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        rightBtn.setImage(UIImage(named : "筛选"), for: .normal)
        rightBtn.addTarget(self, action: #selector(rightBarButtonClick), for: .touchUpInside)
        
        let rightBarItem = UIBarButtonItem()
        rightBarItem.customView = rightBtn
        
        self.navigationItem.rightBarButtonItem = rightBarItem
        
    }
    func rightBarButtonClick (){
        
        //添加抽屉视图
        if let drawerController = navigationController?.parent as? KYDrawerController {
            
            drawerController.setDrawerState(.opened, animated: true)
        }

    }
    func leftBarButtonClick (){
        
        self.dismiss(animated: true, completion: nil)
        
    }
    

    // MARK: - mapSet 地图显示的初始化设置
    func mapViewSetup(){
        
        AMapServices.shared().enableHTTPS = true
        mapView.showsUserLocation = true;
        mapView.userTrackingMode = .none;
        mapView.delegate = self as MAMapViewDelegate
        mapView.zoomLevel = 10.0 //地图的缩放的级别比例
        
        // 带逆地理信息的一次定位（返回坐标和地址信息）
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        //   定位超时时间，最低2s，此处设置为5s
        self.locationManager.locationTimeout = 2;
        //   逆地理请求超时时间，最低2s，此处设置为5s
        self.locationManager.reGeocodeTimeout = 2;
        
        //加载定位的 实时方法
        locationManager.requestLocation(withReGeocode: true, completionBlock:{
            [weak self]  location, regeocode,error in
            
            if let error = error{
                print(error.localizedDescription)
            }
            if let regeocode = regeocode{
                
                print(regeocode)
                
                self?.mapView.setCenter((location?.coordinate)!, animated: true)
            }
            
        })
    }
    
    // MARK: - 获取通知数据
    func receiveNotiesData(){
    
        let center = NotificationCenter.default
        let notiesName = NSNotification.Name(rawValue: "resultDrawerLoadWaysNoties")

        center.addObserver(self, selector: #selector(resultDrawerLoadWaysNoties(noties:)), name: notiesName, object: nil)
    
    }
    
    func resultDrawerLoadWaysNoties (noties : Notification){
        
        let dataArray = noties.userInfo?["VideoLoadWaysArray"] as? NSDictionary
        
        //赋值,划线,逻辑渲染
        
    
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }


 
  
}

extension YQResultMapViewController : MAMapViewDelegate {




}
