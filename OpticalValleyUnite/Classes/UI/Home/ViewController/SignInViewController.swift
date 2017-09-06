//
//  SignInViewController.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/1/12.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit
import SVProgressHUD

class SignInViewController: UIViewController {

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var mapView: MAMapView!
    
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
        showList()
        addressLabel.text = "地理位置获取中..."
        
        let time = Date.dateStringDate(dateFormetString: "HH:mm")
        timeLabel.text = time
        mapSetup()
        
        }
    
    func getSignCount(){
        var paramet = [String: Any]()
        paramet["DATE"] = Date.dateStringDate(dateFormetString: "YYYY-MM-dd")
        HttpClient.instance.post(path: URLPath.getSignCount, parameters: paramet, success: { (resposen) in
            if let count = resposen as? Int{
                self.countLabel.text = "今天签到\(count)次"
                
                self.countLabel.contentNumber(count, andColor: UIColor.orange)
            }
        }) { (error) in
            print(error)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       getSignCount()

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
            self.showList()
            
        }) { (error) in
            
        }
    }
    
    private func showList(){
        var parmat = [String: Any]()
        parmat["DATE"] = Date.dateStringDate(dateFormetString: "YYYY-MM-dd")
        
        let url = URLPath.getPersonSinList
        
        
        HttpClient.instance.get(path: url, parameters: parmat, success: { (response) in
            
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
            }else{
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
                if let address = arry.first?["PARK_NAME"] as? String,address != ""{
                    self.addressLabel.text = address
                    if !self.isPaskAddress {
                        self.updateSige()
                    }
                    
                    self.isPaskAddress = true
                    
                }else{
                    
                    if let regeocode = self.reGeocode{
                        print(regeocode)
                        self.addressLabel.text = regeocode.formattedAddress
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
        mapView.userTrackingMode = .followWithHeading;
        mapView.delegate = self
        mapView.zoomLevel = 17.0
        
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
                return
            }
            
            self?.loction = location
            self?.reGeocode = regeocode
            self?.getParkAddress()

        }
        )

    }
}



extension SignInViewController: MAMapViewDelegate{
    func mapViewDidFinishLoadingMap(_ mapView: MAMapView!) {
//        print(mapView.userLocation.location)
    }
}
