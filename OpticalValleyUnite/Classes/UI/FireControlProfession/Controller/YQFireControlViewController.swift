//
//  YQFireControlViewController.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/9/14.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit
import SnapKit


class YQFireControlViewController: UIViewController {
    
    // MARK: - 属性列表
    // 中间contentView
    @IBOutlet weak var messageContentV: UIView!
    
    // mapview
    @IBOutlet weak var fireMapView: MAMapView!
    
    // MAMap单例
    var locationManager = AMapLocationManager()
    
    // MARK: - 视图生命周期的方法
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //设置leftBar图片和点击事件
        let image = UIImage(named : "pic_default")
        let bnt = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        bnt.setImage(image, for: .normal)
        bnt.addTarget(self, action:  #selector(leftBarButtonClick), for: UIControlEvents.touchUpInside)
        
        //设置显示原始图片的情况
        // image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        // let item2=UIBarButtonItem(customView: btn1)
        // self.navigationItem.rightBarButtonItem=item2
        let left = UIBarButtonItem(customView: bnt)
        self.navigationItem.leftBarButtonItem = left
        
        //设置地图
        mapSetup()

    }
    
    // MARK: - 设置地图的方法
    private func  mapSetup(){
        
        AMapServices.shared().enableHTTPS = true
        fireMapView.showsUserLocation = true;
        fireMapView.userTrackingMode = .followWithHeading;
        fireMapView.delegate = self as MAMapViewDelegate
        fireMapView.zoomLevel = 17.0
        
        // 带逆地理信息的一次定位（返回坐标和地址信息）
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        //   定位超时时间，最低2s，此处设置为2s
        self.locationManager.locationTimeout = 2;
        //   逆地理请求超时时间，最低2s，此处设置为2s
        self.locationManager.reGeocodeTimeout = 2;
        
        locationManager.requestLocation(withReGeocode: true, completionBlock:{
            [weak self]  location, regeocode,error in
            if let error = error{
                print(error.localizedDescription)
            }
            if let regeocode = regeocode{
                print(regeocode)
                
                self?.fireMapView.setCenter((location?.coordinate)!, animated: true)
            }
            }
        )
    }
    
    // MARK: - leftBarButtonClick
    func leftBarButtonClick(){
    
    
    }
    
}


extension YQFireControlViewController: MAMapViewDelegate{
    
    // MARK: - 地图加载成功的调用的方法
    func mapViewDidFinishLoadingMap(_ mapView: MAMapView!) {
        //        print(mapView.userLocation.location)
        self.fireMapView.setCenter((mapView.userLocation!.coordinate), animated: true)
    }
    
}
