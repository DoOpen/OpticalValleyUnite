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
    
    var parkId : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: false)
        
        title = "请选择报事房屋"
        
    
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
            
//            self.Stage = tempModel
//            self.tableView.reloadData()
            
             SJPickerView.show(withDataArry: nil, didSlected: { (indexnum) in
                
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
            par[""] = ""
            
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
                
//                self.Floor = tempModel
//                self.tableView.reloadData()
                
            }, failure: { (error) in
                
                SVProgressHUD.showError(withStatus: "楼栋信息查询失败,请检查网络!")
            })

            
        }
        
    }
    
    //搜索
    @IBAction func searchButtonClick(_ sender: UIButton) {
        
        if self.searchText.text == "" {
            
            self.alert(message: "请输入查询房号")
            
        }else{
            
            var par = [String : Any]()
            par["parkId"] = ""
            par["houseCode"] = ""
            par["stageId"] = ""
            par["floorId"] = ""
            
            SVProgressHUD.show()
            
            HttpClient.instance.post(path: URLPath.getHouse, parameters: par, success: { (response) in
                
                let data = response as? Array<[String : Any]>
                
                if data == nil {
                    SVProgressHUD.showError(withStatus: "没有更多数据!")
                    
                }
                
                
            }, failure: { (error) in
                
                SVProgressHUD.showError(withStatus: "房屋编号查询失败,请检查网络!")
            })
            
        }
        
    }
    

}
