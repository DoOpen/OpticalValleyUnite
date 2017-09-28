//
//  ExecutingViewConttroller.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/2/22.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit
import SVProgressHUD
import RealmSwift

class ExecutingViewConttroller: UIViewController {

    @IBOutlet weak var workOrderContent: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var downView: UIView!
    var isToSee = false
    
    @IBOutlet weak var addPhoneView: SJAddView!
    
    //应急工单中备注内容testView
    @IBOutlet weak var textView: SJTextView!
    @IBOutlet weak var emergencyView: UIView!
    
    
    
    @IBOutlet weak var hideTableViewHeightConstraint: NSLayoutConstraint!
    
    var models = [ExecSectionModel]()
    
    var currentSelectIndexPath: IndexPath?
    var workOrderDetalModel: WorkOrderDetailModel?
    
    weak var ProgressVC: WorkOrderProgressViewController?
    
    var hisriyModel: WorkHistoryModel?
    
    @IBOutlet weak var saveBtn: UIButton!
    
    // 配件库的功能的组件
    // 使用配件
    @IBOutlet weak var doMessageV: UIView!
    @IBOutlet weak var doMessageViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var doMessageDetailV: UIView!
    // 其他事项
    @IBOutlet weak var otherView: UIView!
    
    @IBOutlet weak var otherDetailView: UIView!
    
    @IBOutlet weak var otherDetailViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var otherViewtop: NSLayoutConstraint!
    
    @IBOutlet weak var otherViewHeight: NSLayoutConstraint!
    // 计划工单的备注textView
    @IBOutlet weak var RemarksTextView: SJTextView!
    

    var url: String?
    var image: UIImage?
    
    //创建配件库数据数组
    var partData : NSArray = {return NSArray()}()
    
    
    // MARK: - 视图生命周期的方法
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "工单执行"
        //工单详情里面的数据,直接从workOrderDetalModel 中来进行获取的数据!
        workOrderContent.text = workOrderDetalModel?.content
        timeLabel.text = workOrderDetalModel?.time
        
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.tableFooterView = UIView()
              
        
        if isToSee{
            
            downView.isHidden = true
        }
        
        if workOrderDetalModel?.orderType == "计划工单"{ //计划工单,是有配件库的选择功能的
            emergencyView.isHidden = true
            getData()
           
            
        }else if workOrderDetalModel?.orderType == "应急工单"{//应急工单,里面没有配件的功能
            emergencyView.isHidden = false
            saveBtn.isHidden = true
            //隐藏应急工单 里面的 报事模块 内容
            reportFunctionHiden()
            
            if isToSee{
                emergencyView.isUserInteractionEnabled = false
            }
        }
        
        if let model = hisriyModel{
            //设置text中的默认输入选项
            textView.text = model.text
            
            if let str = model.pictures.first{
                
                _ = URL(string: str)
                
            }
        }
        
        RemarksTextView.placeHolder = "请输入备注内容"
        
        // 接受通知
        receiveNotes()
        
    }
    
    
    //MARK: -获取工单步骤信息
    func getData(){
        var parmat = [String: Any]()
        parmat["WORKUNIT_ID"] = workOrderDetalModel?.id
        parmat["GROUPID"] = workOrderDetalModel?.GROUPID
        parmat["TASKID"] = workOrderDetalModel?.TASKID
        SVProgressHUD.show(withStatus: "加载任务中")
        HttpClient.instance.get(path: URLPath.getTaskList, parameters: parmat, success: { (response) in
            SVProgressHUD.dismiss()
            
            var temp = [ExecSectionModel]()
            
//            for dic in (response as! Array<[String: Any]>){
                let dic = response["task"]
                let model = ExecSectionModel(parmart: dic as! [String : Any])
                model.workOrderId = (self.workOrderDetalModel?.id)!

                temp.append(model)
//            }
            if temp.count == 0{
                SVProgressHUD.showSuccess(withStatus: "没有待执行任务")
            }
            self.models = temp
            self.tableView.reloadData()
            
//            let realm = try! Realm()
//            try! realm.write {
//                realm.add(temp, update: true)
//            }
    
        }) { (error) in
//            let realm = try! Realm()
//            let result = realm.objects(ExecSectionModel.self).map({ model in
//                model as ExecSectionModel
//            })
//            
//            var tempArray = [ExecSectionModel]()
//            for model in result {
//                let model = model as ExecSectionModel
//                if model.workOrderId == self.workOrderDetalModel?.id{
//                    tempArray.append(model)
//                }
//                
//                
//                
//            }
//            self.models = tempArray
//            self.tableView.reloadData()
        }
    }
    
    // MARK: - 接受通知方法
    func receiveNotes(){
    
        let center = NotificationCenter.default//创建通知
        
        center.addObserver(self, selector: #selector(partsSelectionreceiveValue(info:)), name: NSNotification.Name(rawValue: "partsSelectionPassValue"), object: nil)//单个值得传递
    }
    
    // MARK: - 通知实现的方法
    func partsSelectionreceiveValue(info: NSNotification){
        //nav 的环境下通知,代理传递是没有问题的,在window的环境下不可以的
        let array = info.userInfo?["partData"] as! NSArray
//        print(array)
        //传递的模型数据
        self.partData = array
        
    
    }
    
    
    // MARK: - 保存成功更新了调用
    func saveUpdate(json: NSArray){
        
        //保存的参数和接口 应用的json格式来进行回传
        var parmat = [String: Any]()
//        parmat["WORKUNIT_ID"] = self.workOrderDetalModel?.id
//        parmat["UNIT_STATUS"] = 2

        parmat["WORKUNIT_ID"] = json[0]
        parmat["WORKTASK_ID"] = json[1]
        parmat["UNIT_STATUS"] = json[2]
        parmat["ID"] = json[3]
        parmat["DESCRIPTION"] = json[4]
        
        /*
         注意的是:这里的接口的变动的是 以前的是直接传递一个 data 的json 序列化的列表,现在是要求分开来传递,一共是5个参数
         
         */
        
        SVProgressHUD.show(withStatus: "上传中")
        //调用了 相应的接口workunitOpera
        HttpClient.instance.post(path: URLPath.workunitOpera, parameters: parmat, success: { (response) in
            SVProgressHUD.dismiss()
            SVProgressHUD.showSuccess(withStatus: "保存成功")
        }) { (error) in
            print(error)
        }
        
    }
    
    
    // MARK: - 保存按钮的点击的实现逻辑
    @IBAction func saveBtnClick() {
        
        //注意的是:这里通过异步的方式来进行的实现,模型嵌套模型来实现功能的
        let group = DispatchGroup()
        
        SVProgressHUD.show(withStatus: "上传中")
        
        for (index1,model) in models.enumerated(){
           
            for (index2,model2) in model.childs.enumerated(){
                
                if model2.type == "1"{
                    let cell = tableView.cellForRow(at: IndexPath(row: index2, section: index1)) as? ExecCell
                    
                    if cell == nil{
                        continue
                    }
                    
                    if cell!.addPhotoView.photos.count > 0 {
                        
                        let images = cell!.addPhotoView.photos.map{return $0.image}
                        
                        group.enter()
                        upDataImage(images, complit: { (url) in
                            
                            model2.value = url
                            group.leave()
                            
                        },errorHandle: {
                            
                            group.leave()
                        })
                    }
                }
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            
            print("complete!")
            //完成成功的时候,需要的添加那个配件库的功能json的功能
            
            SVProgressHUD.dismiss()
            
            var arry = Array<[String: Any]>()
            
            for model in self.models{
                
                model.workOrderId = (self.workOrderDetalModel?.id)!
                
                let taskDic = model.toDic()
                arry.append(taskDic)
                
            }
            
            do {
                //Convert to Data
                //let jsonData = try JSONSerialization.data(withJSONObject: arry, options: JSONSerialization.WritingOptions.prettyPrinted)
                
                //Do this for print data only otherwise skip
                //if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                    //print(JSONString)
                //}
                
                //改变数据的
                self.saveUpdate(json: arry as NSArray)
                
            } catch  {
                print("转换错误 ")
            }
        }
    }
    
    
    //MARK: - 上传图片的专门的接口
    func upDataImage(_ images: [UIImage], complit: @escaping ((String) -> ()),errorHandle: (() -> ())? = nil){
        SVProgressHUD.show(withStatus: "上传图片中...")
        HttpClient.instance.upLoadImages(images, succses: { (url) in
            SVProgressHUD.dismiss()
            complit(url!)
            
        }) { (error) in
            SVProgressHUD.dismiss()
            if let errorHandle = errorHandle{
                errorHandle()
            }
        }
    }
    

    
    //MARK: - 所有完成按钮点击( 数据要求的是 补全接口的相关 数据)
    @IBAction func doneBtnClick() {
        
        
        if workOrderDetalModel?.orderType == "计划工单"{ //计划工单
            var parmat = [String: Any]()
            parmat["WORKUNIT_ID"] = self.workOrderDetalModel?.id
            parmat["UNIT_STATUS"] = 7
            //设置添加配件库的模型数据进来
            
            self.alert(message: "整个工单已经完成?完成工单之前必须先点击保存按钮提交内容?") { (action) in
                
                //注意的是:这里都做好,提示添加保存完成
                //数据保存的接口调用
                self.upload(parmat)
            }
            
        }else if workOrderDetalModel?.orderType == "应急工单"{
            let images = addPhoneView.photos.map { (image) -> UIImage in
                return image.image
            }
            if images.count > 0 {
                upDataImage(images, complit: { (url) in
                    var parmat = [String: Any]()
                    parmat["WORKUNIT_ID"] = self.workOrderDetalModel?.id
                    parmat["UNIT_STATUS"] = 7
                    parmat["photo"] = url
                    parmat["SUCCESS_TEXT"] = self.textView.text
                    //设置添加配件库的模型数据进来

//                    self.alert(message: "整个工单已经完成?") { (action) in
                    
                        //数据保存的接口调用
                        self.upload(parmat)
//                    }
                })
            }else{
                
                var parmat = [String: Any]()
                parmat["WORKUNIT_ID"] = self.workOrderDetalModel?.id
                parmat["UNIT_STATUS"] = 2
                parmat["SUCCESS_TEXT"] = self.textView.text
                //设置添加配件库的模型数据进来

                
                self.alert(message: "整个工单已经完成?") { (action) in
                    
                    //数据保存的接口调用
                    self.upload(parmat)
                }
            }
        }
    }
    
    
    // MARK: - 工单执行调用数据保存的方法
    func upload(_ parate: [String: Any]){
        
        SVProgressHUD.show(withStatus: "上传中")
        ///工单点击, 完成之后的会调用这个接口,现在的是要求 通过接口文档来进行实现传参和调用的
        //需要修改的后台的接口内容
        HttpClient.instance.post(path: URLPath.workunitExecuSave2, parameters: parate, success: { (response) in
            
            SVProgressHUD.dismiss()
            SVProgressHUD.showSuccess(withStatus: "操作成功")
            self.ProgressVC?.reloadStatus(status: 7)
            _ = self.navigationController?.popViewController(animated: true)
            
        }) { (error) in
            
        }
        
    }
    
    
    // MARK: - 跳转到配件库
    @IBAction func pushPartsLibaryClick(_ sender: Any) {
        
        let vc = UIStoryboard(name: "YQPartsLibary", bundle: nil).instantiateInitialViewController()
        navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    
    // MARK: - 跳转到报事
    @IBAction func pushReportBtnClick(_ sender: Any) {
        
        let vc = UIStoryboard(name: "ReportMaster", bundle: nil).instantiateInitialViewController()
        navigationController?.pushViewController(vc!, animated: true)
        
        
    }
    
    // MARK: - 报事模块隐藏
    func reportFunctionHiden(){
        
        otherView.isHidden = true
        otherViewtop.constant = 0
        otherDetailView.isHidden = true
        otherDetailViewHeight.constant = 0
        otherViewHeight.constant = 0
        
        doMessageV.isHidden = true
        doMessageDetailV.isHidden = true
        doMessageViewHeight.constant = 0
        
        RemarksTextView.isHidden = true
        
    }
    
    
//    //MARK: - 子步骤完成按钮点击
//    func cellDoneBtnClick(model: ExecChild,image: UIImage?,text: String?){
//        
//
//            if let image = image{
//                self.upDataImage([image], complit: { (url) in
//                    self.url = url
////                    self.image = image
//                    self.cellDoneBtnClickRequeset(model, text!)
//                })
//            }else{
//                self.cellDoneBtnClickRequeset(model, text!)
//            }
//    }
    
    //MARK: - 控制器dealloc
    deinit{
        
        //移除通知监听
        NotificationCenter.default.removeObserver(self)
        
    }

    
    
    
//    func cellDoneBtnClick(model: ExecChild,isDone: Bool){
//        
//    
//        var parmat = [String: Any]()
//        parmat["WORKUNIT_ID"] = workOrderDetalModel?.id
//        parmat["WORKTASK_ID"] = model.taskId
//        parmat["NUM"] = currentSelectIndexPath!.row
//        
//       
//        parmat["VALUE"] = isDone
//    
//        HttpClient.instance.post(path: URLPath.workunitExec, parameters: parmat, success: { (response) in
//            
//            SVProgressHUD.showSuccess(withStatus: "执行成功")
//            let model = self.models[self.currentSelectIndexPath!.section].childs[self.currentSelectIndexPath!.row]
//            model.isDone = true
//            
//            self.tableView.reloadRows(at: [self.currentSelectIndexPath!], with: .none)
//            
//            
//        }) { (error) in
//            
//        }
//      
//    }
    
//    //子步骤完成请求接口
//    func cellDoneBtnClickRequeset(_ model: ExecChild,_ text: String){
//        var parmat = [String: Any]()
//        parmat["WORKUNIT_ID"] = workOrderDetalModel?.id
//        parmat["WORKTASK_ID"] = model.taskId
//        parmat["NUM"] = currentSelectIndexPath!.row
//        
//        if text != ""{
//            parmat["VALUE"] = text
//        }
//        
//        if let url = url {
//            parmat["FILEPATH"] = url
//            parmat["FILENAME"] = ""
//        }
//        SVProgressHUD.show(withStatus: "加载中")
//        HttpClient.instance.get(path: URLPath.workunitExec, parameters: parmat, success: { (response) in
//            SVProgressHUD.dismiss()
//            SVProgressHUD.showSuccess(withStatus: "执行成功")
//            let model = self.models[self.currentSelectIndexPath!.section].childs[self.currentSelectIndexPath!.row]
//            model.isDone = true
//            if let url = self.url {
//                model.value = url
//            }
//            if text != "" {
//                model.value = text
//            }
//            self.tableView.reloadRows(at: [self.currentSelectIndexPath!], with: .none)
//            
//        
//        }) { (error) in
//            SVProgressHUD.dismiss()
//        }
//    }
    
    
    
}

extension ExecutingViewConttroller: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let model = models[section]
        if model.isOpen{
            return model.childs.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let model = models[indexPath.section].childs[indexPath.row]
        
        if model.type == "3"{

            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectSell", for: indexPath) as! ExexSwithCell
            
            
            cell.model = model
            currentSelectIndexPath = indexPath
//            cell.doneBtnClickHandle = { [weak self] (isDone) in
//                self?.currentSelectIndexPath = indexPath
//                self?.cellDoneBtnClick(model: model, isDone: isDone)
//            }
            if isToSee{
                cell.isUserInteractionEnabled = false
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ExecCell
            
            
            cell.model = model
            currentSelectIndexPath = indexPath
            if isToSee{
                cell.isUserInteractionEnabled = false
            }
            return cell
        }
        

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = ExecutingSectionView.loadFromXib() as! ExecutingSectionView
        
        let model = models[section]
        
        view.titleLabel.text = "任务\(section + 1): " + model.name
        
        if model.isOpen{
            view.iconBtn.transform =  CGAffineTransform(rotationAngle: CGFloat.pi / 2 )
            view.openBtn.setTitle("收起", for: .normal)
            self.hideTableViewHeightConstraint.constant = 300
            
        }else{
            view.iconBtn.transform = .identity
            view.openBtn.setTitle("展开", for: .normal)
            self.hideTableViewHeightConstraint.constant = 80

            
        }
        view.didTouchHandle = { [weak self] in
//            let realm = try! Realm()
//            realm.beginWrite()
            model.isOpen = !model.isOpen
            self?.tableView.reloadData()
//            try! realm.commitWrite()
        }

        return view
    }
}
