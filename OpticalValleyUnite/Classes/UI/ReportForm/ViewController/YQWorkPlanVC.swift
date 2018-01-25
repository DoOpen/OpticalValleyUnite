//
//  YQWorkPlanVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/1/16.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit
import SVProgressHUD
import SnapKit

class YQWorkPlanVC: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    var dataArray = [YQAddWorkPlanModel]()
    
    var cellID = "AddWorkPlan"
    
    var id : Int = 0
    var parkID = ""

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.title = "工作计划"
        
        let _ = setUpProjectNameLable()
        
        //注册原型cell 设置cell的每个的行高的情况
        let nib = UINib(nibName: "YQAddWorkPlan", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellID)

        //设置原型model的情况,内存保存的情况
        let model = YQAddWorkPlanModel(dic: [String : Any]())
        dataArray.append(model)
        
        self.tableView.reloadData()
    }

    @IBAction func makeSureButtonClick(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        var fristParmerte = [String : Any]()
        
        //调用保存接口,保存add工作计划报告
        var par = [String : Any]()
        par["id"] = id
        par["parkId"] = self.parkID
        
        
        var array = Array<[String : Any]>()
        
        for model in self.dataArray {
            var dict = [String : Any]()
            dict["jobTitle"] = model.backlog
            dict["jobContent"] = model.backLogDetail
            
            array.append(dict)
            
        }
        
        par["planList"] = array
        
        do{
            
            let jsonData = try JSONSerialization.data(withJSONObject: par, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8){
                
                //格式化的json字典的情况
                print(JSONString)
                
                //注意的是这里的par 要求序列化json
                fristParmerte["add"] = JSONString
                
            }
            
        } catch {
            
            print("转换错误 ")
        }

        
        SVProgressHUD.show()
        
        HttpClient.instance.post(path: URLPath.getReportAdd, parameters: fristParmerte, success: { (response) in
            
            SVProgressHUD.dismiss()
            SVProgressHUD.showSuccess(withStatus: "上传成功!")
            self.navigationController?.popViewController(animated: true)
            
        }) { (error) in
            
            SVProgressHUD.showError(withStatus: "保存失败,请检查网络!")
        }
        
        
    }

    @IBAction func cancelButtonClick(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
        
    }

    //MARK: - 添加workPlanList的方法
    func addWorkPlanListButtonClick(){
        
        self.view.endEditing(true)
        
        //设置原型model的情况,内存保存的情况
        let model = YQAddWorkPlanModel(dic: [String : Any]())
        dataArray.append(model)
        
        self.tableView.reloadData()

    }
    
    //MARK: - 删除workPlanList的方法
    func deleteWorkPlanListButtonClick(){
    
        self.view.endEditing(true)
        
        if self.dataArray.count <= 1 {
            self.dataArray.removeAll()
            
            self.tableView.reloadData()
            return
            
        }
        
        self.dataArray.remove(at: self.dataArray.count - 1)
    
        self.tableView.reloadData()
    }
    
    
    // MARK: - 添加默认的项目选择方法
    func setUpProjectNameLable() -> String{
        
        let dic = UserDefaults.standard.object(forKey: Const.YQProjectModel) as? [String : Any]
        
        var projectName  = ""
        
        if dic != nil {
            
            projectName = dic?["PARK_NAME"] as! String
            self.parkID = dic?["ID"] as! String
            
        }else{
            
            projectName = "请选择默认项目"
        }
        
        return projectName
    }

    

}

extension YQWorkPlanVC : UITableViewDataSource,UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? YQAddWorkPlan
        cell?.model = self.dataArray[indexPath.row]
        cell?.indexPathRow = indexPath.row
        cell?.delegate = self
        
        return cell!
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 200
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let view = UIView()
//        view.backgroundColor = UIColor.blue
        let boutton = UIButton()
        boutton.setImage(UIImage.init(name: "icon_edd"), for: .normal)
        
        boutton.addTarget(self, action: #selector(addWorkPlanListButtonClick), for: .touchUpInside)
        
        let bouttonRight = UIButton()
        bouttonRight.setImage(UIImage.init(name: "icon_del"), for: .normal)
        bouttonRight.addTarget(self, action: #selector(deleteWorkPlanListButtonClick), for: .touchUpInside)
        
        view.addSubview(boutton)
        view.addSubview(bouttonRight)
        
        boutton.snp.makeConstraints { (maker) in
            maker.right.bottom.top.equalToSuperview()
            maker.width.equalTo(60)
        }
        bouttonRight.snp.makeConstraints { (maker) in
            maker.left.bottom.top.equalToSuperview()
            maker.width.equalTo(60)
        }
        
        
        return view
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 60
    }

    
}

extension YQWorkPlanVC : YQAddWorkPlanEditDelegate{

    func addWorkPlanEditDelegate(string : String, type : String,indexRow : Int){
    
        let model = self.dataArray[indexRow]
        
        switch type {
        case "View":
            model.backLogDetail = string
            break
        default:
            model.backlog = string
            break
        }
        
        //替换,刷新表格
//        self.dataArray.replace(index: indexRow, object: model)// 这个方法是针对list的
        self.dataArray.replaceSubrange(indexRow...indexRow, with: [model])
        
        let indexpath = IndexPath.init(row: indexRow, section: 0)
        //单行刷新列表
        self.tableView.reloadRows(at: [indexpath], with: .automatic)

        
    }

}


