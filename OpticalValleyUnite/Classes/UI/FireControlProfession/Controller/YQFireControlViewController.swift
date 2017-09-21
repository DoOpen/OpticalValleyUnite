//
//  YQFireControlViewController.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/9/14.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit
import SnapKit
import KYDrawerController
import Alamofire
import SVProgressHUD
import MapKit
//import MAMapKit


class YQFireControlViewController: UIViewController {
    
    // MARK: - 属性列表
    // 执行操作view
    @IBOutlet weak var implementView: YQImplementView!
    // 立即执行bnt
    @IBOutlet weak var backButton: UIButton!
    // 执行listTableView
    @IBOutlet weak var implementTableView: UITableView!
    
    // footer buttonlist
    @IBOutlet weak var alreadyImplementBtn: UIButton!
    @IBOutlet weak var abandonImplementBtn: UIButton!
    @IBOutlet weak var gotoImplementBtn: UIButton!
    
    // 中间contentView
    @IBOutlet weak var messageContentV: UIView!
    
    // mapview
    @IBOutlet weak var fireMapView: MAMapView!
    // currentMapPointAnnotation
    var currentMapPointAnnotation : YQPointAnnotation!
    
    // MAMap单例
    var locationManager = AMapLocationManager()
    
    // userPointLocation
    var pointLocation : MAPointAnnotation!
    
    // leftBtn
    var leftBtn : UIButton!
    // 模型数组
    var fireModel = [YQFireLocationModel](){
        didSet{
            
            //调用地图渲染,打点的方法(有多少个模型,就需要多少个标记)
            for model in fireModel{
                
                addLocationAndMessageView(model: model)
                
            }
        }
    }
    
    var stateListModel = [YQStateListModel](){
        didSet{
            
            self.implementTableView.reloadData()
        }
    
    }
    
    
    
    // MARK: - 视图生命周期的方法
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //设置leftBar图片和点击事件
        let image = UIImage(named : "pic_default")
        let bnt = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        bnt.setImage(image, for: .normal)
        bnt.addTarget(self, action:  #selector(leftBarButtonClick), for: UIControlEvents.touchUpInside)

        //设置显示原始图片的情况
        // image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        // let item2=UIBarButtonItem(customView: btn1)
        // self.navigationItem.rightBarButtonItem=item2
        let left = UIBarButtonItem(customView: bnt)
        self.navigationItem.leftBarButtonItem = left
        
        self.messageContentV.backgroundColor = UIColor(red: 255.0/255.0, green: 240.0/255.0, blue: 230.0/255.0, alpha: 1.0)
        
        //设置地图
        mapSetup()
        
        //接受通知
        setUpNoties()
        
        //获取火警状态的信息
        /*消防点信息, 地图打点使用*/
        makeMapLocationData()
        
    }
    
    
    // MARK: - 设置地图的方法
    private func  mapSetup(){
        
        AMapServices.shared().enableHTTPS = true
        fireMapView.showsUserLocation = true;
        fireMapView.userTrackingMode = .followWithHeading;
        fireMapView.delegate = self as MAMapViewDelegate
        fireMapView.zoomLevel = 10.0 //地图的缩放的级别比例
        
        // 带逆地理信息的一次定位（返回坐标和地址信息）
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        //   定位超时时间，最低2s，此处设置为5s
        self.locationManager.locationTimeout = 5;
        //   逆地理请求超时时间，最低2s，此处设置为5s
        self.locationManager.reGeocodeTimeout = 5;
        
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
                
                self?.fireMapView.setCenter((location?.coordinate)!, animated: true)
            }
            }
        )
    }
    
    
    // MARK: - leftBarButtonClick
    func leftBarButtonClick(){
        
        if let drawerController = navigationController?.parent as? KYDrawerController {
            drawerController.setDrawerState(.opened, animated: true)
        }

    }
    
    
    // MARK: - 接受通知的方法
    func setUpNoties() {
        
        let center = NotificationCenter.default//创建通知
        center.addObserver(self, selector: #selector(drawerSelectionFunction(info:)), name: NSNotification.Name(rawValue: "drawerDetailNoties"), object: nil)//单个值得传递
        center.addObserver(self, selector: #selector(drawerOpenClick), name: NSNotification.Name(rawValue: "openDrawerNoties"), object: nil)//单个值得传递
    }
    
    // MARK: - 通知打开抽屉
    func drawerOpenClick(){
        
        if let drawerController = navigationController?.parent as? KYDrawerController {
            drawerController.setDrawerState(.opened, animated: true)
        }

    }
    
    // MARK: - 抽屉选择功能的实现
    func drawerSelectionFunction(info : NSNotification){
        let infoName = info.userInfo?["notiesName"] as! String
        
        if let drawerController = navigationController?.parent as? KYDrawerController {
            drawerController.setDrawerState(.closed, animated: true)
        }

       
        switch infoName {
            case "join":
                //加载详情界面
                let detail = UIStoryboard.instantiateInitialViewController(name: "YQJoinTotall") as! YQJoinTotallNumVC
                self.navigationController?.pushViewController(detail, animated: true)
                detail.title = "总单量"
                
                break
                
            case "fireAlarm":
                //加载详情界面
                let detail = UIStoryboard.instantiateInitialViewController(name: "YQJoinTotall") as! YQJoinTotallNumVC
                self.navigationController?.pushViewController(detail, animated: true)
                detail.title = "火警单"
                
                break
                
            case "falsePost":
                //加载详情界面
                let detail = UIStoryboard.instantiateInitialViewController(name: "YQJoinTotall") as! YQJoinTotallNumVC
                self.navigationController?.pushViewController(detail, animated: true)
                detail.title = "误报单"
                break
                
            case "system":
                //返回子系统选择界面
                //查看是否有缓存的数据
                let data = UserDefaults.standard.object(forKey: Const.YQTotallData) as? NSArray
                //跳转到子系统的选择界面(需要的是逻辑的判断) 如果是只有一条数据的话,直接调到登录界面
                if (data?.count)! > 1{
                    
                    let systemVC = YQSystemSelectionVC(nibName: "YQSystemSelectionVC", bundle: nil)
                    SJKeyWindow?.rootViewController = systemVC
                    
                    
                }else{// 跳转到登录界面
                    
                    LoginViewController.loginOut()
                    
                }
                
                break
                
            case "pwdModify":
                
                //修改密码的界面
                let vc = UIStoryboard.instantiateInitialViewController(name: "YQUpdataPSW")
                
                navigationController?.pushViewController(vc, animated: true)
                vc.title = "修改密码"
                
                break
                
            case "eixt":
                //退出登录界面
                LoginViewController.loginOut()
                break
            
            case "personalProfile":
                //个人资料
                let vc = UIStoryboard.instantiateInitialViewController(name: "YQPersonDetail")
                navigationController?.pushViewController(vc, animated: true)
                vc.title = "个人资料"
                break
                
            default:
                break
            }
    }
    
    // MARK: - 获取地图打点的位置坐标
    func makeMapLocationData(){
        
        var parameters = [String : Any]()
        let token = UserDefaults.standard.object(forKey: Const.SJToken)
        parameters["token"] = token
        
        SVProgressHUD.show(withStatus: "加载中...")
        
        Alamofire.request(URLPath.basicPath + URLPath.getFireLocation , method: .get, parameters: parameters).responseJSON { (response) in
            
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
                        
                        let array = data["firePointList"] as! NSArray
                        var temp = [YQFireLocationModel]()
                        
                        for dict in array{
                            
                            temp.append(YQFireLocationModel.init(dic: dict as! [String : Any]))
                        }
                        self.fireModel = temp
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
    
    // MARK: - 高德添加 大头针,添加点击弹框视图的
    func addLocationAndMessageView(model : YQFireLocationModel) {
        //添加大头针location点
        //合成生成经纬度的情况
        let CLLocationCoordinate2D = CLLocationCoordinate2DMake(CLLocationDegrees(model.latitude), CLLocationDegrees(model.longitude))
        // let userPoint = MAUserLocation()//用户的location的情况
        
        let starPoint = YQPointAnnotation()//系统标记点location
        starPoint.coordinate = CLLocationCoordinate2D
        starPoint.title = model.name
        starPoint.pointModel = model
        
        self.pointLocation = starPoint
        self.fireMapView.addAnnotation(starPoint)
        
    }
    
    // MARK: - 生成implementView
    // 大头针的详情点击,添加网络的数据,判断网络数据来进行的设置显示UI的功能
    func implementViewDataAndDetailShow(pointAnnotation : YQPointAnnotation){
        self.currentMapPointAnnotation = pointAnnotation
        
        self.implementView.isHidden = false
        //调取火警点执行的动态的接口
        var parameters = [String : Any]()
        let token = UserDefaults.standard.object(forKey: Const.SJToken)
        parameters["token"] = token
        parameters["firePointId"] = pointAnnotation.pointModel.firePointId
        
        SVProgressHUD.show(withStatus: "加载中...")
        
        Alamofire.request(URLPath.basicPath + URLPath.getFireState , method: .get, parameters: parameters).responseJSON { (response) in
            
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
                        let isExec = data["isExec"] as! String
                        DispatchQueue.main.async {
                            self.setImplementFooterState(isExec: isExec)
                        }
                        
                        let array = data["stateList"] as! NSArray
                        var temp = [YQStateListModel]()
                        for dict in array{
                            
                            temp.append(YQStateListModel.init(dic: dict as! [String : Any]))
                        }
                        self.stateListModel = temp
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
    
    // MARK: - 设置implementFooterView
    // 设置implementFooter 的底部显示状态
    func setImplementFooterState(isExec : String){
        //
        if isExec == "true" {//已经有执行了
            self.alreadyImplementBtn.isHidden = false
            
        }else{//没有执行
//           self.abandonImplementBtn.isHidden = false
           self.gotoImplementBtn.isHidden = false
        }
    
    }
    
    // MARK: - implementView执行操作的所有点击的事件
    // 立即执行功能按钮实现
    @IBAction func atOnceFeedBack(_ sender: Any) {
        //跳转到立即反馈的界面进行操作
        let feedBack = UIStoryboard.instantiateInitialViewController(name: "YQImplementFeedback") as! YQImplementFeedbackVC
        
        
        self.navigationController?.pushViewController(feedBack, animated: true)
        
    }
    
    
    //已经执行,前往查看点击
    @IBAction func alreadyImplementAndCheckOutMapViewClick(_ sender: Any) {
        //执行也是跳转到地图详情界面,重新拉接口,传模型
        //跳转界面来进行地图渲染,规划路线,显示详细信息
        let detailVC = UIStoryboard.instantiateInitialViewController(name: "YQFireMapDetail") as! YQFireMapDetailViewController
        self.navigationController?.pushViewController(detailVC, animated: true)
        // 直接进行model 的传值
        detailVC.fireModel = self.currentMapPointAnnotation.pointModel
    
    }
    
    //前往执行
    @IBAction func gotoImplementClick(_ sender: Any) {
        
        if self.currentMapPointAnnotation == nil {
            return
        }
        //调用执行接口,成功就跳转,失败就弹框执行失败
        var parameters = [String : Any]()
        let token = UserDefaults.standard.object(forKey: Const.SJToken)
        parameters["token"] = token
        parameters["firePointId"] = self.currentMapPointAnnotation.pointModel.firePointId
        /*
         1:前往执行 2:放弃执行
         */
        parameters["status"] = 1
        
        
        SVProgressHUD.show(withStatus: "执行中...")
        
        Alamofire.request(URLPath.basicPath + URLPath.getFireExecute , method: .get, parameters: parameters).responseJSON { (response) in
            
            SVProgressHUD.dismiss()
            switch response.result {
                
            case .success(_):
                
                if let value = response.result.value as? [String: Any] {
                    
                    guard value["CODE"] as! String == "0" else{
                        let message = value["MSG"] as! String
                        
                        self.alert(message: message)
                        return
                    }
                    
                    break
                }
                //跳转界面来进行地图渲染,规划路线,显示详细信息
                let detailVC = UIStoryboard.instantiateInitialViewController(name: "YQFireMapDetail") as! YQFireMapDetailViewController
                self.navigationController?.pushViewController(detailVC, animated: true)
                // 直接进行model 的传值
                detailVC.fireModel = self.currentMapPointAnnotation.pointModel
                
                break
            case .failure(let error):
                
                debugPrint(error)
                self.alert(message: "火警执行失败!")
                break
            }
        }
        
    }
    

    // MARK: - 控制器销毁的方法
    deinit{
        //移除所有通知
        NotificationCenter.default.removeObserver(self)
    }
    

}


extension YQFireControlViewController: MAMapViewDelegate{
    
    // MARK: - 地图加载成功的调用的方法
    func mapViewDidFinishLoadingMap(_ mapView: MAMapView!) {
        //        print(mapView.userLocation.location)
        self.fireMapView.setCenter((mapView.userLocation!.coordinate), animated: true)
    }
    
    // MARK: - 设置mark的标记的类型
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        
        //通过这里来进行的样式的设置,点击的弹框的效果情况
        if annotation.isKind(of: MAPointAnnotation.self){
            
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

    // MARK: - markView点击的回调方法
    func mapView(_ mapView: MAMapView!, didSelect view: MAAnnotationView!) {
        
    }
    
    func mapView(_ mapView: MAMapView!, didDeselect view: MAAnnotationView!) {
        
    }
    
    
    /**
     
     // 点击annotation弹框视图的添加的添加方法
     - (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control;
     
     */
    func mapView(_ mapView: MAMapView!, annotationView view: MAAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        
        
        
    }
    
    /**
     // 点击annotation弹框视图的添加的添加方法
     - (void)mapView:(MAMapView *)mapView didAnnotationViewCalloutTapped:(MAAnnotationView *)view;
     */
    func mapView(_ mapView: MAMapView!, didAnnotationViewCalloutTapped view: MAAnnotationView!) {
        
        
        
    }
    
}

extension YQFireControlViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stateListModel.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return Bundle.main.loadNibNamed("YQImplementDetailHead", owner: nil, options: nil)![0] as? UIView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "implementCell", for: indexPath)
        cell.textLabel?.text = self.stateListModel[indexPath.row].content
        return cell
    }
    

}
