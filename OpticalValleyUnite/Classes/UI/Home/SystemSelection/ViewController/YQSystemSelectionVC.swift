//
//  YQSystemSelectionVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/9/1.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit
import Alamofire


var parameters = [String : Any]()

class YQSystemSelectionVC: UIViewController {
    
    
    /// 暂定义的6个子系统的界面功能
    @IBOutlet weak var firstView: YQSystemView!

    @IBOutlet weak var SecondView: YQSystemView!
    
    @IBOutlet weak var thridView: YQSystemView!
    
    @IBOutlet weak var fourVIEW: YQSystemView!
    
    @IBOutlet weak var fiveView: YQSystemView!
    
    @IBOutlet weak var sixthView: YQSystemView!
    
    
    
    
    var dataArray:NSArray = { return NSArray() }(){
        
        didSet{
            
            if dataArray.count > 1 {
                
                //通过数据遍历来进行设置隐藏
                for index in dataArray.count ..< viewArray.count {
                    
                    let dataV = viewArray[index] as? YQSystemView
                    if index == dataArray.count {
                        //设置默认图片
                        dataV?.logoTitileLabel.text = "敬请期待!"
                        dataV?.logoTitileLabel.tintColor = UIColor.gray
                        dataV?.logoImageView.image = UIImage(named: "login_icon_null")
                        
                    }else{
                        //剩余的都进行的隐藏
                        //取出的view
                        dataV?.isHidden = true
                    }
                    
                }
                
                //通过的是遍历来进行的取值
                for index in 0..<dataArray.count{
                    
                    //取出的数据
                    let data =  dataArray[index] as! [String : Any]
                    //取出的view
                    let dataV = viewArray[index] as? YQSystemView
                    
                    let pictureName = data["logo_url"] as! String
                    let url = URL(string: URLPath.systemSelectionURL + pictureName)
                    dataV?.logoImageView.kf.setImage(with: url)
                    
                    dataV?.logoTitileLabel.text = data["name"] as? String
                    
//                    print(data)
                    
                }
                
            }else{ // 直接跳转到home界面, 传递数据情况
                //数据都需要保存下来,归档解档,plist文件
                let tabVc = UITabBarController()
                
                let vc1 = UIStoryboard.instantiateInitialViewController(name: "Home")
                let vc2 = UIStoryboard.instantiateInitialViewController(name: "PersonCore")
                
                tabVc.setViewControllers([vc1,vc2], animated: false)
                SJKeyWindow?.rootViewController = tabVc

            }
        }
    }
    
    
    // MARK: - 懒加载方法
    lazy var viewArray:[YQSystemView] = {
        () ->[YQSystemView]
        in
        
        return[self.firstView,self.SecondView,self.thridView,self.fourVIEW,self.fiveView]
        
    }()
    
    
    // MARK: - 视图生命周期的方法
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.systemSelectionNetworkInterface()
        
    }
    
    
    // MARK: - 子系统的选择的接口调用
    func systemSelectionNetworkInterface(){
        
        
        let token = UserDefaults.standard.object(forKey: Const.SJToken)
        parameters["token"] = token
        
        Alamofire.request(URLPath.basicPath + URLPath.getSystemSelection, method: .post, parameters: parameters).responseJSON { (response) in
            
            switch response.result {
                
            case .success(_):
                
                if let value = response.result.value as? [String: Any] {
                    
                    guard value["CODE"] as! String == "0" else{
                        let message = value["MSG"] as! String
                        
                        self.alert(message: message)
                        
                        return
                    }
                    
                    if let data = value["data"] {//注意区分这里的值的类型,不要定死是字典和数组
                        
//                        let token = data["TOKEN"] as! String
//                        UserDefaults.standard.set(token, forKey: Const.SJToken)
//                        let user = User(data:data)
//                        user?.saveUser()
                        
                        //进行数据的缓存
                        UserDefaults.standard.set(data, forKey: Const.YQTotallData)
                        
//                        print(data)
                        //进行UI界面赋值添加
                        self.dataArray = data as! NSArray
                        
                    }
                    
                    break
                }
                
                break
            case .failure(let error):
                
                debugPrint(error)
                break
            }
        }
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let tabVc = UITabBarController()
        
        let vc1 = UIStoryboard.instantiateInitialViewController(name: "Home")
        let vc2 = UIStoryboard.instantiateInitialViewController(name: "PersonCore")
        
        tabVc.setViewControllers([vc1,vc2], animated: false)
        
        SJKeyWindow?.rootViewController = tabVc
        
    }
    

}
