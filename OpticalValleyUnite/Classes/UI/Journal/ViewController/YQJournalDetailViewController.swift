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
    
    // 项目名
    var parkName : String = ""{
        didSet{
            
            projectNAME.text = parkName
        }
    }
    
    // MARK: - swift懒加载方法
    lazy var heightDic = {
        () -> NSMutableDictionary
        
        in
        
        return NSMutableDictionary()
        
    }()

    
    @IBOutlet weak var projectNAME: UILabel!
    
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
            
            if let parkName = response["parkName"] as? String{
            
                self.parkName = parkName
            }
            
            if let parkID = response["parkId"] as? String {
                
                self.parkId = parkID
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
        workRecord?.parkID = parkId
        
        self.navigationController?.pushViewController(workRecord!, animated: true)
        
    }
    
    // MARK: - 工单完成情况
    @IBAction func workOrderCompleteClick(_ sender: Any) {
        
        let workComplete = UIStoryboard.instantiateInitialViewController(name: "YQWorkOderComplete") as? YQWorkOrderCompleteVC
        
//        workComplete?.workLogID = "\(self.workIDid)"
        workComplete?.parkID = parkId
        
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
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "detailCell") as? YQJournalDetailTVCell
        
        if cell == nil{
            
            cell = YQJournalDetailTVCell()
        }
        
        let dic = self.detailList?[indexPath.row] as? [String : Any]
        let text =  dic?["title"] as? String
        cell?.contentLabel.text = "\(indexPath.row + 1)." + text!
        
        cell?.layoutIfNeeded()
        
        self.heightDic["\(indexPath.row)"] = cell?.cellForHeight()
        
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let height = self.heightDic["\(indexPath.row)"] as! CGFloat
        
        return height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 300
        
    }


}
