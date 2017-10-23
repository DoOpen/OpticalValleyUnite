//
//  YQSystemSelectionVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/9/1.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit
import Alamofire
import KYDrawerController



class YQSystemSelectionVC: UIViewController {
    
    var parameters = [String : Any]()
    
    /// 暂定义的6个子系统的界面功能
    @IBOutlet weak var firstView: YQSystemView!

    @IBOutlet weak var SecondView: YQSystemView!
    
    @IBOutlet weak var thridView: YQSystemView!
    
    @IBOutlet weak var fourVIEW: YQSystemView!
    
    @IBOutlet weak var fiveView: YQSystemView!
    
    @IBOutlet weak var sixthView: YQSystemView!
    
    ///保存消防的index
    var fireindex : Int = -1
    
    
    var dataArray:NSArray = { return NSArray() }(){
        
        didSet{
            
            if dataArray.count > 1 {//注意的是,这里的大于1的情况,就是默认的一张图片不会显示的直接登录
                
                //通过数据遍历来进行设置隐藏
                for index in dataArray.count ..< viewArray.count {
                    
                    let dataV = viewArray[index]
                    if index == dataArray.count {
                        //设置默认图片
                        dataV.logoTitileLabel.text = "敬请期待!"
                        dataV.logoTitileLabel.tintColor = UIColor.gray
                        dataV.logoImageView.image = UIImage(named: "login_icon_null")
                        
                    }else{
                        //剩余的都进行的隐藏
                        //取出的view
                        dataV.isHidden = true
                    }
                    
                }
                
                //通过的是遍历来进行的取值
                for index in 0..<dataArray.count{
                    
                    //取出的数据
                    let data =  dataArray[index] as! [String : Any]
                    //取出的view
                    let dataV = viewArray[index]
                    
                    let pictureName = data["logo_url"] as! String
                    let url = URL(string: URLPath.systemSelectionURL + pictureName)
                    
                    dataV.logoImageView.kf.setImage(with: url, placeholder: UIImage(named: "login_icon_null"), options: nil, progressBlock: nil, completionHandler: nil)
                    
                    dataV.logoTitileLabel.text = data["name"] as? String
                    
                    if dataV.logoTitileLabel.text == "智慧消防"{
                        
                        fireindex = index
                        
                    }
//                    print(data)
                }
                
            } else if dataArray.count == 1 { //只有一条数据的时候处理
            
                let data = dataArray.lastObject as! [String : Any]
                UserDefaults.standard.set(data, forKey: Const.YQSystemSelectData)
                let tabVc = UITabBarController()
                let vc1 = UIStoryboard.instantiateInitialViewController(name: "Home")
                let vc2 = UIStoryboard.instantiateInitialViewController(name: "PersonCore")
                
                tabVc.setViewControllers([vc1,vc2], animated: false)
                
                SJKeyWindow?.rootViewController = tabVc

                
            
            }else{ // 直接跳转到home界面, 传递数据情况,(没有数据的逻辑处理)
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
        
        //  systemView 添加tap
        for index in viewArray {
            
            let tap = YQTapGestureRecognizer.init(target: self, action: #selector( systemViewAddTapGesture(tap:)))
            tap.tapIndex = index.tag
            
            index.addGestureRecognizer(tap)
           
        }
        
        //逻辑判断:如果有缓存的话,就不需要请求
        let data = UserDefaults.standard.object(forKey: Const.YQTotallData)
        
        if data == nil {
            
            self.systemSelectionNetworkInterface()
            
        }else{
            
            //进行UI界面赋值添加
            self.dataArray = data as! NSArray

        }
        
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
    
    
    // MARK: - 添加子系统的手势点击按钮
    func systemViewAddTapGesture( tap : YQTapGestureRecognizer ) {
    
//        print(tap.tapIndex)
        
        if tap.tapIndex >= dataArray.count {
            
            //最后一个是显示的图标
            return
            
        }else if tap.tapIndex == fireindex {
            
            //跳进消防的界面功能
            let fireVC = UIStoryboard.instantiateInitialViewController(name: "YQFireControl")
            let mainViewController   = fireVC
            let drawerViewController = YQDrawerViewController()
            //初始化drawerVC的位置
            let drawerController     = KYDrawerController(drawerDirection: .left, drawerWidth: 300)
            drawerController.mainViewController =  mainViewController
            
            drawerController.drawerViewController = drawerViewController
            
            /* Customize
             drawerController.drawerDirection = .Right   视图的方向
             drawerController.drawerWidth     = 200      宽度的大小
             */

//test 测试用例的情况
//            let vc = SJKeyWindow?.rootViewController
//            
//            if (vc?.isKind(of: YQFireControlViewController.classForCoder()))! {
//                
//                let vc1 = vc as! YQFireControlViewController
//                //重新刷新火警列表
//                vc1.makeMapLocationData()
//                
//            }else{
//                
//                SJKeyWindow?.rootViewController = drawerController
//                
//            }

            SJKeyWindow!.rootViewController?.present(drawerController, animated: true, completion: nil)
            
//            getNavController()?.present(drawerController, animated: true, completion: nil)

        
        }else{
            
            //数组取值,进行传值,控制器加载跳转
            let data = dataArray[tap.tapIndex] as! [String : Any]
            UserDefaults.standard.set(data, forKey: Const.YQSystemSelectData)

            
            let tabVc = UITabBarController()
            
            let vc1 = UIStoryboard.instantiateInitialViewController(name: "Home")
            let vc2 = UIStoryboard.instantiateInitialViewController(name: "PersonCore")
            
            tabVc.setViewControllers([vc1,vc2], animated: false)
            
            SJKeyWindow?.rootViewController = tabVc
            
            
            ///发送通知的方法(这个控制器都已经死了,通知肯定发不了的)
//            let center = NotificationCenter.default
//            center.post(name:  NSNotification.Name(rawValue: "systemSelectionPassValue"), object: nil, userInfo: data)
            
        }
    
    }
    


//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        
//        let tabVc = UITabBarController()
//        
//        let vc1 = UIStoryboard.instantiateInitialViewController(name: "Home")
//        let vc2 = UIStoryboard.instantiateInitialViewController(name: "PersonCore")
//        
//        tabVc.setViewControllers([vc1,vc2], animated: false)
//        
//        SJKeyWindow?.rootViewController = tabVc
//        
//    }
    

}
