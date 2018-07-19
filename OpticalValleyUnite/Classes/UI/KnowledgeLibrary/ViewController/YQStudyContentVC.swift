//
//  YQStudyContentVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/5/3.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh

class YQStudyContentVC: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    var cellID = "studyCell"
    
    var dataArray = [YQStudyListModel]()
    var currentIndex = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //1.init
        self.title = "学习"

        //2.注册原型cell
        let nib = UINib.init(nibName: "YQKnowledgeStudyCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: cellID)
        
        //3.获取数据
        getDataForServer()
        addRefirsh()
        
    }
    
    func getDataForServer(pageIndex : Int = 0,pageSize : Int = 20){
        
        var par = [String : Any]()
        par["parkId"] = self.setUpProjectNameLable()
        par["pageIndex"] = pageIndex
        par["pageSize"] = pageSize
        
        SVProgressHUD.show()
        
        HttpClient.instance.post(path: URLPath.getNewknowledgeList, parameters: par, success: { (response) in
            
            SVProgressHUD.dismiss()
            
            let data = response["data"] as? Array<[String : Any]>
            
            if data == nil || (data?.isEmpty)!{
                
                return
            }
            
            var tempArray = [YQStudyListModel]()
            
            for dict in data! {
                
                tempArray.append(YQStudyListModel.init(dic: dict))
            }
            
            if pageIndex == 0{
                
                self.currentIndex = 0
                self.dataArray = tempArray
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.resetNoMoreData()
                
            }else{
                
                if tempArray.count > 0{
                    
                    self.currentIndex = pageIndex
                    self.dataArray.append(contentsOf: tempArray)
                    self.tableView.mj_footer.endRefreshing()
                    
                }else{
                    
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                }
            }
            
            self.tableView.reloadData()
            
        }) { (error) in
            
            SVProgressHUD.showError(withStatus: "网络数据加载失败,请检查网络!")
        }
        
    }
    
    // MARK: - 添加默认的项目选择方法
    func setUpProjectNameLable() -> String{
        
        let dic = UserDefaults.standard.object(forKey: Const.YQProjectModel) as? [String : Any]
        
        var projectId  = ""
        
        if dic != nil {
            projectId = (dic?["ID"] as? String)!
        }
        
        return projectId
    }
    
    // MARK: - 上下拉的刷新的界面情况
    func addRefirsh(){
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            
            self.getDataForServer()
        })
        
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            
            self.getDataForServer(pageIndex: self.currentIndex + 1)
        })
        
    }
    
    

}

extension YQStudyContentVC : UITableViewDelegate,UITableViewDataSource{

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! YQKnowledgeStudyCell
        
        cell.model = self.dataArray[indexPath.row]
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = YQStudyDetailVC.init(nibName: "YQStudyDetailVC", bundle: nil)
        vc.id = "\(self.dataArray[indexPath.row].id)"
        self.navigationController?.pushViewController(vc, animated: true)
    
    }
    
    
}
