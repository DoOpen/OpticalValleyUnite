//
//  YQFireAlarmDetailViewController.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/9/17.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class YQFireAlarmDetailViewController: UIViewController {
    
    @IBOutlet weak var handlePersonText: UITextField!
    
    @IBOutlet weak var coordinatePersonText: UITextField!
    
    @IBOutlet weak var handleTimeText: UITextField!
    
    @IBOutlet weak var failureCauseText: UITextField!

    @IBOutlet weak var resultText: UITextField!
    
    @IBOutlet weak var addPhotoView: SJAddView!
    
    @IBOutlet weak var editButton: UIButton!
    
    //获取详细信息的接口
    var workunitID : Int = -1
    var  type : Int = -1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fireAlarmDetailData()
    }

    // MARK: - 编辑按钮的点击的实现
    @IBAction func editButtonClick(_ sender: Any) {
        
        
    }
    
    // MARK: - 获取网络接口数据
    func fireAlarmDetailData(){
        
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
                            
//                            for dic in dataList{
//                                
//                                model.append(YQfireMessage.init(dict: dic as! [String : Any]))
//                            }
//                            
//                            self.dataArray = model
                            self.handlePersonText.text = dataList["execPersonName"] as? String
                            self.coordinatePersonText.text = dataList["coopPersonName"] as? String
                            self.handleTimeText.text = dataList["time"] as? String
                            self.failureCauseText.text = dataList["detail"] as? String
                            self.resultText.text = dataList["reason"] as? String
                            
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
