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
    @IBOutlet weak var calendarView: FSCalendar!
   
    
    @IBOutlet weak var mapView: MAMapView!
    
    // MAMap单例
    var locationManager = AMapLocationManager()
    
    // lineType
    var wayLineType = 0
    
    lazy var overlays = {
        
        return Array<MAOverlay>()
    }()

    // video模型数据
    var videoMapPointModel = [YQVideoMapPointModel](){
        
        didSet{
            
            //调用地图渲染,打点的方法(有多少个模型,就需要多少个标记)
            for model in videoMapPointModel{
                
                addLocationAndMessageView(model: model)
            }
        }
    }
    
    ///新版日历属性的懒加载情况
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    
    //路径实时的查询的所有类
    var search : AMapSearchAPI!
    var naviRoute: MANaviRoute?
    
    var currentSearchType: AMapRoutePlanningType = AMapRoutePlanningType.walk
    
    //除了驾车以外的所有的路径显示,高德的返回列表
    var route: AMapRoute!{
        
        didSet{
            
            let MapPath = route?.paths[0]
            
            if MapPath == nil {
                
                return
            }
            //            let x = MapPath?.distance ?? 0
            //            let y = MapPath?.duration ?? 0
        }
    }
    
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
        
        //日历的查询方法
        self.calendarView.select(Date())
        self.calendarView.scope = .week
        //添加手势
        let scopeGesture = UIPanGestureRecognizer(target: self.calendarView, action: #selector(self.calendarView.handleScopeGesture(_:)))
        self.calendarView.addGestureRecognizer(scopeGesture)
        
        //路径导航初始化
        search = AMapSearchAPI()
        search?.delegate = self
        
    }
    
    // MARK: - 重定位buttonClick
    @IBAction func RepositionButtonClick(_ sender: UIButton) {
        
        mapViewSetup()
        
    }
    
    // MARK: - 日期转换模式buttonClick
    
    @IBAction func dateModeButtonClick(_ sender: UIButton) {
        
        if self.calendarView.scope == .month {
            self.calendarView.setScope(.week, animated: true)
        } else {
            self.calendarView.setScope(.month, animated: true)
        }
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
    
    
    // MARK: - mapView 进行打点的方法
    func addLocationAndMessageView(model: YQVideoMapPointModel){
        //进行判空的情况
        if model.latitude == "" || model.longitude == "" {
            
            SVProgressHUD.showError(withStatus: "点位位置信息为空!")
            return
        }
        
        //设置打点的情况
        let CLLocationCoordinate2D = CLLocationCoordinate2DMake(CLLocationDegrees(model.latitude)!, CLLocationDegrees(model.longitude)!)
        
        //设置定义MAPointAnnotation
        let annotation: YQVideoPatrolAnnotation? = YQVideoPatrolAnnotation()
        annotation?.coordinate = CLLocationCoordinate2D
        annotation?.title = model.name
        annotation?.videoModel = model
        
        mapView.addAnnotation(annotation)
        
    }
    
    
    // MARK: - 获取通知数据
    func receiveNotiesData(){
    
        let center = NotificationCenter.default
        let notiesName = NSNotification.Name(rawValue: "resultDrawerLoadWaysNoties")

        center.addObserver(self, selector: #selector(resultDrawerLoadWaysNoties(noties:)), name: notiesName, object: nil)
    
    }
    
    func resultDrawerLoadWaysNoties (noties : Notification){
        
        //划线重新置空的情况
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(overlays)
        mapView.removeOverlays(mapView.overlays)
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
                        
                        var tempModel = [YQVideoMapPointModel]()
                        self.wayLineType = 1
                        var executeWayArray = [CLLocationCoordinate2D]()
                        
                        for dict in pointA {
                            let temp = dict as? [String : Any]
                            
                            let longitude = temp?["longitude"] as? String
                            let latitude = temp?["latitude"] as? String
                            
                            if longitude == "" || latitude == "" {
                                
                                SVProgressHUD.showError(withStatus: "实际执行点位信息为空!")
                                break
                            }
                            
                            let CLLocationCoordinate2D = CLLocationCoordinate2DMake(CLLocationDegrees(latitude!)!, CLLocationDegrees(longitude!)!)
                            executeWayArray.append(CLLocationCoordinate2D)
                            
                            tempModel.append(YQVideoMapPointModel.init(dict: temp!))
                            
                        }
                        //渲染打点的情况
                        self.videoMapPointModel = tempModel
                        
                        if executeWayArray.count < 1 {
                            
                            break
                        }
                        
                        //画规划的步行路线
                        for indexxx in 0..<tempModel.count {
                            
                            if(indexxx == tempModel.count - 1){
                                
                                return
                            }
                            
                            let start =  CLLocationCoordinate2DMake(CLLocationDegrees(tempModel[indexxx].latitude)!, CLLocationDegrees(tempModel[indexxx].longitude)!)
                            
                            let end =  CLLocationCoordinate2DMake(CLLocationDegrees(tempModel[indexxx + 1].latitude)!, CLLocationDegrees(tempModel[indexxx + 1].longitude)!)
                            
                            showRoute(startCoordinate: start, endCoordinate: end)
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
                        var tempModel = [YQVideoMapPointModel]()
                        
                        for dict in pointA {
                            
                            let temp = dict as? [String : Any]
                            
                            let longitude = temp?["longitude"] as? String ?? "0"
                            let latitude = temp?["latitude"] as? String ?? "0"
                            if longitude == "" || latitude == "" {
                                
                                SVProgressHUD.showError(withStatus: "设计路线点位信息为空!")
                                break
                            }
                            
                            let CLLocationCoordinate2D = CLLocationCoordinate2DMake(CLLocationDegrees(latitude)!, CLLocationDegrees(longitude)!)
                            designWayArray.append(CLLocationCoordinate2D)
                            
                             tempModel.append(YQVideoMapPointModel.init(dict: temp!))
                        }
                        //渲染打点的情况
                        self.videoMapPointModel = tempModel
                        
                        if designWayArray.count < 1 {
                            
                            break
                        }
                        
                        self.mapView.setCenter(designWayArray.first!, animated: true)
                        
                        //画规划的步行路线
                        for indexxx in 0..<tempModel.count {

                            if(indexxx == tempModel.count - 1){

                                return
                            }

                            let start =  CLLocationCoordinate2DMake(CLLocationDegrees(tempModel[indexxx].latitude)!, CLLocationDegrees(tempModel[indexxx].longitude)!)

                            let end =  CLLocationCoordinate2DMake(CLLocationDegrees(tempModel[indexxx + 1].latitude)!, CLLocationDegrees(tempModel[indexxx + 1].longitude)!)

                            showRoute(startCoordinate: start, endCoordinate: end)
                        }

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
                        var tempModel = [YQVideoMapPointModel]()
                        
                        for dict in pointA {
                            
                            let temp = dict as? [String : Any]
                            
                            let longitude = temp?["longitude"] as? String
                            let latitude = temp?["latitude"] as? String
                            
                            if longitude == "" || latitude == "" {
                                SVProgressHUD.showError(withStatus: "真实路线点位信息为空!")
                                break
                            }
                            
                            let CLLocationCoordinate2D = CLLocationCoordinate2DMake(CLLocationDegrees(latitude!)!, CLLocationDegrees(longitude!)!)
                            realWayArray.append(CLLocationCoordinate2D)
                            
                            tempModel.append(YQVideoMapPointModel.init(dict: temp!))
                        }
                        
                        //渲染打点的情况
                        self.videoMapPointModel = tempModel
                        
                        if realWayArray.count < 1 {
                            
                            break
                        }
                        
                        //画规划的步行路线
                        for indexxx in 0..<tempModel.count {
                            
                            if(indexxx == tempModel.count - 1){
                                
                                return
                            }
                            
                            let start =  CLLocationCoordinate2DMake(CLLocationDegrees(tempModel[indexxx].latitude)!, CLLocationDegrees(tempModel[indexxx].longitude)!)
                            
                            let end =  CLLocationCoordinate2DMake(CLLocationDegrees(tempModel[indexxx + 1].latitude)!, CLLocationDegrees(tempModel[indexxx + 1].longitude)!)
                            
                            showRoute(startCoordinate: start, endCoordinate: end)
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
    
    // MARK: - 展示真实的路径规划情况
    func showRoute(startCoordinate : CLLocationCoordinate2D, endCoordinate : CLLocationCoordinate2D) {
        
        //通过start 和 end 的经纬度来进行规划路线
        let request = AMapWalkingRouteSearchRequest()
        request.origin = AMapGeoPoint.location(withLatitude: CGFloat(startCoordinate.latitude), longitude: CGFloat(startCoordinate.longitude))
        request.destination = AMapGeoPoint.location(withLatitude: CGFloat(endCoordinate.latitude), longitude: CGFloat(endCoordinate.longitude))
        
        search.aMapWalkingRouteSearch(request)
        
    }
    
    // MARK: - 展示当前路线方案,规划路径
    /* 展示当前路线方案 */
    func presentCurrentCourse(startCoordinate : CLLocationCoordinate2D,endCoordinate : CLLocationCoordinate2D) {
        
        let start = AMapGeoPoint.location(withLatitude: CGFloat(startCoordinate.latitude), longitude: CGFloat(startCoordinate.longitude))
        let end = AMapGeoPoint.location(withLatitude: CGFloat(endCoordinate.latitude), longitude: CGFloat(endCoordinate.longitude))
        
        if currentSearchType == .bus || currentSearchType == .busCrossCity {
            
            naviRoute = MANaviRoute(for: route?.transits.first, start: start, end: end)
        } else {
            
            let type = MANaviAnnotationType(rawValue: currentSearchType.rawValue)
            
            naviRoute = MANaviRoute(for: route?.paths.first, withNaviType: type!, showTraffic: true, start: start, end: end)
        }
        
        naviRoute?.add(to: mapView)
        
        mapView.showOverlays(naviRoute?.routePolylines, edgePadding: UIEdgeInsetsMake(20, 20, 20, 20), animated: true)
        
        mapView.setVisibleMapRect(CommonUtility.mapRect(forOverlays: naviRoute?.routePolylines), edgePadding: UIEdgeInsetsMake(20, 20, 20, 20), animated: true)
        
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
        // self.mapView.remove(overlay)
        
        if overlay.isKind(of: LineDashPolyline.self) {
            
            let naviPolyline: LineDashPolyline = overlay as! LineDashPolyline
            let renderer: MAPolylineRenderer = MAPolylineRenderer(overlay: naviPolyline.polyline)
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
        
        if overlay.isKind(of: MANaviPolyline.self) {
            
            let naviPolyline: MANaviPolyline = overlay as! MANaviPolyline
            let renderer: MAPolylineRenderer = MAPolylineRenderer(overlay: naviPolyline.polyline)
            renderer.lineWidth = 8.0
            
            if naviPolyline.type == MANaviAnnotationType.walking {
                
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
                
            }
            else if naviPolyline.type == MANaviAnnotationType.railway {
                
                renderer.strokeColor = naviRoute?.railwayColor
                
            }
            else {
                
                renderer.strokeColor = naviRoute?.routeColor
            }
            
            return renderer
        }
        
        if overlay.isKind(of: MAMultiPolyline.self) {
            
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

    // MARK: - 设置mark的标记的类型图标的方法
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        
        let nowAnnotation = annotation as? YQVideoPatrolAnnotation
        
        if (annotation.isKind(of: YQVideoPatrolAnnotation.self)) {
           
            let pointReuseIndetifier = "videoPatrolReuseIndetifier"
            
            var annotationView: MAAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier)
            
            if annotationView == nil {
                
                annotationView = MAAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
            }
            
            //添加逻辑的判断 情况: isint的属性来进行判断
            //通过模型来进行的传递的 model
            if nowAnnotation?.videoModel?.isIns == 0 { // 没有执行的情况
                
                switch (nowAnnotation?.videoModel?.type)! {
                case 1://室内点
                    annotationView?.image = UIImage.init(name: "室内2")
                    break
                case 2://室外点
                    if nowAnnotation?.videoModel?.equipmentId != 0 {
                        
                        annotationView?.image = UIImage.init(name: "室外摄像头2")
                    }else{
                        
                        annotationView?.image = UIImage.init(name: "室外2")
                    }
                    
                    break
                default:
                    break
                    
                }
                
            } else {
                
                switch (nowAnnotation?.videoModel?.type)! {
                case 1://室内点
                    annotationView?.image = UIImage.init(name: "室内1")
                    break
                    
                case 2://室外点
                    
                    if nowAnnotation?.videoModel?.equipmentId != 0 {
                        
                        annotationView?.image = UIImage.init(name: "室外摄像头1")
                    }else{
                        
                        annotationView?.image = UIImage.init(name: "室外1")
                    }
                    
                    break
                default:
                    break
                    
                }
                
            }
            
            annotationView!.canShowCallout = true //设置气泡可以弹出，默认为NO
            
            return annotationView!
        }
        
        return nil
    }

}


extension YQResultMapViewController : FSCalendarDataSource, FSCalendarDelegate {
    
    
    //日历的控件的约束改变的delegate
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    //点击日期的delegate方法
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        print("did select date \(self.dateFormatter.string(from: date))")
        
        let dateStr = self.dateFormatter.string(from: date)
        self.title = "巡查轨迹" + dateStr
        //发送通知来进行切换筛选
        let center = NotificationCenter.default
        let notiesName = NSNotification.Name(rawValue: "drawerUpdateNoties")
        center.post(name: notiesName, object: nil, userInfo: ["drawerdateString": dateStr])
        
//        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
//
//        print("selected dates is \(selectedDates)")
        
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        
    
    }
    
    ///切换月的代理方法
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
    
}

extension YQResultMapViewController : AMapSearchDelegate{
    
    // MARK: - 解析search_response获取路径信息
    func onRouteSearchDone(_ request: AMapRouteSearchBaseRequest!, response: AMapRouteSearchResponse!) {
        
        self.route = nil
        
        if response.count > 0 {
            
            self.route = response.route
            let start =  CLLocationCoordinate2DMake(CLLocationDegrees(request.origin.latitude), CLLocationDegrees(request.origin.longitude))
            let end = CLLocationCoordinate2DMake(CLLocationDegrees(request.destination.latitude), CLLocationDegrees(request.destination.longitude))
            
            self.presentCurrentCourse(startCoordinate: start, endCoordinate: end)
            
        }
    }
    
    // MARK: - search失败的代理方法
    func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
        print("Error:\(error)")
    }
    
}
