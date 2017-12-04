//
//  YQVideoPatrolViewController.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/12/4.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit
import MapKit
import KYDrawerController
import SVProgressHUD


class YQVideoPatrolViewController: UIViewController {
    
    @IBOutlet weak var mapView: MAMapView!
    
    
    /// 项目parkID 的属性
    var parkId = ""
    // MAMap单例
    var locationManager = AMapLocationManager()

    // video模型数据
    var videoMapPointModel = [YQVideoMapPointModel](){
        didSet{
            
            //调用地图渲染,打点的方法(有多少个模型,就需要多少个标记)
            for model in videoMapPointModel{
                
                addLocationAndMessageView(model: model)
                
            }

        }
    
    }
    
    
    // MARK: - 视图生命周期的方法
    override func viewDidLoad() {
        super.viewDidLoad()
        //1. 添加leftRight
        addLeftRightBarButtonFunction()
        
    
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
    func leftBarButtonClick() {
        
        //返回子系统选择的界面
        //查看是否有缓存的数据
        let data = UserDefaults.standard.object(forKey: Const.YQTotallData) as? NSArray
        //跳转到子系统的选择界面(需要的是逻辑的判断) 如果是只有一条数据的话,直接调到登录界面
        if (data?.count)! > 1{
            
            let systemVC = YQSystemSelectionVC(nibName: "YQSystemSelectionVC", bundle: nil)
            SJKeyWindow?.rootViewController = systemVC
            
            
        }else{// 跳转到登录界面
            
            LoginViewController.loginOut()
        }
        
    }
    func rightBarButtonClick(){
        
        //添加抽屉视图
        if let drawerController = navigationController?.parent as? KYDrawerController {
            
            drawerController.setDrawerState(.opened, animated: true)
        }
        
    }
    

    // MARK: - 地图加载数据,打点的功能
    func makeMapLocationData(){
        //1.获取parkID
        _ = self.setUpProjectNameLable()
        
        var parameter = [String : Any]()
        parameter["parkId"] = self.parkId
        
        //2.网络数据的请求
        SVProgressHUD.show()
        
        HttpClient.instance.post(path: URLPath.getVideoPatrolMap, parameters: parameter, success: { (response) in
            //获取的数据的点来进行渲染
            
            
        }) { (error) in
            
            
        }
        
        
    }
    
    // MARK: - 添加默认的项目选择方法
    func setUpProjectNameLable() -> String{
        
        let dic = UserDefaults.standard.object(forKey: Const.YQProjectModel) as? [String : Any]
        
        var projectName  = ""
        
        if dic != nil {
            
            projectName = dic?["PARK_NAME"] as! String
            self.parkId = dic?["ID"] as! String
            
            
        }else{
            
            projectName = "请选择默认项目"
        }
        
        return projectName
        
    }
    
    // MARK: - mapSet 地图显示的初始化设置
    func mapViewSetup(){
        
        AMapServices.shared().enableHTTPS = true
        mapView.showsUserLocation = true;
        mapView.userTrackingMode = .none;
        mapView.delegate = self as! MAMapViewDelegate
        mapView.zoomLevel = 16.0 //地图的缩放的级别比例
        
        // 带逆地理信息的一次定位（返回坐标和地址信息）
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        //   定位超时时间，最低2s，此处设置为5s
        self.locationManager.locationTimeout = 2;
        //   逆地理请求超时时间，最低2s，此处设置为5s
        self.locationManager.reGeocodeTimeout = 2;

    
    
    }
    
    // MARK: - mapView 进行打点的方法
    func addLocationAndMessageView(model: YQVideoMapPointModel){
    
    
    
    }
    

}

extension YQVideoDrawerViewController : MAMapViewDelegate{

    // MARK: - 设置mark的标记的类型图标的方法
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        
        return nil
    }
    
    
    //deselect 弹窗的视图的方法
    func mapView(_ mapView: MAMapView!, didDeselect view: MAAnnotationView!) {
        
        //设置为隐藏
        
    }


    //点击地图图标的方法
    func mapView(_ mapView: MAMapView!, didAnnotationViewCalloutTapped view: MAAnnotationView!) {
        //实现的思路是: 应用封装好的packView来实现
        
        
    }

}
