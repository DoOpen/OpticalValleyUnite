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
    
    /// 蓝牙开门的单例的设置
    var rfmsessionClass = RfmSession.sharedManager()
    var bluetoothWhitelist = NSArray()
    var initBluetooth = false
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //设置蓝牙开门的情况
        self.initBluetooth = (rfmsessionClass?.setup(withWhitelist: nil, delegate: self))!
       
    
    }
    
    
    // MARK: - allButtonClick传递事件
    @IBAction func allButtonClickEvent(_ sender: UIButton) {
        
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
    
    // MARK: - 设置上传蓝牙开门的接口
    func bluetoothOpenTheDoor(){
        
        //初始化sdk
        if !(self.initBluetooth) {
            
            self.alert(message: "蓝牙初始化失败!")
            
            return
            
        }else{
        
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
            
            var params = [String : Any]()
            
            var par = [String : Any]()
            par["appType"] = "2"//设备类型  1 业主 2员工
            if parArray.count > 0 {
                
                //传递所有开门的数据
                par["deviceList"] = parArray
                
                
            }else{
                
                self.alert(message: "没有可用的蓝牙设备!")
                
                return
            }
            
            //注意的是这里的par 要求序列化json
            params["data"] = par
            
            SVProgressHUD.show()
            
            HttpClient.instance.post(path: URLPath.getAuthEquipmentList, parameters: params, success: { (reponse) in
                SVProgressHUD.dismiss()
                
                //返回可有权限的开门集合
                //通过字典转模型来进行的操作!
                
                
            }) { (error) in
                
                SVProgressHUD.showError(withStatus: "数据获取失败,请检查网络连接!")
            }
        
        }

        
        

    
    }
    

}

extension YQIntoDoorViewController : RfmSessionDelegate{
    
    func rfmSessionDidFinishedEvent(_ event: RfmSessionEvent, mac: Data!, error: RfmSessionError, extra: Any!) {
        
        
        
        
    }



}
