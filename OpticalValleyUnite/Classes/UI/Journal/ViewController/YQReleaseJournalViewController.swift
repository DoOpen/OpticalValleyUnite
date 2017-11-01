//
//  YQReleaseJournalViewController.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/10/13.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit

class YQReleaseJournalViewController: UIViewController {
    
    // MARK: - 属性加载情况
    @IBOutlet weak var detailTableView: UITableView!
    
    var dataList : [YQToDoListModel]?{
        didSet{
            
            self.detailTableView.reloadData()
        }
    }
    
    // MARK: - 视图生命周期的方法
    override func viewDidLoad() {
        super.viewDidLoad()
        //获取待办事项的列表信息
        getTodoDataList()

    }
    
    // MARK: - 获取待办事项的listdata
    func getTodoDataList(){
        
        let paramet = [String : Any]()
        
        HttpClient.instance.get(path: URLPath.getTodoWorklogList, parameters: paramet, success: { (respose) in
            //获取数据,字典转模型
            var tempModel = [YQToDoListModel]()
            
            if let array = respose["todoList"] as? NSArray{
                
                for temp in array {
                    
                    tempModel.append(YQToDoListModel.init(dic: temp as! [String : Any]))
                }
                
                self.dataList = tempModel
                
            }
            
        }) { (error) in
            
            self.alert(message: error.debugDescription)
        }
    }
    
    // MARK: - 工作记录View的点击,界面跳转
    @IBAction func tapClickWithWorkRecord(_ sender: Any) {
        
        let workRecord = UIStoryboard.instantiateInitialViewController(name: "YQWorkRecord")
        self.navigationController?.pushViewController(workRecord, animated: true)
        
        
    }
    
    // MARK: - 工单完成情况实现
    @IBAction func workorderCompleteClick(_ sender: Any) {
        //直接的跳转到 工单的完成情况界面
        
        let workComplete = UIStoryboard.instantiateInitialViewController(name: "YQWorkOderComplete")
        self.navigationController?.pushViewController(workComplete, animated: true)

    }
    
    // MARK: - 提交rightBarButtonClick
    @IBAction func submitButtonClick(_ sender: Any) {
        
        //数据接口的请求
        /*调用日志新增的接口
         
         token
         workunitIds
         todoIds
         
         */
        
        let parameter = [String : Any]()
        
        HttpClient.instance.post(path: URLPath.getAddWorklog, parameters: parameter, success: { (response) in
            
            //界面跳转
            self.dismiss(animated: true, completion: nil)
            
        }) { (error) in
            
           self.alert(message: error.debugDescription)
        }
        
    }
    
    // MARK: - 返回按钮leftBarButtonClick
    @IBAction func returnButtonClick(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    

}

extension YQReleaseJournalViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 50
    
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = Bundle.main.loadNibNamed("YQJournalDetailHead", owner: nil, options: nil)?[0] as? YQJournalDetailHeadView
        
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footer = Bundle.main.loadNibNamed("YQReseaseJournalFooter", owner: nil, options: nil)?[0] as? YQReleaseJournalFooterV
        footer?.deletage = self as YQReseaseJouranlFooterDeletage
        
        return footer
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        let model = self.dataList?[indexPath.row]
        
        cell.textLabel?.text = "\(indexPath.row + 1)." + (model?.title)!
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let model = self.dataList?[indexPath.row]{
            
            //跳转到添加 详情的界面
            let addDetailVC = UIStoryboard.instantiateInitialViewController(name: "YQJournalAddEvent") as! YQJournalAddEventViewController
            addDetailVC.todoId = model.todoId
            addDetailVC.text = model.title!
            
            self.navigationController?.pushViewController(addDetailVC, animated: true)

        }
        
    }
    

}


extension YQReleaseJournalViewController : YQReseaseJouranlFooterDeletage{
    
    func reseaseJouranlFooterButtonClick(releaseJournal: YQReleaseJournalFooterV) {
        //跳转到添加 详情的界面
        let addDetailVC = UIStoryboard.instantiateInitialViewController(name: "YQJournalAddEvent")
        
        self.navigationController?.pushViewController(addDetailVC, animated: true)
        
    }


}

