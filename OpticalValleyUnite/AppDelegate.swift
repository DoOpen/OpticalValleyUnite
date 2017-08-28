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
        
        UMessage.start(withAppkey: Const.SJUMPushKey, launchOptions: launchOptions)
        UMessage.registerForRemoteNotifications()
        UMessage.setBadgeClear(false)

        
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            //let types =
            center.requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { granted,error in
                
                
            })
            
            
        } else {
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        }
        
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

            
            noticHandel(userInfo: userInfo)
            
            UMessage.didReceiveRemoteNotification(userInfo)
        }else{
            //应用处于后台时的本地推送接受
        }
        
        
    }
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

extension AppDelegate{
    
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
    
    func pushToWorkOrderViewController(_ workId: String){
        
        let vc = WorkOrderProgressViewController.loadFromStoryboard(name: "WorkOrder") as! WorkOrderProgressViewController
        var parmat = [String: Any]()
        parmat["WORKUNIT_ID"] = workId
        vc.parmate = parmat
        getNavController()?.pushViewController(vc, animated: true)
    }
    
    func pushToDubanViewController(_ workId: String){

        let vc = WorkOrderProgressViewController.loadFromStoryboard(name: "WorkOrder") as! WorkOrderProgressViewController
        var parmat = [String: Any]()
        parmat["WORKUNIT_ID"] = workId
        vc.parmate = parmat
        vc.workType = 1
        vc.hasDuban = 0
        getNavController()?.pushViewController(vc, animated: true)
    }
    
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

