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
        
        SVProgressHUD.show()
        
        HttpClient.instance.post(path: URLPath.getDownloadOfflineUnits, parameters: nil, success: { (response) in
            
            SVProgressHUD.dismiss()
            //大数据的处理情况
            let data = response["data"] as? NSArray
            
            //1.先转工单首页的模型数据表
            var tempData = [WorkOrderModel2]()
            
            for temp in data! {
                
                let model = WorkOrderModel2.init(parmart: temp as! [String : Any])
                tempData.append(model)
            }
            
            let realm = try! Realm()
            try! realm.write {
                
                realm.add(tempData)
            }
            
            //2.再转工单详情的模型数据列表
            let offlineFirst = UIStoryboard.instantiateInitialViewController(name: "YQOffLineFirst")
            self.navigationController?.pushViewController(offlineFirst, animated: true)

            
        }) { (error) in
            
            SVProgressHUD.showError(withStatus: "离线工单下载失败,请重试!")
        }
        
        
        
        /// 测试数据库的代码情况
        var tempData = [WorkOrderModel2]()
        
        var dict = [String : Any]()
        dict["id"] = "8980980"
        dict["status"] = 1
        dict["content"] = "都帮songodjodn"
        dict["EXEC_PERSON_ID"] = "jsongodijdojfdof"
        dict["statusCn"] = "jsongdoufbdo"
        dict["reportPeopleName"] = "eionfoaohgd"
        dict["WORKUNIT_TYPE"] = "1"
        
        let model = WorkOrderModel2.init(parmart: dict)
        
        for _ in 0...3 {
            
            tempData.append(model)
        }
        
        
        let realm = try! Realm()
        
        try! realm.write {
            
            realm.deleteAll()
            
            realm.add(tempData)
        }
        
        
        
    }
    
    // MARK: - 离线工单的上传
    @IBAction func offLineButtonUP(_ sender: UIButton) {
        //上传思路:
        /*
         1.读取对应的工单进行上传
         
         */
        
//        let realm = try! Realm()
//        let result =  realm.objects(WorkOrderModel2.self)
//        
//        
//        print(result.count)
//        
//        print(result)

               
    }

}
