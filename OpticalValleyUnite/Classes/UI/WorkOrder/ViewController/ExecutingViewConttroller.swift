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
import AVFoundation
import Photos

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
    var savefalse = true
    
    
    //创建配件库数据数组
    var partData : NSArray = {return NSArray()}()
    
    //设置scrollcontent属性
    @IBOutlet weak var scrollContent: NSLayoutConstraint!
    
    //photo的图片缓存数组
    lazy var photoArray : NSMutableDictionary = {
    
        return NSMutableDictionary()
        
    }()
    
    //行高的缓存数组
    lazy var cellHightArray: NSMutableDictionary = {
    
        return NSMutableDictionary()
        
    }()

    
    // MARK: - 视图生命周期的方法
    override func viewDidLoad() {
        
        super.viewDidLoad()

        title = "工单执行"
        //工单详情里面的数据,直接从workOrderDetalModel 中来进行获取的数据!
        workOrderContent.text = workOrderDetalModel?.content
        timeLabel.text = workOrderDetalModel?.time
        
//        tableView.estimatedRowHeight = 100.0
//        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.scrollContent.constant = self.view.bounds.height + 100
        
        RemarksTextView.placeHolder = "请输入备注内容"
        textView.placeHolder = "请输入备注内容"
        
        if isToSee{
            
            downView.isHidden = true
        }
        
        if workOrderDetalModel?.orderType == "计划工单"{ //计划工单,是有配件库的选择功能的
            emergencyView.isHidden = true
//            self.textView.isHidden = true
            
            getData()
            
            //只有的是 电梯报事中才又配件库的选择功能
            hiddenReportFromWorkOrder()
            
        }else if workOrderDetalModel?.orderType == "应急工单"{//应急工单,里面没有配件的功能
            emergencyView.isHidden = false
            saveBtn.isHidden = true
//            self.RemarksTextView.isHidden = true
            
            //隐藏应急工单 里面的 报事模块 内容,区分计划工单和应急工单的区别
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
            
            let text = response["remark"] as? String
        
            
            DispatchQueue.main.async {
                
                if text != nil {
                
                    self.RemarksTextView.placeHolder = ""
                    self.textView.placeHolder = ""
                
                }
                self.RemarksTextView.text = text
                self.textView.text = text
                
            }
            
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
        let array = info.userInfo?["partData"] as? NSArray
        if array == nil {
            return
        }
//        print(array)
        //传递的模型数据
        self.partData = array!
        
    }
    
    
    // MARK: - 保存成功更新了调用
    func saveUpdate(json: NSArray){
        
        //保存的参数和接口 应用的json格式来进行回传
        var parmat = [String: Any]()
        
        //调整接口的数据的类型,上传数据类型调整
        let json0 = json[0] as! [String : Any]
        
        parmat["WORKUNIT_ID"] = json0["WORKUNIT_ID"]
        parmat["WORKTASK_ID"] = json0["WORKTASK_ID"]
        parmat["UNIT_STATUS"] = json0["UNIT_STATUS"]
        parmat["ID"] = json0["ID"]
        parmat["DESCRIPTION"] = json0["DESCRIPTION"]
        parmat["SUCCESS_TEXT"] = self.RemarksTextView.text
        
        //实现的思路是: 如果是有配件库的情况下,保存上传配件库的操作! 直接是模型的数组!
        if self.partData.count > 1{
        
            for(indexxxxx, partModel)in self.partData.enumerated(){
                
                let tempModel = partModel as! PartsModel
                
                parmat["partsList[" + "\(indexxxxx)" + "].partsId"] = tempModel.partsId
            
                parmat["partsList[" + "\(indexxxxx)" + "].amount"] = tempModel.partNum
            }
        
        
        }
        
        
        /*
         注意的是:这里的接口的变动的是 以前的是直接传递一个 data 的json 序列化的列表,现在是要求分开来传递,一共是5个参数
         */
        
        SVProgressHUD.show(withStatus: "上传中")
        
        //调用了 相应的接口workunitOpera
        HttpClient.instance.post(path: URLPath.workunitOpera, parameters: parmat, success: { (response) in
            
            SVProgressHUD.dismiss()
            SVProgressHUD.showSuccess(withStatus: "保存成功")
            DispatchQueue.main.async {
                
                self.saveBtn.isSelected = false
                self.saveBtn.isUserInteractionEnabled = true
                
                self.tableView.reloadData()
                //查看模型的转变的情况!
                
        
            }

        }) { (error) in
            
            print(error)
        }
        
    }
    
    
    // MARK: - 保存按钮的点击的实现逻辑
    @IBAction func saveBtnClick() {
        
        /*重新梳理逻辑: 
         应用线程加锁的 等待的情况来实现先下载,然后上传图片
         1.先放到 同步的下载
         2.拿到字面量,异步上传
         
         */
        
        //注意的是:这里通过异步的方式来进行的实现,模型嵌套模型来实现功能的
//        let group = DispatchGroup()
//        
//        let dequeue = DispatchQueue.init(label: "grounpQueue")
//        
        SVProgressHUD.show(withStatus: "上传中")
        
        saveBtn.isSelected = true
        saveBtn.isUserInteractionEnabled = false
        
//        group.enter()
        
//        dequeue.async(group: group, qos: .default, flags: [], execute: {
//            
//            for (index1,model) in self.models.enumerated(){
//                
//                for (index2,model2) in model.childs.enumerated(){
//                    
//                    if model2.type == "1"{//图片list选项
//                        
//                        // 保存上传当前的图片 cell里面的图片情况
//                        let cell = self.tableView.cellForRow(at: IndexPath(row: index2, section: index1)) as? YQExecNewCell
//                        
//                        if cell == nil{
//                            continue
//                        }
//                        
//                        
//                        //保存上传图片显示
//                        if let url = cell?.model?.imageValue,url != "" {
//                            
//                            //实现的思路,要求拿到的是一个image数组来进行的上传
//                            var imageArray = [UIImage]()
//                            //                        imageArray.append(<#T##newElement: UIImage##UIImage#>)
//                            let stringArray = url.components(separatedBy: ",")
//                            
//                            for string in stringArray {
//                                
//                                if string.contains("缓存相册图片") {
//                                    
////                                    let image = UIImage(contentsOfFile: string)
//                                    let image = self.photoArray[string] as? UIImage
//                                    
//                                    imageArray.append(image!)
//                                    
//                                }else{
//                                    
//                                    var newString = ""
//                                    if string.contains("http"){
//                                        
//                                        newString = string
//                                        
//                                    }else{
//                                        
//                                        let basicPath = URLPath.basicPath
//                                        newString = basicPath.replacingOccurrences(of: "/api/", with: "") + string
//                                    }
//                                    
//                                    
////                                    let data = NSData.init(contentsOf: URL.init(string: newString)!)
//                                    let image2 = self.photoArray[newString] as? UIImage
//                                    
//                                    if image2 == nil {
//                                        
//                                        SVProgressHUD.showError(withStatus: "网络不给力,上传图片失败!")
////                                        group.leave()
//                                        continue
//                                    }
//                                    
//                                    
////                                    let image2 = UIImage.init(data: data! as Data)
//                                    imageArray.append(image2!)
////                                    group.leave()
//                                    
//                                }
//                                
//                            }
//                            
//                            
//                            group.enter()
//                            
//                            self.upDataImage(imageArray, complit: { (url) in
//                                
//                                model2.imageValue = ""
//                                
//                                if model2.imageValue != "" {
//                                    
//                                    model2.imageValue =  model2.imageValue + "," + url
//                                    
//                                }else{
//                                    
//                                    model2.imageValue = url
//                                }
//                                
//                                group.leave()
//                                
//                                
//                            },errorHandle: {
//                                
//                                
//                                self.savefalse = false
//                                group.leave()
//                                
//                            })
//                        }
//                    }
//                }
//            }
//            
//         })
        
//        group.notify(queue: DispatchQueue.main) {
//        
//            if !self.savefalse {
//            
//                SVProgressHUD.showError(withStatus: "请检查网络,保存失败!")
//                
//                SVProgressHUD.dismiss()
//                
//                return
//            }
        
            //完成成功的时候,需要的添加那个配件库的功能json的功能
//            SVProgressHUD.dismiss()
        
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
                
            } catch {
                
                print("转换错误 ")
            }
        
//        }
        
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
            parmat["SUCCESS_TEXT"] = self.RemarksTextView.text
            
            //设置添加配件库的模型数据进来
            
            self.alert(message: "整个工单已经完成?完成工单之前必须先点击保存按钮提交内容?") { (action) in
                
                //注意的是:这里都做好,提示添加保存完成
                //数据保存的接口调用
                self.upload(parmat)
            }
            
        }else if workOrderDetalModel?.orderType == "应急工单"{//应急工单的保存,保存实现原理不同
            
            let images = addPhoneView.photos.map { (image) -> UIImage in
                
                return image.image
            }
            
            if images.count > 0 {
                
                upDataImage(images, complit: { (url) in
                    
                    //保存的数据的接口的重调!
                    var parmat = [String: Any]()
                    parmat["WORKUNIT_ID"] = self.workOrderDetalModel?.id
                    parmat["UNIT_STATUS"] = 7
                    parmat["photo"] = url
                    parmat["SUCCESS_TEXT"] = self.textView.text
                    
                    //设置添加配件库的模型数据进来

//                    self.alert(message: "整个工单已经完成?") { (action) in
                    
                    //接着是调用了数据保存的接口
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
            
            DispatchQueue.main.async {
                
                self.saveBtn.isSelected = false
                self.saveBtn.isUserInteractionEnabled = true

            }
            
            self.ProgressVC?.reloadStatus(status: 7)
            
            self.navigationController?.popViewController(animated: true)
            
        }) { (error) in
            
        }
        
    }
    
    
    // MARK: - 跳转到配件库
    @IBAction func pushPartsLibaryClick(_ sender: Any) {
        
        let vc = UIStoryboard(name: "YQPartsLibary", bundle: nil).instantiateInitialViewController() as! YQPartsLibaryViewController
        if self.partData.count != 0 {
            
            vc.selectData = self.partData as? [PartsModel]
            
        }
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    // MARK: - 跳转到报事
    @IBAction func pushReportBtnClick(_ sender: Any) {
        
        let vc = UIStoryboard(name: "ReportMaster", bundle: nil).instantiateInitialViewController()
        navigationController?.pushViewController(vc!, animated: true)
        
        
    }
    
    // MARK: - 报事模块隐藏(计划工单和 应急工单的区别)
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
    
    // MARK: - hidden计划工单中的(电梯报事和普通报事)
    func hiddenReportFromWorkOrder(){
        let reportName = UserDefaults.standard.object(forKey: Const.YQReportName) as? String
        if reportName == "报事" {
            //隐藏配件的功能
            doMessageViewHeight.constant = 0
            doMessageV.isHidden = true
            doMessageDetailV.isHidden = true
            
            otherViewtop.constant = 0
        }
        
    
    }
    
    
    // MARK: - 二维码执行扫描界面
    func scanBtnClick() {
        
        if Const.SJIsSIMULATOR {
            alert(message: "模拟器不能使用扫描")
            return
        }
        
        let device = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
        if device != nil {
            
            
            let status = PHPhotoLibrary.authorizationStatus()
            if status == .authorized{
                let vc = SGScanningQRCodeVC()
                //设置代理
                vc.delegate = self
                navigationController?.pushViewController(vc, animated: true)
            }else if status == .notDetermined{
                PHPhotoLibrary.requestAuthorization({ (authorizationStatus) in
                    
                })
            }else{
                self.alert(message: "授权失败")
            }
        }
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
        
        //清空沙盒缓存
        
        
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
        
        if model.type == "3"{//选择事项 cell
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectSell", for: indexPath) as! ExexSwithCell
            
            cell.model = model
//            currentSelectIndexPath = indexPath
            
//            cell.doneBtnClickHandle = { [weak self] (isDone) in
//                self?.currentSelectIndexPath = indexPath
//                self?.cellDoneBtnClick(model: model, isDone: isDone)
//            }
            
            if isToSee{
                
                cell.isUserInteractionEnabled = false
            }
            
            return cell
            
        }else if model.type == "2" {//文本 编辑cell
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "ExecTextCell") as? YQExecTextCell
            if cell == nil {
                
                cell = Bundle.main.loadNibNamed("YQExecTextCell", owner: nil, options: nil)?[0] as? YQExecTextCell
            }
            //
            cell?.delegate = self as YQExecTextCellDelegate
            cell?.indexpath = indexPath
            
            
            cell?.model =  model
            
            return cell!
        
        } else if model.type == "1" {//图片
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "ExecNewCell") as? YQExecNewCell
            
            if cell == nil {
                
                cell = Bundle.main.loadNibNamed("YQExecNew", owner: nil, options: nil)?[0] as? YQExecNewCell
            }
            cell?.delegate = self
            
            //添加图片缓存数组
            cell?.currentIndex = indexPath
            
            cell?.model = model
//            currentSelectIndexPath = indexPath
            
            cell?.layoutIfNeeded()
            
            //缓存 行高
            //要求的定义的是 一个可变的字典的类型的来赋值
            cellHightArray["\(indexPath.row)"] = cell?.cellForHeight()

            if isToSee{
                
                cell?.isUserInteractionEnabled = false
            }
            
            return cell!
            
        }else  { //扫描,扫码的界面cell  <else if model.type == "x">
        
            var cell = tableView.dequeueReusableCell(withIdentifier: "scanCell") as? YQExecScanCell
            
            if cell == nil {
                
                cell = Bundle.main.loadNibNamed("YQExecScanCell", owner: nil, options: nil)?[0] as? YQExecScanCell
            }
            
            cell?.delegate = self
            cell?.indexPath = indexPath.row
    
            return cell!
        }
        
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 64
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        _ =  self.cellHightArray["\(indexPath.row)"] as? CGFloat
        return 100
        
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = ExecutingSectionView.loadFromXib() as! ExecutingSectionView
        
        let model = models[section]
        
        view.titleLabel.text = "任务\(section + 1): " + model.name
        
        if model.isOpen{
            
            view.iconBtn.transform =  CGAffineTransform(rotationAngle: CGFloat.pi / 2 )
            view.openBtn.setTitle("收起", for: .normal)
            self.hideTableViewHeightConstraint.constant = 450
            self.scrollContent.constant = self.view.bounds.height + 350
            
        }else{
            
            view.iconBtn.transform = .identity
            view.openBtn.setTitle("展开", for: .normal)
            self.hideTableViewHeightConstraint.constant = 80
            
            self.scrollContent.constant = self.view.bounds.height + 100
        }
        
//        self.view.setNeedsDisplay()
        
        
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

extension ExecutingViewConttroller : YQExecNewCellClickDelegate{
    
    func ExecNewCellSetSuperDict(view: YQExecNewCell, dict: NSMutableDictionary) {
        
        self.photoArray =  dict
        
    }
    
    func ExecNewCellMakePhotoFunction(view: YQExecNewCell, currentRow: IndexPath,image : UIImage) {
        
        let model = models[(currentRow.section)].childs[currentRow.row]
        
        let imageArray = [image]
        
        self.upDataImage(imageArray, complit: { (url) in
            
            DispatchQueue.main.async {
                
                if model.imageValue == "" {
                    //传递image 刷新列表
                    model.imageValue =  url
                    
                }else{
                    //传递image 刷新列表
                    model.imageValue = model.imageValue + "," + url
                    
                }
                
                //重新的逻辑替换
                self.models[(currentRow.section)].childs.replace(index: currentRow.row, object: model)
                
                //单行刷新列表
                self.tableView.reloadRows(at: [currentRow], with: .automatic)

            }
            
            
        },errorHandle: {
            SVProgressHUD.showError(withStatus: "网络超时,请重试!")
        })

    }
    
    
    func ExecNewCellDeleteSuperModelFunction(view: YQExecNewCell, currentRow: IndexPath, buttonTag: Int) {
        
        //移除相应的模型数据, tableView的单行数据刷新
        let model = models[(currentRow.section)].childs[currentRow.row]
        
        var tempArray =  model.imageValue.components(separatedBy: ",")
        
        //补充逻辑
        if buttonTag >= tempArray.count {
            
//            if model.imageArray.count <= 0 {
//                
//                return
//                
//            }else{
//                //移除本地图片
////                model.imageArray.removeObject(at: buttonTag - tempArray.count)
//            }
        
        }else{
            //移除网络图片
            tempArray.remove(at: buttonTag)
            
            var newimageValue = ""
            
            for temp in 0..<tempArray.count {
                
                if temp == 0 {
                    
                    newimageValue = tempArray[temp]
                    
                }else{
                    
                    newimageValue = newimageValue + "," + tempArray[temp]
                }
            }
            
            model.imageValue = newimageValue
        
        }
        
        //重新的逻辑替换
        models[(currentRow.section)].childs.replace(index: currentRow.row, object: model)
        
        //单行刷新列表
        self.tableView.reloadRows(at: [currentRow], with: .automatic)
        
    }
    
}


extension ExecutingViewConttroller : YQExecTextCellDelegate{

    func ExecTextCellEndTextEidtingDelegate(ExecTextCell: UITableViewCell, textString: String, indexPath: IndexPath) {
        //传递重改模型,刷新当前的cell
        let model = models[(indexPath.section)].childs[indexPath.row]
        
        model.value = textString
        
        //重新的逻辑替换
        models[(indexPath.section)].childs.replace(index: indexPath.row, object: model)
        
        //单行刷新列表
        self.tableView.reloadRows(at: [indexPath], with: .automatic)

        
    }

}


extension ExecutingViewConttroller : YQExecScanCellDelegate ,SGScanningQRCodeVCDelegate {

    func ExecScanCellScanButtonClick(indexPath : Int){
        //跳转到工单扫描界面进行测试
        //1.跳转到工单扫描界面,block回调拿到相应结果
        self.scanBtnClick()
        currentSelectIndexPath = IndexPath.init(row: indexPath, section: 0)
    }
    
    func didScanningText(_ text: String!) {
        
        if text.contains("设备"){//区分是否是自己的二维码的情况
            
            let str = text.components(separatedBy: ":").last
            
            if let str = str{
                
                self.navigationController?.popViewController(animated: false)
                
                //校验二维码的情况
                let equipment_id = self.workOrderDetalModel?.equipment_id
                //截取str 中的设备ID的情况
                let temp = Double(str)
                
                if equipment_id == temp {
                    //代表的是同一设备
                    let cell = self.tableView.cellForRow(at: currentSelectIndexPath!) as! YQExecScanCell
                    cell.color = "green"
                    
//                    self.tableView.reloadRows(at: [currentSelectIndexPath!], with: .automatic)
                    
                }else{
                    
                    //不同的设备类型
                    let cell = self.tableView.cellForRow(at: currentSelectIndexPath!) as! YQExecScanCell
                    cell.color = "red"
                    
//                    self.tableView.reloadRows(at: [currentSelectIndexPath!], with: .automatic)

                }
                
            }
            
        }else{
            
            self.alert(message: "非可识别二维码!")
            
        }
    }


}

