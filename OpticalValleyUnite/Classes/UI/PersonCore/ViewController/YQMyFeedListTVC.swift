//
//  YQMyFeedListTVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/4/2.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh

class YQMyFeedListTVC: UITableViewController {

    var cellID = "feedBackCell"
    
    var dataArray = [YQFeedbackListModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1.initset
        self.title = "我的反馈"
        
        //2.加载数据
        self.getFeedDetailListData()
        
        //3.添加上拉下拉刷新
        
    }
    
    
    // MARK: - 获取网络数据
    func getFeedDetailListData(pageIndex : Int = 0,pageSize : Int = 20){
        
        var par = [String : Any]()
        
        par["pageSize"] = pageSize
        par["pageIndex"] = pageIndex
        
        SVProgressHUD.show()
        
        HttpClient.instance.post(path: URLPath.getFeedbackList, parameters: par, success: { (response) in
            
            SVProgressHUD.dismiss()
            
            let list = response["feedbackList"] as? [String : Any]
            
            if list != nil {
                
                let data = list!["data"] as? Array<[String : Any]>
                
                if data != nil {
                    //字典转模型的操作
                    var tempModel = [YQFeedbackListModel]()
                    
                    for dict in data!{
                        
                        let model = YQFeedbackListModel.init(dict: dict)
                        tempModel.append(model)
                    }
                    
                    self.dataArray = tempModel
                    self.tableView.reloadData()
                    
                }else{
                    
                    SVProgressHUD.showError(withStatus: "数据加载为空!")
                    return
                }
                
            }else{
                
                SVProgressHUD.showError(withStatus: "数据加载为空!")
                return
            }

        }) { (error) in
            
            SVProgressHUD.showError(withStatus: "网络加载失败,请检查网络!")
        }
    
    
    }


    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        

        return self.dataArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! YQMyFeedBackCell
        
        cell.model = self.dataArray[indexPath.row]

        return cell
    }
 
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = YQFeedDetailVC.init(nibName: "YQFeedDetailVC", bundle: nil)
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }


}
