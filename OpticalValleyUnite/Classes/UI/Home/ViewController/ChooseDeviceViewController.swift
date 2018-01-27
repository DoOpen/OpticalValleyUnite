//
//  ChooseDeviceViewController.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/7/6.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit
import MJRefresh
import SVProgressHUD

class ChooseDeviceViewController: UIViewController {

    @IBOutlet weak var chooseAddressLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    var parkId: String?
    var parkInfoModel: ParkInfoModel?
    
    var cuurentPageNo = 0
    
    var cuurentSelectCell: DeriveCell?
    
    var didSelectDeviceModelHandle: ((Equipment) ->())?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)


        title = "选择报事设备"
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100

        
        getData()
        
        addRefirsh()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: .done, target: self, action: #selector(ChooseDeviceViewController.rightBtnClick))
        
    }
    
    deinit {
        
        print("ChooseDeviceViewController----deinit")
    }
    
    var models = [Equipment]()

    @IBAction func chooseHouseBtnClick() {
        
        
        let vc = ChooseHouseViewController.loadFromStoryboard(name: "ReportMaster") as! ChooseHouseViewController
        vc.parkId = parkId
        vc.arry = ["选择分期", "楼栋"]
        vc.isDeviceChoose = true
        vc.selectParkHandel = {[weak self] parkInfoModel in
            self?.parkInfoModel = parkInfoModel
            print(parkInfoModel)
            if parkInfoModel.STAGE_ID != ""{//选择了两层
                self?.parkInfoModel?.FLOOR_ID = parkInfoModel.id
                self?.chooseAddressLabel.text = parkInfoModel.STAGE_Name + " " + parkInfoModel.name
            }else{
                self?.parkInfoModel?.STAGE_ID = parkInfoModel.id
                self?.chooseAddressLabel.text = parkInfoModel.name
            }
            
            self?.getData(stageId: self?.parkInfoModel?.STAGE_ID, floorId: self?.parkInfoModel?.FLOOR_ID)

            
        }
        
        navigationController?.pushViewController(vc, animated: true)

        
    }
    
    private func addRefirsh(){
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            
            self.getData(stageId: self.parkInfoModel?.STAGE_ID, floorId: self.parkInfoModel?.FLOOR_ID)
           
        })
        
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            self.cuurentPageNo += 1
            
            self.getData(stageId: self.parkInfoModel?.STAGE_ID, floorId: self.parkInfoModel?.FLOOR_ID,indexPageNp: self.cuurentPageNo)
        })
    }
    
    
    @objc private func rightBtnClick(){
        
        if let cell = cuurentSelectCell {
            
            if let block = didSelectDeviceModelHandle,let model = cell.model{
                block(model)
                didSelectDeviceModelHandle = nil
                _ = navigationController?.popViewController(animated: true)
            }
        }else{
            self.alert(message: "请先选择一项!")
        }
        
        
    }
    
    fileprivate func getData(NAME: String? = nil,EQUIP_CODE: String? = nil,stageId: String? = nil,floorId: String? = nil,indexPageNp: Int = 0){
        
        guard let parkId = parkId else
        {
            self.alert(message: "请先返回上一步选择一个项目")
            return
        }
        
        var paramet = [String: Any]()
        paramet["NAME"] = NAME
        paramet["EQUIP_CODE"] = EQUIP_CODE
        paramet["stageId"] = stageId
        paramet["floorId"] = floorId
        paramet["parkId"] = parkId
        paramet["pageIndex"] = indexPageNp
        
        SVProgressHUD.show()
        
        HttpClient.instance.get(path: URLPath.getListEquipment, parameters: paramet, success: { (data) in
            
            SVProgressHUD.dismiss()
            
            if let arry = data["data"] as? Array<[String: Any]>{
                var temp = [Equipment]()
                
                for dic in arry{
                    let model = Equipment(parmart: dic)
                    temp.append(model)
                }
                
                if indexPageNp == 0{
                    
                    self.models = temp
                    self.tableView.mj_header.endRefreshing()
                    self.tableView.mj_footer.resetNoMoreData()
                    
                }else{
                    
                    self.cuurentPageNo = indexPageNp
                    
                    self.models.append(contentsOf: temp)
                    
                    if temp.isEmpty{
                        
                        self.tableView.mj_footer.endRefreshingWithNoMoreData()
                    }
                    
                    self.tableView.mj_footer.endRefreshing()
                }
                
                self.tableView.reloadData()
                
            }
            
        }) { (error) in
            
            SVProgressHUD.showError(withStatus: "数据加载失败,请检查网络!")
        }
    }


}

extension ChooseDeviceViewController: UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! DeriveCell
        cell.model = models[indexPath.row]
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        cuurentSelectCell?.select = false
        cuurentSelectCell = tableView.cellForRow(at: indexPath) as? DeriveCell
        cuurentSelectCell?.select = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text! == ""{
            return false
        }
        if textField.tag == 1{
            self.getData(EQUIP_CODE: textField.text!, stageId: parkInfoModel?.STAGE_ID, floorId: parkInfoModel?.FLOOR_ID)
        }else if textField.tag == 2{
            self.getData(NAME: textField.text!, stageId: parkInfoModel?.STAGE_ID, floorId: parkInfoModel?.FLOOR_ID)
        }
        
        return true
    }
}
