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
    @IBOutlet weak var searchBar: UISearchBar!
    
    var type = 0 {
        didSet{
            switch type {
            case 0:
                title = "选择执行人"
                
            case 1:
                title = "选择管理人"
                
            case 2:
                title = "选择协助人"
                isMultipSelect = true
            default:
                break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getPeople()
        addRefirsh()
    }
    
    func addRefirsh(){
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.getPeople()
        })
        
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            
            self.getPeople(indexPage: self.pageNo + 1)
        })
    }
    
    func getPeople(indexPage: Int = 0,name: String = ""){
        
        SVProgressHUD.show(withStatus: "加载中...")
        var parmat = [String: Any]()
        parmat["pageIndex"] = indexPage
        if name != ""{
            parmat["NAME"] = name
        }
        parmat["parkId"] = parkId
        HttpClient.instance.get(path: URLPath.getPersonList, parameters: parmat, success: { (response) in
            SVProgressHUD.dismiss()
            var temp = [PersonModel]()
            for dic in response["list"] as! Array<[String: Any]>{
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
                    self.pageNo = indexPage + 1
                    self.models.append(contentsOf: temp)
                    self.tableView.mj_footer.endRefreshing()
                }else{
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                }
            }
            
            self.tableView.reloadData()
            
        }) { (error) in
            SVProgressHUD.dismiss()
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
