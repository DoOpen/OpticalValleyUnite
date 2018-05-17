//
//  YQChooseHouseVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/5/16.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit
import SVProgressHUD

class YQChooseHouseVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchText: UITextField!
    
    @IBOutlet weak var stagesBtn: UIButton!
    
    @IBOutlet weak var buildingBtn: UIButton!
    
    //选择的模型缓存
    var Stage : YQDecorationStageModel?
    var Floor : YQDecorationFloorModel?
    
    var parkId : String?
    
    var dataAarry = [YQChooseHouseModel]()
    
    var index = -1
    
    var selectParkHandel: ((ParkInfoModel) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: false)
        
        title = "请选择报事房屋"
        
        self.automaticallyAdjustsScrollViewInsets = false
        
    
    }

    // MARK: - buttonClick方法实现
    //选择分期
    @IBAction func stagesButtonClick(_ sender: UIButton) {
        
        if parkId == nil {
            self.alert(message: "请先返回上一步选择一个项目")
            return
        }
        
        var par = [String : Any]()
        par["parkId"] = parkId
            
        SVProgressHUD.show()
        
        HttpClient.instance.post(path: URLPath.getParkStage, parameters: par, success: { (response) in
            SVProgressHUD.dismiss()
            
            let array = response as? Array<[String : Any]>
            
            if (array?.isEmpty)! {
                
                SVProgressHUD.showError(withStatus: "没有加载到更多数据!")
                return
            }
            
            var tempModel = [YQDecorationStageModel]()
            for temp in array! {
                
                tempModel.append(YQDecorationStageModel.init(dict: temp))
                
            }

            var stringArray = [String]()
            for model in tempModel {
                
                stringArray.append(model.stageName)
                
            }
            
             SJPickerView.show(withDataArry: stringArray, didSlected: { (indexnum) in
                
                self.Stage = tempModel[indexnum]
                
                self.stagesBtn.setTitle(stringArray[indexnum], for: .normal )
                
             })
            
        }, failure: { (error) in
            
            SVProgressHUD.showError(withStatus: "区/期信息查询失败,请检查网络!")
        })

        
    }
    
    //选择楼栋
    @IBAction func buildingButtonClick(_ sender: UIButton) {
        
        if (self.stagesBtn.titleLabel?.text?.contains("选择分期"))! {
            
            self.alert(message: "请选择分期")
            
        }else{
            
            var par = [String : Any]()
            par["stageId"] = self.Stage?.id
            
            SVProgressHUD.show()
            
            HttpClient.instance.post(path: URLPath.getParkFloor, parameters: par, success: { (response) in
                
                SVProgressHUD.dismiss()
                let array = response as? Array<[String : Any]>
                
                if (array?.isEmpty)! {
                    
                    SVProgressHUD.showError(withStatus: "没有加载到更多数据!")
                    return
                }
                
                var tempModel = [YQDecorationFloorModel]()
                for temp in array! {
                    
                    tempModel.append(YQDecorationFloorModel.init(dict: temp))
                }

                var stringArray = [String]()
                for model in tempModel {
                    
                    stringArray.append(model.buildName)
                    
                }
                
                SJPickerView.show(withDataArry: stringArray, didSlected: { (indexnum) in
                    
                    self.Floor = tempModel[indexnum]
                    
                    self.buildingBtn.setTitle(stringArray[indexnum], for: .normal )
                    
                })
                
                
            }, failure: { (error) in
                
                SVProgressHUD.showError(withStatus: "楼栋信息查询失败,请检查网络!")
            })

            
        }
        
    }
    
    //搜索
    @IBAction func searchButtonClick(_ sender: UIButton) {
        
        self.searchText.endEditing(false)
        
        if self.searchText.text == "" {
            
            self.alert(message: "请输入查询房号")
            
        }else{
            
            var par = [String : Any]()
            par["parkId"] = parkId
            par["houseCode"] = self.searchText.text
            par["stageId"] = self.Stage?.id
            par["floorId"] = self.Floor?.id
            
            SVProgressHUD.show()
            
            HttpClient.instance.post(path: URLPath.getHouse, parameters: par, success: { (response) in
                
                SVProgressHUD.dismiss()
                
                let data = response as? Array<[String : Any]>
                
                if data == nil {
                    
                    SVProgressHUD.showError(withStatus: "没有更多数据!")
                    self.dataAarry.removeAll()
                    
                }else{
                    
                    var tempArray = [YQChooseHouseModel]()
                    
                    for dict in data! {
                        
                        tempArray.append(YQChooseHouseModel.init(dict: dict))
                    }
                    
                    self.dataAarry = tempArray
                    self.tableView.reloadData()
                    
                }
                
            }, failure: { (error) in
                
                SVProgressHUD.showError(withStatus: "房屋编号查询失败,请检查网络!")
            })
        }
        
    }

    // MARK: - 完成按钮的点击的方法
    func rightBtnClick() {
        
        self.navigationController?.popViewController(animated: true)
    }
    
}


extension YQChooseHouseVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(ChooseHouseViewController.rightBtnClick))
        
        let index = indexPath.row
        
        if selectParkHandel != nil{
            
            let model = self.dataAarry[index]
            var dict = [String : Any]()
            dict["id"] = model.id
            dict["app_need_stage"] = model.stageId
            dict["app_need_floor"] = model.buildId
            
            let string = (model.unitNo) + "单元"
            let string1 = (model.groundNo) + "楼层"
            let string2 = (model.houseCode) + "室"
            
            dict["text"] = model.stageName  + "-" + model.buildName + "_" + string + string1 + string2
            
            let ParkInfo = ParkInfoModel.init(parmart: dict)
            
            selectParkHandel!(ParkInfo)
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataAarry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "YQChooseHouseCell") as? YQChooseHouseCell
        
        if cell == nil {
            
            cell = Bundle.main.loadNibNamed("YQChooseHouseCell", owner: nil, options: nil)?[0] as? YQChooseHouseCell
        }
        
        cell?.model = self.dataAarry[indexPath.row]
        if index == indexPath.row {
            
            cell?.setSelectCellClick(true)
            
        }else{
            
            cell?.setSelectCellClick(false)
        }
        
        return cell!
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        self.searchText.endEditing(false)
    }
    
}


