//
//  YQPublicExaminationTVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/6/21.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit
import SVProgressHUD

class YQPublicExaminationTVC: UITableViewController {
    
    var cellType = -1
    
    var cellJoinExam = "JoinExam"
    var joinExamArray = [YQExamOwnListModel]()
    
    var cellMyScore = "MyScore"
    
    var cellExamRecords = "ExamRecords"
    
    
    
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
                break
            case 2:
                self.title = "我的成绩"
                break
            case 3:
                self.title = "考试记录"
                break
            default:
                break
        }
        
    }
    
    // MARK: - "参加考试"list数据方法
    func getStartExaminationListData(){
        
        var par = [String : Any]()
        
        par["parkId"] = ""
        
        SVProgressHUD.show()
        
        HttpClient.instance.post(path: URLPath.getNewknowledgeOwnList, parameters: par, success: { (response) in
            
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
    


    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch self.cellType {
        case 1:
            return self.joinExamArray.count
            
        case 2:
            return 20
            
        case 3:
            return 20
            
        default:
            
            return 0
        }
        
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch self.cellType {
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: cellJoinExam, for: indexPath)
                return cell
            
            
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: cellMyScore, for: indexPath)
                return cell
            
            
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: cellExamRecords, for: indexPath)
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
                self.navigationController?.pushViewController(vc, animated: true)
                
                break
            
            case 2:
                
                let vc = YQAchievementDetailVC.init(nibName: "YQAchievementDetailVC", bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
                
                break
            
            case 3:
                
                break
            
            default:
                break
        }
        
    }
    
    
}
