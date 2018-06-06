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
    
    @IBOutlet weak var deleteEvent: UIButton!
    
    
    var text : String = ""
    var todoId : Int64 = -1
    
    // MARK: - 视图的生命周期方法
    override func viewDidLoad() {
        super.viewDidLoad()
        //1.设置默认的 占位字符
        self.addTextView.placeHolder = "添加事件详情"
        
        //2.显示隐藏删除按钮
        if todoId == -1 {
            
            self.deleteEvent.isHidden = true
            
        }else {
            
            self.deleteEvent.isHidden = false
        }
        
        
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
            
            parameter["todoId"] = self.todoId //修改界面
        }
        
        SVProgressHUD.show(withStatus: "正在保存中...")
        //调用的编辑,新增和修改的待办事项的接口
        HttpClient.instance.post(path: URLPath.getTodoWorklogEdit, parameters: parameter, success: { (response) in
            
            SVProgressHUD.showSuccess(withStatus: "保存成功!")
        
            let addTodoID = response["todoId"] as? Int64 ?? -1
            
            
                
            //传递添加事项的内容
            let string = NSNotification.Name(rawValue: "YQAddEventdata")
            
            NotificationCenter.default.post(name: string, object: nil, userInfo: ["YQAddEventdataKey" : "\( addTodoID)","YQAddEventdataValue" : self.addTextView.text])
            
            
            SVProgressHUD.dismiss()
            
            self.navigationController?.popViewController(animated: true)
            
        }) { (error) in
            
            SVProgressHUD.showError(withStatus: "数据加载失败,请检查网络!")
            
        }
    }
    
    @IBAction func deleteEventButtonClick(_ sender: Any) {
        
        if todoId == -1 {
            return
        }
        self.deleteEvent.isUserInteractionEnabled = false
        
        //调用接口,popVC
        var par = [String : Any]()
        par["todoId"] = todoId
        
        HttpClient.instance.get(path: URLPath.getTodoWorklogDelete, parameters: par, success: { (response) in
            
            SVProgressHUD.showSuccess(withStatus: "删除成功!")
            let string = NSNotification.Name(rawValue: "YQDelectEventdata")
            NotificationCenter.default.post(name: string, object: nil)
            
            self.navigationController?.popViewController(animated: true)
            
             self.deleteEvent.isUserInteractionEnabled = false
            
        }) { (error) in
            
            SVProgressHUD.showError(withStatus: "删除失败!")
            self.deleteEvent.isUserInteractionEnabled = true
        }
        
        
    }
    
    
    

}
