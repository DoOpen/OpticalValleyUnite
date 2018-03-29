//
//  CallBackListViewController.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/6/6.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit

class CallBackListViewController: UITableViewController {

    
    var callBackModels = [CallbackModel](){
        didSet{
            
            tableView.reloadData()
        }
    }
    
    var workOrderDetalModel: WorkOrderDetailModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "回访记录"
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 0)
        tableView.separatorStyle = .singleLine
        
        tableView.tableFooterView = UIView()
        
    }




}

extension CallBackListViewController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return callBackModels.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "callBackxiangqing") as! WorkOrderDetailsCell
            
            cell.callBackCell = true
            cell.model = workOrderDetalModel
            
            return cell
            
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "callBackCell") as! CallBackCell
            cell.model = callBackModels[indexPath.row - 1]
            
            cell.upLineView.isHidden = false
            cell.downLineView.isHidden = false
            
            if indexPath.row == 1{
                
                cell.circleView.backgroundColor = UIColor.blue
                
            }else if indexPath.row == callBackModels.count{
                
                cell.circleView.backgroundColor = UIColor.colorFromRGB(rgbValue: 0xcccccc)
                
            }else{
                
                cell.circleView.backgroundColor = UIColor.colorFromRGB(rgbValue: 0xcccccc)
            }
            
            return cell
        }
    }
}
