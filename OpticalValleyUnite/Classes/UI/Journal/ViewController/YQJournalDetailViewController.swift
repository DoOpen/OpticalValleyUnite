//
//  YQJournalDetailViewController.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/10/13.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit
import SVProgressHUD

class YQJournalDetailViewController: UIViewController {

    // MARK: - 控制器的属性
    @IBOutlet weak var detailTableView: UITableView!
    
    //id 
    var workIDid : Int64 = -1
    
    //detailList
    var detailList : NSArray?{
        didSet{
        
            //刷新数据列表
            self.detailTableView.reloadData()

        }
    
    }
    
    //项目ID
    var parkId : String = ""
    
    // workunitIds
    var workunitIds : String = ""
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getDetailDataList()
        
    }
    
    // MARK: - 查看detail 界面的详情的数据
    func getDetailDataList(){
        
        var parameter = [String : Any]()
        parameter["parkId"] = parkId
        parameter["worklogId"] = workIDid
        
        SVProgressHUD.show(withStatus: "加载中...")
        
        HttpClient.instance.get(path: URLPath.getCheckWorklogDetail, parameters: parameter, success: { (response) in
            
            SVProgressHUD.dismiss()
            
            
            //模型取值
            let array = response["todoList"] as? NSArray
            self.detailList = array
            
            if let worklogid = response["worklogId"] as? Int64{
            
                self.workIDid =  worklogid
                
            }
            
            if let workunitIds = response["workunitIds"] as? String  {
                
                self.workunitIds = workunitIds
            }
            
            
        }) { (error) in
            
            //数据加载失败!
            SVProgressHUD.showError(withStatus: error.description)
        }
    
    }
    
    
    // MARK: - 工作记录
    @IBAction func workRecordButtonClick(_ sender: Any) {
        
        let workRecord = UIStoryboard.instantiateInitialViewController(name: "YQWorkRecord") as? YQWorkRecordViewController
        workRecord?.workLogID = "\(self.workIDid)"
        workRecord?.workunitIds = workunitIds
        
        self.navigationController?.pushViewController(workRecord!, animated: true)
        
    }
    
    // MARK: - 工单完成情况
    @IBAction func workOrderCompleteClick(_ sender: Any) {
        
        let workComplete = UIStoryboard.instantiateInitialViewController(name: "YQWorkOderComplete") as? YQWorkOrderCompleteVC
        
//        workComplete?.workLogID = "\(self.workIDid)"
        
        self.navigationController?.pushViewController(workComplete!, animated: true)

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
