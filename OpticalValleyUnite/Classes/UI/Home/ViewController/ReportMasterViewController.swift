//
//  ReportMasterViewController.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/1/13.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import SVProgressHUD
import Alamofire

class ReportMasterViewController: UIViewController {
    
/// 普通报事的按钮的情况
    //代客按钮
    @IBOutlet weak var brokerBtn: UIButton!
    //自检按钮
    @IBOutlet weak var selfCheckingBtn: UIButton!
    //自发按钮
    @IBOutlet weak var spontaneousBtn: UIButton!
    

/// 电梯报事的按钮情况
    //电话
    @IBOutlet weak var telReportMaster: UIButton!
    
    //维修
    @IBOutlet weak var maintenanceReportMaster: UIButton!
    
    //其他 改为 自发 的电梯的报事
    @IBOutlet weak var otherReportMaster: UIButton!
    
    /// 提交按钮button
    @IBOutlet weak var SubmitBtn: UIButton!
    
    @IBOutlet weak var famlyBtn: UIButton!
    
    @IBOutlet weak var publicBtn: UIButton!
    
    ///项目选择按钮的点击
    @IBOutlet weak var projectBtn: UIButton!

    @IBOutlet weak var contentHeightConstraint: NSLayoutConstraint!
    
    /// 区分电梯和普通报事
    var reportName : String = ""
    
    /// 加锁
    let lock = 0
    let lock1 = 0
    
    
    //中间要求变换的 contentview
    @IBOutlet weak var contenView: UIView!
    
    @IBOutlet weak var appointmentTimeConstraint: NSLayoutConstraint!
    
    //预约时间的view的点击
    @IBOutlet weak var appointmentTimeView: UIView!
    
    //连接的是xib的reportMasterView.xib
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var workTypeLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var address2Label: UITextField!
    @IBOutlet weak var textView: SJTextView!
    
    @IBOutlet weak var OwnerAddressTextField: UITextField!
    @IBOutlet weak var ownerNameTextField: UITextField!
    @IBOutlet weak var ownerPhoneTextField: UITextField!
    @IBOutlet weak var appointmentTimeLabel: UILabel!
    @IBOutlet weak var addPhotoView: SJAddView!
    
    @IBOutlet weak var chooseAddressLabel: UILabel!
    
    @IBOutlet weak var secanBtn: UIButton!
    
    @IBOutlet weak var deviceViewheightConstrnit: NSLayoutConstraint!
    
    @IBOutlet weak var deviceView: DeviceView!
    

/// 紧急报事的情况下的按钮的缓存
    var urgentDegreeBtn: UIButton?
    @IBOutlet weak var UrgentMatterlow: UIButton!
    
    var selfCheckingView = UIView()
    
    var selectProject: ProjectModel?
    var selectWorkType: WorkTypeModel?
    var selectParkInfo: ParkInfoModel?
    var selectDate: Date?
    
    var deriveChoose = false
    var deviceModel: Equipment?
    
    
    
//    if let token = UserDefaults.standard.object(forKey: "SJDeviceToken") as? String{
//        
//        parameters["UMENG_TOKEN"] = token
//        
//    }
    
    //缓存电梯报事的按钮组

    
    // MARK: - 视图生命周期的方法
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //1.通过判断是普通报事,还是电梯报事
        //        Alamofire.request(URLPath.basicPath + URLPath.typeOfReportMaster, method: .get, parameters: parameters, encoding: <#T##ParameterEncoding#>, headers: <#T##HTTPHeaders?#>).responseJSON { (response) in
        
        
        if let reportName = UserDefaults.standard.object(forKey: Const.YQReportName){
            
            self.reportName = reportName as! String
            
        }

        if self.reportName == "报事"{ // 普通报事
            
            self.reportHide()
            
            // selfCheckingView 直接加载xib的视图
            self.selfCheckingView = Bundle.main.loadNibNamed("ReportMasterView", owner: self, options: nil)![0] as! UIView
            // 默认调取了 selfCheckingBtnClick
            self.selfCheckingBtnClick()
            // 默认调取了 familyBtnClick
            self.familyBtnClick()
            
        }else{  //电梯报事
            
            self.elevatorReportHide()
            
        }

        
        
        //请求参数:
//        var reportParameter = [String : Any]()
//        
//        SVProgressHUD.show(withStatus: "登录中")
//        reportParameter["token"] = UserDefaults.standard.object(forKey: Const.SJToken)
//        
////        UserDefaults.standard.set(token, forKey: Const.SJToken)
//
//        
//        //发送请求:
//        Alamofire.request(URLPath.basicPath + URLPath.typeOfReportMaster,  parameters: reportParameter).responseJSON { (response) in
//            
//            SVProgressHUD.dismiss()
//
//            let type = response.result
//            
//            print(type)
//            switch response.result {
//                
//                case .success(_):
//                    
//                    if let value = response.result.value as? [String: Any] {
//                        
//                        if let data:NSArray = value["data"] as? NSArray {
//                            
//                            if data.count < 1 {
//                                
//                                self.alert(message: "没有显示数据!")
//                                self.elevatorReportHide()
//                                
//                                return
//                            }
//                                
//                            let dict:NSDictionary = (data[0] as? NSDictionary)!
//                            self.reportName = (dict["APP_MODULE_NAME"] as? String)!
//                            
//                            print(self.reportName)
//                            
//                            if self.reportName == "报事"{ // 普通报事
//                                
//                                self.reportHide()
//                                
//                                // selfCheckingView 直接加载xib的视图
//                                self.selfCheckingView = Bundle.main.loadNibNamed("ReportMasterView", owner: self, options: nil)![0] as! UIView
//                                // 默认调取了 selfCheckingBtnClick
//                                self.selfCheckingBtnClick()
//                                // 默认调取了 familyBtnClick
//                                self.familyBtnClick()
//                                
//                            }else{  //电梯报事
//                                
//                                self.elevatorReportHide()
//                            
//                            }
//                            
//                        }
//                        
//                        break
//                    }
//                    
//                    break
//                
//                case .failure(let error):
//                    
//                    debugPrint(error)
//                    
//                    break
//            }
//            
//        }
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "报事记录", style: .plain, target: self, action: "rightBtnClick")
        
        //设置默认的紧急的报事情况
        self.urgentDegreeBtn = self.UrgentMatterlow
        self.urgentDegreeBtnClick(urgentDegreeBtn!)
        getUserDefaultsProject()
        
    }
    
    
    // MARK: - 获取默认的项目的值来显示
    func getUserDefaultsProject() {
        
        let dic = UserDefaults.standard.object(forKey: Const.YQProjectModel) as? [String : Any]
        if dic == nil {
            return
        }
        
        let model = ProjectModel()
        model.projectId = (dic?["ID"] as? String)!
        model.projectName = (dic?["PARK_NAME"] as? String)!
        
        if model.projectName != "" {
            
            self.projectBtn.setTitle(model.projectName, for: .normal)
            selectProject = model
            
        }
        
    }
    
    
    //MARK: - 报事类型按钮组clickEvents
    ///待客按钮clickEvents
    @IBAction func brokerBtnClick() {
        setBtnSelect(btn: brokerBtn, true)
        setBtnSelect(btn: selfCheckingBtn, false)
        setBtnSelect(btn: spontaneousBtn, false)
        
        contentHeightConstraint.constant = selfCheckingView.height
        contenView.layoutIfNeeded()
        selfCheckingView.frame = contenView.bounds
        contenView.addSubview(selfCheckingView)
        
    }
    
    /// 自检按钮selfCheckingBtnClick方法
    @IBAction func selfCheckingBtnClick() {
        setBtnSelect(btn: selfCheckingBtn, true)
        setBtnSelect(btn: brokerBtn, false)
        setBtnSelect(btn: spontaneousBtn, false)

        if contenView.subviews.count != 0 {
            contenView.subviews[0].removeFromSuperview()
        }
        contentHeightConstraint.constant = 0
        contenView.layoutIfNeeded()
    }
    
    /// 自发按钮点击的方法
    @IBAction func spontaneousBtnClick() {
        
        setBtnSelect(btn: selfCheckingBtn, false)
        setBtnSelect(btn: brokerBtn, false)
        setBtnSelect(btn: spontaneousBtn, true)
        
        if contenView.subviews.count != 0 {
            contenView.subviews[0].removeFromSuperview()
        }
        contentHeightConstraint.constant = 0
        contenView.layoutIfNeeded()

    }

    /// 电话按钮
    @IBAction func telBtnClick() {
        
        setBtnSelect(btn:telReportMaster , true)
        setBtnSelect(btn:maintenanceReportMaster , false)
        setBtnSelect(btn:otherReportMaster , false)

    }
    /// 维保按钮
    @IBAction func maintenanceBtnClick() {
        
        setBtnSelect(btn:telReportMaster , false)
        setBtnSelect(btn:maintenanceReportMaster , true)
        setBtnSelect(btn:otherReportMaster , false)
        
    }
    
    /// 其它按钮
    @IBAction func otherBtnClick() {
        
        setBtnSelect(btn:telReportMaster , false)
        setBtnSelect(btn:maintenanceReportMaster , false)
        setBtnSelect(btn:otherReportMaster , true)
    }
    
    // MARK: - 待客类型按钮方法点击
    ///(业主按钮)familyBtnClick方法
    @IBAction func familyBtnClick() {
        setBtnSelect(btn: famlyBtn, true)
        setBtnSelect(btn: publicBtn, false)
        //更新约束,设置方法
        if appointmentTimeView.isHidden {
            appointmentTimeConstraint.constant = 44
            appointmentTimeView.layoutIfNeeded()
            appointmentTimeView.isHidden = false
            contentHeightConstraint.constant = selfCheckingView.height + 44
            appointmentTimeView.layoutIfNeeded()
        }
    }
    
    ///(公共按钮点击)publicBtnClick
    @IBAction func publicBtnClick() {
        setBtnSelect(btn: famlyBtn, false)
        setBtnSelect(btn: publicBtn, true)
        
        appointmentTimeConstraint.constant = 0
        appointmentTimeView.layoutIfNeeded()
        appointmentTimeView.isHidden = true
        contentHeightConstraint.constant = selfCheckingView.height - 44.0
        appointmentTimeView.layoutIfNeeded()
    }

    
    func setBtnSelect(btn: UIButton?, _ select: Bool){
        
        if let btn = btn{
            if select {
                btn.isSelected = true
                btn.borderColor = Const.SJThemeColor
            }else{
                btn.isSelected = false
                btn.borderColor = UIColor.clear
            }
        }
    }
    
    // MARK: - 各种按钮的点击方法
    @IBAction func deriveChooseValueChange(_ sender: UISwitch) {
        chooseAddressLabel.text = sender.isOn ? "选择设备位置" : "报事位置"
        deriveChoose = sender.isOn
        secanBtn.isHidden = !sender.isOn
        if deriveChoose{
            deviceViewheightConstrnit.constant = 500.0
            deviceView.isHidden = false
        }else{
            deviceViewheightConstrnit.constant = 290.0
            deviceView.isHidden = true
            deviceModel = nil
        }
        
    }
    
    @IBAction func scaningBtnClick() {
        
        let device = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
        
        if device != nil {
            let status = PHPhotoLibrary.authorizationStatus()
            if status == .authorized{
                let vc = SGScanningQRCodeVC()
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
    
    
    // MARK: - 紧急程度的系列按钮点击事件
    @IBAction func urgentDegreeBtnClick(_ sender: UIButton) {
        
        setBtnSelect(btn: urgentDegreeBtn, false)
        
        urgentDegreeBtn = sender
        
        setBtnSelect(btn: urgentDegreeBtn, true)
    }
    
    
    
    // MARK: - 选择项目列表的pickView展示
    @IBAction func chooseProjectBtnClick(){
        
        SVProgressHUD.show(withStatus: "加载中")
        
        HttpClient.instance.get(path: URLPath.getParkList, parameters: nil, success: { (response) in
            
            SVProgressHUD.dismiss()
            
            guard response.count > 0 else{
                SVProgressHUD.showError(withStatus: "数据为空")
                return
            }
            
            var temp = [ProjectModel]()
            
            for dic in response as! Array<[String: Any]> {
                temp.append(ProjectModel(parmart: dic))
            }
            
            SJPickerView.show(withDataArry2: temp, didSlected: { [weak self] index in
                
                self?.projectBtn.setTitle(temp[index].title, for: .normal)
                self?.selectProject = temp[index]
                //是一个项目的模型,更新传递项目模型
                //重新传递的是 项目模型
                var dic = [String : Any]()
                dic["ID"] = temp[index].projectId
                dic["PARK_NAME"] = temp[index].projectName
                
                UserDefaults.standard.set(dic, forKey: Const.YQProjectModel)
                
            })
            
            
        }) { (error) in
            
        }
    }

    
    // MARK: - 时间pickView选择时间按钮的内容
    @IBAction func chooseTimeBtnClick(_ sender: UITapGestureRecognizer) {
        
        let dic = ["Mon": "星期一", "Tue": "星期二", "Wed": "星期三", "Thu": "星期四", "Fri": "星期五", "Sat": "星期六", "Sun": "星期日"]
        
        SJPickerView.show(withDateType: .dateAndTime, defaultingDate: Date(), userController: self, selctedDateFormot: "MM-dd EEE HH:mm", didSelcted: {date, dateStr in
           var text = dateStr
            
            for (key, value) in dic{
                text = text?.replacingOccurrences(of: key, with: value)
            }
            
            self.timeLabel.text = text
            self.selectDate = date
            
        })
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let toVc = segue.destination as? WorkOrderTypeChooseViewController{
            
            toVc.didSelectedHandel = { [weak self] model in
                print(model.name)
                self?.workTypeLabel.text = model.name
                self?.selectWorkType = model
            }
            
        }else if let toVc = segue.destination as? ChooseHouseViewController{
           
            toVc.parkId = selectProject?.projectId
            toVc.selectParkHandel = {[weak self] parkInfoModel in
                self?.selectParkInfo = parkInfoModel
                
                self?.addressLabel.text =  parkInfoModel.name
                
            }
        }
    }
    
    // MARK: - 选择报事位置的bnt 的点击事件
    @IBAction func chooseBtnClick() {
        
        //重置
        self.addressLabel.text = ""
        
        if self.deriveChoose{
            
            let vc = ChooseDeviceViewController.loadFromStoryboard(name: "ReportMaster") as! ChooseDeviceViewController
            vc.parkId = selectProject?.projectId
            vc.didSelectDeviceModelHandle = { model in
                self.deviceModel = model
                self.deviceView.model = model
            }
            
            navigationController?.pushViewController(vc, animated: true)
            
        }else{
            
            let vc = ChooseHouseViewController.loadFromStoryboard(name: "ReportMaster") as! ChooseHouseViewController
            
            vc.parkId = selectProject?.projectId
            
            vc.selectParkHandel = {[weak self] parkInfoModel in
                
                self?.selectParkInfo = parkInfoModel
                
                if self?.addressLabel.text == "" {
                    
                    self?.addressLabel.text =  parkInfoModel.name
                    
                }else{
                    
                    self?.addressLabel.text = (self?.addressLabel.text)! + "-" + parkInfoModel.name
                    
                }
                
            }
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    // MARK: - 提交-完成buttonClick
    @IBAction func doneBtnClick() {
        
        if selectProject == nil {
            SVProgressHUD.showError(withStatus: "请选择一个项目")
            return
        }
        
        if selectWorkType == nil {
            SVProgressHUD.showError(withStatus: "请选择一个工单类型")
            return
        }
//        if selectParkInfo == nil {
//            SVProgressHUD.showError(withStatus: "请选择地址")
//            return
//        }
        
        if textView.text == "" {
            SVProgressHUD.showError(withStatus: "请输入工单描述")
            return
        }
        
        
        var parmarReport = [String: Any]()
        
//        if selectParkInfo != nil{
//            let address = selectParkInfo!.id
//        }
        let projectId = selectProject!.projectId
        let workTypeId = selectWorkType!.id
        
        let level = urgentDegreeBtn?.tag
        
        parmarReport["PARK_ID"] = projectId

        if selectParkInfo?.FLOOR_ID != ""{
            
            parmarReport["STAGE_ID"] = selectParkInfo?.STAGE_ID ?? ""
            parmarReport["FLOOR_ID"] = selectParkInfo?.FLOOR_ID ?? ""
            parmarReport["HOUSE_ID"] = selectParkInfo?.id ?? ""

        }else{
            
            parmarReport["STAGE_ID"] = selectParkInfo?.STAGE_ID ?? ""
            parmarReport["FLOOR_ID"] = selectParkInfo?.id ?? ""
            parmarReport["HOUSE_ID"] = ""
        }
        
        parmarReport["WORKTYPE_ID"] = workTypeId
        parmarReport["IMPORTENT_LEVEL"] = level
        parmarReport["EVENT_ADDR"] = address2Label.text ?? ""
        parmarReport["DESCRIPTION"] = textView.text
        
        //设备id
        parmarReport["equipment_id"] = deviceModel?.id
        
        //新添加逻辑代码:如果是contentView存在,约束不为0的话:
        if self.reportName == "报事"{  //普通报事情况
        
            if brokerBtn.isSelected {
                
                //待客
                if ownerNameTextField.text == "" {
                    SVProgressHUD.showError(withStatus: "请输入业主名字")
                    return
                }
//                            if OwnerAddressTextField.text == "" {
//                                SVProgressHUD.showError(withStatus: "请输入业主地址")
//                                return
//                            }
                if ownerPhoneTextField.text == "" {
                    SVProgressHUD.showError(withStatus: "请输入业主电话")
                    return
                }
                
                //待客模式
                parmarReport["EVENT_TYPE"] = 1
                
                parmarReport["CUSTOMER_NAME"] = ownerNameTextField.text
                parmarReport["CUSTOMER_ADDR"] = OwnerAddressTextField.text
                
                parmarReport["CUSTOMER_PHONE"] = ownerPhoneTextField.text
                
                parmarReport["REPRE_TYPE"] = !famlyBtn.isSelected
                
                parmarReport["EXEC_DATE"] = selectDate?.dataString(dateFormetStr: "yyyy-MM-dd HH:mm:ss")
                
            }else{
                
                
                //自检 and 自发
                if selfCheckingBtn.isSelected{
                
                    parmarReport["EVENT_TYPE"] = 0
                
                }else if spontaneousBtn.isSelected{
                    
                    parmarReport["EVENT_TYPE"] = 9
                
                }
                
            }
            
        }else{//电梯报事:
            
            if telReportMaster.isSelected{//电话
                parmarReport["EVENT_TYPE"] = 2
                
            }else if maintenanceReportMaster.isSelected{//维保报事
                parmarReport["EVENT_TYPE"] = 3
                
            }else{// 其他报事
//                parmarReport["EVENT_TYPE"] = 4  现在改其他 为 自发  的电梯报事
                parmarReport["EVENT_TYPE"] = 9
            }
            
        }
        
        //直接的是,禁用button
        self.SubmitBtn.isUserInteractionEnabled = false
        
        let images = addPhotoView.photos.map{$0.image}
        
//        let time: TimeInterval = 2.0
        if images.count > 0 {
            
            HttpClient.instance.upDataImages(images, complit: { (url) in
                
                parmarReport["PICTURE"] = url
                
                HttpClient.instance.post(path: URLPath.reportMaster, parameters: parmarReport, success: { (response) in
                
                    
                    SVProgressHUD.showSuccess(withStatus: "提交成功")
                    _ = self.navigationController?.popViewController(animated: true)
                    //主线程设置 button可用
                    DispatchQueue.main.async {
                        self.SubmitBtn.isUserInteractionEnabled = true
                        self.view .layoutIfNeeded()
                    }
                    
                    
                }) { (error) in
                    
                    print(error)
                    //主线程设置 button可用
                    DispatchQueue.main.async {
                        self.SubmitBtn.isUserInteractionEnabled = true
                        self.view .layoutIfNeeded()
                    }

                }
                
            })
            
            return
        }
        
        
//        print(parmarReport)
        
        HttpClient.instance.post(path: URLPath.reportMaster, parameters: parmarReport, success: { (response) in
            
            SVProgressHUD.showSuccess(withStatus: "提交成功")
            _ = self.navigationController?.popViewController(animated: true)
            
            //主线程设置 button可用
            DispatchQueue.main.async {
                
                self.SubmitBtn.isUserInteractionEnabled = true
                self.view .layoutIfNeeded()
            }
            
        }) { (error) in
            
            print(error)
            //主线程设置 button可用
            DispatchQueue.main.async {
                self.SubmitBtn.isUserInteractionEnabled = true
                self.view .layoutIfNeeded()
                
            }

        }
        
    }
    
    
    // MARK: - 电梯报事和报事hide方法
    /// 电梯报事
    func elevatorReportHide(){
        brokerBtn.isHidden = true
        selfCheckingBtn.isHidden = true
        spontaneousBtn.isHidden = true
        self.telBtnClick()
        
        contentHeightConstraint.constant = 0
        contenView.layoutIfNeeded()
        
    }
    
    /// 报事
    func reportHide(){
        telReportMaster.isHidden = true
        maintenanceReportMaster.isHidden = true
        otherReportMaster.isHidden = true
        
    }
    
}

/// 公共的类的扩展的分类
extension ReportMasterViewController: SGScanningQRCodeVCDelegate{
    
    func didScanningText(_ text: String!) {
        if text.contains("设备"){
            let str = text.components(separatedBy: ":").last
            
            if let str = str{
                getEquipment(str)
            }
        }
    }
    
    
    func getEquipment(_ equipment: String){
        
        let parmate = ["id": equipment]
        
        HttpClient.instance.get(path: URLPath.getEquipmentDetail, parameters: parmate, success: { (response) in
            
            if let dic = response as? [String: Any]{
                
                let model = Equipment(parmart: dic)
                
                self.deviceModel = model
                self.deviceView.model = model
                self.navigationController?.popViewController(animated: true)
                
            }
        
        }) { (error) in
            
        }
    }
    
}

