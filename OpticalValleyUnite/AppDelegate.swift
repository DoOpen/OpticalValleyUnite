//
//  AppDelegate.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/1/12.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit
import IQKeyboardManager
import SVProgressHUD
import MessageUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow()
        window?.frame = UIScreen.main.bounds
        window?.makeKeyAndVisible()
        
        LoginViewController.chooseRootViewController()
        
        AMapServices.shared().apiKey = Const.SJMapKey
        IQKeyboardManager.shared().isEnabled = true
        SVProgressHUD.setMaximumDismissTimeInterval(2)
        
        /*
         1. 集成友盟的sdk,步骤方法
         2. 通过的是 适配Https
         */
        UMessage.start(withAppkey: Const.SJUMPushKey, launchOptions: launchOptions)
        //注册通知，如果要使用category的自定义策略，可以参考demo中的代码。
        UMessage.registerForRemoteNotifications()
        UMessage.setBadgeClear(false)

        // 3.如果是ios10 必须加上 如下的代码
        if #available(iOS 10.0, *) {
            
            let center = UNUserNotificationCenter.current()
            //设置 友盟的代理的情况
            center.delegate = self
            //let types =
            center.requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { granted,error in
                //文档中的继承 granted  通过的逻辑的执行来进行的判断 允许点击和 不允许的点击的逻辑判断
                
            })
            
        } else {
            
            /// iOS 10.0 以下的代码,它重新的设置了 系统通知的类型方法
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        }
        
        
        //打开日志，方便调试
        UMessage.setLogEnabled(true)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}



/// 集成的友盟的接口
extension AppDelegate: UNUserNotificationCenterDelegate{
    
    //iOS10以下使用这个方法接收通知
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
        UMessage.didReceiveRemoteNotification(userInfo)
        
        noticHandel(userInfo: userInfo)
        
        UIApplication.shared.applicationIconBadgeNumber += 1
    }
    
    //iOS10新增：处理后台点击通知的代理方法
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        
        if (response.notification.request.trigger?.isKind(of: UNPushNotificationTrigger.classForCoder()))!{

            // 接受通知执行界面的跳转功能
            noticHandel(userInfo: userInfo)
    
            UMessage.didReceiveRemoteNotification(userInfo)
            
        }else{
            //应用处于后台时的本地推送接受
            
        }
        
    }
    
//iOS10新增：处理前台收到通知的代理方法
    ////iOS10新增：处理前台收到通知的代理方法
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        if (notification.request.trigger?.isKind(of: UNPushNotificationTrigger.classForCoder()))!{
            //应用处于前台时的远程推送接受
            //关闭U-Push自带的弹出框
            UMessage.setAutoAlert(false)
            UMessage.didReceiveRemoteNotification(userInfo)
            
        }else{
            //应用处于前台时的本地推送接受
        }
        UIApplication.shared.applicationIconBadgeNumber += 1
        completionHandler(UNNotificationPresentationOptions.alert)
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let token = NSData(data: deviceToken).description.replacingOccurrences(of: "<", with: "").replacingOccurrences(of: ">", with: "").replacingOccurrences(of: " ", with: "")
        
        print(token)
        
        UserDefaults.standard.set(token, forKey: "SJDeviceToken")
        
        if let _ = UserDefaults.standard.object(forKey: "HasToken"){
            
        }
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
        
        }
}



/// 继承appDelegate的点击进行的界面间跳转的方法
extension AppDelegate{
    
    // MARK: - 推送通知返回的 值--->(关联后台的参数值来解析) 进行相应的跳转传值
    func noticHandel(userInfo: [AnyHashable : Any]){
        
        if !User.isLogin(){
            print("没有登录")
            return
        }
        
        //应用处于后台时的远程推送接受
        if let type = userInfo["type"] as? String{
            if type == "工单"{
                if let sub_type = userInfo["sub_type"] as? String,sub_type == "督办"{
                    let workId = userInfo["workId"] as! String
                    pushToDubanViewController(workId)
                    
                }else{
                    let workId = userInfo["id"] as! String
                    pushToWorkOrderViewController(workId)
                }
                
            }else if type == "通知"{
                
                pushToHomeViewController()
            }
        }
    }
    
    
    func getNavController(_ vc: UIViewController = (SJKeyWindow!.rootViewController)!) -> UINavigationController?{
        
        if let vc = vc as? UITabBarController{
            
            return getNavController(vc.selectedViewController!)
        }else if let vc = vc as? UINavigationController{
            
            return vc
        }
        return nil

    }
    
    // MARK: - push到 工单的界面
    func pushToWorkOrderViewController(_ workId: String){
        
        let vc = WorkOrderProgressViewController.loadFromStoryboard(name: "WorkOrder") as! WorkOrderProgressViewController
        var parmat = [String: Any]()
        parmat["WORKUNIT_ID"] = workId
        vc.parmate = parmat
        getNavController()?.pushViewController(vc, animated: true)
    }
    
    // MARK: - push到 督办的界面
    func pushToDubanViewController(_ workId: String){

        let vc = WorkOrderProgressViewController.loadFromStoryboard(name: "WorkOrder") as! WorkOrderProgressViewController
        var parmat = [String: Any]()
        parmat["WORKUNIT_ID"] = workId
        vc.parmate = parmat
        vc.workType = 1
        vc.hasDuban = 0
        getNavController()?.pushViewController(vc, animated: true)
    }
    
    // MARK: - push到 主界面的情况
    func pushToHomeViewController(){
        if let vc = SJKeyWindow!.rootViewController as? UITabBarController{
            if vc.selectedIndex == 0{
                (vc.selectedViewController as! UINavigationController).popToRootViewController(animated: true)
            }else{
                (vc.selectedViewController as! UINavigationController).popToRootViewController(animated: false)
                vc.selectedIndex = 0
            }
        }
    }
}

