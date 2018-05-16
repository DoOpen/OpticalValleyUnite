//
//  YQHouseLocationScreenView.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/2/9.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

protocol YQHouseLocationScreenViewDelegate : class {
    
    func houseLocationScreenViewJumpToLocation(selecteTitile : String ,indexPathRow : Int)
    
    func houseCheckOutClickDelegate()
}

class YQHouseLocationScreenView: UIView {
    
    /// 数据cell
    var dataArray = ["选择项目","区/期","栋","单元","楼","房号"]
    
    var cellID = "decorationScreenCell"
    
    var delegate : YQHouseLocationScreenViewDelegate?
    
    /// 选值参数
    var selectePrameter = [String : Any](){
        
        didSet{//一旦值选中改变就 刷新列表
        
            self.tableView.reloadData()
        }
    
    }

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func checkoutButtonClick(_ sender: UIButton) {
        
        self.delegate?.houseCheckOutClickDelegate()
    }
    
    // MARK: - 添加默认的项目选择方法
    func setUpProjectNameLable() -> String{
        
        let dic = UserDefaults.standard.object(forKey: Const.YQProjectModel) as? [String : Any]
        
        var projectName  = ""
        
        if dic != nil {
            
            projectName = dic?["PARK_NAME"] as! String
            
        }else{
            
            projectName = "请选择默认项目"
        }
        
        return projectName
    }

    
}

extension YQHouseLocationScreenView : UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.delegate?.houseLocationScreenViewJumpToLocation(selecteTitile: self.dataArray[indexPath.row], indexPathRow: indexPath.row)
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? YQDecorationScreenCell
        if cell == nil {
            
            cell = Bundle.main.loadNibNamed("YQDecorationScreenCell", owner: nil, options: nil)?[0] as? YQDecorationScreenCell

        }
        
        cell?.staticLabel.text = self.dataArray[indexPath.row]
        
        switch (cell?.staticLabel.text)! {
        case "选择项目":
            
            cell?.locationLabel.text =  setUpProjectNameLable()
            break
            
        case "区/期":
            
            let model = self.selectePrameter["stage"] as? YQDecorationStageModel
            cell?.locationLabel.text = model?.stageName ?? ""
            break
            
        case "栋":
            let model = self.selectePrameter["floor"] as? YQDecorationFloorModel
            cell?.locationLabel.text = model?.buildName ?? ""
            break
            
        case "单元":
            
            let model = self.selectePrameter["unitNo"] as? YQDecorationUnitNoModel
            cell?.locationLabel.text = model?.unitNo ?? ""
            break
            
        case "楼":
            
            let model = self.selectePrameter["groupNo"] as? YQDecorationGroundNoModel
            cell?.locationLabel.text = model?.groundNo ?? ""
            break
            
        case "房号":
            let model = self.selectePrameter["house"] as? YQDecorationHouseModel
            
            cell?.locationLabel.text = model?.houseName ?? ""
            break
            
        default:
            break
        }
        
        return cell!
    }
    
}
