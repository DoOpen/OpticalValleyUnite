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
    @IBOutlet weak var textView: SJTextView!
    @IBOutlet weak var emergencyView: UIView!
    
    @IBOutlet weak var RemarksTextView: UITextView!
    
    @IBOutlet weak var hideTableViewHeightConstraint: NSLayoutConstraint!
    
    var models = [ExecSectionModel]()
    var currentSelectIndexPath: IndexPath?
    var workOrderDetalModel: WorkOrderDetailModel?
    
    weak var ProgressVC: WorkOrderProgressViewController?
    
    var hisriyModel: WorkHistoryModel?
    
    @IBOutlet weak var saveBtn: UIButton!
    var url: String?
    var image: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "工单执行"
        
        workOrderContent.text = workOrderDetalModel?.content
        timeLabel.text = workOrderDetalModel?.time
        
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.tableFooterView = UIView()
              
        
        if isToSee{
            downView.isHidden = true
        }
        if workOrderDetalModel?.orderType == "计划工单"{ //计划工单
            emergencyView.isHidden = true
            getData()
           
            
        }else if workOrderDetalModel?.orderType == "应急工单"{
            emergencyView.isHidden = false
            saveBtn.isHidden = true
            if isToSee{
                emergencyView.isUserInteractionEnabled = false
            }
        }
        
        if let model = hisriyModel{
            textView.text = model.text
            if let str = model.pictures.first{
                let url = URL(string: str)
                
            }
        }
        
        
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
            for dic in (response as! Array<[String: Any]>){
                let model = ExecSectionModel(parmart: dic)
                model.workOrderId = (self.workOrderDetalModel?.id)!

                temp.append(model)
            }
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
    
    func saveUpdate(json: String){
        
        var parmat = [String: Any]()
//        parmat["WORKUNIT_ID"] = self.workOrderDetalModel?.id
//        parmat["UNIT_STATUS"] = 2
        parmat["data"] = json
        SVProgressHUD.show(withStatus: "上传中")
        HttpClient.instance.post(path: URLPath.workunitOpera, parameters: parmat, success: { (response) in
            SVProgressHUD.dismiss()
            SVProgressHUD.showSuccess(withStatus: "保存成功")
        }) { (error) in
            print(error)
        }
        
    }
    
    
    
    @IBAction func saveBtnClick() {
        
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
            SVProgressHUD.dismiss()
            var arry = Array<[String: Any]>()
            
            for model in self.models{
                model.workOrderId = (self.workOrderDetalModel?.id)!
                let taskDic = model.toDic()
             
                arry.append(taskDic)
            }
            do {
                //Convert to Data
                let jsonData = try JSONSerialization.data(withJSONObject: arry, options: JSONSerialization.WritingOptions.prettyPrinted)
                
                //Do this for print data only otherwise skip
                if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                    print(JSONString)
                    self.saveUpdate(json: JSONString)
                }
            } catch  {
                print("转换错误 ")
            }
            
        }
        

        
    }
    //MARK: - 上传图片
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
            self.alert(message: "整个工单已经完成?完成工单之前必须先点击保存按钮提交内容?") { (action) in
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
//                    self.alert(message: "整个工单已经完成?") { (action) in
                        self.upload(parmat)
//                    }
                })
            }else{
                
                var parmat = [String: Any]()
                parmat["WORKUNIT_ID"] = self.workOrderDetalModel?.id
                parmat["UNIT_STATUS"] = 2
                parmat["SUCCESS_TEXT"] = self.textView.text
                self.alert(message: "整个工单已经完成?") { (action) in
                    self.upload(parmat)
                }
                
            }
        }
    }
    
    func upload(_ parate: [String: Any]){
        SVProgressHUD.show(withStatus: "上传中")
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
    
//    //MARK: - 子步骤完成按钮点击
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
