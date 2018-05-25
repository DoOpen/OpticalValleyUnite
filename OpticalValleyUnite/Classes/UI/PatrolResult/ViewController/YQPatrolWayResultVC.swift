//
//  YQPatrolWayResultVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/5/25.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit
import SVProgressHUD

class YQPatrolWayResultVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var id : String = ""
    
    var dataArray = [YQPatrolWayResultModel]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //init
        self.title = "巡查结果"
        
        getDataWayResultForService()
      
    }
    
    // MARK: - 加载点位数据的方法
    func getDataWayResultForService(){
        
        var par = [String : Any]()
        par["id"] = id
        
        SVProgressHUD.show()
        
        HttpClient.instance.post(path:URLPath.getResultInsPointList , parameters: par, success: { (response) in
            
            SVProgressHUD.dismiss()
            let data = response["data"] as? Array<[String : Any]>
            
            if data == nil || (data?.isEmpty)! {
                
                SVProgressHUD.showError(withStatus: "没有更多数据!")
                return
            }
            
            var tempArray = [YQPatrolWayResultModel]()
            
            for dict in data! {
                
                tempArray.append(YQPatrolWayResultModel.init(dict: dict))
                
            }
            
            self.dataArray = tempArray
            self.tableView.reloadData()
            
            }, failure: { (error) in
                
              SVProgressHUD.showError(withStatus: "数据加载失败,请检查网络!")
        })
    }
    

}

extension YQPatrolWayResultVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "") as? YQPatrolWayResultCell
        
        if cell == nil {
            
            cell = Bundle.main.loadNibNamed("YQPatrolWayResultCell", owner: nil, options: nil)?[0] as! YQPatrolWayResultCell
        }
        
        cell?.model = self.dataArray[indexPath.row]
        
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detail = UIStoryboard.instantiateInitialViewController(name : "YQResultDetail") as? YQResultDetailViewController
        
        let model = self.dataArray[indexPath.row]
        detail?.insResultId = model.insResultId
        navigationController?.pushViewController(detail!, animated: true)
        
    }
    
}

