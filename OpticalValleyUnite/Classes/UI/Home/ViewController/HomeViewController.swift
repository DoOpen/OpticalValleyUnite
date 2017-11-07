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
import SnapKit

let KDistence = 50.0

class HomeViewController: UIViewController,CheckNewBundleVersionProtocol {
    
    @IBOutlet weak var messageBtn: UIButton!
    @IBOutlet weak var scanBtn: UIButton!
    
    var eixtButton : UIButton! = nil
    
/// 子系统选择的数据
    var systemSelection : NSDictionary = {return NSDictionary() }()
    
    
    
/// 模型的数据解析model.swift中的类
    var datas = [SystemMessageModel]()
    
    var locationManager = AMapLocationManager()
    var lastUpdateTime = Date().addingTimeInterval(-6.0 * 60.0)
    var workCount = 0
    var dubanCount = 0
    
/// 上面的4个按钮的拖线的事件
    @IBOutlet weak var top1BtnView: HomeBtnView!
    @IBOutlet weak var top2BtnView: HomeBtnView!
    @IBOutlet weak var top3BtnView: HomeBtnView!
    @IBOutlet weak var top4BtnView: HomeBtnView!
 
/// 下面的3个按钮的拖线的事件
    @IBOutlet weak var donw1BtnView: HomeBtnView!
    @IBOutlet weak var donw2BtnView: HomeBtnView!
    @IBOutlet weak var donw3BtnView: HomeBtnView!

    var topBtnViewArray = [HomeBtnView]()
    var downBtnViewArray = [HomeBtnView]()
    
    var allPermissionModels = [PermissionModel]()
    var downPermissionModels = [PermissionModel]()
    
    
/// tabelView的拖线的指针
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - 视图生命周期方法
    override func viewDidLoad() {
        
        super.viewDidLoad()

        navigationItem.title = "光谷联合"
        //分别设置两个(上下)按钮数组
        topBtnViewArray = [top1BtnView,top2BtnView,top3BtnView,top4BtnView]
        downBtnViewArray = [donw1BtnView,donw2BtnView,donw3BtnView]
        
        //接受服务消息通知
        getNotice()
        
        //设置定位
        setUpLocation()
        
        //接受新的数据来显示
        getPermission()

        
        //接受VC的数据通知
        receiveNotes()
        
        //获取app版本号的方法
        checkNewBundleVersion(isBlack: true)
        
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //调用获取工单的数量
        getStaticWorkunitDB()
        
    }
    
    
    // MARK: - 接受服务器系统消息
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
    
    // MARK: - 接受服务消息通知
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
    
    // MARK: - 获取不同管理员权限的方法,首页数据获取核心方法 getModules的接口
    func getPermission(){
        
        let data = UserDefaults.standard.object(forKey: Const.YQSystemSelectData)
        if data == nil {
            
            return
        }
    
        //注意的是:通过的是子系统选择的界面功能取消   URLPath.getModules 的网络请求
        systemSelection = UserDefaults.standard.object(forKey: Const.YQSystemSelectData) as! NSDictionary
        
        //新增 获取集团版 和 项目版  的区别 来进行的操作
        let isgroup = systemSelection["is_group"] as? Int ?? -1
        UserDefaults.standard.set(isgroup, forKey: Const.YQIs_Group)
        
        
        if systemSelection.count > 0 {
            
            
            let array : NSArray = systemSelection["app_res"] as! [[String : Any]] as NSArray
            let sortArray : NSMutableArray = {return NSMutableArray()}()
            
            //解决bug: 需要通过的是 "SORT" : 2 的值来进行对数据来重新排序
            for xxxx in 0..<array.count {
                
                for temp in array {
                    
                    let sortTemp = temp as! [String : Any]
                    var SORT = sortTemp["SORT"] as? Int
                    
                    if SORT == 9 {
                        
                        SORT = 6 //重新对sort进行赋值的操作
                    }
                    
                    if xxxx == SORT {
                        //前台的数据重写逻辑!
                        sortArray.add(temp)
                        
                    }
                }
            }
            
            self.setPermission(arry: sortArray as! Array<[String : Any]> )
            
            if sortArray.count > 1 {
                
                let app = sortArray[0] as! [String : Any]
//                let app_res = app["app_res"] as? NSArray
//                let temp = app_res?[0] as? [String : Any]
                let reportName = (app["APP_MODULE_NAME"] as? String)!
                
                //设置保存电梯和普通的报事全局保存
                UserDefaults.standard.set(reportName, forKey: Const.YQReportName)
//                print(reportName)
                
            }
        
            do {
                
                //Convert to Data
                let jsonData = try JSONSerialization.data(withJSONObject: systemSelection, options: JSONSerialization.WritingOptions.prettyPrinted)
                
                //Do this for print data only otherwise skip
                if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                    print(JSONString)
                    
                    UserDefaults.standard.set(JSONString, forKey: "PermissionModels")
                }
                
            } catch  {
                print("转换错误 ")
            }


        }else{
            //弹框提示网络出现异常
        
        }

    }
    
    // MARK: - 接受系统的通知
    func receiveNotes(){
        
        let center = NotificationCenter.default//创建通知
        
        center.addObserver(self, selector: #selector(systemSelectionreceiveValue(info:)), name: NSNotification.Name(rawValue: "systemSelectionPassValue"), object: nil)//单个值得传递
        center.addObserver(self, selector: #selector(systemSelectionreceiveValue(info:)), name: NSNotification.Name(rawValue: "systemSelectionPassValue"), object: nil)
        
    }
    
    // MARK: - 通知实现的方法
     func systemSelectionreceiveValue(info:NSNotification){
//        print(info.userInfo)
        
        let dic = info.userInfo! as NSDictionary
        self.systemSelection = dic
        
    }
    
    
    //MARK: - 获取读完工单数量
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
        let imageDic = ["报事": "报事","工单": "工单","签到": "qiandao-1","扫描": "扫描","定位": "dingwei","待办事项": "daiban", "督办": "btn_duban","智能开门": "ic_door","丽岛学院": "xueyuan","电梯报事":"报事","日志":"日志"]
        for (index,model) in topArry.enumerated(){
            
            if index >= 4{
                break
            }
            let imageName = imageDic[model.aPPMODULENAME] ?? ""
            topBtnViewArray[index].imageView.image = UIImage(named:imageName)
            //设置appicon的名字
            if(model.aPPMODULENAME == "电梯报事"){
                topBtnViewArray[index].textLabel.text = "报事"

            }else{
                
                topBtnViewArray[index].textLabel.text = model.aPPMODULENAME
            }
            
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
    

    
    // MARK: - 全部按钮点击界面跳转的方法
    /// 中间全部按钮的点击跳转
    @IBAction func pushToAllVc(){
        
        if !allPermissionModels.isEmpty{
            
            let vc = AllViewController.loadFromStoryboard(name: "Home") as! AllViewController
            vc.models = allPermissionModels
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    //MARK: - 设置定位的方法;
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
    
    //MARK: -top和down按钮组点击界面跳转的方法;
    /// action Push ---> 中间系列的按钮点击的navVC的界面的跳转!
    //  注意的是 有待办的事项没有设置过来
    func actionPush(text:String){
        switch text {
        case "报事":
            
            let vc = UIStoryboard(name: "ReportMaster", bundle: nil).instantiateInitialViewController()
            
            navigationController?.pushViewController(vc!, animated: true)
//            surveillanceWorkOrderBtnClick()
        case "电梯报事":
            
            let vc = UIStoryboard(name: "ReportMaster", bundle: nil).instantiateInitialViewController()
            
            navigationController?.pushViewController(vc!, animated: true)
            
        case "工单":
            
            let WO = UIStoryboard.instantiateInitialViewController(name: "YQWorkOrderFirst")
            navigationController?.pushViewController(WO, animated: true)
            
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
            
        case "日志":
            //测试日志模块
            let journa = UIStoryboard.instantiateInitialViewController(name: "YQJournal")
            
//            navigationController?.pushViewController(journa, animated: true)
            self.present(journa, animated: true, completion: nil)
            
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
  
 
    // MARK: - leftbar消息按钮的点击事件
/// leftbar消息按钮的点击事件的
    @IBAction func messageBtnClick() {
        
        let bool1 = allPermissionModels.contains { (model) -> Bool in
            
            model.aPPMODULENAME == "工单"
        }
        
        let bool2 = allPermissionModels.contains { (model) -> Bool in
            
            model.aPPMODULENAME == "督办"
        }

        if bool1 && bool2{//这个逻辑是 工单和 督办都有选项的值情况
            
            MessageView.show(workOrderCount: workCount, surveillanceWorkOrder: dubanCount)
            
        }else if bool1{// 只有工单
            
            actionPush(text:"工单")
            
        }else if bool2{// 只有督办
            
            actionPush(text:"督办")
            
        }else{// 全都没有的情况
            
            MessageView.show(workOrderCount: workCount, surveillanceWorkOrder: dubanCount)
        }
        
        
        
    }
    
  
/// rightBar扫描二维码的事件的点击:
    @IBAction func scanBtnClick() {
        
//        pushToDeviceViewController()
//        return  
        
        if Const.SJIsSIMULATOR {
            
            alert(message: "模拟器不能使用扫描")
            return
            
        }
        
        let device = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
        
//        let device = AVCaptureDeviceDiscovery
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
    
    
    // MARK: - 添加按钮悬浮
    @IBAction func suspendButtonClick(_ sender: Any) {
        
        let data = UserDefaults.standard.object(forKey: Const.YQTotallData) as? NSArray
        
        if UserDefaults.standard.object(forKey: Const.YQTotallData) == nil {
            
             LoginViewController.loginOut()
        }
        
        
        //跳转到子系统的选择界面(需要的是逻辑的判断) 如果是只有一条数据的话,直接调到登录界面
        if (data?.count)! > 1{
            
            let systemVC = YQSystemSelectionVC(nibName: "YQSystemSelectionVC", bundle: nil)
            SJKeyWindow?.rootViewController = systemVC

        
        }else{// 跳转到登录界面
            
            LoginViewController.loginOut()

        }
        
        
    }
    
    
//    func addSuspendButton(){
//        
//        let button = UIButton()
//        button.setImage( UIImage(named : "btn_home_quit_nor" ), for: UIControlState.normal)
//        
//        button.setImage( UIImage(named : "btn_home_quit_p" ), for: UIControlState.highlighted)
//        button.frame = CGRect(x: 100, y: 100, width: 60, height: 60)
//        
//        button.backgroundColor = UIColor.blue
//        view.addSubview(button)
//        self.eixtButton = button
//        
//        //设置约束布局
//        button.snp.makeConstraints { (make) in
//            make.right.equalTo(40)
//            make.bottom.equalTo(100)
//            make.height.equalTo(60)
//            make.width.equalTo(60)
//        }
//        
//        view.bringSubview(toFront: button)
//    
//    }
    
    
    func surveillanceWorkOrderBtnClick() {
        let vc = SurveillanceWorkOrderViewController.loadFromStoryboard(name: "WorkOrder")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    fileprivate func pushToDeviceViewController(equipmentId: String){
        
        let vc = DeviceViewController.loadFromStoryboard(name: "Home") as! DeviceViewController
        vc.equipmentId = equipmentId
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    // MARK: - 控制器dealloc的方法
    deinit{
        
        //移除通知监听
        NotificationCenter.default.removeObserver(self)
        
    }
    
    
}

/// 全局的extension的tableView的数据源和代理的方法
/// 订单数据的tabelView 代理和 数据源方法
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 120
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
