//
//  YQWebVideoVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/3/2.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit
import SVProgressHUD

class YQWebVideoVC: UIViewController {

    @IBOutlet weak var webVIEW: UIWebView!
    
    var equipHouseId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "查看视频"
        
    }
    
    
    // MARK: - 获取摄像头设备的id情况
    func getVideoIDForServer(){
    
        var par = [String : Any]()
        par["equipHouseId"] = self.equipHouseId
        
        SVProgressHUD.show()
        
        HttpClient.instance.post(path: URLPath.getHouseVideo, parameters: par, success: { (response) in
            
            SVProgressHUD.dismiss()
            
            let data = response as? String
            
            if data == nil {
            
                SVProgressHUD.showError(withStatus: "没有更多数据!")
                
                return
            
            }
            
            //接口请求调取相应的设备id
            let baseUrl = URLPath.basicVideoURLPath
            let tempUrl = "mobile/mobileVideo.html?equipmentIds="
            let url = baseUrl + tempUrl + data!
            
            let nowurl = URL(string: url)
            let request = URLRequest(url: nowurl!)
            self.webVIEW.allowsInlineMediaPlayback = true
            self.webVIEW.mediaPlaybackRequiresUserAction = false
            
            self.webVIEW.loadRequest(request)

        }) { (error) in
            
            SVProgressHUD.showError(withStatus: "视频数据加载失败,请检查网络!")
        }
    
    }
    


}
