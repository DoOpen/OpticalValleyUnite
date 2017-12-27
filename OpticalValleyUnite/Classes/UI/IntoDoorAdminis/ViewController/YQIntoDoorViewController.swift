//
//  YQIntoDoorViewController.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/12/17.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit
import SVProgressHUD
import AVFoundation
import Photos


class YQIntoDoorViewController: UIViewController {

    /// 各种属性
    @IBOutlet weak var openBluetooth: UIButton!
    
    @IBOutlet weak var openQRCode: UIButton!
    
    @IBOutlet weak var OpenDynamicCipher: UIButton!

    @IBOutlet weak var tableView: UITableView!
    
    /// 获取项目的parkID
    var parkID = ""
    
    
    /// 蓝牙开门的单例的设置
    var rfmsessionClass = RfmSession.sharedManager()
    var bluetoothWhitelist = NSArray()
    var initBluetooth = false
    
    /// 定义的模型的数组
    var dataArray : [YQBluetooth]?{
        
        didSet{
            
            self.tableView.reloadData()
        }
    
    }
    
    /// 当前操作cell
    var currentIndexP : IndexPath?
    /// 当前的button
    var currentSelectButton : UIButton?
    
    
    // MARK: - 生命周期方法
    override func viewDidLoad() {
        
        super.viewDidLoad()
    
        //设置蓝牙开门的情况
        self.initBluetooth = (rfmsessionClass?.setup(withWhitelist: nil, delegate: self))!
        
        //获取项目parkID的情况
        let _ = setUpProjectNameLable()
        
        if self.parkID == "" {
            
            let project = UIStoryboard.instantiateInitialViewController(name: "YQAllProjectSelect")
            navigationController?.pushViewController(project, animated: true)
        }
        
        addLeftRightBarButtonFunction()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        let _ = setUpProjectNameLable()
        
        if self.currentSelectButton != nil{
            
            self.allButtonClickEvent(self.currentSelectButton!)
            
        }else{
            //默认的是选中第二项 二维码扫描的图片
            self.allButtonClickEvent(self.openQRCode)
        }
        
    }
    
    
    // MARK: - allButtonClick传递事件
    @IBAction func allButtonClickEvent(_ sender: UIButton) {
        self.currentSelectButton?.isSelected = false
        sender.isSelected = true
        self.currentSelectButton = sender
        
        switch sender.tag {
            
            case 0://蓝牙开门
                bluetoothOpenTheDoor()
                break
            
            case 1:
                getDoorByBGQrCode()
                break
                
            case 2://动态密码开门,实现逻辑一样的
                bluetoothOpenTheDoor()
                break

            default:
                break
        }
        
        
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
        rightBtn.setImage(UIImage.init(name: "二维码2"), for: .normal)
        rightBtn.addTarget(self, action: #selector(rightBarButtonClick), for: .touchUpInside)
        let batItem2 = UIBarButtonItem()
        batItem2.customView = rightBtn
        
        self.navigationItem.rightBarButtonItem = batItem2
        
        
    }
    func leftBarButtonClick() {
//        //返回子系统选择的界面
//        //查看是否有缓存的数据
//        let data = UserDefaults.standard.object(forKey: Const.YQTotallData) as? NSArray
//        //跳转到子系统的选择界面(需要的是逻辑的判断) 如果是只有一条数据的话,直接调到登录界面
//        if (data?.count)! > 1{
//            
//            let systemVC = YQSystemSelectionVC(nibName: "YQSystemSelectionVC", bundle: nil)
//            SJKeyWindow?.rootViewController = systemVC
//            
//            
//        }else{// 跳转到登录界面
//            
//            LoginViewController.loginOut()
//        }
        
        self.dismiss(animated: true, completion: nil)

        
    }
    func rightBarButtonClick(){
        //跳转扫描
        self.scanBtnClick()
        
    }
    
    
    // MARK: - 设置上传蓝牙开门的接口
    func bluetoothOpenTheDoor(){
        
        //初始化sdk
        if !(self.initBluetooth) {
            
            self.alert(message: "蓝牙初始化失败!")
            
            return
            
        }else{
            
            if self.parkID == "" {
                self.alert(message: "请选择项目")
                return
            }
            //刷新门禁模块数组
            let parArray = NSMutableArray()
            
            if let discoveredDevices = rfmsessionClass?.discoveredDevices(){
                
                for temp in discoveredDevices {
                    
                    let Device = temp as? RfmSimpleDevice
                    var dict = [String : Any]()
                    let data =  Device?.mac as NSData?
                    dict["deviceBlueMac"] = data?.dataToHexString()
                
                    parArray.add(dict)
                }
                
            }
            
            var allParams = [String : Any]()
            
            var params = [String : Any]()
            
            var par = [String : Any]()
            
            par["appType"] = "2"//设备类型  1 业主 2员工
            par["parkId"] = self.parkID
            
            if parArray.count > 0 {
                
                //传递所有开门的数据
                par["deviceList"] = parArray
                
                
            }else{
                
                self.alert(message: "没有可用的蓝牙设备!")
                
                return
            }
            
            params["data"] = par
            
            //swift 中的 格式化的固定写法语法!
            do{
                
                let jsonData = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
                
                if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8){
                    
                    //格式化的json字典的情况
                    print(JSONString)
                    
                    //注意的是这里的par 要求序列化json
                    allParams["params"] = JSONString

                }
                
            } catch {
                
                print("转换错误 ")
            }
        
            SVProgressHUD.show()
            
            HttpClient.instance.post(path: URLPath.getAuthEquipmentList, parameters: allParams, success: { (reponse) in
                
                SVProgressHUD.dismiss()
                //返回可有权限的开门集合
                var temp = [YQBluetooth]()
                
                //通过字典转模型来进行的操作!
                let array = reponse as? NSArray
                for dict in array!{
                    
                    temp.append(YQBluetooth.init(dic: dict as! [String : Any]))
                
                }
                
                self.dataArray = temp
                
            }) { (error) in
                
                print(error)
                SVProgressHUD.showError(withStatus: "数据获取失败,请检查网络连接!")
            }
        
        }
    }
    
    // MARK: - 动态密码开门
    func dynamicPwdOpenTheDoorWithData(model : YQBluetooth) {
        
        var allParams = [String : Any]()
        
        var params = [String : Any]()
        
        var par = [String : Any]()
        
        par["appType"] = "2"//设备类型  1 业主 2员工
        par["parkId"] = self.parkID
        par["deviceBlueMac"] = model.deviceBlueMac
        
        
        params["data"] = par
        
        //swift 中的 格式化的固定写法语法!
        do{
            
            let jsonData = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8){
                
                //格式化的json字典的情况
                print(JSONString)
                
                //注意的是这里的par 要求序列化json
                allParams["params"] = JSONString
                
            }
            
        }catch {
            
            print("转换错误 ")
        }
        
        
        SVProgressHUD.show()
        
        HttpClient.instance.post(path: URLPath.getdynPwdOpenDoor, parameters: allParams, success: { (response) in
            
            SVProgressHUD.dismiss()
            
            //获取时间和data 密码
            let dict = response as? NSDictionary
            
            DispatchQueue.main.async {
                
                let pwdVC = YQDynamicPwdViewController.init(nibName: "YQDynamicPwdViewController", bundle: nil)
                pwdVC.model = model
                pwdVC.dataDict = dict
                pwdVC.parkID = self.parkID
                
                self.navigationController?.pushViewController(pwdVC, animated: true)
                
            }
            
        }) { (error) in
            
            print(error)
            SVProgressHUD.showError(withStatus: "保存失败,请检查网络!")
            
        }
        
    }
    
    
    // MARK: - 设置保存记录的上传
    func bluetoothOpenDoorSaveFunction(){
    
        var allParams = [String : Any]()
        
        var params = [String : Any]()
        
        var par = [String : Any]()
        
        par["appType"] = "2"//设备类型  1 业主 2员工
        par["parkId"] = self.parkID
        
        let model = self.dataArray?[(self.currentIndexP?.row)!]
        par["deviceBlueMac"] = model?.deviceBlueMac
    
        params["data"] = par
        
        //swift 中的 格式化的固定写法语法!
        do{
            
            let jsonData = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8){
                
                //格式化的json字典的情况
                print(JSONString)
                
                //注意的是这里的par 要求序列化json
                allParams["params"] = JSONString
                
            }
            
        }catch {
            
            print("转换错误 ")
        }

        
        SVProgressHUD.show()
        
        HttpClient.instance.post(path: URLPath.getopenDoorByBlueTooth, parameters: allParams, success: { (response) in
            
            SVProgressHUD.dismiss()
            SVProgressHUD.showSuccess(withStatus: "保存成功!")
            
            
        }) { (error) in
            
            print(error)
            SVProgressHUD.showError(withStatus: "保存失败,请检查网络!")
            
        }
    
    }
    
    
    
    // MARK: - 添加默认的项目选择方法
    func setUpProjectNameLable() -> String{
        
        let dic = UserDefaults.standard.object(forKey: Const.YQProjectModel) as? [String : Any]
        
        var projectName  = ""
        
        if dic != nil {
            
            projectName = dic?["PARK_NAME"] as! String
            self.parkID = dic?["ID"] as! String
            
        }else{
            
            projectName = "请选择默认项目"
        }
        
        return projectName
    }

    
    // MARK: - 二维码执行扫描界面
    func scanBtnClick() {
        
        if Const.SJIsSIMULATOR {
            alert(message: "模拟器不能使用扫描")
            return
        }
        
        let device = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
        if device != nil {
            
            
            let status = PHPhotoLibrary.authorizationStatus()
            if status == .authorized{
                let vc = SGScanningQRCodeVC()
                //设置代理
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

    
    // MARK: - 二维码正扫开门的接口调试
    func openDoorByQrCodeFunction(deviceMacString : String){
        
        var allParams = [String : Any]()
        
        var params = [String : Any]()
        
        var par = [String : Any]()
        
        par["appType"] = "2"//设备类型  1 业主 2员工
        par["parkId"] = self.parkID
        par["deviceQrMac"] = deviceMacString
        
        
        params["data"] = par
        
        //swift 中的 格式化的固定写法语法!
        do{
            
            let jsonData = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8){
                
                //格式化的json字典的情况
                //print(JSONString)
                
                //注意的是这里的par 要求序列化json
                allParams["params"] = JSONString
                
            }
            
        }catch {
            
            print("转换错误 ")
        }
        
        
        SVProgressHUD.show()
        
        HttpClient.instance.post(path: URLPath.getOpenDoorByQrCode, parameters: allParams, success: { (response) in
            
            SVProgressHUD.dismiss()
            // 显示的是开门成功的内容
            SVProgressHUD.showSuccess(withStatus: "打开成功!")
           
            
        }) { (error) in
            print(error)
            SVProgressHUD.showError(withStatus: "保存失败,请检查网络!")
            
        }

    }
    
    // MARK: - 二维码反扫list获取
    func getDoorByBGQrCode(pageIndex : Int = 0){
    
        if self.parkID == "" {
            self.alert(message: "请选择项目")
            return
        }

        
        var par = [String : Any]()
        par["appType"] = "2"//设备类型  1 业主 2员工
        par["parkId"] = self.parkID
        par["pageIndex"] = pageIndex
        par["pageSize"] = 20
        
        SVProgressHUD.show()
        
        HttpClient.instance.post(path: URLPath.getQrAuthEquipmentList, parameters: par, success: { (resonse) in
            
            SVProgressHUD.dismiss()
            //获取相应的数据,字典转模型
            //获取时间和data 密码
            var temp = [YQBluetooth]()
            
            //通过字典转模型来进行的操作!
            let array = resonse["data"] as? NSArray
            for dict in array!{
                
                temp.append(YQBluetooth.init(dic: dict as! [String : Any]))
                
            }
            
            self.dataArray = temp

        }) { (error) in
            
            print(error)
            SVProgressHUD.showError(withStatus: "数据加载失败,请检查网络!")
        }
    
    }

}

extension YQIntoDoorViewController : UITableViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray?.count ?? 0
        
    }
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //逻辑判断写出三种类型的cell的判断
        switch (self.currentSelectButton?.tag)! {
        case 0://蓝牙开门
            
            var Cell = tableView.dequeueReusableCell(withIdentifier: "bluetoothCell") as? YQBluetoothCell
            if Cell == nil {
                Cell = Bundle.main.loadNibNamed("YQBluetoothCell", owner: nil, options: nil)?[0] as? YQBluetoothCell
            }
            Cell?.delegate = self
            Cell?.indexpath = indexPath
            Cell?.model = self.dataArray?[indexPath.row]
            return Cell!
            
        case 1://二维码开门(调用的反扫列表)
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "") as? YQScanCell
            if cell == nil {
                cell = Bundle.main.loadNibNamed("YQScanCell", owner: nil, options: nil)?[0] as? YQScanCell
            }
            cell?.delegate = self
            cell?.model = self.dataArray?[indexPath.row]
            cell?.indexPath = indexPath
            
            return cell!

            
        case 2://动态密码开门
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "pwdCell") as? YQDynamicPasswordCell
            if cell == nil {
                cell = Bundle.main.loadNibNamed("YQDynamicPasswordCell", owner: nil, options: nil)?[0] as? YQDynamicPasswordCell
            }
            cell?.delegate = self
            cell?.model = self.dataArray?[indexPath.row]
            cell?.indexPath = indexPath
            
            return cell!
            
        default:
            break
        }
        
        return UITableViewCell()
    }

}

extension YQIntoDoorViewController : RfmSessionDelegate{
    
    func rfmSessionDidFinishedEvent(_ event: RfmSessionEvent, mac: Data!, error: RfmSessionError, extra: Any!) {
        
        var message = ""
        
        if (event == RfmSessionEvent.openDoor )   //开门
        {
            switch error {
            case RfmSessionError.none:
                //开门成功
                message = "操作成功"
                SVProgressHUD.showSuccess(withStatus: message)
                
                //获取cell,设置button的属性
                let cell  = self.tableView.cellForRow(at: self.currentIndexP!) as? YQBluetoothCell
                
                cell?.openButton.isSelected = true
                
                //发送保蓝牙开门操作记录!
                self.bluetoothOpenDoorSaveFunction()

                break
                
            case RfmSessionError.noDevice:
                //无当前操作设备
                message = "无当前操作设备"
                SVProgressHUD.showError(withStatus: "message")
                break

                
            case RfmSessionError.deviceTimeOut:
                //设备应答超时
                message = "设备应答超时"
                SVProgressHUD.showError(withStatus: "message")
                break
    
            default:
                break
            }
        }
    }

}

extension YQIntoDoorViewController : YQBluetoothCellDelegate{

    func BluetoothCellOpenTheDoor( indexpath : IndexPath){
        
        self.currentIndexP = indexpath
    }
    
}

extension YQIntoDoorViewController : YQDynamicPasswordCellDelegate{
    
    func dynamicPasswordCellPwdClick(indexPath: IndexPath) {
        //获取数据-跳转界面
        let model = self.dataArray?[indexPath.row]
        
        self.dynamicPwdOpenTheDoorWithData(model: model!)
        
    }
    
}

extension YQIntoDoorViewController : SGScanningQRCodeVCDelegate{
    
    func didScanningText(_ text: String!) {
        
        if text.contains("设备"){//区分是否是自己的二维码的情况
            
            let str = text.components(separatedBy: ":").last
            
            if str != nil{
                
                self.navigationController?.popViewController(animated: false)
                //拿到了二维码的设备开门的str ---->
                self.openDoorByQrCodeFunction(deviceMacString: str!)
                
            }
            
        }else{
            
            self.alert(message: "非可识别二维码!")
            
        }
    }
}

extension YQIntoDoorViewController : YQScanCellDelegate{

    func scanCellBGButtonClick( indexpath : IndexPath ){
        //跳转到相应的二维码的图片的界面
        let scanImageV = YQScanImageViewController.init(nibName: "YQScanImageViewController", bundle: nil)
        
        scanImageV.model = self.dataArray?[indexpath.row]
        
        self.navigationController?.pushViewController(scanImageV, animated: true)
    
    }

}



