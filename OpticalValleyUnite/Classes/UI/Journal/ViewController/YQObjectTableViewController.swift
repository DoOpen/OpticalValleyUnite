//
//  YQObjectTableViewController.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/10/30.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit
import SVProgressHUD

class YQObjectTableViewController: UITableViewController {
    
    var filterModel : YQFilterParkModel?
    
    var departmentModel : YQFilterDeptModel?
    
    var dataList : [YQFilterPersonModel]?{
        didSet{
            
            self.personTableView.reloadData()
        }
        
    }
    
    @IBOutlet var personTableView: UITableView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //添加rightbar的完成按钮
        let button = UIButton()
        button.frame = CGRect(x:0,y:0,width:40,height:40)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.setTitle("完成", for: .normal)
        button.addTarget(self, action: #selector(compeletedButtonClick), for: .touchUpInside)
        
        let rightBar = UIBarButtonItem()
        rightBar.customView = button
        self.navigationItem.rightBarButtonItem = rightBar
        
    }
    
    func getPersonListData(){
    
        var paramet = [String : Any]()
        paramet["deptId"] = departmentModel?.deptId
        
        SVProgressHUD.show(withStatus: "数据加载中")
        
        HttpClient.instance.get(path: URLPath.getFilterPersonList, parameters: paramet, success: { (respones) in
            SVProgressHUD.dismiss()
            //字典转模型,数据显示
            let array = respones["personList"] as! NSArray
            
            var dic = [YQFilterPersonModel]()
            
            for temp in array{
                
                dic.append(YQFilterPersonModel.init(dic: temp as! [String : Any]))
                
            }
            
            self.dataList = dic
            
        }) { (error) in
            
            SVProgressHUD.showError(withStatus: error.debugDescription)
        }

    }
    
    
    
    // MARK: - 完成按钮的点击实现
    func compeletedButtonClick() {
        
        //读取选择的数据
        
        //跳转到根控制器来执行
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    
    // MARK: - tableView 的代理方法和数据源方法
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return (self.dataList?.count)! 
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "object", for: indexPath)
        
        let model = self.dataList?[indexPath.row]
        
        cell.textLabel?.text = model?.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //选择相应行号对应的数据 添加选择数据
        
        
    }
    

}
