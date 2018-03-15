//
//  YQAllProjectSelectVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/10/19.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit
import MJRefresh


class YQAllProjectSelectVC: UIViewController {
    
    // MARK: - 属性
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    var isMultipSelect = false
    
    var currentSelecIndex: IndexPath?
    
    var projectData = [ProjectModel](){
        
        didSet{
            
            let projectName = getUserDefaultsProject()
            for index in 0 ..< projectData.count {
                
                let model = projectData[index]
                if projectName == model.projectName {
                    
                    model.selected = true
                    let indexPath = IndexPath.init(row: index, section: 0)
                    self.currentSelecIndex = indexPath as IndexPath
                }
            }
            
            self.tableView.reloadData()
        }
    }
    
    var isAll : Int = 2 // 默认是关联自己的
    
    
    // MARK: - 控制器加载的方法
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "项目选择"
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        button.setTitle("重置", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.addTarget(self, action: #selector(resetButtonClick), for: .touchUpInside)
        
        let barView = UIBarButtonItem()
        barView.customView = button
        
        navigationItem.rightBarButtonItem = barView
        
        //获取数据
        getProjectData()
        //添加刷新
        addRefirsh()
        
    }
    
    // MARK: - 重置按钮的点击方法
    func resetButtonClick(){
        
        
        if currentSelecIndex == nil {
            
            return
            
        }else{
            
            if projectData.isEmpty {
                
                return
            }
            
            self.tableView.deselectRow(at: currentSelecIndex!, animated: true)
            
            if let index = currentSelecIndex?.row{
                
                let model = projectData[index]
                model.selected = false
            }
            
            tableView.reloadRows(at: [currentSelecIndex!], with: .none)
            currentSelecIndex = nil
            //重置没有清空缓存
            UserDefaults.standard.removeObject(forKey: Const.YQProjectModel)
            
        }
        
    }
    
    // MARK: - 获取默认的项目的值来显示
    func getUserDefaultsProject() -> String {
        
        let dic = UserDefaults.standard.object(forKey: Const.YQProjectModel) as? [String : Any]
        
        var projectName  = ""
        
        if dic != nil {
            projectName = dic?["PARK_NAME"] as! String
        }
        
        return projectName
    }

    // MARK: - 获取项目data的数据
    func getProjectData(){
        
        var par = [String : Any]()
        
        par["isAll"] = self.isAll // 1是查全部的项目; 2是关联自己的项目
        
        HttpClient.instance.get(path: URLPath.getParkList, parameters: nil, success: { (response) in
            
            
            var temp = [ProjectModel]()
            for dic in response as! Array<[String: Any]> {
                temp.append(ProjectModel(parmart: dic))
            }
            
            self.projectData = temp
            
            //必须加上结束刷新
            self.tableView.mj_header.endRefreshing()
            
        }) { (error) in
            
        }
    }

    // MARK: - 上下拉的刷新的界面情况
    func addRefirsh(){
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            
            self.getProjectData()
            
        })
        
//        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
//            
//            self.getProjectData(indexPage: self.pageNo + 1)
//        })
        
    }
    
    
    // MARK: - 本地数据的模糊查询方法
    func fuzzyQueryMethod(text : String){
        
        var temp =  [ProjectModel]()
        
        for model in self.projectData {
            let projectN = model.projectName
            
            if projectN.components(separatedBy: text).count > 1  {
                
                temp.append(model)
            }
        }
        
        self.projectData = temp
    
    }

}


extension YQAllProjectSelectVC : UITableViewDelegate,UITableViewDataSource,YQProjectTableViewCellDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.projectData.count

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        if isMultipSelect{//这个逻辑是可以进行多选的情况
//            
//            let model = projectData[indexPath.row]
//            model.selected = !model.selected
//            tableView.reloadRows(at: [indexPath], with: .none)
//            
//        }
        
        if let index = currentSelecIndex?.row{//上一次有选中的
            var model = projectData[index]
            
            if index == indexPath.row {//重复同时选中的一个
                
                model.selected = !model.selected
                tableView.reloadRows(at: [currentSelecIndex!], with: .none)
                
            }else{
            
                model.selected = false
                
                model = projectData[indexPath.row]
                model.selected = true
                tableView.reloadRows(at: [currentSelecIndex!,indexPath], with: .none)
            }
            
        }else{
            
            let model = projectData[indexPath.row]
            model.selected = true
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        currentSelecIndex = indexPath
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! YQProjectTableViewCell
        cell.model = self.projectData[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        // footer
        let footer = Bundle.main.loadNibNamed("YQProjectSelectFooter", owner: nil, options: nil)?[0] as? YQProjectSelectFooterView
        footer?.delegate = self
        
        return footer!
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
        
    }
    
    
    // MARK: - 点击完成的 数据的保存添加的功能实现
    func projectSelectCompletedClick() {
        
        if let index = currentSelecIndex?.row {
            
            let model = self.projectData[index]
            // json化一个组织数组 array
            // let jsonData = try JSONSerialization.data(withJSONObject: arry, options: JSONSerialization.WritingOptions.prettyPrinted)
            var dic = [String : Any]()
            dic["PARK_NAME"] = model.projectName
            dic["ID"] = model.projectId
            
            //应用归档解档来存储项目名称
            UserDefaults.standard.set(dic, forKey: Const.YQProjectModel)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    
}


extension YQAllProjectSelectVC : UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text{
            //自定义的模糊查询的方法
            self.fuzzyQueryMethod(text: text)
            
            self.currentSelecIndex = nil
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.view.endEditing(true)
        
        searchBar.text = nil
        self.getProjectData()
        
    }
    

}

