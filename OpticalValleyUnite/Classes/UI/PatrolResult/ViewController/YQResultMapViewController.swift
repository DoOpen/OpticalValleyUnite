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
    @IBOutlet weak var timeView: DateChooseView!
   
    
    @IBOutlet weak var mapView: MAMapView!
    
    // MAMap单例
    var locationManager = AMapLocationManager()
    
    // lineType
    var wayLineType = 0
    
    lazy var overlays = {
        
        return Array<MAOverlay>()
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "巡查轨迹"
        self.automaticallyAdjustsScrollViewInsets = false
        
        //地图定位
        mapViewSetup()
        
        addLeftRightBarButtonFunction()
        
        //默认打开弹窗
        rightBarButtonClick()
        
        //获取项目筛选的数据,接受通知
        receiveNotiesData()
        
        //日历查询的方法
        timeView.didSelectHandle = { [weak self] dateStr in
            
            self?.title = "巡查轨迹" + dateStr
            //发送通知来进行切换筛选
            let center = NotificationCenter.default
            let notiesName = NSNotification.Name(rawValue: "drawerUpdateNoties")
            center.post(name: notiesName, object: nil, userInfo: ["drawerdateString": dateStr])
            
        }
    }
    
    // MARK: - 重定位buttonClick
    @IBAction func RepositionButtonClick(_ sender: UIButton) {
        
        mapViewSetup()
        
    }
    
    
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        mapView.addOverlays(overlays)
//        mapView.showOverlays(overlays, edgePadding: UIEdgeInsetsMake(20, 20, 20, 20), animated: true)
//
//    }
    
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
        mapView.zoomLevel = 15.0 //地图的缩放的级别比例
        
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
        
        //划线重新置空的情况
        mapView.removeOverlays(overlays)
        overlays.removeAll()
        
        
        let dataArray = noties.userInfo?["VideoLoadWaysArray"] as? NSDictionary
        if dataArray == nil {
            
            return
        }

        if let drawerController = self.navigationController?.parent as? KYDrawerController {
            
            drawerController.setDrawerState(.closed , animated: true)
        }

        //赋值,划线,逻辑渲染
        //1.实际执行的路线, 还是应用的是 红色 箭头来显示的  本地区分是 1
        if let executeWay = dataArray?["executeWay"]  as? NSArray{
            
            for temp1 in executeWay {
                
                let  temp2 = temp1 as! NSDictionary
                
                if let pointA =  temp2["pointList"] as? NSArray {
                    if pointA.count > 0  {
                        
                        self.wayLineType = 1
                        var executeWayArray = [CLLocationCoordinate2D]()
                        
                        for dict in pointA {
                            let temp = dict as? NSDictionary
                            
                            let longitude = temp?["longitude"] as? String
                            let latitude = temp?["latitude"] as? String
                            let CLLocationCoordinate2D = CLLocationCoordinate2DMake(CLLocationDegrees(latitude!)!, CLLocationDegrees(longitude!)!)
                            executeWayArray.append(CLLocationCoordinate2D)
                            
                        }
                        
                        self.mapView.setCenter(executeWayArray.first!, animated: true)
                        
                        //执行画线的方法
                        //划线
                        let polyline: MAPolyline = MAPolyline(coordinates: &executeWayArray, count: UInt(executeWayArray.count))
                       overlays.append(polyline)
                    }
                }
            }
        }
        
        //设计路线  要求应用 蓝色来表示 本地区分是 2
        if let designWay = dataArray?["designWay"] as? NSArray {
    
            for temp in designWay {
                
                let temp1 = temp as! NSDictionary
                
                if let pointA = temp1["pointList"] as? NSArray {
                    if pointA.count > 0  {
                        
                        self.wayLineType = 2
                        var designWayArray = [CLLocationCoordinate2D]()
                        
                        for dict in pointA {
                            let temp = dict as? NSDictionary
                            
                            let longitude = temp?["longitude"] as? String
                            let latitude = temp?["latitude"] as? String
                            let CLLocationCoordinate2D = CLLocationCoordinate2DMake(CLLocationDegrees(latitude!)!, CLLocationDegrees(longitude!)!)
                            designWayArray.append(CLLocationCoordinate2D)
                            
                        }
                        
                        
                         self.mapView.setCenter(designWayArray.first!, animated: true)
                        //执行画线的方法
                        //划线
                        let polyline: MAPolyline = MAPolyline(coordinates: &designWayArray, count: UInt(designWayArray.count))
                        overlays.append(polyline)
                        
                    }
                }
            }
        }
        
        //真实路线  要求应用 绿色来表示绘制  本地区分是 3
        if let realWay = dataArray?["realWay"] as? NSArray {
            
            for temp in realWay {
                
                let temp1 = temp as! NSDictionary
                
                if let pointA = temp1["pointList"] as? NSArray {
                    
                    if pointA.count > 0  {
                        
                        self.wayLineType = 3
                        var realWayArray = [CLLocationCoordinate2D]()
                        
                        for dict in pointA {
                            let temp = dict as? NSDictionary
                            
                            let longitude = temp?["longitude"] as? String
                            let latitude = temp?["latitude"] as? String
                            let CLLocationCoordinate2D = CLLocationCoordinate2DMake(CLLocationDegrees(latitude!)!, CLLocationDegrees(longitude!)!)
                            realWayArray.append(CLLocationCoordinate2D)
                            
                        }
                        
                        self.mapView.setCenter(realWayArray.first!, animated: true)
                        
                        //执行画线的方法
                        //划线
                        let polyline: MAPolyline = MAPolyline(coordinates: &realWayArray, count: UInt(realWayArray.count))
                        overlays.append(polyline)
                    }
                    
                }
                
            }
          
        }
        
        
        mapView.addOverlays(overlays)
        
    }
    
    
    // MARK: - vc销毁的方法
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }


 
  
}

extension YQResultMapViewController : MAMapViewDelegate {

    func mapView(_ mapView: MAMapView!, rendererFor overlay: MAOverlay!) -> MAOverlayRenderer! {
        
        //想要设置文理的方法是: 直接到这个方法中来进行添加的 设置相应的图片
        /*
         polylineRenderer.loadStrokeTextureImage(UIImage.init(named: "arrowTexture"))
         */
        
        //重置渲染的情况
//        self.mapView.remove(overlay)
        
        if overlay.isKind(of: MAPolyline.self) {
            
            //switch 的来进行的判断各个type的线条颜色
            let renderer: MAPolylineRenderer = MAPolylineRenderer(overlay: overlay)
            renderer.lineWidth = 8.0
            
            switch self.wayLineType {
            case 1://实际行走执行轨迹
                renderer.strokeImage = UIImage.init(named: "多边形-1")
                
                break
                
            case 2://设计轨迹,蓝色来 渲染
                renderer.strokeColor = UIColor.blue
                renderer.lineCapType = kMALineCapArrow //设置画箭头的属性情况
                
                break
                
            case 3://真实路线,绿色来 渲染
                renderer.strokeColor = UIColor.green
                renderer.lineCapType = kMALineCapArrow //设置画箭头的属性情况

                break
                
            default:
                break
            }
            
            
            return renderer
        }
        
        return nil
    }



}
