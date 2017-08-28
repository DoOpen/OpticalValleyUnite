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
        
        var paramet = [String: Any]()
        paramet["OLD_PASSWORD"] = oragerPassWorld?.md5()
        paramet["NEW_PASSWORD"] = newPassword2?.md5()
        
        HttpClient.instance.post(path: URLPath.updatepwd, parameters: paramet, success: { (response) in
            SVProgressHUD.showSuccess(withStatus: "修改密码成功")
        }) { (error) in
            
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
