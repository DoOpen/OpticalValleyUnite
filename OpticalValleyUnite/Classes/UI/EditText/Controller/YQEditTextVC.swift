//
//  YQEditTextVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/3/30.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQEditTextVC: UIViewController {

    
    @IBOutlet weak var editWebView: UIWebView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //在线的文档编辑的请求url的情况!
        let nowurl = URL(string: "")
        let request = URLRequest(url: nowurl!)
        
        self.editWebView.loadRequest(request)
    
    }

   
}
