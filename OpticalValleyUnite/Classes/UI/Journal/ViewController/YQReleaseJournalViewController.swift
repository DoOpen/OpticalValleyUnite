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
    
    @IBOutlet weak var projectLabel: UILabel!
    
    
    // 所有的工单ID
    var workunitIds : String = ""
    
    // 所有的待办事项ID
    var todoIds : String = ""
    
    //项目ID(这个是必填的 选项)
    var projectID : String  = ""
    
    //日志ID
    var worklogId : Int64 = -1
    
    //ifupdata
    var isupdata : Bool = true
    
    var selectIndex : IndexPath?
    
    @IBOutlet weak var selectWorkunitIds: UILabel!
    
    // MARK: - swift懒加载方法
    lazy var heightDic = {
        () -> NSMutableDictionary
        
        in
        
        return NSMutableDictionary()
        
    }()

    
    var dataList = [YQToDoListModel](){
        
        didSet{
            
            self.detailTableView.reloadData()
        }
    }
    
    // MARK: - 视图生命周期的方法
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //添加通知
        addNotes()
        
        //添加全局的项目选择的信息
        self.projectLabel.text = setUpProjectNameLable()
        
        if self.projectID == "" {
            
//            self.alert(message: "请先选择项目!", doneBlock: { (UIAlertAction) in
//                <#code#>
//            })
            
            let project = UIStoryboard.instantiateInitialViewController(name: "YQAllProjectSelect")
            navigationController?.pushViewController(project, animated: true)
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        //1.获取全局的项目
        self.projectLabel.text = setUpProjectNameLable()
        
        if isupdata{
        
            //获取待办事项的列表信息
            getTodoDataList()
            
            self.todoIds = self.getTodoIdsFunction()
            
        }
        
        self.selectWorkunitIds.text = self.workunitIds
        
        
        if self.selectWorkunitIds.text == "" {
            
            self.selectWorkunitIds.text = "未选"
            
        }else{
            
            self.selectWorkunitIds.text = "已选"
        
        }
        

    }
    
    // MARK: - 获取待办事项的listdata
    func getTodoDataList(){
        
        var paramet = [String : Any]()
        
        paramet["parkId"] = self.projectID
    
        SVProgressHUD.show(withStatus: "正在加载中...")
        
        HttpClient.instance.get(path: URLPath.getCheckWorklogDetail, parameters: paramet, success: { (response) in
            
            SVProgressHUD.dismiss()
            
            //获取数据,字典转模型
            var tempModel = [YQToDoListModel]()
            
            if let array = response["todoList"] as? NSArray{
                
                for temp in array {
                    
                    tempModel.append(YQToDoListModel.init(dic: temp as! [String : Any]))
                }
                
                self.dataList = tempModel
            }
            
            if let workunitIds = response["workunitIds"] as? String  {
                
                self.workunitIds = workunitIds
                self.selectWorkunitIds.text = "已选"
                
            }
            
            if let worklogid = response["worklogId"] as? Int64{
                
                self.worklogId =  worklogid
            }
            
        }) { (error) in
            
            self.alert(message: error.debugDescription)
            
        }
    }
    
    // MARK: - 全局项目选择tap点击,界面跳转
    @IBAction func allProjectSelectClick(_ sender: Any) {
        
        let project = UIStoryboard.instantiateInitialViewController(name: "YQAllProjectSelect")
        navigationController?.pushViewController(project, animated: true)
        
    }
    
    // MARK: - 工作记录View的点击,界面跳转
    @IBAction func tapClickWithWorkRecord(_ sender: Any) {
        
        //发布界面 没有workLogID传递的值
        let workRecord = UIStoryboard.instantiateInitialViewController(name: "YQWorkRecord") as? YQWorkRecordViewController
        
        workRecord?.isAddWorkLog = true
        workRecord?.parkID = self.projectID
        
        self.navigationController?.pushViewController(workRecord!, animated: true)
        
    }
    
    // MARK: - 工单完成情况实现
    @IBAction func workorderCompleteClick(_ sender: Any) {
        //直接的跳转到 工单的完成情况界面
        //发布界面 没有workLogID的值传递
        let workComplete = UIStoryboard.instantiateInitialViewController(name: "YQWorkOderComplete") as? YQWorkOrderCompleteVC
        
//        workComplete?.workLogID = "\(self.workIDid)"
        workComplete?.parkID = self.projectID
        
        self.navigationController?.pushViewController(workComplete!, animated: true)

    }
    
    // MARK: - 提交rightBarButtonClick
    @IBAction func submitButtonClick(_ sender: Any) {
        
        if self.projectID == ""{
            
            self.alert(message: "请选择项目!")
            
            return
        }
        
        //数据接口的请求
        /*调用日志新增的接口
         token
         workunitIds
         todoIds
         */
        
        self.todoIds = self.getTodoIdsFunction()
        
        var parameter = [String : Any]()
        
        //全部的id 的字段都是要求string 来进行拼接
        parameter["workunitIds"] = self.workunitIds
        
        parameter["todoIds"] = self.todoIds
        parameter["parkId"] = self.projectID
        
        if self.worklogId != -1{
            
            parameter["worklogId"] = self.worklogId
        }
        
        // || self.worklogId == -1
        if self.workunitIds == ""  {
            
            self.alert(message: "请选择工作记录")
            
            return
        }
        
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
    
        if  (dataList.count) < 1 {
            
            return ""
        }
        
        var str = ""
        
        for index in 0 ..< (dataList.count) {
            
            let model = dataList[index]
            if index == 0 {
                
                str = "\( model.todoId)"
                
            }else{
            
                str = str + "," + "\( model.todoId)"
            }
        }
        
        return str
    }
    
    
    // MARK: - 接受通知方法
    func addNotes(){
    
        let name = NSNotification.Name(rawValue: "workRecordToSuper")
        NotificationCenter.default.addObserver(self, selector: #selector(workRecordToWorkUNITID(notification:)), name: name, object: nil)
        
        let string = NSNotification.Name(rawValue: "YQAddEventdata")
        NotificationCenter.default.addObserver(self, selector: #selector(addEventForData(notification:)), name: string, object: nil)
        
        let string1 = NSNotification.Name(rawValue: "YQDelectEventdata")
         NotificationCenter.default.addObserver(self, selector: #selector(delectEventForData), name: string1, object: nil)
        
    }
    
    func workRecordToWorkUNITID(notification: Notification){
        
        let workUnit = notification.userInfo?["YQWorkRecordTo"] as? String
        
        self.isupdata = false
        
        self.workunitIds = workUnit!
//        self.selectWorkunitIds.text = self.workunitIds
        
    }
    
    func addEventForData(notification:Notification){
        
        isupdata = false
        
        let dataKey = notification.userInfo?["YQAddEventdataKey"] as? String
        let dataValue = notification.userInfo?["YQAddEventdataValue"] as? String
        var  dic = [String : Any]()
        dic["title"] = dataValue
        dic["todoId"] = Int64(dataKey!)

        let model = YQToDoListModel(dic: dic)
        
//        let workID = dataString?["YQAddEventdataKey"] as? String
//        model.todoId = workID.toInt()
//        
//        let workVlue = dataString?["YQAddEventdataValue"] as? String
//        model.title = workVlue
        
        if selectIndex != nil {
            
            self.dataList.replaceSubrange((selectIndex?.row)! ... (selectIndex?.row)!, with: [model])
            
            
        }else{
            
            self.dataList.insert(model, at: self.dataList.count)
            
        }
    
    }
    
    
    func delectEventForData(){
        
        self.dataList.remove(at: (selectIndex?.row)!)
    }
    
    // MARK: - 添加默认的项目选择方法
    func setUpProjectNameLable() -> String{
        
        let dic = UserDefaults.standard.object(forKey: Const.YQProjectModel) as? [String : Any]
        
        var projectName  = ""
        
        if dic != nil {
            
            projectName = dic?["PARK_NAME"] as! String
            
            if self.projectLabel.text != projectName {
                
                self.workunitIds = ""
                self.selectWorkunitIds.text = ""
                self.worklogId = -1
            }
            
            self.projectID = dic?["ID"] as! String
            
            
        }else{
            
            projectName = "请选择默认项目"
        }
        
        return projectName
        
    }

    
    // MARK: - dealloc方法
    deinit {
        
        NotificationCenter.default.removeObserver(self)
        
    }
    

}

extension YQReleaseJournalViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataList.count 
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
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? YQReleaseDetailTableViewCell
        
        if cell == nil {
            
            cell = YQReleaseDetailTableViewCell()
        }
        
        let model = self.dataList[indexPath.row]
        
        cell?.detailLabel?.text = "\(indexPath.row + 1)." + (model.title)!
        
        //cell的更新
        cell?.layoutIfNeeded()
        
        self.heightDic["\(indexPath.row)"] = cell?.cellForHeight()
        
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 200
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let  height = self.heightDic["\(indexPath.row)"] as! CGFloat
        
        return height
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        isupdata = true
        self.selectIndex = indexPath
        
        if let model = self.dataList[indexPath.row] as? YQToDoListModel{
            
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
        
        selectIndex = nil
        
        //跳转到添加 详情的界面
        let addDetailVC = UIStoryboard.instantiateInitialViewController(name: "YQJournalAddEvent")
        
        self.navigationController?.pushViewController(addDetailVC, animated: true)
        
    }

}

