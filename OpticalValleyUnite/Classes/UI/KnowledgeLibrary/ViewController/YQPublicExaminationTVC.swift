//
//  YQPublicExaminationTVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/6/21.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh

class YQPublicExaminationTVC: UITableViewController {
    
    var cellType = -1
    
    var cellJoinExam = "JoinExam"
    var joinExamArray = [YQExamOwnListModel]()
    
    var cellMyScore = "MyScore"
    var myScoreArray = [YQMyAchievementsModel]()
    
    var cellExamRecords = "ExamRecords"
    var examRecordsArray = [YQExaminationRecordsModel]()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        //1.注册原型cell
        let nib1 = UINib.init(nibName: "YQJoinExamCell", bundle: nil)
        self.tableView.register(nib1, forCellReuseIdentifier: cellJoinExam)
        
        let nib2 = UINib.init(nibName: "YQMyScoreCell", bundle: nil)
        self.tableView.register(nib2, forCellReuseIdentifier: cellMyScore)
        
        let nib3 = UINib.init(nibName: "YQExamRecordsCell", bundle: nil)
        self.tableView.register(nib3, forCellReuseIdentifier: cellExamRecords)
        
        //2.设置title
        switch cellType {
            case 1:
                self.title = "参加考试"
                self.getStartExaminationListData()
                
                break
            case 2:
                self.title = "我的成绩"
                self.getMyAchievementsListData()
                
                break
            case 3:
                self.title = "考试记录"
                self.getExaminationRecordsListData()
                
                break
            default:
                break
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.cellType == 1 {
            //实时刷新下
            self.getStartExaminationListData()
        }
        
    }
    
    // MARK: - "参加考试"list数据方法
    func getStartExaminationListData(){
        
        var par = [String : Any]()
        
        par["parkId"] = setUpProjectNameLable()
        
        SVProgressHUD.show()
        
        HttpClient.instance.post(path: URLPath.getNewknowledgeOwnList, parameters: par, success: { (response) in
            
            SVProgressHUD.dismiss()
            
            let data = response["data"] as? Array<[String : Any]>
            
            if data == nil || (data?.isEmpty)! {
                
                SVProgressHUD.showError(withStatus: "没有更多数据")
                return
            }
            
            var tempArray = [YQExamOwnListModel]()
            
            for dict in data!{
                
                tempArray.append(YQExamOwnListModel.init(dict: dict))
            }
            
            self.joinExamArray = tempArray
            self.tableView.reloadData()
            
        }) { (error) in
            
            SVProgressHUD.showError(withStatus: "网络请求失败,请检查网络!")
        }
    }
    
    // MARK: - "我的成绩"list数据方法
    func getMyAchievementsListData(){
        
        var par = [String : Any]()
        par["parkId"] = setUpProjectNameLable()
        
        SVProgressHUD.show()
        
        HttpClient.instance.post(path: URLPath.getNewknowledgeOwnResultList, parameters: par, success: { (response) in
            
            SVProgressHUD.dismiss()
            
            let data = response["data"] as? Array<[String : Any]>
            
            if data == nil || (data?.isEmpty)! {
                
                SVProgressHUD.showError(withStatus: "没有更多数据!")
                return
            }
            
            var tempArray = [YQMyAchievementsModel]()
            
            for dict in data! {
                
                tempArray.append(YQMyAchievementsModel.init(dict: dict))
            }
            
            self.myScoreArray = tempArray
            self.tableView.reloadData()
            
            
        }) { (error) in
            
            SVProgressHUD.showError(withStatus: "网络请求失败,请检查网络!")
        }
        
    }
    
    // MARK: - "考试记录"list数据方法
    func getExaminationRecordsListData(){
        
        var par = [String : Any]()
        par["parkId"] = setUpProjectNameLable()
        
        SVProgressHUD.show()
        
        HttpClient.instance.post(path: URLPath.getNewknowledgeOwnRecord, parameters: par, success: { (response) in
            
            SVProgressHUD.dismiss()
            
            let data = response["data"] as? Array<[String : Any]>
            
            if data == nil || (data?.isEmpty)! {
                
                SVProgressHUD.showError(withStatus: "没有更多数据!")
                return
            }
            
            var tempArray = [YQExaminationRecordsModel]()
            
            for dict in data! {
                
                tempArray.append(YQExaminationRecordsModel.init(dict: dict))
            }
            
            self.examRecordsArray = tempArray
            self.tableView.reloadData()
            
            
        }) { (error) in
            
            SVProgressHUD.showError(withStatus: "网络请求失败,请检查网络!")
        }
    }

    
    // MARK: - 添加默认的项目选择方法
    func setUpProjectNameLable() -> String{
        
        let dic = UserDefaults.standard.object(forKey: Const.YQProjectModel) as? [String : Any]
        
        var projectId  = ""
        
        if dic != nil {
            
            projectId = (dic?["ID"] as? String)!
        }
        
        return projectId
    }
    
    // MARK: - 上下拉的刷新的界面情况
    func addRefirsh(){
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            
            //self.getDataForServer()
        })
        
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            
            //self.getDataForServer(pageIndex: self.currentIndex + 1)
        })
    }


    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch self.cellType {
            
            case 1:
                return self.joinExamArray.count
            
            case 2:
                return self.myScoreArray.count
            
            case 3:
                return self.examRecordsArray.count
            
            default:
                return 0
            
        }
        
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch self.cellType {
            
            case 1:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: cellJoinExam, for: indexPath) as! YQJoinExamCell
                
                cell.model = self.joinExamArray[indexPath.row]
                
                return cell
            
            
            case 2:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: cellMyScore, for: indexPath) as! YQMyScoreCell
                cell.model = self.myScoreArray[indexPath.row]
                
                return cell
            
            
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: cellExamRecords, for: indexPath) as! YQExamRecordsCell
                
                cell.model = self.examRecordsArray[indexPath.row]
                
                return cell
            
            default:
                break
        }
        
        return UITableViewCell()
    }
 
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if self.cellType == 2{
            
            return 50
            
        }else{
            
            return 100
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch self.cellType {
            
            case 1:
                
                let vc = YQStartExaminationVC.init(nibName: "YQStartExaminationVC", bundle: nil)
                vc.id = "\(self.joinExamArray[indexPath.row].id)"
                
                if self.joinExamArray[indexPath.row].isAttend == 1 {//显示都是可以点击的
                    //已参加
                    vc.isCheck = true
                    
                }else {//未参加
                    
                    if self.joinExamArray[indexPath.row].isEnd == 1 {
                        
                        SVProgressHUD.showError(withStatus: "对不起,考试已结束")
                        return
                    }

                }
                
                self.navigationController?.pushViewController(vc, animated: true)
                
                break
            
            case 2:
                
                let vc = YQAchievementDetailVC.init(nibName: "YQAchievementDetailVC", bundle: nil)
                vc.id = "\(self.myScoreArray[indexPath.row].id)"
                
                self.navigationController?.pushViewController(vc, animated: true)
                
                break
            
            default:
                break
        }
        
    }
    
    
}
