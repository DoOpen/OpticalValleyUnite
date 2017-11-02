//
//  YQJournalAddEventViewController.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/10/16.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit
import SVProgressHUD

class YQJournalAddEventViewController: UIViewController {
    
    // MARK: - 属性列表
    @IBOutlet weak var addTextView: SJTextView!
    
    var text : String = ""
    var todoId : Int64 = -1
    
    // MARK: - 视图的生命周期方法
    override func viewDidLoad() {
        super.viewDidLoad()
        //1.设置默认的 占位字符
        self.addTextView.placeHolder = "添加事件详情"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if text != "" {
            
            self.addTextView.text = text
            self.addTextView.placeHolder = nil
        }
    }
    

    // MARK: - 编辑完成的按钮点击
    @IBAction func addEventComplete(_ sender: Any) {
        
        self.addTextView.endEditing(true)
        
        var parameter = [String : Any]()
        parameter["title"] = self.addTextView.text
        
        if self.todoId != -1{//让其有真正id
            parameter["todoId"] = self.todoId
        }
        
        SVProgressHUD.show(withStatus: "正在保存中...")
        //调用的编辑,新增和修改的待办事项的接口
        HttpClient.instance.post(path: URLPath.getTodoWorklogEdit, parameters: parameter, success: { (response) in
            SVProgressHUD.showSuccess(withStatus: "保存成功!")
            
            self.navigationController?.popViewController(animated: true)
            
            SVProgressHUD.dismiss()
            
        }) { (error) in
            
            SVProgressHUD.showError(withStatus: error.debugDescription)
            
        }
    }
    
    

}
