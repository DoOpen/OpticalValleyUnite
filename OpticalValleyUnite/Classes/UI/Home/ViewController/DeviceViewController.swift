//
//  DeviceViewController.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/7/11.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit

class DeviceViewController: UIViewController {

    @IBOutlet weak var deviceDetailBtn: UIButton!
    @IBOutlet weak var workOrderBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deviceView: UIScrollView!
    
    
    @IBOutlet weak var deviceType: UILabel!
    @IBOutlet weak var deviceName: UILabel!
    @IBOutlet weak var deviceBrand: UILabel!
    @IBOutlet weak var deviceModel: UILabel!
    @IBOutlet weak var madePeople: UILabel!
    @IBOutlet weak var madeAddress: UILabel!
    @IBOutlet weak var productionDate: UILabel!
    @IBOutlet weak var registerCodeLabel: UILabel!
    @IBOutlet weak var usePeople: UILabel!
    @IBOutlet weak var usePark: UILabel!
    @IBOutlet weak var reformCompanyLabel: UILabel!
    @IBOutlet weak var installCompanyLabel: UILabel!
    @IBOutlet weak var installDateLabel: UILabel!
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
    
    var equipmentId: String?{
        didSet{
            if let equipmentId = equipmentId{
                getEquipment(equipmentId)
                getData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "设备台账"
        tableView.isHidden = true
        
        tableView.register(UINib(nibName: "DeviceCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        
        //设置scrollView的x方向的滚动
        self.deviceView.setContentOffset(CGPoint(x:300 , y: 300 ), animated: true)
        
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
        
        HttpClient.instance.get(path: URLPath.getEquipmentWorkunit, parameters: parmate, success: { (response) in
            
            if let arry = response["data"] as? Array<[String: Any]>{
                var temp = [WorkOrderDetailModel]()
                for dic in arry{
                    let model = WorkOrderDetailModel(parmart: dic)
                    temp.append(model)
                }
                self.detailModels = temp
                
            }
        }) { (error) in
            print(error)
        }
    }
    
    private func getEquipment(_ equipment: String){
        
        
        
        let parmate = ["id": equipment]
        
        HttpClient.instance.get(path: URLPath.getEquipmentDetail, parameters: parmate, success: { (response) in
            
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
                deviceBrand.text = model.brand
                deviceModel.text = model.model_name
                madePeople.text = model.manufacturer
                madeAddress.text = model.madeIn
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
            }
        }
    }
}

extension DeviceViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! DeviceCell
        cell.model = detailModels[indexPath.row]
        
        return cell
    }
}
