//
//  YQShareViewController.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/3/30.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQShareViewController: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.title = "分享"
        
        setupRightAndLeftBarItem()
    }

    
    // MARK: - 自定义的right_left barItem
    func setupRightAndLeftBarItem(){
        
        let right_add_Button = UIButton()
        
        right_add_Button.frame = CGRect(x : 0, y : 0, width : 40, height : 40)
        right_add_Button.setImage(UIImage(named: "分享"), for: .normal)
        right_add_Button.setTitle("分享", for: .normal)
        right_add_Button.addTarget(self, action: #selector(addRightBarItemButtonClick), for: .touchUpInside)
        
        let  right2Bar = UIBarButtonItem()
        right2Bar.customView = right_add_Button
        
        self.navigationItem.rightBarButtonItems = [right2Bar]
        
    }
    
    //MARK: - leftBarItemButtonClick方法
    func addRightBarItemButtonClick(){

        UMShareSwiftInterface.showShareMenuViewInWindowWithPlatformSelectionBlock { (platformType : UMSocialPlatformType, nil) in
            
            self.shareWebPageToPlatformType(platformType: platformType)
        }
    }

    //MARK: - 友盟分享内容视图方法
    func shareWebPageToPlatformType(platformType : UMSocialPlatformType){
    
        //封装UM的消息体的情况
        let messageObject = UMSocialMessageObject()
        let thumbURL = "https://mobile.umeng.com/images/pic/home/social/img-1.png"
        let shareObject = UMShareWebpageObject.shareObject(withTitle: "欢迎使用【友盟+】社会化组件U-Share", descr: "欢迎使用【友盟+】社会化组件U-Share，SDK包最小，集成成本最低，助力您的产品开发、运营与推广！", thumImage: thumbURL)
        shareObject?.webpageUrl = "http://mobile.umeng.com/social"
        
        messageObject.shareObject = shareObject
        
        UMShareSwiftInterface.share(plattype: platformType, messageObject: messageObject, viewController: self) { (data, error) in
            
            if ((error) != nil) {
                
//                UMSocialLog("************Share fail with error %@*********")
                
            }else{
                
                if ((data) != nil) {
                    
//                    let resp = data as! UMSocialShareResponse;
                    //分享结果消息
//                    UMSocialLogInfo("response message is %@",resp.message);
                    //第三方原始返回的数据
//                    UMSocialLogInfo("response originalResponse data is %@",resp.originalResponse);
                    
                }else{
                    
//                    UMSocialLogInfo("response data is %@",data);
                }
            }
        }
    }

}
