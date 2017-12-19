//
//  YQBluetoothCell.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/12/19.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol YQBluetoothCellDelegate : class {
    
    func BluetoothCellOpenTheDoor( indexpath : IndexPath)
}

class YQBluetoothCell: UITableViewCell {

  
    @IBOutlet weak var textView: UITextView!

    @IBOutlet weak var openButton: UIButton!
    
    var indexpath : IndexPath?
    
    var model : YQBluetooth?{
        didSet{
        
            self.textView.text = model?.name
        
        }
    
    }
    
    weak var delegate : YQBluetoothCellDelegate?
    
    @IBAction func openButtonClick(_ sender: UIButton) {
        
       
        
        let data =  model?.deviceBlueMac.stringToHexData()
        
        //直接开门
        let error =  RfmSession.sharedManager().openDoorChecked(withMac: data, deviceKey: model?.deviceKey, outputActiveTime: 60)
        
        if (error == RfmActionError.none)
        {
//            [self showMessage:@"认证中..." time:kShowTimeLong];
            SVProgressHUD.showSuccess(withStatus: "认证中...")
            self.delegate?.BluetoothCellOpenTheDoor(indexpath: self.indexpath!)
            
        }
        else if (error == .param)
        {
//            [self showMessage:@"输入参数有误" time:kShowTimeLong];
            SVProgressHUD.showError(withStatus: "输入参数有误")
        }
        else if (error == .noDevice)
        {
//            [self showMessage:@"指定设备不再范围内" time:kShowTimeLong];
            SVProgressHUD.showError(withStatus: "指定设备不再范围内")

        }
        else if (error == .poweredOff)
        {
//            [self showMessage:@"蓝牙开关未开启" time:kShowTimeLong];
            SVProgressHUD.showError(withStatus: "蓝牙开关未开启")

        }
        else if (error == .unauthorized)
        {
//            [self showMessage:@"用户未授权" time:kShowTimeLong];
            SVProgressHUD.showError(withStatus: "用户未授权")

        }
        else if (error == .busy)
        {
//            [self showMessage:@"操作忙" time:kShowTimeLong];
            SVProgressHUD.showError(withStatus: "操作忙")

        }
        else if (error == .other)
        {
//            [self showMessage:@"其他异常" time:kShowTimeLong];
            SVProgressHUD.showError(withStatus: "其他异常")

            
        }

        
        
    }
    
}
