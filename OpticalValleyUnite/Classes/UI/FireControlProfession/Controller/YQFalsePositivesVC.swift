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

    @IBOutlet weak var proveImageV: UIImageView!
    
    @IBOutlet weak var imagesView: ShowImageView!
    
    //获取详细信息的接口
    var workunitID : Int = -1
    var  type : Int = -1

    
    override func viewDidLoad() {
        super.viewDidLoad()

        falsePositivesData()
        
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
                        
                           
                            
                            let imageString = dataList["imgPaths"] as! String
                            //通过的是逗号拼接的
                            if imageString != "" {
                                
                                var temp = [String]()
                                
                                let array =  imageString.components(separatedBy: ",")
                                
                                for tempIndex in array{
                                    
                                    if (tempIndex.contains("http")){
                                        
                                        temp.append((tempIndex))
                                        
                                    }else {
                                        
                                        let basicPath = URLPath.systemSelectionURL
                                        let imageValue = basicPath.replacingOccurrences(of: "/api/", with: "") + "/" + (tempIndex)
                                        temp.append(imageValue)
                                    }
                                    
                                }
                                
                                self.imagesView.showImageUrls(temp)
                                
                                self.imagesView.didClickHandle = { index, image in
                                    
                                    CoverView.show(image: image)
                                }
                            }

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
