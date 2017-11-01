//
//  YQJournalDetailViewController.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/10/13.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit

class YQJournalDetailViewController: UIViewController {

    // MARK: - 控制器的属性
    @IBOutlet weak var detailTableView: UITableView!
    
    //id 
    var workIDid : Int64 = -1
    
    //detailList
    var detailList : NSArray?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //刷新数据列表
        self.detailTableView.reloadData()
     
    }
    
    // MARK: - 工作记录
    @IBAction func workRecordButtonClick(_ sender: Any) {
        
        let workRecord = UIStoryboard.instantiateInitialViewController(name: "YQWorkRecord")
        self.navigationController?.pushViewController(workRecord, animated: true)
        
        
    }
    
    // MARK: - 工单完成情况
    @IBAction func workOrderCompleteClick(_ sender: Any) {
        
        let workComplete = UIStoryboard.instantiateInitialViewController(name: "YQWorkOderComplete")
        self.navigationController?.pushViewController(workComplete, animated: true)

    }

}

extension YQJournalDetailViewController : UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (self.detailList?.count ?? 0)!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = Bundle.main.loadNibNamed("YQJournalDetailHead", owner: nil, options: nil)?[0] as? YQJournalDetailHeadView
        
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as? YQJournalDetailTVCell
        
        if cell == nil{
            
            cell = YQJournalDetailTVCell()
        }
        
        let dic = self.detailList?[indexPath.row] as? [String : Any]
        let text =  dic?["title"] as? String
        cell?.contentLabel.text = "\(indexPath.row + 1)." + text!
        
        return cell!
    }


}
