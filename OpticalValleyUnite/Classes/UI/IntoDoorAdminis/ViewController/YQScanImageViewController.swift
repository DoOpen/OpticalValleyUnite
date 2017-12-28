//
//  YQScanImageViewController.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/12/21.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit
import SVProgressHUD
import Kingfisher

class YQScanImageViewController: UIViewController {

    //属性列表
    @IBOutlet weak var imageView: UIImageView!
    
    //model
    var model : YQBluetooth?
    var parkID : String?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "二维码开门"
        
        //添加right刷新项
        addLeftRightBarButtonFunction()
        
        //添加parkid
        let _ = self.setUpProjectNameLable()
        
        //请求网络数据的方法
        setBGImageData()

    }
    
   
    // MARK: - 添加左右barItem的情况
    func addLeftRightBarButtonFunction(){
        
        let leftBtn = UIButton()
        leftBtn.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        leftBtn.setImage(UIImage.init(name: "二维码2"), for: .normal)
        leftBtn.setTitleColor(UIColor.blue, for: .normal)
        leftBtn.addTarget(self, action: #selector(leftBarButtonClick), for: .touchUpInside)
        
        let barItem = UIBarButtonItem()
        barItem.customView = leftBtn
        
        self.navigationItem.rightBarButtonItem = barItem
        
    }
    func leftBarButtonClick(){
    
        setBGImageData()
        
    }
    
    
    // MARK: - 获取反扫image数据的方法
    func setBGImageData(){
        
        var allParams = [String : Any]()
        
        var params = [String : Any]()
        
        var par = [String : Any]()
        var devicePar = [String : Any]()
        
        par["appType"] = "2"//设备类型  1 业主 2员工
        par["parkId"] = self.parkID
    
        devicePar["deviceQrMac"] = self.model?.deviceQrMac
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        devicePar["qrCreateTime"] = dateFormatter.string(from: Date())
    
        par["device"] = devicePar
        params["data"] = par
        
        //swift 中的 格式化的固定写法语法!
        do{
            
            let jsonData = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8){
                
                //格式化的json字典的情况
                //print(JSONString)
                
                //注意的是这里的par 要求序列化json
                allParams["params"] = JSONString
                
                print(JSONString)
                
            }
            
        }catch {
            
            print("转换错误 ")
        }
        
        
      
        
        SVProgressHUD.show()
        
        HttpClient.instance.post(path: URLPath.getOpenDoorByQrCode, parameters: allParams, success: { (response) in
            
            SVProgressHUD.dismiss()
            
            let dict = response as? NSDictionary
            let result = dict?["result"] as! Int
            let qrCode = dict?["qrCode"] as! String
            
            switch (result) {
                case 0://成功
                    //判断图片的地址名称
                    //通过SGQRcode 来生成二维码的图片
                    self.imageView.image =  SGQRCodeTool.sg_generate(withDefaultQRCodeData: qrCode, imageViewWidth: self.imageView.width)
                    break
                case 1://门禁设备未连接
                     SVProgressHUD.showError(withStatus: "门禁设备未连接!")
                    break
                case 2://数据加载失败
                    SVProgressHUD.showError(withStatus: "数据加载失败,请检查网络!")

                    break
                default:
                    break
            }
            
            // 显示的拿到的image图片的数据
//            self.imageView.kf.setImage(with: nil, placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
           
            
        }) { (error) in
            
            SVProgressHUD.showError(withStatus: "数据加载失败,请检查网络!")
        }
    }
    
    // MARK: - 添加默认的项目选择方法
    func setUpProjectNameLable() -> String{
        
        let dic = UserDefaults.standard.object(forKey: Const.YQProjectModel) as? [String : Any]
        
        var projectName  = ""
        
        if dic != nil {
            
            projectName = dic?["PARK_NAME"] as! String
            self.parkID = dic?["ID"] as? String
            
        }else{
            
            projectName = "请选择默认项目"
        }
        return projectName
    }


}
