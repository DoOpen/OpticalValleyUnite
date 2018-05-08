//
//  UpdataPSWViewController.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/1/25.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit
import SVProgressHUD

class UpdataPSWViewController: UIViewController {
    @IBOutlet weak var oragerPassWorldTextField: UITextField!
    @IBOutlet weak var newPasswordTextFeild: UITextField!
    @IBOutlet weak var newPasswordTextFeild2: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func sumbitBtnClick() {
        let oragerPassWorld = oragerPassWorldTextField.text
        let newPassword = newPasswordTextFeild.text
        let newPassword2 = newPasswordTextFeild2.text
        
        guard oragerPassWorld != "" ,newPassword == newPassword2 ,newPassword != "", newPassword2 != "" else {
            SVProgressHUD.showError(withStatus: "输入信息有误")
            return
        }
        
        let string1 = NSString.init(string: (oragerPassWorld?.md5())!)
        let string2 = NSString.init(string: (newPassword2?.md5())!)
        var paramet = [String: Any]()
        //修改密码,字符串要求全部转大写的情况!
        paramet["oldPassword"] = string1.uppercased
        paramet["newPassword"] = string2.uppercased
        
        SVProgressHUD.show()
        
        HttpClient.instance.post(path: URLPath.updatepwd, parameters: paramet, success: { (response) in
            
            SVProgressHUD.showSuccess(withStatus: "修改密码成功")
            self.navigationController?.popViewController(animated: true)
            
        }) { (error) in
            
            SVProgressHUD.showError(withStatus: error.description)
        }
        
    }
    @IBAction func cancelBtnClick() {
        _ = navigationController?.popViewController(animated: true)
    }

    @IBAction func passwordVisible(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.tag == 0{
            oragerPassWorldTextField.isSecureTextEntry = !sender.isSelected
        }else if sender.tag == 1{
            newPasswordTextFeild.isSecureTextEntry = !sender.isSelected
        }else{
            newPasswordTextFeild2.isSecureTextEntry = !sender.isSelected
        }
    }

}
