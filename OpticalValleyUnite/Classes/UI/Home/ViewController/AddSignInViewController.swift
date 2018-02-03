//
//  AddSignInViewController.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/1/13.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit
import SVProgressHUD

class AddSignInViewController: UIViewController {
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentTextView: SJTextView!
    @IBOutlet weak var addPhtonView: SJAddView!
    
    var parmat = [String: Any]()
    
    var address = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        addressLabel.text = address
        timeLabel.text = Date.dateStringDate(dateFormetString: "HH:mm")
    }


    
    @IBAction func doneBtnClick() {
        

        if contentTextView.text != "" {
            parmat["DESCRIPTION"] = contentTextView.text
        }
        parmat["SIGN_TYPE"] = 2
        
        let images = addPhtonView.photos.map{$0.image}
        if images.count > 0 {
            HttpClient.instance.upDataImages(images, complit: { (url) in
                self.parmat["PICTRUE"] = url
                HttpClient.instance.post(path: URLPath.sign, parameters: self.parmat, success: { (respose) in
                    
                    print("签到成功")
                    SVProgressHUD.showSuccess(withStatus: "签到成功")
                    if let count = UserDefaults.standard.object(forKey: Date().dataString(dateFormetStr: "yyyy-MM-dd")) as? Int{
                        UserDefaults.standard.set(count + 1, forKey: Date().dataString(dateFormetStr: "yyyy-MM-dd"))
                    }
                    
                    _ = self.navigationController?.popViewController(animated: true)
                    
                }) { (error) in
                    
                }
                
                
            })
            
            return
        }
        
        
        HttpClient.instance.post(path: URLPath.sign, parameters: parmat, success: { (respose) in
            
            print("签到成功")
            SVProgressHUD.showSuccess(withStatus: "签到成功")
            if let count = UserDefaults.standard.object(forKey: Date().dataString(dateFormetStr: "yyyy-MM-dd")) as? Int{
                UserDefaults.standard.set(count + 1, forKey: Date().dataString(dateFormetStr: "yyyy-MM-dd"))
            }
            _ = self.navigationController?.popViewController(animated: true)
            
        }) { (error) in
            
        }
        
    }


}
