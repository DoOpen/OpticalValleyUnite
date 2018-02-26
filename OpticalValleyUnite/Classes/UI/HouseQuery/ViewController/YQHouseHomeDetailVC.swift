//
//  YQHouseHomeDetailVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/2/19.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit
import SVProgressHUD


class YQHouseHomeDetailVC: UIViewController {

    var dataArray = ["业主亲属&租户","设备清单","工单列表"]
    
    @IBOutlet weak var tableView: UITableView!
    
    /// 房屋详细信息
    @IBOutlet weak var houseNum: UILabel!
    @IBOutlet weak var ownerName: UILabel!
    @IBOutlet weak var ownerTel: UILabel!
    
    var houseModel : YQHouseQueryHomeModel?
    
    var cellID = "houseDetailCell"
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "房屋巡查详情"

        //通过模型来进行设置
        getOwerDetail()
        
    }
    
    func getOwerDetail(){
        
        var par = [String : Any]()
        
        par["houseId"] = self.houseModel?.id
        self.houseNum.text = self.houseModel?.houseCode
        
        SVProgressHUD.show()
        
        HttpClient.instance.post(path: URLPath.getHouseGet, parameters: par, success: { (response) in
            
            SVProgressHUD.dismiss()
            
            let data = response as? [String : Any]
            self.ownerName.text = data?["ownerName"] as? String
            self.ownerTel.text = data?["phone"] as? String
            
        }) { (error) in
            
            SVProgressHUD.showError(withStatus: "数据查询失败,请检查网络!")
        }
        
    }
    
    // MARK: - 查询按钮的点击事件
    @IBAction func searchButtonClick(_ sender: UIButton) {
        
        
    }
    
}

extension YQHouseHomeDetailVC : UITableViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //点击的跳转到详情的界面  (注意的是:这些的条件的查询 都是需要houseID来进行的实现的)
        switch self.dataArray[indexPath.row] {
            
            case "业主亲属&租户":
                let relativesTenantVC = UIStoryboard.instantiateInitialViewController(name: "YQHouseRelativesAndTenant") as! YQHouseRelativesAndTenantVC
                
                relativesTenantVC.houseID =  self.houseModel?.id
                
                navigationController?.pushViewController(relativesTenantVC, animated: true)
                break
            
            case "设备清单":
                
                let equipmentVC = UIStoryboard.instantiateInitialViewController(name: "YQEquipmentListTVC") as! YQEquipmentListTVC
                
                equipmentVC.houseID = self.houseModel?.id
                navigationController?.pushViewController(equipmentVC, animated: true)
                
                break
            
            case "工单列表":
                
                let workVC = UIStoryboard.instantiateInitialViewController(name: "YQWorkListVC") as! YQWorkListVC
                workVC.houseID = self.houseModel?.id
                
                navigationController?.pushViewController(workVC, animated: true)
                break
            
            default:
                break
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        cell?.textLabel?.text = self.dataArray[indexPath.row]
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
    }
    

}
