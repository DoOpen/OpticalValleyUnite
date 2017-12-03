//
//  YQStepScreenViewController.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/11/13.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh

class YQStepScreenViewController: UIViewController {
    
    // MARK: 各种的按钮属性列表
    @IBOutlet weak var groupButton: UIButton!
    
    @IBOutlet weak var projectButton: UIButton!
    
    @IBOutlet weak var department: UIButton!
    
    @IBOutlet weak var buttonView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var cellID = "stepsCell"
    var currentIndex  = 1
    var type = -1
    
    lazy var yesterday : String = { () -> String
        in
        
        let date = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let byesterday = NSDate.init(timeInterval: -60*60*24*1, since: date as Date)
        
        let yes = formatter.string(from: byesterday as Date)

        return yes
        
    }()
    
    
    var rankData = [YQStepShowModel](){
        
        didSet{
        
            self.tableView.reloadData()
        }
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        
        //1.默认选择第一个button
        switch type {
        case 1:
            self.selectButtonClicked(groupButton)
            
        case 2:
            self.selectButtonClicked(projectButton)
           
        case 3:
            self.selectButtonClicked(department)
            
        default:
            
            break
        }
        
        //2.添加上拉下拉刷新
        addRefirsh()
    
    }
    
    
    @IBAction func selectButtonClicked(_ sender: UIButton) {
        
        type = sender.tag
        
        allButtonHideAndShow(selectTag: type)
    }
    
    
    // MARK: - 按钮隐藏的功能方法
    func allButtonHideAndShow(selectTag : Int) {
        
        let btnView = self.buttonView.subviews as? [UIButton]
        
        for btn in btnView! {
            
            if btn.tag == selectTag {
                btn.isSelected = true
                
            }else{
                btn.isSelected = false
            
            }
        }
        
        var par = [String : Any]()
        par["type"] = selectTag
        
        getRankForAllData( date: yesterday, dic: par)
        
    }
    
    // MARK: - 获取list的数据,整体的列表的数据刷新
    func getRankForAllData(indexPage : Int = 1 , date : String = "", dic : [String : Any]  = [String: Any]()){
        
        var parmat = [String: Any]()
        
        parmat["pagesize"] = 20
        parmat["pageno"] = indexPage
        
        parmat["date"] = date
        
        for (key,value) in dic{
            parmat[key] = value
        }
        
        SVProgressHUD.show(withStatus: "加载中...")
        
        HttpClient.instance.post(path: URLPath.getRankPedometer, parameters: parmat, success: { (respose) in
            
            SVProgressHUD.dismiss()
            
            //字典转模型,读取相应的数据
            var temp = [YQStepShowModel]()
            
            for dic in respose as! NSArray {
                
                temp.append(YQStepShowModel.init(dict: dic as! [String : Any]))
                
            }
            
            if indexPage == 1{
                
                self.currentIndex = 1
                self.rankData = temp
                
                self.tableView.mj_header.endRefreshing()
                
            }else{
                
                
                if temp.count > 0{
                    
                    self.currentIndex = indexPage
                    
                    self.rankData.append(contentsOf: temp)
                    
                }
            
                self.tableView.mj_footer.endRefreshing()
            }
            
            
        }) { (error) in
            
            SVProgressHUD.showError(withStatus: error.description)
            
            self.tableView.mj_header.endRefreshing()

            self.tableView.mj_footer.endRefreshing()
            
        }
        
    }
    
    // MARK: - 上下拉的刷新的界面情况
    func addRefirsh(){
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            
            var par = [String : Any]()
            par["type"] = self.type
            par["date"] = self.yesterday
            
            self.getRankForAllData(indexPage: 1,dic : par)
            
        })
        
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            
            var par = [String : Any]()
            par["type"] = self.type
            par["date"] = self.yesterday

            self.getRankForAllData(indexPage: self.currentIndex + 1,dic : par)
        })
    
    }

    
}

extension YQStepScreenViewController : UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.rankData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? YQStepStatisticsView
        if cell == nil {
            
            cell = Bundle.main.loadNibNamed("YQStepStatistics", owner: nil, options: nil)?[0] as? YQStepStatisticsView
            
        }
        
        cell?.indepathrow = indexPath.row
        cell?.backgroundColor =  UIColor.clear
        cell?.type = self.type
        
        cell?.model = self.rankData[indexPath.row]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
    }

}
