//
//  SignInViewController.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/1/12.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit
import SVProgressHUD
import AudioToolbox

class SignInViewController: UIViewController {

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var mapView: MAMapView!
    
    @IBOutlet weak var signButtonView: UIButton!
    
    
    var loction: CLLocation?
    var reGeocode: AMapLocationReGeocode?
    var locationManager = AMapLocationManager()
    
    var parmat = [String: Any]()
    
    var hasAddress = false
    var isPaskAddress = false
    
    var models = [SignModel]()
    @IBOutlet weak var siginFirstView: SiginCellView!
    @IBOutlet weak var siginLastView: SiginCellView!
    
    deinit {
        
        print("SignInViewController----deinit")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //首先,获取签到,定位的执行信息!
        showList()
        
        addressLabel.text = "地理位置获取中..."
        
        let time = Date.dateStringDate(dateFormetString: "HH:mm")
        timeLabel.text = time
    
        mapSetup()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getSignCount()
        
        //签到功能的逻辑实现:
        //添加自动签到的功能,签到进入当前的范围
        //1.先地图定位,执行签到的范围
        //2.然后自动签到
        //3.弹出小框,进入签到范围
        //4.签到成功,振动效果
        
    }
    
    
    func getSignCount(){
        var paramet = [String: Any]()
        paramet["DATE"] = Date.dateStringDate(dateFormetString: "YYYY-MM-dd")
        HttpClient.instance.post(path: URLPath.getSignCount, parameters: paramet, success: { (resposen) in
            
            if let count = resposen as? String{
                //接口文档的改变, int --> string 的数据类型
                self.countLabel.text = "今天签到\(count)次"
                let countInt = Int(count)!
                self.countLabel.contentNumber(countInt, andColor: UIColor.orange)
            }
        }) { (error) in
            print(error)
        }
    }
    
    

    @IBAction func signInBtnClick() {
        
        sign()
    }
    
    func sign(){
        
        var parmat = [String: Any]()
        
        if let loction = loction,hasAddress == true{
            
            parmat["MAP_LNG"] = loction.coordinate.longitude
            parmat["MAP_LAT"] = loction.coordinate.latitude
            
        }else{
            self.alert(message: "请开启定位,或者正在定位中")
            return
        }
        
        
        if isPaskAddress{
            
           updateSige()
            
        }else{
            parmat["ADDRESS"] = addressLabel.text
            
            let vc = AddSignInViewController.loadFromStoryboard(name: "SignIn") as! AddSignInViewController
            vc.parmat = parmat
            vc.address = addressLabel.text!
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    func updateSige(){
        
        var parmat = [String: Any]()
        parmat["ADDRESS"] = addressLabel.text
        parmat["SIGN_TYPE"] = 1
        parmat["MAP_LNG"] = loction!.coordinate.longitude
        parmat["MAP_LAT"] = loction!.coordinate.latitude
        HttpClient.instance.post(path: URLPath.sign, parameters: parmat, success: { (respose) in
            print("签到成功")
            
            SVProgressHUD.showSuccess(withStatus: "签到成功")
            //振动添加
            self.showVibration()
            
            //添加累计,签到次数
            self.getSignCount()
            
            self.showList()
            
        }) { (error) in
            
        }
    }
    
    // MARK: - 添加振动的API方法
    private func showVibration(){
    
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
    
    private func showList(){
        
        var parmat = [String: Any]()
        parmat["DATE"] = Date.dateStringDate(dateFormetString: "YYYY-MM-dd")
        
        let url = URLPath.getPersonSinList
    
        HttpClient.instance.post(path: url, parameters: parmat, success: { (response) in
            
            var temp = [SignModel]()
            
            if let arry = response as? Array<[String: Any]>{
                
                for dic in arry {
                    let model = SignModel(parmart: dic)
                    temp.append(model)
                }
            }
            
            
            if temp.count == 1{
                
                self.siginFirstView.isHidden = false
                self.siginFirstView.model = temp.first
                
            }else if temp.count >= 2{
                
                self.siginFirstView.isHidden = false
                self.siginFirstView.model = temp.last
                
                self.siginLastView.isHidden = false
                self.siginLastView.model = temp.first
                
            }else if temp.count <= 0{
                
                self.siginLastView.isHidden = true
                self.siginFirstView.isHidden = true
            }
            
        }) { (error) in
            
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let toVc = segue.destination as? AddSignInViewController{
//            toVc.address = addressLabel.text!
//            toVc.parmat = parmat
//        }
//    }
    
    func getParkAddress(){
        
        var paramet = [String: Any]()
        paramet["MAP_LNG"] = loction?.coordinate.longitude
        paramet["MAP_LAT"] = loction?.coordinate.latitude
//        paramet["MAP_LNG"] = "114.321783"
//        paramet["MAP_LAT"] = "30.470451"
        HttpClient.instance.post(path: URLPath.getParkAddress, parameters: paramet, success: { (resposen) in
            if let arry = resposen as? Array<[String: Any]>{
                
                self.hasAddress = true
                
                if let address = arry.first?["PARK_NAME"] as? String,address != ""{//正常签到
                    
                    self.addressLabel.text = address
                    
                    self.signButtonView.isHidden = false
                    
                    if !self.isPaskAddress {
                        
                        self.updateSige()
                    }
                    
                    self.isPaskAddress = true
                    
                    if let regeocode = self.reGeocode{
                        
                        print(regeocode)
                        
//                        self.addressLabel.text = regeocode.formattedAddress
                        self.mapView.setCenter((self.loction?.coordinate)!, animated: true)
                    }

                    
                }else{//外勤签到的
                    
                    if let regeocode = self.reGeocode{
                        
                        print(regeocode)
                        self.addressLabel.text = regeocode.formattedAddress
                        
                        //显示button的
                        self.signButtonView.setBackgroundImage(UIImage.init(name: "外勤签到"), for: UIControlState.normal)
                        self.signButtonView.isHidden = false
                        
                        self.mapView.setCenter((self.loction?.coordinate)!, animated: true)
                    }
                }
            }
            
        }) { (error) in
            
            print(error)
        }
    }
    
    func  mapSetup(){
        
        AMapServices.shared().enableHTTPS = true
        mapView.showsUserLocation = true;
        mapView.userTrackingMode = .follow;
        mapView.delegate = self
        mapView.zoomLevel = 15.0
        
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
                return
            }
            
            self?.loction = location
            self?.reGeocode = regeocode
            self?.getParkAddress()

        })
    }
}



extension SignInViewController: MAMapViewDelegate{
    func mapViewDidFinishLoadingMap(_ mapView: MAMapView!) {
//        print(mapView.userLocation.location)
       
    }
}
