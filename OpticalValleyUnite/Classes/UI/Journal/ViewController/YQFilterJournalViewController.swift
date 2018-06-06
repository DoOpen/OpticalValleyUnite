//
//  YQFilterJournalViewController.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/10/13.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit
import SVProgressHUD

class YQFilterJournalViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    //模型数据
    var dataList : [YQFilterParkModel]?{
        didSet{
        
            self.tableView.reloadData()
        }
    }

    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.title = "选择项目"
        
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getFilterData()
    }
    
    func getFilterData(){

        let paramet = [String : Any]()
        
        SVProgressHUD.show(withStatus: "数据加载中")
        
        HttpClient.instance.get(path: URLPath.getFilterParkList, parameters: paramet, success: { (respones) in
            SVProgressHUD.dismiss()
            //字典转模型,数据显示
            let array = respones["parkList"] as! NSArray
            
            var dic = [YQFilterParkModel]()
            
            for temp in array{
                
                dic.append(YQFilterParkModel.init(dic: temp as! [String : Any]))
            
            }
            
            self.dataList = dic
            
        }) { (error) in
            
            SVProgressHUD.showError(withStatus: "数据加载失败,请检查网络!")
        }
        
    }

}

extension YQFilterJournalViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "filterJournal", for: indexPath)
        
        cell.textLabel?.numberOfLines = 0
        
        let model = self.dataList?[indexPath.row]
        
        cell.textLabel?.text = model?.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //传递模型,跳转到(项目 -->  部门 --> 对象)
        let department = UIStoryboard.instantiateInitialViewController(name: "YQFilterDepartment") as? YQDepartmentTableViewController
        department?.filerModel = self.dataList?[indexPath.row]
        
        self.navigationController?.pushViewController(department!, animated: true)
        
    }

}
