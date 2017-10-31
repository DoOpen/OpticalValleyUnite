//
//  YQReleaseJournalViewController.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/10/13.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit

class YQReleaseJournalViewController: UIViewController {

    @IBOutlet weak var detailTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    // MARK: - 工作记录View的点击,界面跳转
    @IBAction func tapClickWithWorkRecord(_ sender: Any) {
        
        let workRecord = UIStoryboard.instantiateInitialViewController(name: "YQWorkRecord")
        self.navigationController?.pushViewController(workRecord, animated: true)
        
    }
    
    // MARK: - 工单完成情况实现
    @IBAction func workorderCompleteClick(_ sender: Any) {
        //直接的跳转到 工单的完成情况界面
        
    }
    
    
    // MARK: - 提交rightBarButtonClick
    @IBAction func submitButtonClick(_ sender: Any) {
        
        //数据接口的请求
        //界面跳转
        self.dismiss(animated: true, completion: nil)
        
    }
    
    // MARK: - 返回按钮leftBarButtonClick
    
    @IBAction func returnButtonClick(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    

}

extension YQReleaseJournalViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
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
        cell.textLabel?.text = "molishuju" + "\(indexPath.row)"
        
        return cell
    }
    

}


extension YQReleaseJournalViewController : YQReseaseJouranlFooterDeletage{
    
    func reseaseJouranlFooterButtonClick(releaseJournal: YQReleaseJournalFooterV) {
        //跳转到添加 详情的界面
        let addDetailVC = UIStoryboard.instantiateInitialViewController(name: "YQJournalAddEvent")
        
        self.navigationController?.pushViewController(addDetailVC, animated: true)
        
    }


}

