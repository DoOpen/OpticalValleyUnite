//
//  DeviceViewController.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/7/11.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit
import SVProgressHUD

class DeviceViewController: UIViewController {
    /// 新增设备的属性
    //app设备编码
    @IBOutlet weak var appDeviceCode: UILabel!
    
    //app设备名称
    @IBOutlet weak var appDeviceName: UILabel!
    
    //位置惯用名
    @IBOutlet weak var positionName: UILabel!
    
    //设备惯用名
    @IBOutlet weak var deviceCommonName: UILabel!
    
    //品牌
    @IBOutlet weak var brand: UILabel!
    
    //规格参数
    @IBOutlet weak var specificationParameter: UILabel!

    @IBOutlet weak var openButton: UIButton!
    
    @IBOutlet weak var scrollViewHeightConstraint: NSLayoutConstraint!
    
    /// 扫码的设备的属性的列表
    @IBOutlet weak var deviceDetailBtn: UIButton!
    @IBOutlet weak var workOrderBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deviceView: UIScrollView!
    
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var deviceType: UILabel!
    
    @IBOutlet weak var deviceName: UILabel!
    
    
    @IBOutlet weak var deviceModel: UILabel!
    //厂商
    @IBOutlet weak var madePeople: UILabel!
    //产地
    @IBOutlet weak var madeAddress: UILabel!
    @IBOutlet weak var productionDate: UILabel!
    @IBOutlet weak var registerCodeLabel: UILabel!
    @IBOutlet weak var usePeople: UILabel!
    @IBOutlet weak var usePark: UILabel!
    @IBOutlet weak var reformCompanyLabel: UILabel!
    @IBOutlet weak var installCompanyLabel: UILabel!
    @IBOutlet weak var installDateLabel: UILabel!
    
    //维保单位
    @IBOutlet weak var maintainCompanyLabel: UILabel!
    @IBOutlet weak var maintainPersonLabel: UILabel!
    @IBOutlet weak var fristMaintainDateLabel: UILabel!
    @IBOutlet weak var nextMaintainDateLabel: UILabel!
    @IBOutlet weak var yearMaintainDateLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var parkAddress: UILabel!
    @IBOutlet weak var mark: UILabel!
    
    var detailModels = [WorkOrderDetailModel](){
        didSet{
            tableView.reloadData()
        }
    }
    
    var cellID = "deviceCell2"
    
    var equipmentId: String?{
        didSet{
            if let equipmentId = equipmentId{
                
                getEquipment(equipmentId)
                getData()
            }
        }
    }
    
    // MARK: - swift懒加载方法
    lazy var heightDic = {
        () -> NSMutableDictionary
        
        in
        
        return NSMutableDictionary()
    }()

    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        title = "设备台账"
        tableView.isHidden = true
        
//        tableView.register(UINib(nibName: "DeviceCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //设置scrollView的x方向的滚动
//        self.deviceView.setContentOffset(CGPoint(x:50 , y: self.mark.frame.origin.y + 200 ), animated: true) //里面添加了视图之后就不收代码限制了
        self.scrollViewHeightConstraint.constant = openButton.frame.origin.y + 50
        self.scrollViewHeight.constant =  openButton.frame.origin.y + 50
        
    }
    
    
    @IBAction func openButtonClick(_ openButton: UIButton) {
        
        let titile = openButton.titleLabel?.text
        
        if titile == "收起" {
            
            self.scrollViewHeightConstraint.constant = openButton.frame.origin.y + 50

            self.scrollViewHeight.constant = openButton.frame.origin.y + 50
            
            openButton.setTitle("展开", for: .normal)
            
        }else if titile == "展开" {
            
             self.scrollViewHeightConstraint.constant = UIScreen.main.bounds.size.height
                
            self.scrollViewHeight.constant = self.mark.maxY + 200
            
            openButton.setTitle("收起", for: .normal)
        }
        
    }

    @IBAction func deviceBtnClick() {
        
        deviceDetailBtn.isSelected = true
        workOrderBtn.isSelected = false
        
        tableView.isHidden = true
        deviceView.isHidden = false
        
    }
    
    @IBAction func workOrderBtnClick() {
        
        deviceDetailBtn.isSelected = false
        workOrderBtn.isSelected = true
        
        tableView.isHidden = false
        deviceView.isHidden = true
    }

    
    private func getData(){
        
        let parmate = ["equipmentId": equipmentId!]
        
        SVProgressHUD.show(withStatus: "加载中...")
        
        HttpClient.instance.get(path: URLPath.getEquipmentWorkunit, parameters: parmate, success: { (response) in
            
            SVProgressHUD.dismiss()
            
            if let arry = response["data"] as? Array<[String: Any]>{
                
                var temp = [WorkOrderDetailModel]()
                
                var DCLTemp = [WorkOrderDetailModel]()
                
                for dic in arry{
                    
                    let model = WorkOrderDetailModel(parmart: dic)
                    
                    if model.DCL == 1{
                        
                        DCLTemp.append(model)
                        
                    }else if model.DCL == 0{
                    
                        temp.append(model)
                    }
    
                }
                
                //分别分两次来进行的添加的操作
                self.detailModels = DCLTemp
                self.detailModels.append(contentsOf: temp)
                
            }
            
            
        }) { (error) in
            
            print(error)
        }
        
    }
    
    private func getEquipment(_ equipment: String){
        
        let parmate = ["id": equipment]
        SVProgressHUD.show(withStatus: "加载中...")
        HttpClient.instance.get(path: URLPath.getEquipmentDetail, parameters: parmate, success: { (response) in
            
            SVProgressHUD.dismiss()
            
            if let dic = response as? [String: Any]{
                let model = EquimentModel(parmart: dic)
                self.equipmentModel = model
            }
            
        }) { (error) in
            
        }
    }

    
    var equipmentModel: EquimentModel?{
        
        didSet{
            
            if let model = equipmentModel{
                
//                deviceName.text = model.name
//                deviceBrand.text = model.brand
                deviceModel.text = model.model_name
                
                madePeople.text = model.made_company
                madeAddress.text = model.origin
                
                productionDate.text = model.produce_date
                usePeople.text = model.use_company
                usePark.text = model.park_name
//                parkAddress.text = model.parkAddress
                mark.text = model.comment
                deviceType.text = model.type_name
                registerCodeLabel.text = model.regi_code
                reformCompanyLabel.text = model.reform_company
                installCompanyLabel.text = model.install_company
                installDateLabel.text = model.install_date
                
                maintainCompanyLabel.text = model.maintain_company
                
                maintainPersonLabel.text = model.maintain_person
                fristMaintainDateLabel.text = model.frist_maintain_date
                nextMaintainDateLabel.text = model.next_maintain_date
                yearMaintainDateLabel.text = model.year_maintain_date
                addressLabel.text = model.parkAddress
                
                //设置相应的模型属性
                appDeviceCode.text = model.app_code
                appDeviceName.text = model.app_name
                positionName.text = model.loc_simple_name
                deviceCommonName.text = model.equip_simple_name
                brand.text = model.brand_name
                specificationParameter.text = model.attrs
                
            }
        }
    }
}

extension DeviceViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return detailModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? YQDeviceCell2
        
        if cell == nil {
            
            cell = Bundle.main.loadNibNamed("YQDeviceCell2", owner: nil, options: nil)?[0] as? YQDeviceCell2
        }
        
        cell?.model = detailModels[indexPath.row]
        
        cell?.layoutIfNeeded()
        //添加模型的数据内容
        heightDic["\(indexPath.row)"] = cell?.cellForHeight()
        
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let height = heightDic["\(indexPath.row)"] as! CGFloat
        
        return height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //传递数据模型, 判断来进行可执行与否
        let vc = WorkOrderProgressViewController.loadFromStoryboard(name: "WorkOrder") as! WorkOrderProgressViewController
        //        vc.workModelId = currentDatas[indexPath.row].workOrderId
        let model = detailModels[indexPath.row]
        
        var parmat = [String: Any]()
        
        parmat["UNIT_STATUS"] = model.status
        
        parmat["PERSONTYPE"] = model.PERSONTYPE
        
//        parmat["EXEC_PERSON_ID"] = model.execPersionId
        parmat["WORKUNIT_ID"] = model.id
        
        vc.parmate = parmat
//        vc.listVc = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
