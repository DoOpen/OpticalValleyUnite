//
//  SignInListViewController.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/1/12.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit
import SVProgressHUD

class SignInListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateView: DateChooseView!

    
    var models = [SignModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = Date.dateStringDate(dateFormetString: "YYYY-MM-dd")
        
        getData(Date.dateStringDate(dateFormetString: "YYYY-MM-dd"))
        let nib = UINib(nibName: "SigninCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
//        dateView.selecIndex = 6
        
        dateView.didSelectHandle = { [weak self] dateStr in
            
            self?.getData(dateStr)
            self?.title = dateStr
            
        }
        
    }
    
    func getData(_ date: String){
        
        var parmat = [String: Any]()
        parmat["DATE"] = date
        
        let url = URLPath.getPersonSinList
        
        SVProgressHUD.show()
        
        HttpClient.instance.get(path: url, parameters: parmat, success: { (response) in
            
            SVProgressHUD.dismiss()
            
            var temp = [SignModel]()
            
            if let arry = response as? Array<[String: Any]>{
                for dic in arry {
                    let model = SignModel(parmart: dic)
                    temp.append(model)
                }
            }

            if temp.isEmpty{
                SVProgressHUD.showSuccess(withStatus: "数据为空")
            }
            
            self.models = temp
            self.tableView.reloadData()
            
        }) { (error) in
            
        }
    }

}

extension SignInListViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SigninCell
        
        let model = models[indexPath.row]
        model.index = indexPath.row
        cell.model = model
        
        return cell
    }
}
