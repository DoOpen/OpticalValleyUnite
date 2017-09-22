//
//  YQFireMapDetailViewController.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/9/21.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit


class YQFireMapDetailViewController: UIViewController {

    // MARK: - 视图属性
    // 传递的fireModel,监听set方法
    var fireModel  : YQFireLocationModel!{
        didSet{
            let Coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(fireModel.latitude), CLLocationDegrees(fireModel.longitude))
            self.endCoordinate = Coordinate
            //调用规划路径的方法
            
            
        }
    }
    
    //startCoordinate
    var startCoordinate : CLLocationCoordinate2D!
    //endCoordinate
    var endCoordinate : CLLocationCoordinate2D!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var locationMapView: MAMapView!
    
    // MAMap单例
    var locationManager = AMapLocationManager()
    
    // MARK: - 视图生命周期的方法
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //设置地图
        mapSetup()
        
    }
    
    
    // MARK: - 执行界面(implementView)系列buttonClick
    //立即反馈
    @IBAction func atOnceFeedBackClick(_ sender: Any) {
        
        //跳转到立即反馈的界面进行操作
        let feedBack = UIStoryboard.instantiateInitialViewController(name: "YQImplementFeedback") as! YQImplementFeedbackVC
        
        self.navigationController?.pushViewController(feedBack, animated: true)
        
    }
    
    //立即执行
    @IBAction func atOnceImplementClick(_ sender: Any) {
        
        
    }
    
    
    //放弃执行
    @IBAction func giveUpImplementClick(_ sender: Any) {
        
        
    }
    
    // MARK: - 设置地图
    func mapSetup(){
        
        //map实现的单例
        AMapServices.shared().enableHTTPS = true
        locationMapView.showsUserLocation = true;
        locationMapView.userTrackingMode = .none
        
        locationMapView.delegate = self as MAMapViewDelegate
        locationMapView.zoomLevel = 10.0 //地图的缩放的级别比例
        
        // 带逆地理信息的一次定位（返回坐标和地址信息）
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        //   定位超时时间，最低2s，此处设置为5s
        self.locationManager.locationTimeout = 2;
        //   逆地理请求超时时间，最低2s，此处设置为5s
        self.locationManager.reGeocodeTimeout = 2;
        
        //添加自定义的小蓝点的情况
        /*
         以下功能自iOS 地图 SDK V5.0.0 版本起支持。
         let r = MAUserLocationRepresentation()
         r.image = UIImage(named: "您的图片")
         mapView.update(r)
         
         */
        
        locationManager.requestLocation(withReGeocode: true, completionBlock:{
            [weak self]  location, regeocode,error in
            if let error = error{
                print(error.localizedDescription)
            }
            if let regeocode = regeocode{
                print(regeocode)
                
                self?.locationMapView.setCenter((location?.coordinate)!, animated: true)
            }
            }
        )
    }
    
    // MARK: - 展示路径
    func showRoute() {
        
        let search = AMapSearchAPI()
        search?.delegate = self
        
    
    }
}

extension YQFireMapDetailViewController : MAMapViewDelegate{



}

extension YQFireMapDetailViewController : AMapSearchDelegate{


}


