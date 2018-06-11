//
//  PeopleListViewController.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/2/20.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh

class PeopleListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var models = [PersonModel]()
    var orangeModels = [PersonModel]()
    var pageNo = 0
    var isMultipSelect = false
    
    var currentSelecIndex: IndexPath?
    
    
    var isSearchIng = false
    var doneBtnClickHandel: ((Int,[PersonModel]) -> ())?
    var parkId = ""
    var personType = ""
    
    //添加部门显示字段:
    var isWorkOrderSift = false
    
    @IBOutlet weak var rightButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var type = 0 {
        didSet{
            switch type {
            case 0:
                title = "选择执行人"
                personType = "exec"
            case 1:
                title = "选择管理人"
                personType = "manage"
            case 2:
                title = "选择协助人"
                personType = "assis"
                isMultipSelect = true
            default:
                break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //0.系统属性的归零处理情况
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        getPeople()
        addRefirsh()
        
        if isWorkOrderSift {
            
            self.navigationItem.rightBarButtonItem?.customView?.isHidden = true
            self.rightButtonItem.customView?.isHidden = true
            self.rightButtonItem.tintColor = UIColor.clear
        }
    }
    
    func addRefirsh(){
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            
            self.getPeople(indexPage: 0)
            
        })
        
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            
            self.getPeople(indexPage: self.pageNo + 1 )
        })
    }
    
    
    
    func getPeople(indexPage: Int = 0,name: String = ""){
        
        SVProgressHUD.show(withStatus: "加载中...")
        var parmat = [String: Any]()
        
        parmat["pageIndex"] = indexPage
        parmat["pageSize"] = 20
        
        if name != ""{
            
            parmat["name"] = name
        }
        
        //获取集团和 项目版的参数
        let isgroup = UserDefaults.standard.object(forKey: Const.YQIs_Group) as? Int ?? -1
        
        if isgroup == 2 {//集团版
            
        }else{//项目版
            
            parmat["parkId"] = parkId
        }
        
        if isWorkOrderSift {
            
            HttpClient.instance.post(path: URLPath.getPersonQuery, parameters: parmat, success: { (response) in
                
                SVProgressHUD.dismiss()
                
                let data = response["data"] as? Array<[String: Any]>
                
                if data == nil {
                    
                    SVProgressHUD.showError(withStatus: "没有更多数据!")
                    return
                }
                var temp = [PersonModel]()
                for dic in data! {
                    temp.append(PersonModel(parmart: dic))
                }
                
                if self.isSearchIng{
                    self.orangeModels = self.models
                }
                
                if indexPage == 0{
                    
                    self.pageNo = 0
                    self.models = temp
                    self.tableView.mj_header.endRefreshing()
                    
                }else{
                    
                    if temp.count > 0{
                        
                        self.pageNo = indexPage
                        self.models.append(contentsOf: temp)
                        
                    }
                    
                    self.tableView.mj_footer.endRefreshing()
                }
                self.tableView.reloadData()
                
            }, failure: { (error) in
                
                SVProgressHUD.dismiss()
            })
            
            return
            
        }else{
            
            //新增一个选择执行人的类型
            parmat["personType"] = personType
            
            HttpClient.instance.get(path: URLPath.getPersonList, parameters: parmat, success: { (response) in
                
                SVProgressHUD.dismiss()
                
                let data = response["data"] as? Array<[String: Any]>
                
                if data == nil {
                    
                    SVProgressHUD.showError(withStatus: "没有更多数据!")
                    return
                }
                
                var temp = [PersonModel]()
                for dic in data! {
                    temp.append(PersonModel(parmart: dic))
                }
                
                if self.isSearchIng{
                    self.orangeModels = self.models
                }
                
                if indexPage == 0{
                    
                    self.pageNo = 0
                    self.models = temp
                    self.tableView.mj_header.endRefreshing()
                    
                }else{
                    
                    if temp.count > 0{
                        
                        self.pageNo = indexPage
                        self.models.append(contentsOf: temp)
                        
                    }
                    
                    self.tableView.mj_footer.endRefreshing()
                }
                
                self.tableView.reloadData()
                
            }) { (error) in
                
                SVProgressHUD.dismiss()
            }
        }
        
    }
    
    
    
    @IBAction func doneBtnClick(_ sender: UIBarButtonItem) {
        
        let array = models.filter{$0.selected == true}
        
        if array.isEmpty {
            SVProgressHUD.showError(withStatus: "请先选中一个人")
            return
        }
        
        if let block = doneBtnClickHandel {
            
            block(type,array)
            _ = navigationController?.popViewController(animated: true)
        }
    }

}


extension PeopleListViewController: UISearchBarDelegate{

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text{
            isSearchIng = true
            orangeModels = [PersonModel]()
            getPeople(indexPage:0, name: text)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        searchBar.text = nil
        self.pageNo = 0
        isSearchIng = false
        if orangeModels.count > 0{
            models = orangeModels
        }
        
        tableView.reloadData()
//        self.getPeople(indexPage: self.pageNo)
    }
    
}


extension PeopleListViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = models[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! PersonCell
        cell.model = model
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isWorkOrderSift {
            
            if let index = currentSelecIndex?.row{
                
                var model = models[index]
                model.selected = false
                
                model = models[indexPath.row]
                model.selected = true
                tableView.reloadRows(at: [currentSelecIndex!,indexPath], with: .none)
            }else{
                
                let model = models[indexPath.row]
                model.selected = true
                tableView.reloadRows(at: [indexPath], with: .none)
            }
            
            currentSelecIndex = indexPath
            
            let array = models.filter{$0.selected == true}
            
            if let block = doneBtnClickHandel {
                
                block(type,array)
                
                self.navigationController?.popViewController(animated: true)
            }
            
            return
        }
        
        if isMultipSelect{
            let model = models[indexPath.row]
            model.selected = !model.selected
            tableView.reloadRows(at: [indexPath], with: .none)
        }else{
            if let index = currentSelecIndex?.row{
                
                var model = models[index]
                model.selected = false
                
                model = models[indexPath.row]
                model.selected = true
                tableView.reloadRows(at: [currentSelecIndex!,indexPath], with: .none)
            }else{
                
                let model = models[indexPath.row]
                model.selected = true
                tableView.reloadRows(at: [indexPath], with: .none)
            }
            
            currentSelecIndex = indexPath
        }
    }
}
