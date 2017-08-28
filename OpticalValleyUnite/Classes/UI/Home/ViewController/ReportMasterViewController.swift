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
    
    @IBOutlet weak var brokerBtn: UIButton!
    
    @IBOutlet weak var selfCheckingBtn: UIButton!
    
    @IBOutlet weak var famlyBtn: UIButton!
    
    @IBOutlet weak var publicBtn: UIButton!
    
    @IBOutlet weak var projectBtn: UIButton!

    @IBOutlet weak var contentHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var contenView: UIView!
    @IBOutlet weak var appointmentTimeConstraint: NSLayoutConstraint!
    @IBOutlet weak var appointmentTimeView: UIView!
    
    
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
    
    var urgentDegreeBtn: UIButton?
    
    var selfCheckingView = UIView()
    
    var selectProject: ProjectModel?
    var selectWorkType: WorkTypeModel?
    var selectParkInfo: ParkInfoModel?
    var selectDate: Date?
    
    var deriveChoose = false
    
    var deviceModel: Equipment?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selfCheckingView = Bundle.main.loadNibNamed("ReportMasterView", owner: self, options: nil)![0] as! UIView
        selfCheckingBtnClick()
        familyBtnClick()
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "报事记录", style: .plain, target: self, action: "rightBtnClick")
    }

    //MARK: - Events
    @IBAction func brokerBtnClick() {
        setBtnSelect(btn: brokerBtn, true)
        setBtnSelect(btn: selfCheckingBtn, false)

        contentHeightConstraint.constant = selfCheckingView.height
        contenView.layoutIfNeeded()
        selfCheckingView.frame = contenView.bounds
        contenView.addSubview(selfCheckingView)
    }

    @IBAction func selfCheckingBtnClick() {
        setBtnSelect(btn: selfCheckingBtn, true)
        setBtnSelect(btn: brokerBtn, false)
        

        if contenView.subviews.count != 0 {
            contenView.subviews[0].removeFromSuperview()
        }
        contentHeightConstraint.constant = 0
        contenView.layoutIfNeeded()
        
    }
    
    @IBAction func familyBtnClick() {
        setBtnSelect(btn: famlyBtn, true)
        setBtnSelect(btn: publicBtn, false)
        if appointmentTimeView.isHidden {
            appointmentTimeConstraint.constant = 44
            appointmentTimeView.layoutIfNeeded()
            appointmentTimeView.isHidden = false
            contentHeightConstraint.constant = selfCheckingView.height + 44
            appointmentTimeView.layoutIfNeeded()
        }
    }

    @IBAction func publicBtnClick() {
        setBtnSelect(btn: publicBtn, true)
        setBtnSelect(btn: famlyBtn, false)

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
    
    @IBAction func deriveChooseValueChange(_ sender: UISwitch) {
        chooseAddressLabel.text = sender.isOn ? "选择设备位置" : "报事位置"
        deriveChoose = sender.isOn
        secanBtn.isHidden = !sender.isOn
        if deriveChoose{
            deviceViewheightConstrnit.constant = 400.0
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
    
    @IBAction func urgentDegreeBtnClick(_ sender: UIButton) {
        setBtnSelect(btn: urgentDegreeBtn, false)
        urgentDegreeBtn = sender
        setBtnSelect(btn: urgentDegreeBtn, true)
    }
    
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
            })
            
        }) { (error) in
            
        }
        
        

    }
    
 
    func rightBtnClick(){
        
    }

    

    
    @IBAction func chooseTimeBtnClick(_ sender: UITapGestureRecognizer) {
        
        let dic = ["Mon": "星期一", "Tues": "星期二", "Wed": "星期三", "Thur": "星期四", "Fri": "星期五", "Sat": "星期六", "Sun": "星期日"]
        
        
        SJPickerView.show(withDateType: .dateAndTime, defaultingDate: Date(), selctedDateFormot: "MM-dd EEE HH:mm", didSelcted: {
            date, dateStr in
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
    
    
    @IBAction func chooseBtnClick() {
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
                
                
                
                self?.addressLabel.text =  parkInfoModel.name
                
            }
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
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
        
        var parmar = [String: Any]()
        
//        if selectParkInfo != nil{
//            let address = selectParkInfo!.id
//        }
        let projectId = selectProject!.projectId
        let workTypeId = selectWorkType!.id
        
        let level = urgentDegreeBtn?.tag
        
        parmar["PARK_ID"] = projectId

        if selectParkInfo?.FLOOR_ID != ""{
            
            parmar["STAGE_ID"] = selectParkInfo?.STAGE_ID ?? ""
            parmar["FLOOR_ID"] = selectParkInfo?.FLOOR_ID ?? ""
            parmar["HOUSE_ID"] = selectParkInfo?.id ?? ""

        }else{
            parmar["STAGE_ID"] = selectParkInfo?.STAGE_ID ?? ""
            parmar["FLOOR_ID"] = selectParkInfo?.id ?? ""
            parmar["HOUSE_ID"] = ""
        }
        
        
        parmar["WORKTYPE_ID"] = workTypeId
        parmar["IMPORTENT_LEVEL"] = level
        parmar["EVENT_ADDR"] = address2Label.text ?? ""
        parmar["DESCRIPTION"] = textView.text
        parmar["equipment_id"] = deviceModel?.id
        
        if selfCheckingBtn.isSelected {//自检

            parmar["EVENT_TYPE"] = 0
        }else{
//            if ownerNameTextField.text == "" {
//                SVProgressHUD.showError(withStatus: "请输入业主名字")
//                return
//            }
//            if OwnerAddressTextField.text == "" {
//                SVProgressHUD.showError(withStatus: "请输入业主地址")
//                return
//            }
            if ownerPhoneTextField.text == "" {
                SVProgressHUD.showError(withStatus: "请输入业主电话")
                return
            }
            
            parmar["CUSTOMER_NAME"] = ownerNameTextField.text
            parmar["CUSTOMER_ADDR"] = OwnerAddressTextField.text
            
            parmar["CUSTOMER_PHONE"] = ownerPhoneTextField.text
            parmar["REPRE_TYPE"] = !famlyBtn.isSelected
            parmar["EXEC_DATE"] = selectDate?.dataString(dateFormetStr: "yyyy-MM-dd HH:mm:ss")
        }
        
        
        let images = addPhotoView.photos.map{$0.image}
        if images.count > 0 {
            HttpClient.instance.upDataImages(images, complit: { (url) in
                parmar["PICTURE"] = url
                HttpClient.instance.post(path: URLPath.reportMaster, parameters: parmar, success: { (response) in
                    
                    SVProgressHUD.showSuccess(withStatus: "提交成功")
                    _ = self.navigationController?.popViewController(animated: true)
                    
                }) { (error) in
                    
                }
                
                
            })
            
            return
        }
        
    
        HttpClient.instance.post(path: URLPath.reportMaster, parameters: parmar, success: { (response) in
            
            SVProgressHUD.showSuccess(withStatus: "提交成功")
            _ = self.navigationController?.popViewController(animated: true)
            
        }) { (error) in
            
        }
    }
    
    
}

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

