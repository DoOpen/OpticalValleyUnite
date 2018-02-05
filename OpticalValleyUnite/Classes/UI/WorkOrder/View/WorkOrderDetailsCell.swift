//
//  WorkOrderDetailsCell.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/1/13.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit
import RealmSwift

class WorkOrderDetailsCell: UITableViewCell {

    @IBOutlet weak var DeviceView: UIView!
    @IBOutlet weak var DeviceHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var subDeviceView: UIView!
    @IBOutlet weak var subDeviceHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var contentLabel: UILabel!

    @IBOutlet weak var workOrderNameLabel: UILabel!
    
    //工单类型 label
    @IBOutlet weak var workReportTypeLable: UILabel!
    @IBOutlet weak var workReportLabelHieghtConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var workReportHightConstraint: NSLayoutConstraint!
    
    //工单类型 显示值
    @IBOutlet weak var reportTypeLabel: UILabel!
    @IBOutlet weak var urgentDegreeLabel: UILabel!
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var workIdLabel: UILabel!
    @IBOutlet weak var stutasLabel: UILabel!
    @IBOutlet weak var callBackBtn: UIButton!
    @IBOutlet weak var seePhotpBtn: UIButton!
    @IBOutlet weak var parkNameLabel: UILabel!
    
    //工单的设备类的数据的label的拖线
    @IBOutlet weak var deviceName: UILabel!
    @IBOutlet weak var deviceBrand: UILabel!
    @IBOutlet weak var deviceModel: UILabel!
    @IBOutlet weak var madePeople: UILabel!
    @IBOutlet weak var madeAddress: UILabel!
    @IBOutlet weak var productionDate: UILabel!
    @IBOutlet weak var usePeople: UILabel!
    @IBOutlet weak var usePark: UILabel!
    @IBOutlet weak var parkAddress: UILabel!
    @IBOutlet weak var mark: UILabel!
    
    
    var equipmentModel: EquimentModel?{
        didSet{
            if let model = equipmentModel{
                
                
                
                deviceName.text = model.name
                deviceBrand.text = model.brand_name
                
                deviceModel.text = model.model_name
                
                //厂商和 产地 字段的显示问题的bug 解决!
                madePeople.text = model.made_company
                madeAddress.text = model.origin
                
                productionDate.text = model.produce_date
                usePeople.text = model.use_company
                usePark.text = model.park_name
                parkAddress.text = model.parkAddress
                mark.text = model.comment
            }
        }
    }
    
    var changedHeight: (() -> ())?
    
    var hasCallBackList = false{
        didSet{
            callBackBtn.isHidden = !hasCallBackList
        }
    }
    
    
    var model: WorkOrderDetailModel?{
        didSet{
            
            if let model = model{
                
                contentLabel.text = model.content
//                contentLabel.text = "东方化工二手电脑办公二维老地方能够两三年栋欧式文公;色是;我;第呢如果;老实人"
//                contentLabel.text = "我xxxxx"
                workOrderNameLabel.text = model.workName
                reportTypeLabel.text = model.orderType
                
                projectNameLabel.text = model.workTypeName
                
                    
                addressLabel.text = model.address
                workIdLabel.text = model.id
                stutasLabel.text = model.statu
//             parkNameLabel.text = model.PARK_NAME
                
//                if model.orderType == "计划工单"{
//                    
//                }else if model.orderType == "应急工单"{
//                    
//                }
                if model.equipment_id == -1{
                    DeviceView.isHidden = true
                    DeviceHeightConstraint.constant = 0
                }else{
                    if model.isOpen {
                        DeviceView.isHidden = false
                        DeviceHeightConstraint.constant = 365.0
                        
                        subDeviceView.isHidden = false
                        subDeviceHeightConstraint.constant = 278.0
                        
                    }else{
                        DeviceView.isHidden = false
                        DeviceHeightConstraint.constant = 87.0
                        
                        subDeviceView.isHidden = true
                        subDeviceHeightConstraint.constant = 0.0
                    }
                }
                
                
                
                switch model.importentLivel {
                case 0:
                    urgentDegreeLabel.text = "低"
                case 1:
                    urgentDegreeLabel.text = "普通"
                case 0:
                    urgentDegreeLabel.text = "紧急"
                default:
                    urgentDegreeLabel.text = "普通"
                }
                
                
                
                
                switch model.status {
                case 10:
                    stutasLabel.text = "待督办"
                    
                case 11:
                    stutasLabel.text = "已督办"

                case 0:
                    stutasLabel.text = "待派发"
                case 1:
                    stutasLabel.text = "已派发"
                    if let name = User.currentUser()?.nickname{
                        if name == model.EXEC_PERSON_NAME{
                            stutasLabel.text = "待接单"
                        }
                    }
                    
                    
                case 2:
                    stutasLabel.text = "已完成"
                     
                case 3:
                    stutasLabel.text = "已关闭"
                     
                case 4:
                    stutasLabel.text = "待派发"
                     
                case 5:
                    stutasLabel.text = "已接单"

                case 6:
                    stutasLabel.text = "处理中"
                     
                    
                case 7:
                    stutasLabel.text = "已处理"
                     
                    
                case 8:
                    stutasLabel.text = "已评价"
                     
                    
                default:
                    stutasLabel.text = "工单生成"
            }
                
            seePhotpBtn.isHidden = model.picture == ""
       
        }
        }
    }
    
    
    @IBAction func callBackBtnClick() {
        
    }
    
    
    @IBAction func openBtnClick(_ sender: UIButton) {
        
        //这里需要改写数据库的属性情况
        let realm = try! Realm()
        realm.beginWrite()
        model?.isOpen = !(model?.isOpen)!
        
        sender.isSelected = (model?.isOpen)!
        try! realm.commitWrite()
        
        if let block = changedHeight{
            block()
        }
        
        
    }
    
    
    @IBAction func seephotoBtnClick() {
        if let model = model{
            if model.picture != ""{
                
                var photos = [Photo]()
                
                let arry = model.picture.components(separatedBy: ",")
                
                for str in arry{
                    
                    let basicPath = URLPath.systemSelectionURL
                    
                    if str.contains("http") {
                        
                        let photo = Photo(urlString: str)
                        photos.append(photo)

                    }else{
                    
                        let imageValue = basicPath.replacingOccurrences(of: "/api/", with: "") + "/" + str
                    
                        let photo = Photo(urlString: imageValue)
                        photos.append(photo)
                    }
                    
                    
                }
                
                let pb = PhotoBrowser(photos: photos, currentIndex: 0)
                pb.indicatorStyle = .pageControl

                
                SJKeyWindow?.rootViewController?.present(pb, animated: true, completion: nil)
            }
        }

    }
}
