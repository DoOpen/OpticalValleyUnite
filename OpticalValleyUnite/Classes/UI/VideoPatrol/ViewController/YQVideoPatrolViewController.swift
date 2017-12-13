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
    
    /// 是否有室内点的情况
    var isIndoorPoint : Bool?
    
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
    
    // indoorVideo模型数据
    var indoorVideoPointModel = [YQVideoIndoorPatorlModel](){
        didSet{
            
            //创建一个indoorpickerArray
            var indoorPickerArray = [String]()
            
            for indoorModel in indoorVideoPointModel {
                
                if indoorModel.name == "" {
                    
                    self.alert(message: "没有室内点!")
                    return
                    
                }else{
                
                    indoorPickerArray.append(indoorModel.name)
                }
                
            }
            
            if !indoorPickerArray.isEmpty {
                
                //创建实现一个VideoIndoorPicker
                SJPickerView.show(withDataArry: indoorPickerArray) { (intIndex) in
                    
                    //取出响应的数据点模型
                    self.indoorVideoSelectModel = self.indoorVideoPointModel[intIndex]
                    if  self.indoorVideoSelectModel?.videoConfigId != 0 {
                        
                        self.videoAllSelectParmeter["videoConfigId"] = self.indoorVideoSelectModel?.videoConfigId
                    }
                    
                    self.videoAllSelectParmeter["insPointId"] = self.indoorVideoSelectModel?.insPointId
                    
                    self.CheckBeginDataStart()
                }
            }
        }
    }
    
    var indoorVideoSelectModel : YQVideoIndoorPatorlModel?
    
    //选择的mapPoint的缓存
    var videoAnnotationModel : YQVideoMapPointModel?
    
    ///懒加载传参属性字典
    lazy var videoAllSelectParmeter = {
    
        return NSMutableDictionary()
        
    }()
    
    // MARK: - 视图生命周期的方法
    override func viewDidLoad() {
        super.viewDidLoad()
        //1. 添加leftRight
        addLeftRightBarButtonFunction()
        //2. 获取map数据
        mapViewSetup()
        makeMapLocationData()
        
        //3.接受通知赋值
        setupNoties()
    
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
            SVProgressHUD.dismiss()
            
            if let data = response as? NSArray{
                
                var temp = [YQVideoMapPointModel]()
                
                for dict in data{
                    
                    temp.append(YQVideoMapPointModel.init(dict: dict as! [String : Any]))
                }
                self.videoMapPointModel = temp
            }

            
        }) { (error) in
            
            SVProgressHUD.showError(withStatus: "数据加载失败,请检查网络!")
            
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
    
    // MARK: - mapView 进行打点的方法
    func addLocationAndMessageView(model: YQVideoMapPointModel){
        //设置打点的情况
        let CLLocationCoordinate2D = CLLocationCoordinate2DMake(CLLocationDegrees(model.latitude)!, CLLocationDegrees(model.longitude)!)
        
        //设置定义MAPointAnnotation
        let annotation: YQVideoPatrolAnnotation? = YQVideoPatrolAnnotation()
        annotation?.coordinate = CLLocationCoordinate2D
        annotation?.title = model.name
        annotation?.videoModel = model
        
//        annotation?.subtitle = "CustomAnnotationView"
    
        mapView.addAnnotation(annotation)
    }
    
    
    // MARK: - pickerView的展示的方法
    func pickerViewImplementAndLoadData( mapViewModel : YQVideoMapPointModel ){
        
        var parameter = [String : Any]()
        parameter["insPointId"] = mapViewModel.insPointId
        videoAllSelectParmeter["insPointId"] = mapViewModel.insPointId
      
        
        if mapViewModel.type == 1 {//室内点,要求调用两个接口
            
            SVProgressHUD.show()
            
            self.videoAllSelectParmeter["type"] = mapViewModel.type
            
            HttpClient.instance.post(path: URLPath.getVideoPatrolFloorNum, parameters: parameter, success: { (respose) in
                
                SVProgressHUD.dismiss()
                let num = respose as! Int
                var floorArray = [String]()
                
                for indexNum in 1...num {
                    
                    floorArray.append("\(indexNum)" + "层")
                    
                }
                
                //返回直接是一个 层数 ,这里进行的循环遍历
                SJPickerView.show(withDataArry: floorArray, didSlected: { (indexnum) in
                    
                    //pickerView 点击执行的回调的函数
                    let floorIndex = indexnum + 1
                    //调用查询点的情况
                    
                    var par = [String : Any]()
                    par["insPointId"] = mapViewModel.insPointId
                    par["floorNum"] = floorIndex
                    
                
                    HttpClient.instance.post(path: URLPath.getVideoPatrolPoint, parameters: par, success: { (respose) in
                        
                        var tempArray = [YQVideoIndoorPatorlModel]()
                        
                        //获取的巡查点的路径来进行 字典转模型
                        for indoorArray in (respose as! NSArray) {
                            
                            tempArray.append(YQVideoIndoorPatorlModel.init(dic: indoorArray as! [String : Any]))
                        
                        }
                        
                        self.indoorVideoPointModel = tempArray
                        
                        
                    }, failure: { (error) in
                        
                         SVProgressHUD.showError(withStatus: "网络请求失败,请检查网络!")
                    })
                    
                })

            }, failure: { (error) in
                
                SVProgressHUD.showError(withStatus: "网络请求失败,请检查网络!")
            })
            
        }else{//室外点,直接调用
            
            if  mapViewModel.videoConfigId != 0 {
                
                videoAllSelectParmeter["videoConfigId"] = mapViewModel.videoConfigId
            }

            self.videoAllSelectParmeter["type"] = mapViewModel.type
            
            self.CheckBeginDataStart()
        }
        
    }
    
    
    // MARK: - CheckBegin开始巡查的接口调直接调用
    func CheckBeginDataStart(){
        
        //只传token 不要什麽东西
        SVProgressHUD.show()
        
        HttpClient.instance.post(path: URLPath.getVideoPatrolCheckBegin, parameters: nil, success: { (respose) in
            
            SVProgressHUD.dismiss()
            
            let test = respose["insOrbit"] as? NSDictionary
            
            //拿到的值分为两种情况. 有起始点的情况, 和没有起始点的情况,都需要保存和缓存
            if (test != nil ) {
                //展示巡查项的结果,跳选起始点的情况
                let array = respose["insOrbit"] as? NSDictionary
                var stringArray = [String]()
                
//                for temp  in array! {
//
//                    let temp1 = temp as? NSDictionary
//                    stringArray.append((temp1?["wayName"] as? String)!)
//                }
                
                stringArray.append((array?["wayName"] as? String)!)
                
                SJPickerView.show(withDataArry: stringArray, didSlected: { (index) in
                    
                    //选择的情况:
                    _ = array?[index] as? NSDictionary
                    
                    self.videoAllSelectParmeter["orbitId"] = array?["orbitId"]
                    self.videoAllSelectParmeter["insWayId"] = array?["insWayId"]
                    
                    //遍历巡查的操作
                    let selectDic = respose["status"] as! NSArray
                    var array = [String]()
                    var idArray = [String]()
                    
                    for dic in selectDic {
                        
                        let tempDic = dic as? NSDictionary
                        idArray.append((tempDic?["id"] as? String)!)
                        array.append((tempDic?["title"] as? String)!)
                    }
                    
                    //发送查询路线的规划的情况!路线的内容信息的保存添加
                    //界面跳转,数据的参数的传递!(跳转到视频巡查的路线界面)
                    SJPickerView.show(withDataArry: array , didSlected: { (indexRow) in
                        
                       self.videoAllSelectParmeter["pointType"] = idArray[index]
                        //执行的是界面的跳转的情况!
                        //所有的选择,参数要求一起传递过来!(跳转到视频巡查的路线界面)
                        self.pushToVideoAndPatrolVC()
                        
                    })

                
                })
            
            
            }else{//请求巡查路线
                
                var paramet = [String : Any]()
                paramet["parkId"] = self.parkId
                paramet["insPointId"] = self.videoAnnotationModel?.insPointId
                
//                paramet["insPointName"] = self.videoAnnotationModel?.name
                
                    
                HttpClient.instance.post(path: URLPath.getVideoPatrolLoadWayName, parameters: paramet, success: { (result) in
                    
                    var stringArray = [String]()
                    //展示中夜班,跳选 起始点
                    //通过的是,展示的respose 的insWayId 的展示
                    for temp in (result as? NSArray)! {
                    
                        let insWayDic = temp as? NSDictionary
                        stringArray.append((insWayDic?["wayName"] as? String)!)
                    }
                    
                    
                    SJPickerView.show(withDataArry: stringArray, didSlected: { (index) in
                        
                        let result1 = result as? NSArray
                        let selectLoadWay = result1?[index] as? NSDictionary //需要进行缓存的内容选项!
                        
                        self.videoAllSelectParmeter["insWayId"] = selectLoadWay?["insWayId"]
                        
                        //选择的班次和对应的id的情况
                        let selectDic = respose["status"] as! NSArray
                        var array = [String]()
                        var idArray = [String]()
                        
                        for dic in selectDic {
                            let tempDic = dic as? NSDictionary
                            
                            array.append((tempDic?["title"] as? String)!)
                            idArray.append((tempDic?["id"] as? String)!)
                        }
                        
                        
                        
                        SJPickerView.show(withDataArry: array , didSlected: { (indexRow) in
                            
                             self.videoAllSelectParmeter["pointType"] = idArray[index]
                            
                            //执行的是界面的跳转的情况!
                            //所有的选择,参数要求一起传递过来!(跳转到视频巡查的路线界面)
                            self.pushToVideoAndPatrolVC()
                            
                        })
                    })
                    
                    
                }, failure: { (error) in
                    
                    SVProgressHUD.showError(withStatus: "数据加载失败,请检查网络!")
                })
        
            }
            
            
        }, failure: { (error) in
            
            SVProgressHUD.showError(withStatus: "网络请求失败,请检查网络!")
            
        })

    }
    
    
    // MARK: - 接受所有的通知类型
    func setupNoties(){
    
        let center = NotificationCenter.default
        let notiesName = NSNotification.Name(rawValue: "drawerVideoLoadWaysNoties")
        center.addObserver(self, selector: #selector(videoLoadWaysNoties(noties :)), name: notiesName, object: nil)
        
    }
    func videoLoadWaysNoties(noties : Notification){
        //1.关闭弹窗
        //回弹的方法接口
        if let drawerController = self.navigationController?.parent as? KYDrawerController {
            
            drawerController.setDrawerState(.closed , animated: true)
        }
        
        //2.获取数据重绘,多维的数组的情况
        let loadWays = noties.userInfo?["VideoLoadWaysArray"] as? NSArray
        
        for array in loadWays! {
            
            var tempModel = [YQVideoMapPointModel]()
            
            //重绘轨迹线条的方法,(添加所有的)
            var videoMapLayWays = [CLLocationCoordinate2D]()
            
            for dict in array as! NSArray{
                
                let d = dict as? NSDictionary
                let longitude = d?["longitude"] as? String
                let latitude = d?["latitude"] as? String
                let CLLocationCoordinate2D = CLLocationCoordinate2DMake(CLLocationDegrees(latitude!)!, CLLocationDegrees(longitude!)!)
                videoMapLayWays.append(CLLocationCoordinate2D)
                
                tempModel.append(YQVideoMapPointModel.init(dict: dict as! [String : Any]))
            }
            
            //只是重新的打点的情况
            self.videoMapPointModel = tempModel
            
            //划线
            let polyline: MAPolyline = MAPolyline(coordinates: &videoMapLayWays, count: UInt(videoMapLayWays.count))
            mapView.add(polyline)
            
        }
    }
    
    // MARK: - 跳转到视频执行界面的操作
    func pushToVideoAndPatrolVC(){
        
        let vc = UIStoryboard.instantiateInitialViewController(name: "YQVideoMonitorAndPatrol") as? YQVideoMonitorAndPatrolVC
        //传递相应的参数值的情况
        vc?.prameterDict = self.videoAllSelectParmeter
        
        navigationController?.pushViewController(vc! , animated: true)
        
    }
    

    deinit {
        
        NotificationCenter.default.removeObserver(self)
        
    }

}

extension YQVideoPatrolViewController : MAMapViewDelegate{

    // MARK: - 设置mark的标记的类型图标的方法
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        
        let nowAnnotation = annotation as? YQVideoPatrolAnnotation
        
        if (annotation.isKind(of: YQVideoPatrolAnnotation.self)) {
//            //注意的是:这里的是可以来进行的实现的自定义的custom的annotation的view
//            let customReuseIndetifier: String = "videoPatrolIndetifier"
//
//            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: customReuseIndetifier) as? CustomAnnotationView
//            
//            if annotationView == nil {
//                annotationView = CustomAnnotationView.init(annotation: annotation, reuseIdentifier: customReuseIndetifier)
//                
//                annotationView?.canShowCallout = false
//                annotationView?.isDraggable = true
//                annotationView?.calloutOffset = CGPoint.init(x: 0, y: -5)
//            }
//            
//            annotationView?.portrait = UIImage.init(named: "hema")
//            annotationView?.name = "河马"
//            
//            return annotationView
            
            let pointReuseIndetifier = "videoPatrolReuseIndetifier"
            
            var annotationView: MAAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier)
            
            if annotationView == nil {
                
                annotationView = MAAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
            }
            
            
            //通过模型来进行的传递的 model
            switch (nowAnnotation?.videoModel?.type)! {
            case 1://室内点
                annotationView?.image = UIImage.init(name: "内摄像头-关")
                break
            case 2://室外点
                if nowAnnotation?.videoModel?.videoConfigId != 0 {
                    
                    annotationView?.image = UIImage.init(name: "外摄像头—关")
                }else{
                    
                    annotationView?.image = UIImage.init(name: "室外-关")
                }
                
                break
            default:
                break
                
            }
            

            annotationView!.canShowCallout = true //设置气泡可以弹出，默认为NO
            
            return annotationView!
        }

        return nil
    }
    
    
    //deselect 弹窗的视图的方法
    func mapView(_ mapView: MAMapView!, didDeselect view: MAAnnotationView!) {
        
        //设置为隐藏
        
    }


    //点击地图图标的方法
    func mapView(_ mapView: MAMapView!, didAnnotationViewCalloutTapped view: MAAnnotationView!) {
        //实现的思路是: 应用封装好的packView来实现
        if view.annotation.isKind(of: YQVideoPatrolAnnotation.self) {
            
            let clilckAnnotation = view.annotation as? YQVideoPatrolAnnotation
            
            if clilckAnnotation?.videoModel == nil {
                
                return
                
            }else{
                
                //展示pickerView, 调用相应的数据接口
                self.pickerViewImplementAndLoadData(mapViewModel : (clilckAnnotation?.videoModel)! )
                //缓存整个项目中的点击AnnotationView的model
                self.videoAnnotationModel = (clilckAnnotation?.videoModel)!
                
            }
        }
    }
    
    func mapView(_ mapView: MAMapView!, rendererFor overlay: MAOverlay!) -> MAOverlayRenderer! {
        
        //想要设置文理的方法是: 直接到这个方法中来进行添加的 设置相应的图片
        /*
            polylineRenderer.loadStrokeTextureImage(UIImage.init(named: "arrowTexture"))
         */
        
        if overlay.isKind(of: MAPolyline.self) {
            
            let renderer: MAPolylineRenderer = MAPolylineRenderer(overlay: overlay)
            renderer.lineWidth = 8.0
//            renderer.strokeColor = UIColor.cyan
            renderer.strokeImage = UIImage.init(named: "多边形-1")
//            renderer.loadStrokeTextureImage(UIImage.init(named: "多边形1"))
//            renderer.loadTexture(UIImage.init(named: "多边形1"))
//            renderer.lineCapType = kMALineCapArrow 设置画箭头的属性情况
            return renderer
        }
        
        return nil
    }
    

}
