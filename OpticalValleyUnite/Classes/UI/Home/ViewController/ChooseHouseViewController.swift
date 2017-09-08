//
//  ChooseHouseViewController.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/1/14.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit
import SVProgressHUD

class ChooseHouseViewController: UIViewController {

    var currentLevel = 0{
        didSet{
            (tempView.subviews[currentLevel] as! UILabel).textColor = Const.SJThemeColor
            tableView.reloadData()
        }
    }
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var nextBtnHeightConstraint: NSLayoutConstraint!
    var tempView = UIView()
    var currentSelectCell: ChooseHouseCell?
    var arry = ["选择分期", "楼栋", "选择房屋"]
//    let arry = ["选择分期", "楼栋"]
    var addressDic = [String: String]()
    var parkId: String?
    var selectParkHandel: ((ParkInfoModel) -> ())?

    var parkInfoModels: [ParkInfoModel]?
    
    var currentParkInfoModel = [ParkInfoModel]()
    
    var isDeviceChoose = false
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "请选择报事房屋"
        
        setupTopView()
        
        if isDeviceChoose{
            nextBtnHeightConstraint.constant = 54.0
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(ChooseHouseViewController.rightBtnClick))
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getDataTool()
    }

    @IBAction func nextBtnClick() {
        if let _ = currentSelectCell {
            
            if currentLevel + 1 != arry.count{
                
                if (currentParkInfoModel[index].child?.count)! > 0{
                    currentParkInfoModel = currentParkInfoModel[index].child!
                    currentLevel += 1
                    
                    if currentLevel + 1 == arry.count{
                        nextBtnHeightConstraint.constant = 0
                    }
                }else{
                    self.alert(message: "没有数据")
                }
                
                

            }
        }
    }
    func rightBtnClick() {
        
        if currentSelectCell == nil{
            return
        }
        
        let index = tableView.indexPath(for: currentSelectCell!)!.row
        if selectParkHandel != nil{
            
            selectParkHandel!(currentParkInfoModel[index])
        }
        
        _ = self.navigationController?.popViewController(animated: true)
        
    }

    func setupTopView(){
        var lastX: CGFloat = 0.0
        for text in arry{
            let label = UILabel()
            label.text = text
            label.font = UIFont.systemFont(ofSize: 13)
            label.textColor = UIColor.colorFromRGB(rgbValue: 0xc5c5c5)
            label.sizeToFit()
            label.frame = CGRect(x: lastX, y: 0, width: label.width + 5, height: topView.height)
            tempView.addSubview(label)
            lastX = label.maxX
        }
        tempView.width = lastX
        tempView.height = topView.height
        tempView.y = 0
        tempView.x = (SJScreeW - lastX) * 0.5
        topView.addSubview(tempView)
        currentLevel = 0
    }
    
    func getDataTool(){
        
        if parkId == nil {
            self.alert(message: "请先返回上一步选择一个项目")
            return
        }
        
        
        HttpClient.instance.get(path: URLPath.getParkInfoById, parameters: ["PARK_ID": parkId!], success: { (response) in
            
            var temp = [ParkInfoModel]()
            for dic in response as! Array<[String: Any]> {
                temp.append(ParkInfoModel(parmart: dic))
            }
            
            self.parkInfoModels = temp
            if temp.count > 0{
                self.currentParkInfoModel = temp
                self.tableView.reloadData()
            }else{
                SVProgressHUD.showSuccess(withStatus: "数据为空")
            }
            
            
        }) { (error) in
            print(error)
        }
    }
    
}

extension ChooseHouseViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentParkInfoModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()

            cell = tableView.dequeueReusableCell(withIdentifier: "houseCell")!
            if let cell = cell as? ChooseHouseCell{
                cell.addressLabel.text = currentParkInfoModel[indexPath.row].name
                cell.setSelectCellClick(false)
            }
            
    
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if currentLevel == 0 && parkInfoModels?[indexPath.row].child != nil && !isDeviceChoose{
            currentLevel = 1
            nextBtnHeightConstraint.constant = 54.0
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(ChooseHouseViewController.rightBtnClick))
            
            if parkInfoModels?[indexPath.row].child == nil{
                
            }else{
                if (parkInfoModels?[indexPath.row].child?.count)! > 0 {
                    currentParkInfoModel = (parkInfoModels?[indexPath.row].child)!
                }
                tableView.reloadData()
            }
        }else{
            currentSelectCell?.setSelectCellClick(false)
            currentSelectCell = tableView.cellForRow(at: indexPath) as! ChooseHouseCell?
            currentSelectCell?.setSelectCellClick(true)
            index = indexPath.row
            
        }
        
    }
}