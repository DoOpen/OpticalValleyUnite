//
//  YQHouseHomeVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/2/9.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit
import MJRefresh
import SVProgressHUD

class YQHouseHomeVC: UIViewController {

    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "房屋查询"

        //1.添加左右bar
        addRightBarButtonItem()
        
        //2.上拉下拉
        addRefirsh()
        
        //3.获取list数据
        getDataForList()
    
    }

 
    // MARK: - 添加rightBarbutton选项
    func addRightBarButtonItem(){
        
        let button = UIButton()
        button.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        button.setTitle("查询", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.sizeToFit()
        button.addTarget(self, action: #selector(screenToHouseVC), for: .touchUpInside)
        
        let barItem = UIBarButtonItem()
        barItem.customView = button
        
        navigationItem.rightBarButtonItem = barItem
        
    }
    
    // MARK: - 筛选界面的跳转执行
    func screenToHouseVC(){
        
        let screenHouse = YQHouseScreenVC.init(nibName: "YQHouseScreenVC", bundle: nil)
        
        navigationController?.pushViewController(screenHouse, animated: true)
    }
    
    // MARK: - 获取list的数据的接口
    func getDataForList(){

        var parmeter = [String : Any]()
        
        SVProgressHUD.show()
        
        HttpClient.instance.post(path: URLPath.getHouseList, parameters: parmeter, success: { (reponse) in
            
            SVProgressHUD.dismiss()
            let data = reponse["data"] as? Array<[String : Any]>
            
            
            
            
        }) { (error) in
            
            SVProgressHUD.showError(withStatus: error.description)
        }
        
    
    }
    
    
    // MARK: - 上下拉的刷新的界面情况
    func addRefirsh(){
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            
            var par = [String : Any]()
//            
//            if self.notiesPramert != nil{
//                
//                for (key,value) in self.notiesPramert! {
//                    
//                    par[key] = value
//                }
//            }
//            
//            self.getDataListFunction(tag: (self.selectButton?.tag)!, currentIndex: 0, pramert: par)
            
        })
        
        
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            
            var par = [String : Any]()
            
//            if self.notiesPramert != nil{
//                
//                for (key,value) in self.notiesPramert! {
//                    
//                    par[key] = value
//                }
//            }
//            
//            self.getDataListFunction(tag: (self.selectButton?.tag)!, currentIndex: self.currentIndex + 1, pramert: par)
            
        })
        
    }

}

extension YQHouseHomeVC : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //界面的跳转情况
        
    }
    
    
}
