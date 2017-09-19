//
//  YQFalsePositivesVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/9/17.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD


class YQFalsePositivesVC: UIViewController {
    
    @IBOutlet weak var handlePerson: UITextField!
    
    @IBOutlet weak var handleTime: UITextField!

    @IBOutlet weak var addPhotoView: SJAddView!
    
    @IBOutlet weak var editButton: UIButton!
    
    //获取详细信息的接口
    var workunitID : Int = -1
    var  type = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()

        falsePositivesData()
        
        
    }

    // MARK: - 编辑按钮的点击的实现
    @IBAction func editButtonClick(_ sender: Any) {
        
        
    }
    
    func falsePositivesData(){
        
        var parameters = [String : Any]()
        let token = UserDefaults.standard.object(forKey: Const.SJToken)
        parameters["token"] = token
        parameters["workunitId"] = workunitID
        
        SVProgressHUD.show(withStatus: "加载中...")
        
        Alamofire.request(URLPath.basicPath + URLPath.getFireDetail , method: .post, parameters: parameters).responseJSON { (response) in
            
            SVProgressHUD.dismiss()
            
            switch response.result {
                
            case .success(_):
                
                if let value = response.result.value as? [String: Any] {
                    
                    guard value["CODE"] as! String == "0" else{
                        let message = value["MSG"] as! String
                        
                        self.alert(message: message)
                        return
                    }
                    
                    if let data = value["data"] as? NSDictionary{
//                        //字典转模型的操作
                        if let dataList = data["workunit"] as? [String : Any] {
                            
//                            var model = [YQfireMessage]()
//
//                            for dic in dataList{
//                                
//                                model.append(YQfireMessage.init(dict: dic as! [String : Any]))
//                            }
//                            
//                            self.dataArray = model
                            self.handlePerson.text = dataList["execPersonName"] as? String
                            self.handleTime.text = dataList["coopPersonName"] as? String
                        
                        }
                        
                    }
                    
                    break
                }
                
                break
            case .failure(let error):
                
                debugPrint(error)
                self.alert(message: "请求失败!")
                break
            }
        }
    
    }

}
