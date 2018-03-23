//
//  YQLocationDetailsVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/2/7.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh

class YQLocationDetailsVC: UIViewController {
    ///属性列表
    @IBOutlet weak var titileLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    //parkID
    var parkID = ""
    
    //列表属性
    var titile : String!
    
    ///三个模型的数组
    var Stage = [YQDecorationStageModel]()
    
    var Floor = [YQDecorationFloorModel]()
    
    var UnitNo = [YQDecorationUnitNoModel]()
    
    var groupNo = [YQDecorationGroundNoModel]()
    
    var House = [YQDecorationHouseModel]()
    
    ///选择的位置字典
    var selectDict = [String : Any]()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = titile
        self.titileLabel.text = "选择" +  titile!
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        let _ = setUpProjectNameLable()
        
        //获取网络数据
        getLocationDataWithString(titile: titile!)
        
    }
    
    
    @IBAction func makeSureButtonClick(_ sender: UIButton) {
        //确定按钮的点击执行的操作
        let center = NotificationCenter.default
        let notiesName = NSNotification.Name(rawValue: "selectLocationNoties")
        center.post(name: notiesName, object: nil, userInfo: [ "selectLocation": self.selectDict])
        
        navigationController?.popViewController(animated: true)
        
    }
    
    // MARK: - 获取相应的location的位置信息
    func getLocationDataWithString(titile : String){
        
        var par = [String : Any]()
        
        switch titile {
                        
            case "区/期":
                
                par["parkId"] = self.parkID
                
                if self.parkID == "" {
                
                    self.alert(message: "请先选择项目")
                    return
                }
                
                SVProgressHUD.show()
                self.getStageData(par : par)
                
                break
                
            case "栋":
                
                let model = selectDict["stage"] as? YQDecorationStageModel
                
                if model == nil{
                    
                    self.alert(message: "请先选择区/期信息")
                    return
                    
                }
                
                par["stageId"] = model?.stageId
                self.getFloorData(par: par)
              
                break
                
            case "单元":
                
                let model = selectDict["floor"] as? YQDecorationFloorModel
                
                if model == nil {
                    
                    self.alert(message: "请先选择栋信息")
                    return

                }
                
                par["floorId"] = model?.floorId
                
                self.getUnitNoData(par: par)
                
                break
            
            case "楼":
                let model = selectDict["unitNo"] as? YQDecorationUnitNoModel
                let model1 = selectDict["floor"] as? YQDecorationFloorModel
                
                if model == nil {
                    
                    self.alert(message: "请先选择单元信息")
                    return
                    
                }
                par["floorId"] = model1?.floorId
                par["unitNu"] = model?.unitNo
            
                self.getGroundNoData(par: par)
                
                break
                
            case "房号":
                
                let model = selectDict["unitNo"] as? YQDecorationUnitNoModel
                let model1 = selectDict["groupNo"] as? YQDecorationGroundNoModel
                let model2 = selectDict["floor"] as? YQDecorationFloorModel
                
                if model == nil {
                    
                    self.alert(message: "请先选择楼层信息")
                    return
                    
                }
                par["floorId"] = model2?.floorId
                par["unitNu"] = model?.unitNo
                par["groundNo"] = model1?.groundNo
                
                self.getHouseData(par: par)
               
                break
                
            default:
                break
        }
    }
    
    // MARK: - 添加默认的项目选择方法
    func setUpProjectNameLable() -> String{
        
        let dic = UserDefaults.standard.object(forKey: Const.YQProjectModel) as? [String : Any]
        
        var projectName  = ""
        
        if dic != nil {
            
            projectName = dic?["PARK_NAME"] as! String
            self.parkID = dic?["ID"] as! String
            
        }else{
            
            projectName = "请选择默认项目"
        }
        
        return projectName
    }

    
    // MARK: - 上下拉的刷新的界面情况
    func addRefirsh(){
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            
//            var par = [String : Any]()
            
        })
        
        
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            
//            var par = [String : Any]()
            
            
        })
        
    }
    
    // MARK: - 获取各个信息的数据情况
    func getStageData( par : [String : Any] ){
    
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
            
            self.Stage = tempModel
            self.tableView.reloadData()
            
        }, failure: { (error) in
            
            SVProgressHUD.showError(withStatus: "区/期信息查询失败,请检查网络!")
        })

    }
    
    func getUnitNoData( par : [String : Any]){
        
        SVProgressHUD.show()
        
        HttpClient.instance.post(path: URLPath.getParkUnitNu, parameters: par, success: { (response) in
            
            SVProgressHUD.dismiss()
            let array = response as? Array<[String : Any]>
            
            if (array?.isEmpty)! {
                
                SVProgressHUD.showError(withStatus: "没有加载到更多数据!")
                return
            }
            
            var tempModel = [YQDecorationUnitNoModel]()
            for temp in array! {
                
                tempModel.append(YQDecorationUnitNoModel.init(dict: temp))
            }
            
            self.UnitNo = tempModel
            self.tableView.reloadData()
            
        
        }, failure: { (error) in
            
            SVProgressHUD.showError(withStatus: "单元信息查询失败,请检查网络!")
        })

    }

    func getFloorData(par : [String : Any]){
        
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
            
            self.Floor = tempModel
            self.tableView.reloadData()
            
        }, failure: { (error) in
            
            SVProgressHUD.showError(withStatus: "楼栋信息查询失败,请检查网络!")
        })

    }
    
    func getGroundNoData(par : [String : Any]){
        
        SVProgressHUD.show()
        
        HttpClient.instance.post(path: URLPath.getParkGroundNo, parameters: par, success: { (response) in
            
            SVProgressHUD.dismiss()
            
            let array = response as? Array<[String : Any]>
            
            if (array?.isEmpty)! {
                
                SVProgressHUD.showError(withStatus: "没有加载到更多数据!")
                return
            }
            
            var tempModel = [YQDecorationGroundNoModel]()
            for temp in array! {
                
                tempModel.append(YQDecorationGroundNoModel.init(dict: temp))
            }
            
            self.groupNo = tempModel
            self.tableView.reloadData()

            
        }) { (error) in
            
            SVProgressHUD.showError(withStatus: "楼层信息查询失败,请检查网络!")
        }
    
    }
    
    func getHouseData(par : [String : Any]){
        
        SVProgressHUD.show()
        
        HttpClient.instance.post(path: URLPath.getParkHouse, parameters: par, success: { (response) in
            
            SVProgressHUD.dismiss()
            let array = response as? Array<[String : Any]>
            
            if (array?.isEmpty)! {
                
                SVProgressHUD.showError(withStatus: "没有加载到更多数据!")
                return
            }
            
            var tempModel = [YQDecorationHouseModel]()
            for temp in array! {
                
                tempModel.append(YQDecorationHouseModel.init(dict: temp))
            }
            
            self.House = tempModel
            self.tableView.reloadData()
            
            
        }, failure: { (error) in
            
            SVProgressHUD.showError(withStatus: "房号信息查询失败,请检查网络!")
        })

    }

}

extension YQLocationDetailsVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch self.titile {
            
            case "区/期":
                return Stage.count
            
            case "栋":
                return Floor.count
            
            case "单元":
                return UnitNo.count
            
            case "楼":
                return groupNo.count
            
            case "房号":
                return House.count
            
            default:
                return 0
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "HouseCell")
        
        if cell == nil {
        
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "HouseCell")
        }
        
        switch self.titile {
            
            case "区/期":
                cell?.textLabel?.text = Stage[indexPath.row].stageName
                break
            
            case "栋":
                cell?.textLabel?.text = Floor[indexPath.row].floorName
                break
            
            case "单元":
                cell?.textLabel?.text = UnitNo[indexPath.row].unitNoName
                break
            
            case "楼":
                cell?.textLabel?.text = groupNo[indexPath.row].groundNo
                break
            
            case "房号":
                cell?.textLabel?.text = House[indexPath.row].houseName
                break
            
            default:
                break
        }

        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch self.titile {
            
            
            case "区/期":
                
                self.selectDict.removeAll()
                self.selectDict["stage"] =  Stage[indexPath.row]
                break
                
            case "栋":
                
                self.selectDict.removeValue(forKey: "unitNo")
                self.selectDict.removeValue(forKey: "house")
                self.selectDict.removeValue(forKey: "groupNo")
                self.selectDict["floor"] = Floor[indexPath.row]
                break
                
            case "单元":
                
                self.selectDict.removeValue(forKey: "house")
                self.selectDict.removeValue(forKey: "groupNo")
                self.selectDict["unitNo"] = UnitNo[indexPath.row]
                break
            
            case "楼":
                
                self.selectDict.removeValue(forKey: "house")
                self.selectDict["groupNo"] = groupNo[indexPath.row]
                break
            
            case "房号":
                self.selectDict["house"] = House[indexPath.row]
                break
                
            default:
                break
        }

    }
    
    
    
}


