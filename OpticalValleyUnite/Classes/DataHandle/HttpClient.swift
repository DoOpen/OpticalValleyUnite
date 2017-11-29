//
//  HttpClient.swift
//  断点续传
//
//  Created by 贺思佳 on 2016/12/26.
//  Copyright © 2016年 贺思佳. All rights reserved.
//

import Foundation
import Alamofire
import SVProgressHUD

class HttpClient {
    
    static let instance = HttpClient()
    private init() {}
    
    /**
     *  网络请求成功闭包:
     */
    typealias HttpSuccess = (_ response:AnyObject) -> ()
    
    /**
     *  网络请求失败闭包:
     */
    typealias HttpFailure = (_ error:NSError) -> ()
    
}

extension HttpClient {
    /**
     * POST 请求, <注：GET请求类似>
     * parameter urlString:  请求URL
     * parameter parameters: 请求参数
     * parameter success:    成功回调
     * parameter failure:    失败回调
     */
    func post(path urlString: String ,parameters: [String : Any]?, success: @escaping HttpSuccess, failure : @escaping HttpFailure) {
        
        var parameters = parameters ?? [String : Any]()
//        parameters["token"] = "097e84d8d4cd4e93973528a8e06fd54e"
         parameters["token"] = UserDefaults.standard.object(forKey: Const.SJToken)
        print("请求URL:" + URLPath.basicPath + urlString)
        print("请求参数:")
        print(parameters)
        Alamofire.request(URLPath.basicPath + urlString, method: .post, parameters: parameters).responseJSON { (response) in

            switch response.result {
            case .success(_):
                if let value = response.result.value as? [String: Any] {
                    
                    guard value["MSG"] as? String != "token无效" else{
                        if urlString != URLPath.logOut{
                            LoginViewController.loginOut()
                        }
                        
                        print("token无效")
                        return
                    }
                    
                    guard value["CODE"] as! String == "0" else{
                        
                        let message = (value["MSG"] as? String) ?? ""
                        let status = Int(value["CODE"] as! String) ?? 1111
                        SVProgressHUD.showError(withStatus: message)
                        failure(NSError(domain: message, code: status, userInfo: nil))
                        
                        return
                    }
                    
                    success(value["data"]  as AnyObject)
                    
                    break
                }
                
                break
            case .failure(let error):
                failure(error as NSError)
                debugPrint(error)
                print(error)
                
                SVProgressHUD.dismiss()
                break
            }

        }

    }
    
    /**
     * POST 请求, <注：GET请求类似>
     * parameter urlString:  请求URL
     * parameter parameters: 请求参数
     * parameter success:    成功回调
     * parameter failure:    失败回调
     */
    func get(path urlString: String ,parameters: [String : Any]?, success: @escaping HttpSuccess, failure : @escaping HttpFailure) {
        
        var parameters = parameters ?? [String : Any]()
        parameters["token"] = UserDefaults.standard.object(forKey: Const.SJToken)
        
        print("请求URL:" + URLPath.basicPath + urlString)
        print(parameters)
        
//        print(parameters)
        Alamofire.request(URLPath.basicPath + urlString, method: .get, parameters: parameters).responseJSON { (response) in
            
            switch response.result {
            case .success(_):
                
                if let value = response.result.value as? [String: Any] {
                    
                    guard !value.isEmpty else{
                        print("返回数据为空")
                        return
                    }
                    
                    
                    guard value["MSG"] as? String != "token无效" else{
                        LoginViewController.loginOut()
                        print("token无效")
                        return
                    }
                    
        
                    guard value["CODE"] as! String == "0" else{
                        
                        let message = value["MSG"] as! String
                        let status = 1111
                        
                        print("系统错误:" + urlString)
                        print(NSError(domain: message, code: status, userInfo: nil))
                        failure(NSError(domain: message, code: status, userInfo: nil))
                        
                        
                        SVProgressHUD.showError(withStatus: message)
                        
                        return
                    }
                    
                    
                    success(value["data"]  as AnyObject)
                    break
                }
                break
            case .failure(let error):
                
                failure(error as NSError)
                
                debugPrint(error)
                
                SVProgressHUD.dismiss()
                
                break
            }
        }
        
    }
    
    func upLoadImage(_ image: UIImage, succses: @escaping ((String?) -> ()), failure: @escaping ((Error) -> ())){
        
        upLoadImages([image], succses: succses, failure: failure)
        
//        let data = UIImagePNGRepresentation(image)
//        
//        Alamofire.upload(multipartFormData: { (multipartFormData) in
//            multipartFormData.append(data!, withName: "file",fileName:"file.jpg", mimeType: "image/jpeg")
//        }, to: URLPath.basicPath + URLPath.uploadImage) { (response) in
//            
//            switch response {
//            case .success(let upload, _, _):
//                upload.responseJSON(completionHandler: { (resposen) in
//                    switch resposen.result {
//                    case .success(let value):
//                        if let dic = value as? [String: Any]{
//                            succses(dic["previewUrl"] as? String)
//                        }
//                        
//                    case .failure(let error):
//                        print(error)
//                        failure(error)
//                    }
//                })
//                break
//            case .failure(let error):
//                
//                debugPrint(error)
//                failure(error)
//                break
//            }
//        }
//        
    }
    
    func upDataImage(_ image: UIImage, complit: @escaping ((String) -> ())){
        SVProgressHUD.show(withStatus: "上传图片中...")
        HttpClient.instance.upLoadImage(image, succses: { (url) in
            SVProgressHUD.dismiss()
            complit(url!)
            
        }) { (error) in
            
            
            
            SVProgressHUD.dismiss()
        }
    }
    
    func upDataImages(_ images: [UIImage], complit: @escaping ((String) -> ())){
        SVProgressHUD.show(withStatus: "上传图片中...")
        HttpClient.instance.upLoadImages(images, succses: { (url) in
            SVProgressHUD.dismiss()
            complit(url!)
            
        }) { (error) in
            
            
            
            SVProgressHUD.dismiss()
        }
    }
    
    func getAddress(lat: Double,lon: Double,succses: @escaping ((String?) -> ())){
        let url = "http://restapi.amap.com/v3/geocode/regeo?output=json&location=\(lon),\(lat)&key=07ed7530d719148697c92a1fbd0b5d8d"
        
        Alamofire.request(url).responseJSON { (resposen) in
            
            switch resposen.result {
             
            case .success(let value):
                print(value)
                if let dic = value as? [String: Any]{
                    if let info = dic["info"] as? String,info == "OK"{
                        if let dic2 = dic["regeocode"] as? [String: Any]{
                            if let address = dic2["formatted_address"] as? String{
                                succses(address)
                                return
                            }
                            
                            
                            
                        }
                    }
                }
                
                succses(nil)
                
                
            case .failure(let error):
                print(error)
                
            }

            
        }
    }


    func upLoadImages(_ images: [UIImage], succses: @escaping ((String?) -> ()), failure: @escaping ((Error) -> ())){
        
        var url = URLPath.basicPath + URLPath.uploadImage
        if let token = UserDefaults.standard.object(forKey: Const.SJToken) as? String{
            
            url = url + "?token=\(token)"
        }
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            var count = 0
            for image in images{
                let frame = CGRect(x: image.size.width - 400, y: image.size.height - 80, width: 400, height: 40)
                let str = NSDate().dateStr(withFormat: "YYYY-MM-dd HH:mm")
                let newImage = image.addContent(content: str!, frame: frame)
                let data = UIImageJPEGRepresentation(newImage, 0.4)
                multipartFormData.append(data!, withName: "file\(count)",fileName:"file\(count).jpg", mimeType: "image/jpeg")
                count += 1
            }
    
        }, to: url) { (response) in
            
            switch response {
                
            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: { (resposen) in
                    switch resposen.result {
                    case .success(let value):
                        if let dic = value as? [String: Any]{
                            
                            guard dic["MSG"] as? String != "token无效" else{
                                LoginViewController.loginOut()
                                print("token无效")
                                return
                            }
                            
                            guard dic["MSG"] as? String != "图片上传失败" else{
//                                LoginViewController.loginOut()
                                print("图片上传失败")
                                SVProgressHUD.showError(withStatus: "图片上传失败")
                                return
                            }
                            
                            
                            succses(dic["urls"] as? String)
                        }
                        
                    case .failure(let error):
                        print(error)
                        failure(error)
                    }
                })
                break
            case .failure(let error):
                
                debugPrint(error)
                failure(error)
                break
            }
        }
        
    }
    
    
    /**
     * 配置headers, 可以自定义
     */
    func configHeaders() -> [String : String]? {
        let headers = [
            "content": "application/x-www-form-urlencoded; charset=utf-8",
            "Accept": "application/json",
            "token": "AOS51ADKH7881391"
        ]
        return headers
    }
}

