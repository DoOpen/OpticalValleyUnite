//
//  YQStudyContentVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/5/3.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit
import SVProgressHUD


class YQStudyContentVC: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    var cellID = "studyCell"
    
    var dataArray = [YQStudyListModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //1.init
        self.title = "学习"

        //2.注册原型cell
        let nib = UINib.init(nibName: "YQKnowledgeStudyCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: cellID)
        
    }
    
    func getDataForServer(){
        
        var par = [String : Any]()
        par["parkId"] = ""
        
        SVProgressHUD.show()
        
        HttpClient.instance.post(path: URLPath.getNewknowledgeList, parameters: par, success: { (response) in
            
            SVProgressHUD.dismiss()
            
            let data = response as? Array<[String : Any]>
            
            if data == nil || (data?.isEmpty)!{
                
                return
            }
            
            var tempArray = [YQStudyListModel]()
            
            for dict in data! {
                
                tempArray.append(YQStudyListModel.init(dic: dict))
            }
            
            self.dataArray = tempArray
            
            
        }) { (error) in
            
            SVProgressHUD.showError(withStatus: "网络数据加载失败,请检查网络!")
        }
        
    }
    
    
    

}

extension YQStudyContentVC : UITableViewDelegate,UITableViewDataSource{

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 30
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = YQStudyDetailVC.init(nibName: "YQStudyDetailVC", bundle: nil)
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    
}
