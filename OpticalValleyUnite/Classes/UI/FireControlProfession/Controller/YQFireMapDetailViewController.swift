//
//  YQFireMapDetailViewController.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/9/21.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class YQFireMapDetailViewController: UIViewController {

    // MARK: - 视图属性
    // 传递的fireModel,监听set方法
    var fireModel : YQFireLocationModel!{
        
        didSet{
            //调用展示详情list的数据
            self.makeImplementTableViewData(model : (self.fireModel)!)
        }
        
    }
    
    //startCoordinate
    var startCoordinate : CLLocationCoordinate2D!
    //endCoordinate
    var endCoordinate : CLLocationCoordinate2D!
    
    //tableViewDataList
    var implementTableViewDataArray = [YQStateListModel](){
        didSet{
        
            self.tableView.reloadData()
        }
    }
    
    //相距的距离label
    @IBOutlet weak var distanceLable: UILabel!
    
    //步行的时间label
    @IBOutlet weak var walkingMinuteLable: UILabel!
    
    
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var locationMapView: MAMapView!
    
    @IBOutlet weak var giveupAbandon: UIButton!
    @IBOutlet weak var atOnceImplement: UIButton!
    
    // userPointLocation
    var pointLocation : AnimatedAnnotation!
    
    // MAMap单例
    var locationManager = AMapLocationManager()
    
    /* 路径规划的系列的属性 */
    // 主search对象
    var search : AMapSearchAPI!
    var naviRoute: MANaviRoute?
    
    //除了驾车以外的所有的路径显示,高德的返回列表
    var route: AMapRoute!{
        
        didSet{
            
            let MapPath = route?.paths[0]
            
            if MapPath == nil {
                
                return
            }
            
            let x = MapPath?.distance ?? 0
            let y = MapPath?.duration ?? 0
//            print(x)
//            print(y)
            self.distanceLable.text = "\(x/1000)" + "km"
            
            self.walkingMinuteLable.text = self.getFormatPlayTime(secounds: TimeInterval(y))
            
            
        
        }
    }
    

    var currentSearchType: AMapRoutePlanningType = AMapRoutePlanningType.drive

    
    
    // MARK: - 视图生命周期的方法
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let Coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(fireModel.latitude), CLLocationDegrees(fireModel.longitude))
        self.endCoordinate = Coordinate
        
        //创建和设置search代理的方法
        search = AMapSearchAPI()
        search?.delegate = self
        
        //设置地图
        mapSetup()
        
        //接受通知
        // acceptNotes()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {

        //用户执行按钮可用
        self.giveupAbandon.isUserInteractionEnabled = true
        self.atOnceImplement.isUserInteractionEnabled = true
        
        //设置打点和渲染
        self.addLocationAndMessageView(model: (self.fireModel)!)
        //添加默认的选中气泡
        self.locationMapView.selectAnnotation(self.pointLocation, animated: true)
        
    }

    
    // MARK: - 执行界面(implementView)系列buttonClick
    //立即反馈
    @IBAction func atOnceFeedBackClick(_ sender: Any) {
        
        //跳转到立即反馈的界面进行操作
        let feedBack = UIStoryboard.instantiateInitialViewController(name: "YQImplementFeedback") as! YQImplementFeedbackVC
        
        feedBack.fireModel = self.fireModel
        
        self.navigationController?.pushViewController(feedBack, animated: true)
    }
    
    
    /*
     实现的逻辑:点击立即执行 --> 请求执行接口 ---> 刷新table列表数据接口 ---> 设置btn的状态属性
     */
    //立即执行
    @IBAction func atOnceImplementClick(_ sender: Any) {
    
        var paramet = [String : Any]()
        let token = UserDefaults.standard.object(forKey: Const.SJToken)
        /*
         status : 1 代表前往执行  2 代表放弃执行
         */
        paramet["token"] = token
        paramet["firePointId"] = self.fireModel.firePointId
        paramet["status"] = 1
        self.atOnceImplement.isUserInteractionEnabled = false
    
        self.firePointExecuteFunction(par: paramet)
    
    }
    
    
    //放弃执行
    @IBAction func giveUpImplementClick(_ sender: Any) {
        
        var paramet = [String : Any]()
        let token = UserDefaults.standard.object(forKey: Const.SJToken)
        /*
         status : 1 代表前往执行  2 代表放弃执行
         */
        paramet["token"] = token
        paramet["firePointId"] = self.fireModel.firePointId
        paramet["status"] = 2
        self.giveupAbandon.isUserInteractionEnabled = false
        
        self.firePointExecuteFunction(par: paramet)
       
        
    }
    
    // MARK: - 手动添加定位按钮点击方法
    @IBAction func manualLocationBtnClick(_ sender: Any) {
        
        
    }
    
    // MARK: - 接受通知方法
//    func acceptNotes(){
//        
//        NotificationCenter.default.addObserver(self
//            , selector: #selector(locationDetailModel(notes:)), name: NSNotification.Name(rawValue: "locationDetailModelPassValue"), object: nil)
//    }
//    func locationDetailModel(notes : NSNotification){
//        
//        let model = notes.userInfo?["model"] as! YQFireLocationModel
//        
//        self.fireModel = model
//    
//    }
    
    // MARK: - 前往执行、放弃执行的方法
    func firePointExecuteFunction(par : [String : Any]){
        
        SVProgressHUD.show()
        HttpClient.instance.post(path: URLPath.getFireExecute, parameters: par, success: { (response) in
            
            SVProgressHUD.dismiss()
            
            if par["status"] as? Int == 2 {
                
                self
                    .navigationController?.popViewController(animated: true)
            }
            
        }) { (error) in
            
            SVProgressHUD.showError(withStatus: "执行失败!")
        }
        
        
    }
    
    
    // MARK: - 调用展示详情list的数据
    func makeImplementTableViewData(model : YQFireLocationModel){
        
        //调取火警点执行的动态的接口
        var parameters = [String : Any]()
        let token = UserDefaults.standard.object(forKey: Const.SJToken)
        parameters["token"] = token
        parameters["firePointId"] = model.firePointId
        self.gotoImplementDataWithBackStage(parameters: parameters)

    }
    
    // MARK: - 获取fire的数据接口方法
    func gotoImplementDataWithBackStage(parameters : [String :Any]){
        
        SVProgressHUD.show(withStatus: "加载中...")
        
        Alamofire.request(URLPath.basicPath + URLPath.getFireState , method: .post, parameters: parameters).responseJSON { (response) in
            
            SVProgressHUD.dismiss()
            switch response.result {
                
            case .success(_):
                
                if let value = response.result.value as? [String: Any] {
                    
                    guard value["CODE"] as! String == "0" else{
                        let message = value["MSG"] as! String
                        
                        self.alert(message: message)
                        return
                    }
                    

                    if let data = value["data"] as? NSDictionary{
                        //判断isExec,主线程跟新UI设置
                        let isExec = data["isExec"] as! Bool
                        DispatchQueue.main.async {
                            
                            self.setUpFooterButtonState(isExec: isExec)
                            
                        }
                        
                        let array = data["stateList"] as? NSArray
                        
                        if array != nil || (array!.count > 1){
                            
                            var temp = [YQStateListModel]()
                            
                            for dict in array!{
                                
                                temp.append(YQStateListModel.init(dic: dict as! [String : Any]))
                            }
                            
                            self.implementTableViewDataArray = temp
                            
                        }
                    }
                    
                   
                    break
                }
                break
                
            case .failure(let error):
                
                debugPrint(error)
                self.alert(message: "请求失败!")
                break
            }
        }
    
    }
    
    // MARK: - 设置地图
    func mapSetup(){
        
        //map实现的单例
        AMapServices.shared().enableHTTPS = true
        locationMapView.showsUserLocation = true;
        locationMapView.userTrackingMode = .none
        
        locationMapView.delegate = self as MAMapViewDelegate
        locationMapView.zoomLevel = 5.0 //地图的缩放的级别比例
        //设置移动的最小定位距离
        locationMapView.distanceFilter = 10.0 //位移10米才进行的定位操作
        
        // 带逆地理信息的一次定位（返回坐标和地址信息）
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        //   定位超时时间，最低2s，此处设置为5s
        self.locationManager.locationTimeout = 2;
        //   逆地理请求超时时间，最低2s，此处设置为5s
        self.locationManager.reGeocodeTimeout = 2;
        
        //添加自定义的小蓝点的情况
        /*
         以下功能自iOS 地图 SDK V5.0.0 版本起支持。
        */
        //添加自定义的_UserLocationRepresentation
        let r = MAUserLocationRepresentation()
        r.image = UIImage(named: "icon_fire_position_blue")
        //精度圈是否显示
        r.showsAccuracyRing = true
        //方向箭头是否显示
        r.showsHeadingIndicator = true
        locationMapView.update(r)
        
        locationManager.requestLocation(withReGeocode: true, completionBlock:{
            [weak self]  location, regeocode,error in
            
            if let error = error{
                print(error.localizedDescription)
                
            }
            
            if let regeocode = regeocode{
                print(regeocode)
                
                self?.locationMapView.setCenter((location?.coordinate)!, animated: true)
                
                let  loc = (location?.coordinate)!
                self?.startCoordinate = CLLocationCoordinate2DMake(loc.latitude, loc.longitude)
                
                //调用规划路径的方法
                self?.showRoute()
            }
            
        })
    }
    
    // MARK: - 设置底部的footer的显示状态的方法
    func setUpFooterButtonState(isExec : Bool){
        
        //主线程进行设置,btn的循环显示
        if isExec {//已经执行,显示放弃执行
            
            self.giveupAbandon.isHidden = !isExec
            self.atOnceImplement.isHidden = isExec
            
        }else{//没有执行,显示已经执行
            
            self.giveupAbandon.isHidden = isExec
            self.atOnceImplement.isHidden = !isExec
        }
        
        self.giveupAbandon.isUserInteractionEnabled = true
        self.atOnceImplement.isUserInteractionEnabled = true
        
    }
    
    
    // MARK: - 高德添加 大头针,添加点击弹框视图的
    func addLocationAndMessageView(model : YQFireLocationModel) {
        //添加大头针location点
        //合成生成经纬度的情况
        let CLLocationCoordinate2D = CLLocationCoordinate2DMake(CLLocationDegrees(model.latitude), CLLocationDegrees(model.longitude))
        
        let starPoint = YQPointAnnotation()//系统标记点location
        starPoint.coordinate = CLLocationCoordinate2D
        starPoint.title = model.name
        starPoint.subtitle = model.detail
        starPoint.pointModel = model
        self.pointLocation = starPoint
        
        locationMapView.addAnnotation(starPoint)
    }
    
    
    // MARK: - 展示路径
    func showRoute() {
        
        //通过start 和 end 的经纬度来进行规划路线
        let request = AMapWalkingRouteSearchRequest()
        request.origin = AMapGeoPoint.location(withLatitude: CGFloat(startCoordinate.latitude), longitude: CGFloat(startCoordinate.longitude))
        request.destination = AMapGeoPoint.location(withLatitude: CGFloat(endCoordinate.latitude), longitude: CGFloat(endCoordinate.longitude))
        
        search.aMapWalkingRouteSearch(request)

    }
    
    // MARK: - 展示当前路线方案,规划路径
    /* 展示当前路线方案 */
    func presentCurrentCourse() {
        
        let start = AMapGeoPoint.location(withLatitude: CGFloat(startCoordinate.latitude), longitude: CGFloat(startCoordinate.longitude))
        let end = AMapGeoPoint.location(withLatitude: CGFloat(endCoordinate.latitude), longitude: CGFloat(endCoordinate.longitude))
        
        if currentSearchType == .bus || currentSearchType == .busCrossCity {
            naviRoute = MANaviRoute(for: route?.transits.first, start: start, end: end)
        } else {
            let type = MANaviAnnotationType(rawValue: currentSearchType.rawValue)
            
            naviRoute = MANaviRoute(for: route?.paths.first, withNaviType: type!, showTraffic: true, start: start, end: end)
        }
        
        naviRoute?.add(to: locationMapView)
        
        locationMapView.showOverlays(naviRoute?.routePolylines, edgePadding: UIEdgeInsetsMake(20, 20, 20, 20), animated: true)
        locationMapView.zoomLevel = 12.0 //地图的缩放的级别比例
        
    }
    
    // MARK: - 分秒换算的方法
    func getFormatPlayTime(secounds:TimeInterval)->String{
        
        if secounds.isNaN{
            return "00:00"
        }
        
        var Min = Int(secounds / 60)
        let Sec = Int(secounds.truncatingRemainder(dividingBy: 60))
        var Hour = 0
        if Min>=60 {
            Hour = Int(Min / 60)
            Min = Min - Hour*60
            return String(format: "%02d时%02d分%02d秒", Hour, Min, Sec)
        }
        
        return String(format: "%02d分%02d秒", Min, Sec)
    }
    

    
    // MARK: - 控制器销毁的方法
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    
}

extension YQFireMapDetailViewController : MAMapViewDelegate{
    
    func mapViewDidFinishLoadingMap(_ mapView: MAMapView!) {
        
    }
    
    func mapInitComplete(_ mapView: MAMapView!) {
        
    }
    
    // MARK: - overlay执行的代理方法
    // overlay
    func mapView(_ mapView: MAMapView!, rendererFor overlay: MAOverlay!) -> MAOverlayRenderer! {
        
        if overlay.isKind(of: LineDashPolyline.self) {
            let naviPolyline: LineDashPolyline = overlay as! LineDashPolyline
            let renderer: MAPolylineRenderer = MAPolylineRenderer(overlay: naviPolyline.polyline)
            renderer.lineWidth = 8.0
            renderer.strokeColor = UIColor.red
            renderer.lineDash = true
            
            return renderer
        }
        if overlay.isKind(of: MANaviPolyline.self) {
            
            let naviPolyline: MANaviPolyline = overlay as! MANaviPolyline
            let renderer: MAPolylineRenderer = MAPolylineRenderer(overlay: naviPolyline.polyline)
            renderer.lineWidth = 8.0
            
            if naviPolyline.type == MANaviAnnotationType.walking {
                renderer.strokeColor = naviRoute?.walkingColor
            }
            else if naviPolyline.type == MANaviAnnotationType.railway {
                renderer.strokeColor = naviRoute?.railwayColor;
            }
            else {
                renderer.strokeColor = naviRoute?.routeColor;
            }
            
            return renderer
        }
        if overlay.isKind(of: MAMultiPolyline.self) {
            let renderer: MAMultiColoredPolylineRenderer = MAMultiColoredPolylineRenderer(multiPolyline: overlay as! MAMultiPolyline!)
            renderer.lineWidth = 8.0
            renderer.strokeColors = naviRoute?.multiPolylineColors
            
            return renderer
        }
        
        return nil
    }
    
    
    // MARK: - 设置mark的标记的类型
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        
        //通过这里来进行的样式的设置,点击的弹框的效果情况
        if annotation.isKind(of: YQPointAnnotation.self){
            
            let pointReuseIndetifier = "pointReuseIndetifier"
            var annotationView: MAPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier) as! MAPinAnnotationView?
            
            if annotationView == nil {
                annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
            }
            
            annotationView!.image = UIImage(named: "icon_fire_position_red")
            annotationView!.canShowCallout = true //设置气泡可以弹出，默认为NO
            annotationView!.animatesDrop = true  //设置标注动画显示，默认为NO
            annotationView!.isDraggable = false  //设置标注可以拖动，默认为NO
            //            annotationView!.rightCalloutAccessoryView = UIButton(type: UIButtonType.detailDisclosure)
            
            //            let idx = annotation.index(of: annotation as! MAPointAnnotation)
            //            annotationView!.pinColor = MAPinAnnotationColor(rawValue: idx!)!
            
            return annotationView!
        }
        return nil
    }
}

extension YQFireMapDetailViewController : AMapSearchDelegate{
    
    // MARK: - 解析search_response获取路径信息
    func onRouteSearchDone(_ request: AMapRouteSearchBaseRequest!, response: AMapRouteSearchResponse!) {
        self.route = nil
        if response.count > 0 {
            
//            print(response)
//            print(response.route)
            
            self.route = response.route
            
            presentCurrentCourse()
            
        }
    }
    
    // MARK: - search失败的代理方法
    func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
        print("Error:\(error)")
    }

}


extension YQFireMapDetailViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.implementTableViewDataArray.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return Bundle.main.loadNibNamed("YQImplementDetailHead", owner: nil, options: nil)![0] as? UIView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "implementCell", for: indexPath)
        cell.textLabel?.text = self.implementTableViewDataArray[indexPath.row].content
        return cell
    }

}


