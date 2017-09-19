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

class YQFireControlViewController: UIViewController {
    
    // MARK: - 属性列表
    // 中间contentView
    @IBOutlet weak var messageContentV: UIView!
    
    // mapview
    @IBOutlet weak var fireMapView: MAMapView!
    
    // MAMap单例
    var locationManager = AMapLocationManager()
    
    // leftBtn
    var leftBtn : UIButton!
    // 模型数组
    var fireModel = [YQFireLocationModel](){
        didSet{
            //调用地图渲染,打点的方法
            
        
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
        fireMapView.zoomLevel = 17.0
        
        // 带逆地理信息的一次定位（返回坐标和地址信息）
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        //   定位超时时间，最低2s，此处设置为2s
        self.locationManager.locationTimeout = 5;
        //   逆地理请求超时时间，最低2s，此处设置为2s
        self.locationManager.reGeocodeTimeout = 5;
        
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
        
        
        
    }

    
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
    
}
