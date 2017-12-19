//
//  YQIntoDoorViewController.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/12/17.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit
import SVProgressHUD

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
        
        addLeftRightBarButtonFunction()
        
        
        //默认的是选中第一项bluetooth
//        self.allButtonClickEvent(self.openBluetooth)
        
        
    
    }
    
    
    // MARK: - allButtonClick传递事件
    @IBAction func allButtonClickEvent(_ sender: UIButton) {
        self.currentSelectButton?.isSelected = false
        sender.isSelected = true
        self.currentSelectButton = sender
        
        switch sender.tag {
            
            case 0:
                bluetoothOpenTheDoor()
                break
            case 1:
                
                break
                
            case 2:

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
                
            }catch {
                
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
                
                SVProgressHUD.showError(withStatus: "数据获取失败,请检查网络连接!")
            }
        
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

    

}

extension YQIntoDoorViewController : UITableViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray?.count ?? 0
        
    }
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var Cell = tableView.dequeueReusableCell(withIdentifier: "bluetoothCell") as? YQBluetoothCell
        if Cell == nil {
            Cell = Bundle.main.loadNibNamed("YQBluetoothCell", owner: nil, options: nil)?[0] as? YQBluetoothCell
        }
        Cell?.delegate = self
        Cell?.indexpath = indexPath
        Cell?.model = self.dataArray?[indexPath.row]
        
        return Cell!
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

