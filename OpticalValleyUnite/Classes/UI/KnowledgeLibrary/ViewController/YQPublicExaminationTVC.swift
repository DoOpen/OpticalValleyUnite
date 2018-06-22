//
//  YQPublicExaminationTVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/6/21.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQPublicExaminationTVC: UITableViewController {
    
    var cellType = -1
    
    var cellJoinExam = "JoinExam"
    
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


    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 20
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
    
    
}
