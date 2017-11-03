//
//  YQReleaseJournalViewController.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/10/13.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit
import SVProgressHUD

class YQReleaseJournalViewController: UIViewController {
    
    // MARK: - 属性加载情况
    @IBOutlet weak var detailTableView: UITableView!
    
    // 所有的工单ID
    var workunitIds : String = ""
    // 所有的日志ID
    var todoIds : String = ""
    
    
    var dataList : [YQToDoListModel]?{
        
        didSet{
            
            self.detailTableView.reloadData()
        }
    }
    
    // MARK: - 视图生命周期的方法
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //添加通知
        addNotes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //获取待办事项的列表信息
        getTodoDataList()
    }
    
    // MARK: - 获取待办事项的listdata
    func getTodoDataList(){
        
        let paramet = [String : Any]()
        
        SVProgressHUD.show(withStatus: "正在加载中...")
        HttpClient.instance.get(path: URLPath.getTodoWorklogList, parameters: paramet, success: { (respose) in
            
            SVProgressHUD.dismiss()
            //获取数据,字典转模型
            var tempModel = [YQToDoListModel]()
            
            if let array = respose["todoList"] as? NSArray{
                
                for temp in array {
                    
                    tempModel.append(YQToDoListModel.init(dic: temp as! [String : Any]))
                }
                
                self.dataList = tempModel
            }
            
        }) { (error) in
            
            self.alert(message: error.debugDescription)
        }
    }
    
    // MARK: - 工作记录View的点击,界面跳转
    @IBAction func tapClickWithWorkRecord(_ sender: Any) {
        
        //发布界面 没有workLogID传递的值
        let workRecord = UIStoryboard.instantiateInitialViewController(name: "YQWorkRecord")
        
        self.navigationController?.pushViewController(workRecord, animated: true)
        
    }
    
    // MARK: - 工单完成情况实现
    @IBAction func workorderCompleteClick(_ sender: Any) {
        //直接的跳转到 工单的完成情况界面
        //发布界面 没有workLogID的值传递
        let workComplete = UIStoryboard.instantiateInitialViewController(name: "YQWorkOderComplete")
        
        self.navigationController?.pushViewController(workComplete, animated: true)

    }
    
    // MARK: - 提交rightBarButtonClick
    @IBAction func submitButtonClick(_ sender: Any) {
        
        //数据接口的请求
        /*调用日志新增的接口
         token
         workunitIds
         todoIds
         */
        var parameter = [String : Any]()
        
        //全部的id 的字段都是要求string 来进行拼接
        parameter["workunitIds"] = self.workunitIds
        parameter["todoIds"] = self.getTodoIdsFunction()
        
//        if self.workunitIds == ""{
//            
//            self.alert(message: "请选择工单!")
//            return
//        }
        
        SVProgressHUD.show(withStatus: "提交中...")
        
        HttpClient.instance.post(path: URLPath.getAddWorklog, parameters: parameter, success: { (response) in
            
            SVProgressHUD.showSuccess(withStatus: "提交成功!")
            //界面跳转
            self.dismiss(animated: true, completion: {
                
                SVProgressHUD.dismiss()
            })
            
        }) { (error) in
            
           self.alert(message: error.debugDescription)
        }
        
    }
    
    // MARK: - 返回按钮leftBarButtonClick
    @IBAction func returnButtonClick(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - 获取待办事项的ID
    func getTodoIdsFunction() -> String {
    
        if (dataList?.count)! < 1 {
            return ""
        }
        
        var str = ""
        
        for index in 0 ..< (dataList?.count)! {
            
            let model = dataList?[index]
            if index == 0 {
                
                str = "\( model!.todoId)"
                
            }else{
            
                str = str + "," + "\( model!.todoId)"
            }
        }
        
        return str
    }
    
    // MARK: - 接受通知方法
    func addNotes(){
    
        let name = NSNotification.Name(rawValue: "workRecordToSuper")
        NotificationCenter.default.addObserver(self, selector: #selector(workRecordToWorkUNITID(notification:)), name: name, object: nil)
    
    }
    
    func workRecordToWorkUNITID(notification: Notification){
        
        let workUnit = notification.userInfo?["YQWorkRecordTo"] as? String
        
        self.workunitIds = workUnit!
        
    }
    
    // MARK: - dealloc方法
    deinit {
        
        NotificationCenter.default.removeObserver(self)
        
    }
    

}

extension YQReleaseJournalViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 50
    
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = Bundle.main.loadNibNamed("YQJournalDetailHead", owner: nil, options: nil)?[0] as? YQJournalDetailHeadView
        
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footer = Bundle.main.loadNibNamed("YQReseaseJournalFooter", owner: nil, options: nil)?[0] as? YQReleaseJournalFooterV
        footer?.deletage = self as YQReseaseJouranlFooterDeletage
        
        return footer
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        let model = self.dataList?[indexPath.row]
        
        cell.textLabel?.text = "\(indexPath.row + 1)." + (model?.title)!
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let model = self.dataList?[indexPath.row]{
            
            //跳转到添加 详情的界面
            let addDetailVC = UIStoryboard.instantiateInitialViewController(name: "YQJournalAddEvent") as! YQJournalAddEventViewController
            addDetailVC.todoId = model.todoId
            addDetailVC.text = model.title!
            
            self.navigationController?.pushViewController(addDetailVC, animated: true)

        }
        
    }
}


extension YQReleaseJournalViewController : YQReseaseJouranlFooterDeletage{
    
    func reseaseJouranlFooterButtonClick(releaseJournal: YQReleaseJournalFooterV) {
        //跳转到添加 详情的界面
        let addDetailVC = UIStoryboard.instantiateInitialViewController(name: "YQJournalAddEvent")
        
        self.navigationController?.pushViewController(addDetailVC, animated: true)
        
    }

}

