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
    
    @IBOutlet weak var failureCauseText: UILabel!
    

    @IBOutlet weak var resultText: UITextField!
    
    @IBOutlet weak var addPhotoView: SJAddView!
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var proveImageV: UIImageView!
    
    @IBOutlet weak var imagePathsView: ShowImageView!
    
    //获取详细信息的接口
    var workunitID : Int = -1
    var  type : Int = -1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fireAlarmDetailData()
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
                        
                        print(message)
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
                            
                            //setImage
//                            let url = URL(string : dataList["imgPaths"] as! String)
//                            self.proveImageV.kf.setImage(with: url, placeholder: UIImage(named: "avatar"), options: nil, progressBlock: nil, completionHandler: nil)
                            let imageString = dataList["imgPaths"] as! String
                            //通过的是逗号拼接的
                            //图片展示
                            var photoImage = [Photo]()
                            
                            if imageString != "" {
                                
                                var temp = [String]()
                                
                                let array =  imageString.components(separatedBy: ",")
                                //框架
                                var pUrl = Photo()
                                for tempIndex in array{
                                    
                                    if (tempIndex.contains("http")){
                                        
                                        temp.append((tempIndex))
                                        pUrl = Photo.init(urlString: tempIndex)
                                        
                                        
                                    }else {
                                        
                                        let basicPath = URLPath.systemSelectionURL
                                        let imageValue = basicPath.replacingOccurrences(of: "/api/", with: "") + "/" + (tempIndex)
                                        temp.append(imageValue)
                                        pUrl = Photo.init(urlString: imageValue)

                                    }
                                    photoImage.append(pUrl)
                                    
                                }
                                
                                self.imagePathsView.showImageUrls(temp)
                                
                                self.imagePathsView.didClickHandle = { index, image in
                                    //改换框架,应用切换保存,缩放,移动的图片框架
                                    //CoverView.show(image: image)
                                    let pb = PhotoBrowser(photos: photoImage , currentIndex: 0)
                                    pb.indicatorStyle = .pageControl
                                    SJKeyWindow?.rootViewController?.present(pb, animated: true, completion: nil)
                                    
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
