//
//  YQDecorationScreenVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/2/6.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQDecorationScreenVC: UIViewController {

    @IBOutlet weak var decorationRoutButton: UIButton!
    
    @IBOutlet weak var decorationAcceptButton: UIButton!
    /// 当前选中的button
    var currentSelectBtn : UIButton?
    
    @IBOutlet weak var tableView: UITableView!
    
    /// 模拟的cell的数据
    var dataArray = ["区/期","栋","单元","楼","房号"]
    var cellID = "decorationScreenCell"
    
    var selectePrameter = [String : Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "筛选"
//        decorationRoutButton.isSelected = true
//        self.currentSelectBtn = decorationRoutButton
        self.automaticallyAdjustsScrollViewInsets = false
        
        //注册原型cell
        let nib = UINib.init(nibName: "YQDecorationScreenCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellID)
        
        //接受通知的方法
        addNoticeMethod()
    
    }
    
    
    // MARK: - buttonClick方法的应用
    @IBAction func decorationButtonSelect(_ sender: UIButton) {
        
        currentSelectBtn?.isSelected = false
        sender.isSelected = true
        currentSelectBtn = sender
        
    }
    
    @IBAction func cancelButtonSelect(_ sender: UIButton) {
        
        //要求的是,重置筛选按钮
        let center = NotificationCenter.default
        let notiesName = NSNotification.Name(rawValue: "resetHouseNoties")

        center.post(name: notiesName, object: nil)
        
        
        navigationController?.popViewController(animated: true)
        
    }
  
    @IBAction func makeSureButtonClick(_ sender: UIButton) {
        //选择houseid才能确定
        let model = self.selectePrameter["house"] as? YQDecorationHouseModel
        if model == nil  && currentSelectBtn == nil {
            self.alert(message: "请选择房屋号或者类型!")
            return
        }
    
        let center = NotificationCenter.default
        let notiesName = NSNotification.Name(rawValue: "selectHouseNoties")
        
        if currentSelectBtn != nil && model != nil {
            
            center.post(name: notiesName, object: nil, userInfo: [ "selectLocation": (model?.houseId)!,"decorationType" : (currentSelectBtn?.tag)!])
            
        }else if(model == nil ){
        
            center.post(name: notiesName, object: nil, userInfo: [ "decorationType": (currentSelectBtn?.tag)!])

        }else if (currentSelectBtn == nil){
            
            center.post(name: notiesName, object: nil, userInfo: [ "selectLocation": (model?.houseId)!])
        }

        navigationController?.popViewController(animated: true)
        
    }
    
    // MARK: - 接受通知的方法
    func addNoticeMethod(){
        
        let center = NotificationCenter.default
        let notiesName = NSNotification.Name(rawValue: "selectLocationNoties")
    
        center.addObserver(self, selector: #selector(selectLocationParmeter(info:)), name: notiesName, object: nil)
    }
    
    func selectLocationParmeter(info: NSNotification){
        
        let value = info.userInfo?["selectLocation"] as! [String : Any]
        self.selectePrameter = value
        
        self.tableView.reloadData()
        
    }
    
    deinit {
        
        let center = NotificationCenter.default
        center.removeObserver(self)
    }


}

extension YQDecorationScreenVC : UITableViewDataSource,UITableViewDelegate{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! YQDecorationScreenCell
        cell.staticLabel.text = self.dataArray[indexPath.row]
        
        switch (cell.staticLabel.text)! {
        case "区/期":
            
            let model = self.selectePrameter["stage"] as? YQDecorationStageModel
            cell.locationLabel.text = model?.stageName ?? ""
            break
        case "栋":
             let model = self.selectePrameter["floor"] as? YQDecorationFloorModel
            cell.locationLabel.text = model?.floorName ?? ""
            break
        case "单元":
            let model = self.selectePrameter["unitNo"] as? YQDecorationUnitNoModel
            
            cell.locationLabel.text = model?.unitNuName ?? ""
            break
            
        case "楼":
            
            let model = self.selectePrameter["groupNo"] as? YQDecorationGroundNoModel
            cell.locationLabel.text = model?.groundNoName ?? ""
            break

        case "房号":
            let model = self.selectePrameter["house"] as? YQDecorationHouseModel
            
            cell.locationLabel.text = model?.houseName ?? ""
            break
        
        default:
            break
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detail = YQLocationDetailsVC.init(nibName: "YQLocationDetailsVC", bundle: nil)
        detail.selectDict = self.selectePrameter
        detail.titile = self.dataArray[indexPath.row]
        
        navigationController?.pushViewController(detail, animated: true)
        
    
    }

}

