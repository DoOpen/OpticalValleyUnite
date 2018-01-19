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
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.title = "工作计划"
        
        //注册原型cell 设置cell的每个的行高的情况
        let nib = UINib(nibName: "YQAddWorkPlan", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellID)

        //设置原型model的情况,内存保存的情况
        let model = YQAddWorkPlanModel(dic: [String : Any]())
        dataArray.append(model)
        
        self.tableView.reloadData()
    }

    @IBAction func makeSureButtonClick(_ sender: UIButton) {
        
    }

    @IBAction func cancelButtonClick(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
        
    }

    //MARK: - 添加workPlanList的方法
    func addWorkPlanListButtonClick(){
        //设置原型model的情况,内存保存的情况
        let model = YQAddWorkPlanModel(dic: [String : Any]())
        dataArray.append(model)
        
        self.tableView.reloadData()

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
        boutton.setTitleColor(UIColor.brown, for: .normal)
        boutton.setTitle("添加", for: .normal)
        boutton.addTarget(self, action: #selector(addWorkPlanListButtonClick), for: .touchUpInside)
        
        view.addSubview(boutton)
        boutton.snp.makeConstraints { (maker) in
            maker.right.bottom.top.equalToSuperview()
            maker.width.equalTo(80)
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


