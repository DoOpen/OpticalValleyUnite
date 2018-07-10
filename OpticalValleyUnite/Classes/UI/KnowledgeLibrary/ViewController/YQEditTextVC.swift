//
//  YQEditTextVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/3/30.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQEditTextVC: UIViewController,UIWebViewDelegate {

    @IBOutlet weak var editWebView: UIWebView!
    
    var urlString = ""
    //培训材料id
    var id = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //init
        self.title = "详情"
        
        //在线的文档编辑的请求url的情况!
        let nowurl = URL(string: urlString)
        let request = URLRequest(url: nowurl!)
        
        self.editWebView.loadRequest(request)
    
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        //请求培训浏览的次数情况
        var par = [String : Any]()
        par["id"] = self.id
        
        HttpClient.instance.post(path: URLPath.getNewknowledgeCollect, parameters: par, success: { (response) in
            
            //print("统计成功!")
            
        }) { (error) in
            
        }
        
        
    }
    
    
    
   
}
