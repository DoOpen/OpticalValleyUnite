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
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //1.init
        self.title = "我的反馈"
        self.automaticallyAdjustsScrollViewInsets = false
        
        //2.网络数据加载
        self.getGenaralFeedBackListData()
        
        //3.上拉下拉
        addRefirsh()
        
    }
    

    // MARK: - 获取list的数据列表
    func getGenaralFeedBackListData(pageIndex : Int = 0,pageSize : Int = 20){
        
        var par = [String : Any]()
        
        par["pageIndex"] = pageIndex
        par["pageSize"] = pageSize
        
        SVProgressHUD.show()
        
        HttpClient.instance.post(path: URLPath.getgm_emailMyList, parameters: par
            , success: { (response) in
                
                SVProgressHUD.dismiss()
                
                let dictTotall = response["feedbackList"] as? [String : Any]
                
                if dictTotall != nil{
                    
                    let data = dictTotall!["data"] as? Array<[String : Any]>
                    
                    if data == nil {
                        
                        SVProgressHUD.showError(withStatus: "没有更多数据!")
                        self.tableView.mj_header.endRefreshing()
                        self.tableView.mj_footer.endRefreshing()
                        return
                        
                    }else{
                        
                        //字典转模型的操作!
                        var tempModel = [YQGeneralFeedBackModel]()
                        
                        for dict in data!{
                            
                            tempModel.append(YQGeneralFeedBackModel.init(dict: dict))
                            
                        }
                        
                        //添加上拉下拉刷新的情况
                        if pageIndex == 0 {
                            
                            self.dataArray = tempModel
                            self.tableView.mj_header.endRefreshing()
                            
                        }else{
                            
                            if tempModel.count > 0{
                                
                                self.currentIndex = pageIndex
                                self.dataArray.append(contentsOf: tempModel)
                            }
                            
                            self.tableView.mj_footer.endRefreshing()
                        }
                        
                        self.tableView.reloadData()
                    }
                }
                
        }) { (error) in
            
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            SVProgressHUD.showError(withStatus: "数据加载失败,请检查网络!")
        }
    }
    
    // MARK: - 上下拉的刷新的界面情况
    func addRefirsh(){
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            
            self.getGenaralFeedBackListData()
        })
        
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            
            self.getGenaralFeedBackListData(pageIndex: self.currentIndex + 1)
            
        })
        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let feedbackDetailVC = YQGenaralFeedBackDetailVC.init(nibName: "YQGenaralFeedBackDetailVC", bundle: nil)
        
        feedbackDetailVC.id = "\(self.dataArray[indexPath.row].id)"
        self.navigationController?.pushViewController(feedbackDetailVC, animated: true)

    }
    
}
