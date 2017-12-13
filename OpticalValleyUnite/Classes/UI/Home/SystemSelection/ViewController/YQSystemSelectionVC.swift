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
import CoreMotion


class YQSystemSelectionVC: UIViewController {
    
    var parameters = [String : Any]()
    
    /// 暂定义的6个子系统的界面功能
    @IBOutlet weak var firstView: YQSystemView!

    @IBOutlet weak var SecondView: YQSystemView!
    
    @IBOutlet weak var thridView: YQSystemView!
    
    @IBOutlet weak var fourVIEW: YQSystemView!
    
    @IBOutlet weak var fiveView: YQSystemView!
    
    @IBOutlet weak var sixthView: YQSystemView!
    
    @IBOutlet weak var sevenView: YQSystemView!
    
    @IBOutlet weak var eightView: YQSystemView!
    
    @IBOutlet weak var nineView: YQSystemView!
    
    ///保存消防的index
    var fireindex : Int = -1
    
    ///计步器的功能模块属性
    //设置注册 计步设备的
    lazy var counter = { () -> CMPedometer
        
        in
        
        return CMPedometer()
    }()

    
    
    var dataArray:NSArray = { return NSArray() }(){
        
        didSet{
            
            //调用写入计步数据的接口
            stepFunctionDidStart()
            
            if dataArray.count > 1 && dataArray.count <= viewArray.count {//注意的是,这里的大于1的情况,就是默认的一张图片不会显示的直接登录
                
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
                    
                    var url = URL(string: "")
                    
                    //图片的逻辑的判断,需要的是全局的更改
                    //所有的获取图片信息逻辑判断
                    if pictureName.contains("http"){
                        
                        url = URL(string : pictureName)
                        
                    }else{
                        
                        url = URL(string : URLPath.systemSelectionURL + pictureName)
                    }
                    
                    
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

            
            }  else { // 直接跳转到home界面, 传递数据情况,(没有数据的逻辑处理)
                
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
        
        return[self.firstView,self.SecondView,self.thridView,self.fourVIEW,self.fiveView,self.sixthView,self.sevenView,self.eightView,self.nineView]
        
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
    
    
    // MARK: - 计步功能的模块实现
    func stepFunctionDidStart() {
        
        if !CMPedometer.isStepCountingAvailable() {
            
            //设备不可用的情况下是在登录界面,不需要提示的
            //            self.alert(message: "设备不可用! 支持5s及以上的机型")
            return
            
        }else{
        
            //获取昨天 和 前天的时间数据
            let date = NSDate()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
            let formatter1 = DateFormatter()
            formatter1.dateFormat = "yyyy-MM-dd"
            let temp = formatter1.string(from: date as Date)
            let tempstring = temp.appending(" 00:00:00")
        
            let nowdate = formatter.date(from: tempstring)
        
            //直接应用的是 CMPedometer 获取系统的健康的应用
            self.counter.queryPedometerData(from: nowdate!, to: date as Date , withHandler: { (pedometerData, error) in
                
                let num = pedometerData?.numberOfSteps ?? 0
                //上传前一天的步数
                
                DispatchQueue.main.async {
                    
                    var parameter = [String : Any]()
                    parameter["date"] = temp
                    
                    parameter["steps"] = num
                    
                    HttpClient.instance.post(path: URLPath.getSavePedometerData, parameters: parameter, success: { (respose) in
                        
                        
                    }, failure: { (error) in
                        
                    })
                }
                
            })
        }
    }
    
    
    // MARK: - 添加子系统的手势点击按钮
    func systemViewAddTapGesture( tap : YQTapGestureRecognizer ) {
    
//        print(tap.tapIndex)
        
        if tap.tapIndex >= dataArray.count {
            
            //最后一个是显示的图标
            // return
            
//            // 调试视频巡查的内容
//            let Video = UIStoryboard.instantiateInitialViewController(name: "YQVideoPatrol")
//            let mainViewController   = Video
//            let drawerViewController = YQVideoDrawerViewController()
//            // 初始化drawer抽屉的情况
//            let drawerController     = KYDrawerController(drawerDirection: .right, drawerWidth: 300)
//            drawerController.mainViewController =  mainViewController
//            
//            drawerController.drawerViewController = drawerViewController
//
//            SJKeyWindow?.rootViewController = drawerController
            
            // 调试视频结果的内容
            let videoResult = UIStoryboard.instantiateInitialViewController(name: "YQPatrolResult")
            SJKeyWindow?.rootViewController = videoResult
            
        }else if tap.tapIndex == fireindex {//消防的界面的跳转的情况
            
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
            SJKeyWindow?.rootViewController = drawerController
//
//            }

// 注意的是:这个方法是 保留了SJKeyWindow?.rootViewController的跟控制器,而直接赋值的区别是替换了,这样导致的是弹框的视图的显示问题??????
//            SJKeyWindow!.rootViewController?.present(drawerController, animated: true, completion: nil)
            
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
