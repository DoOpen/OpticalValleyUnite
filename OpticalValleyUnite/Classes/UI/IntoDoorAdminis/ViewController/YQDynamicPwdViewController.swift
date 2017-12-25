//
//  YQDynamicPwdViewController.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/12/20.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit
import SVProgressHUD


class YQDynamicPwdViewController: UIViewController {

    ///属性列表
    @IBOutlet weak var pwdView: UIView!
    
    var model : YQBluetooth?
    
    var dataDict : NSDictionary?
    
    var parkID : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "动态密码开门"
        
        //添加手动刷新的按钮
        addLeftRightBarButtonFunction()
        
        //设置动态密码
        makeupDynamicPwd()
       
    }
    
    
    // MARK: - 添加左右barItem的情况
    func addLeftRightBarButtonFunction(){
        
        let leftBtn = UIButton()
        leftBtn.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        leftBtn.setTitle("刷新", for: .normal)
        leftBtn.setTitleColor(UIColor.blue, for: .normal)
        leftBtn.addTarget(self, action: #selector(leftBarButtonClick), for: .touchUpInside)
        
        let barItem = UIBarButtonItem()
        barItem.customView = leftBtn
        
        self.navigationItem.rightBarButtonItem = barItem
        
    }
    func leftBarButtonClick() {
        //重新刷新开门的动态的密码
        var allParams = [String : Any]()
        
        var params = [String : Any]()
        
        var par = [String : Any]()
        
        par["appType"] = "2"//设备类型  1 业主 2员工
        par["parkId"] = self.parkID
        par["deviceBlueMac"] = self.model?.deviceBlueMac
        
        params["data"] = par
        
        //swift 中的 格式化的固定写法语法!
        do{
            
            let jsonData = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8){
                
                //格式化的json字典的情况
                print(JSONString)
                
                //注意的是这里的par 要求序列化json
                allParams["params"] = JSONString
                
            }
            
        }catch {
            
            print("转换错误 ")
        }
        
        
        SVProgressHUD.show()
        
        HttpClient.instance.post(path: URLPath.getdynPwdOpenDoor, parameters: allParams, success: { (response) in
            
            SVProgressHUD.dismiss()
            
            //获取时间和data 密码
            let dict = response as? NSDictionary
            self.dataDict = dict
            self.makeupDynamicPwd()
            
        }) { (error) in
            
            SVProgressHUD.showError(withStatus: "数据加载失败,请检查网络!")
            
        }
        
    }
    
    // MARK: - 获取验证码的方法
    func makeupDynamicPwd(){
        
        //设置动态密码的情况数值
        if let dataString = dataDict?["dynPwd"] as? String{
            
            let splitData = dataString.components(separatedBy: ",")
            
            for indexxxx  in 0..<self.pwdView.subviews.count{
                
                let temp = self.pwdView.subviews[indexxxx] as? UILabel
                
                temp?.text = splitData[indexxxx]
                
            }
            
        }
        
    }
    
}


