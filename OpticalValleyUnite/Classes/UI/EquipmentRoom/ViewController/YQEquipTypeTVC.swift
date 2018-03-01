//
//  YQEquipTypeTVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/2/28.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit
import SVProgressHUD

class YQEquipTypeTVC: UITableViewController {

    //数据data
    var dataArray = Array<[String : Any]>()
    
    //回调函数
    var selectCellClickHandel: (([String: Any]) -> ())?

    //已选的selectTypeString
    var selectTypeString  : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getData()
        
        
    }

    // MARK: - 获取数据的方法
    func getData(){
    
        let par = [String : Any]()
        
        SVProgressHUD.show()
        
        HttpClient.instance.post(path: URLPath.getHouseTypeList, parameters: par, success: { (response) in
            SVProgressHUD.dismiss()
            
            let data = response as? Array<[String : Any]>
            
            if data == nil {
                SVProgressHUD.showError(withStatus: "没有更多的数据!")
                return
            }
            
            self.dataArray = data!
            self.tableView.reloadData()
            
        }) { (error) in
            
            SVProgressHUD.showError(withStatus: "数据加载失败,请检查网络!")
        }
    
    }
    

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArray.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "typeCell", for: indexPath)
        
        let dict = self.dataArray[indexPath.row]
        
        cell.textLabel?.text = dict["equipTypeName"] as? String
        let type = dict["equipTypeId"] as? Int
        
        if (type == selectTypeString) {//相同的选中项 设置相同
            
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableViewScrollPosition.none)
        }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let block = selectCellClickHandel{
            //通过的是block的回调来进行的传值,如果是需要保存的话,要求保存paramert 的参数
            block(self.dataArray[indexPath.row])
        }
        
        selectCellClickHandel = nil
    }
    
    
  
}
