//
//  ViewController.swift
//    OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/1/10.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import Alamofire

let KDistence = 50.0

class HomeViewController: UIViewController,CheckNewBundleVersionProtocol {
    
    @IBOutlet weak var messageBtn: UIButton!
    @IBOutlet weak var scanBtn: UIButton!
    var datas = [SystemMessageModel]()
    
    var locationManager = AMapLocationManager()
    var lastUpdateTime = Date().addingTimeInterval(-6.0 * 60.0)
    var workCount = 0
    var dubanCount = 0
    
    
    @IBOutlet weak var top1BtnView: HomeBtnView!
    @IBOutlet weak var top2BtnView: HomeBtnView!
    @IBOutlet weak var top3BtnView: HomeBtnView!
    @IBOutlet weak var top4BtnView: HomeBtnView!
    
    @IBOutlet weak var donw1BtnView: HomeBtnView!
    @IBOutlet weak var donw2BtnView: HomeBtnView!
    @IBOutlet weak var donw3BtnView: HomeBtnView!

    var topBtnViewArray = [HomeBtnView]()
    var downBtnViewArray = [HomeBtnView]()
    
    var allPermissionModels = [PermissionModel]()
    var downPermissionModels = [PermissionModel]()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "光谷联合"
        
        getNotice()
        
        setUpLocation()
        
        topBtnViewArray = [top1BtnView,top2BtnView,top3BtnView,top4BtnView]
        downBtnViewArray = [donw1BtnView,donw2BtnView,donw3BtnView]
        
        if let json = UserDefaults.standard.object(forKey: "PermissionModels") as? String{
            do {
                //Convert to Data
                let data = json.data(using: .utf8)!
                let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                if let arry = jsonData as? Array<[String: Any]>{
                    setPermission(arry: arry)
                }else{
                    print("不能转成数组了")
                }
                

            } catch  {
                print("转换错误 ")
            }
        }else{
            self.top1BtnView.textLabel.text = "工单"
            self.top1BtnView.imageView.image = UIImage(named: "工单")
            
            self.top2BtnView.textLabel.text = "报事"
            self.top2BtnView.imageView.image = UIImage(named: "报事")
            
            self.top3BtnView.textLabel.text = "签到"
            self.top3BtnView.imageView.image = UIImage(named: "qiandao-1")
            
            self.top4BtnView.textLabel.text = "扫描"
            self.top4BtnView.imageView.image = UIImage(named: "扫描")
            
            
            
            self.donw1BtnView.textLabel.text = "定位"
            self.donw1BtnView.imageView.image = UIImage(named: "dingwei")
            
            self.donw2BtnView.textLabel.text = "代办事项"
            self.donw2BtnView.imageView.image = UIImage(named: "daiban")
            
            self.donw3BtnView.textLabel.text = "智能开门"
            self.donw3BtnView.imageView.image = UIImage(named: "ic_door")
        }
        
        

        
        
        
        getPermission()
        
        checkNewBundleVersion(isBlack: true)
        

    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getStaticWorkunitDB()
    }
    
    
    
    func getSystemMessage(){
        HttpClient.instance.get(path: URLPath.systemMessage, parameters: nil, success: { (respose) in
            
            var temp = [SystemMessageModel]()
            for dic in respose as! Array<[String: Any]>{
                temp.append(SystemMessageModel(parmart: dic))
            }
            self.datas = temp
            self.tableView.reloadData()
            

            
        }) { (error) in
            print(error)
        }
    }
    
    func getNotice(){
        HttpClient.instance.get(path: URLPath.getNoticeList, parameters: nil, success: { (respose) in
            
            var temp = [SystemMessageModel]()
            
            if let dic = respose as? [String: Any]{
                for dic2 in dic["data"] as! Array<[String: Any]>{
                    temp.append(SystemMessageModel(parmart: dic2))
                }
                self.datas = temp
                self.tableView.reloadData()
            }
            

            
            
            
        }) { (error) in
            print(error)
        }
    }
    
    
    func setPermission(arry: Array<[String: Any]>){
        self.allPermissionModels.removeAll()
        var topArry = [PermissionModel]()
        var downArry = [PermissionModel]()
        for dic in arry{
            let model = PermissionModel(json:dic)
            if model?.iSTOP == 0{
                topArry.append(model!)
            }else{
                downArry.append(model!)
            }
            
        }
        downPermissionModels = downArry
        self.allPermissionModels.append(contentsOf: topArry)
        self.allPermissionModels.append(contentsOf: downArry)
        self.settopArry(topArry: topArry, donwArry: downArry)

    }
    
    func getPermission(){
        HttpClient.instance.get(path: URLPath.getModules, parameters: nil, success: { (respose) in
            
            
            if let arry = respose as? Array<[String: Any]>{
                self.setPermission(arry: arry)
                do {
                    //Convert to Data
                    let jsonData = try JSONSerialization.data(withJSONObject: arry, options: JSONSerialization.WritingOptions.prettyPrinted)
                    
                    //Do this for print data only otherwise skip
                    if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                        print(JSONString)
                        
                        UserDefaults.standard.set(JSONString, forKey: "PermissionModels")
                    }
                } catch  {
                    print("转换错误 ")
                }
                
                
                
            }
            
        }) { (error) in
            print(error)
        }
    }
    
    func getStaticWorkunitDB(){
        HttpClient.instance.get(path: URLPath.getStaticWorkunitDB, parameters: nil, success: { (respose) in
            

            if let dic = respose as? [String: Any]{
                let workCount = dic["DBSX"] as? Int ?? 0
                let dubanCount = dic["DDB"] as? Int ?? 0
                let tatolCount = workCount + dubanCount
                self.dubanCount = dubanCount
                self.workCount = workCount
                if tatolCount >= 0 {
                    self.messageBtn.badge(text: "\(tatolCount)")
                    
                    UIApplication.shared.applicationIconBadgeNumber = tatolCount
                }
            }
            
        }) { (error) in
            print(error)
        }
    }

    func settopArry(topArry:[PermissionModel],donwArry: [PermissionModel]){
        let imageDic = ["报事": "报事","工单": "工单","签到": "qiandao-1","扫描": "扫描","定位": "dingwei","待办事项": "daiban", "督办": "btn_duban","智能开门": "ic_door","丽岛学院": "xueyuan"]
        for (index,model) in topArry.enumerated(){
            if index >= 4{
                break
            }
            let imageName = imageDic[model.aPPMODULENAME] ?? ""
            topBtnViewArray[index].imageView.image = UIImage(named:imageName)
            topBtnViewArray[index].textLabel.text = model.aPPMODULENAME
            topBtnViewArray[index].textLabel.textColor = UIColor.white
            topBtnViewArray[index].clickHandle = { [weak self] in
                self?.actionPush(text: model.aPPMODULENAME)
            }
        }
        
        let count = [3,donwArry.count].min()!
        
        
        _ = downBtnViewArray.map{ btnView in
            btnView.isHidden = true
        }
        for (index,model) in donwArry.enumerated(){
            if index >= count{
                if index < 3{
                    downBtnViewArray[index].isHidden = true
                }
                
            }else{
                let imageName = imageDic[model.aPPMODULENAME] ?? ""
                downBtnViewArray[index].imageView.image = UIImage(named:imageName)
                downBtnViewArray[index].textLabel.text = model.aPPMODULENAME
                downBtnViewArray[index].isHidden = false
                downBtnViewArray[index].clickHandle = { [weak self] in
                    self?.actionPush(text: model.aPPMODULENAME)
                }
            }
            
        }
    }
    
    
    @IBAction func pushToAllVc(){
        if !allPermissionModels.isEmpty{
            let vc = AllViewController.loadFromStoryboard(name: "Home") as! AllViewController
            vc.models = allPermissionModels
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    func setUpLocation() {
        locationManager.delegate = self
        locationManager.distanceFilter = KDistence
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.locatingWithReGeocode = true
        
        
        if Double(UIDevice.current.systemVersion.components(separatedBy: ".").first!)! >= 9.0{
            locationManager.allowsBackgroundLocationUpdates = true
        }else{
            locationManager.pausesLocationUpdatesAutomatically = false
        }
        
        locationManager.startUpdatingLocation()
    }
    
    func actionPush(text:String){
        switch text {
        case "报事":
            let vc = UIStoryboard(name: "ReportMaster", bundle: nil).instantiateInitialViewController()
            navigationController?.pushViewController(vc!, animated: true)
//            surveillanceWorkOrderBtnClick()
        case "工单":
            let vc = UIStoryboard(name: "WorkOrder", bundle: nil).instantiateInitialViewController()
            navigationController?.pushViewController(vc!, animated: true)
        case "签到":
            let vc = UIStoryboard(name: "SignIn", bundle: nil).instantiateInitialViewController()
            navigationController?.pushViewController(vc!, animated: true)
        case "定位":
            let vc = UIStoryboard(name: "Map", bundle: nil).instantiateInitialViewController()
            navigationController?.pushViewController(vc!, animated: true)
        case "扫描":
            scanBtnClick()
//            surveillanceWorkOrderBtnClick()
        case "督办":
            surveillanceWorkOrderBtnClick()
        default: break
            
        }
    }
    
    func uploadLocation(parmat: [String: Any]){
        
//        if lastUpdateTime.timeIntervalSinceNow < -3.0 * 60{
            lastUpdateTime = Date()
            HttpClient.instance.post(path: URLPath.updateLocation, parameters: parmat, success: { (response) in
                print("上传位置成功")
                
                
            }) { (error) in
                print(error)
            }
//        }
        
    }
    
    
    @IBAction func messageBtnClick() {
        let bool1 = allPermissionModels.contains { (model) -> Bool in
            model.aPPMODULENAME == "工单"
        }
        let bool2 = allPermissionModels.contains { (model) -> Bool in
            model.aPPMODULENAME == "督办"
        }

        if bool1 && bool2{
            MessageView.show(workOrderCount: workCount, surveillanceWorkOrder: dubanCount)
        }else if bool1{
            actionPush(text:"工单")
        }else if bool2{
            actionPush(text:"督办")
        }else{
            MessageView.show(workOrderCount: workCount, surveillanceWorkOrder: dubanCount)
        }
        
    }
    @IBAction func scanBtnClick() {
        
//        pushToDeviceViewController()
//        return  
        
        if Const.SJIsSIMULATOR {
            alert(message: "模拟器不能使用扫描")
            return
        }
        
        let device = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
        if device != nil {
            let status = PHPhotoLibrary.authorizationStatus()
            if status == .authorized{
                let vc = SGScanningQRCodeVC()
                vc.delegate = self
                navigationController?.pushViewController(vc, animated: true)
            }else if status == .notDetermined{
                PHPhotoLibrary.requestAuthorization({ (authorizationStatus) in
                    
                })
            }else{
                self.alert(message: "授权失败")
            }
        }
    }
    func surveillanceWorkOrderBtnClick() {
        let vc = SurveillanceWorkOrderViewController.loadFromStoryboard(name: "WorkOrder")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    fileprivate func pushToDeviceViewController(equipmentId: String){
        let vc = DeviceViewController.loadFromStoryboard(name: "Home") as! DeviceViewController
        vc.equipmentId = equipmentId
        navigationController?.pushViewController(vc, animated: true)
    }
    

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "message") as! SystemMessageCell
        cell.model = datas[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = SystemMessageViewController.loadFromStoryboard(name: "Home") as! SystemMessageViewController
                navigationController?.pushViewController(vc, animated: true)
        vc.model = datas[indexPath.row]

    }
}

extension HomeViewController: AMapLocationManagerDelegate{

    func amapLocationManager(_ manager: AMapLocationManager!, didUpdate location: CLLocation!, reGeocode: AMapLocationReGeocode!) {
        
        print("location:lat:\(location.coordinate.latitude); lon:\(location.coordinate.longitude)")
        
        var parmet = [String: Any]()
        parmet["MAP_LAT"] = location.coordinate.latitude
        parmet["MAP_LNG"] = location.coordinate.longitude
        
        if !User.isLogin(){
            return
        }
        
        if let latitude = UserDefaults.standard.object(forKey: "SJlatitude") as? CLLocationDegrees,let longitude = UserDefaults.standard.object(forKey: "SJlongitude") as? CLLocationDegrees{
            let lastCLLocation = CLLocation(latitude: latitude, longitude: longitude)
            let nowCLLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let distance = lastCLLocation.distance(from: nowCLLocation)
            
            if distance < KDistence{
                return
            }
            
        }else{
            UserDefaults.standard.set(location.coordinate.latitude, forKey: "SJlatitude")
            UserDefaults.standard.set(location.coordinate.longitude, forKey: "SJlongitude")
        }
        
        
        if reGeocode != nil
        {
            parmet["RESERVER"] = reGeocode.formattedAddress
            uploadLocation(parmat: parmet)
        }else{
            HttpClient.instance.getAddress(lat: location.coordinate.latitude, lon: location.coordinate.longitude, succses: { (address) in
                if let address = address{
                    parmet["RESERVER"] = address
                    self.uploadLocation(parmat: parmet)
                }
            })
        }
        
    }
}

extension HomeViewController:SGScanningQRCodeVCDelegate{

    
    func didScanningText(_ text: String!) {
        if text.contains("设备"){
            let str = text.components(separatedBy: ":").last
            if let str = str{
                
                self.navigationController?.popViewController(animated: false)
                pushToDeviceViewController(equipmentId: str)
            }
        }
    }
    

}
