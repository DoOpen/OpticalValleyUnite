//
//  YQOffLineWorkOrderVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/1/4.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit
import RealmSwift
import SVProgressHUD

class YQOffLineWorkOrderVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "离线工单"
    }
    
    // MARK: - 离线工单的操作
    @IBAction func offLineButtonDownLoad(_ sender: UIButton) {
        //思路:
        /*
         1.调用离线工单的下载的接口
         2.数据解压,base64转json
         3.relam写入数据库的操作
         4.读取进行渲染,拿到数据,进行操作
         */
        
        let realm = try! Realm()
        
        try! realm.write {
            
//            realm.add("你好")
            
        }
        
        SVProgressHUD.show()
        
        HttpClient.instance.post(path: URLPath.getDownloadOfflineUnits, parameters: nil, success: { (response) in
            
            
            
        }) { (error) in
            
            SVProgressHUD.showError(withStatus: "离线工单下载失败,请重试!")
            
        }
        
    }
    
    // MARK: - 离线工单的上传
    @IBAction func offLineButtonUP(_ sender: UIButton) {
        //上传思路:
        /*
         1.读取对应的工单进行上传
         
         */
        
        
        
    }

}
