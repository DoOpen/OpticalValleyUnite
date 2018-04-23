//
//  YQGenaralFeedBackListVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/4/21.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh

class YQGenaralFeedBackListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var dataArray  = [YQGeneralFeedBackModel]()
    
    var cellID = "generalFeedBackCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "我的反馈"
        
        self.getGenaralFeedBackListData()
        
    }
    

    // MARK: - 获取list的数据列表
    func getGenaralFeedBackListData(){
        
        SVProgressHUD.show()
        
        HttpClient.instance.post(path: URLPath.getgm_emailMyList, parameters: nil
            , success: { (response) in
                
                SVProgressHUD.dismiss()
                let data = response["feedbackList"] as? Array<[String : Any]>
                
                if data == nil{
                    SVProgressHUD.showError(withStatus: "没有更多数据!")
                    return
                }
                //字典转模型的操作!
                var tempArray = [YQGeneralFeedBackModel]()
                
                for dict in data!{
                    
                    tempArray.append(YQGeneralFeedBackModel.init(dict: dict))
                    
                }
                
                self.dataArray = tempArray
                self.tableView.reloadData()
                
        }) { (error) in
            
            SVProgressHUD.showError(withStatus: "数据加载失败,请检查网络!")
        }
    }

}

extension YQGenaralFeedBackListVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! YQGeneralFeedBackCell
        
        cell.model = self.dataArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let feedbackDetailVC = YQGenaralFeedBackDetailVC.init(nibName: "YQGenaralFeedBackDetailVC", bundle: nil)
        
       feedbackDetailVC.id = self.dataArray[indexPath.row].id
        
        self.navigationController?.pushViewController(feedbackDetailVC, animated: true)

    }
    
}
