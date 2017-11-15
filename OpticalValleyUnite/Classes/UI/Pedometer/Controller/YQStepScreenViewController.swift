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
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //1.默认选择第一个button
        self.selectButtonClicked(groupButton)
        
        //2.添加上拉下拉刷新
        addRefirsh()
    
    }
    
    
    @IBAction func selectButtonClicked(_ sender: UIButton) {
        
        let tag = sender.tag
        
        allButtonHideAndShow(selectTag: tag)
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
    }
    
    // MARK: - 获取list的数据,整体的列表的数据刷新
    func getRankForAllData(currentIndex : Int , date : String, dic : [String : Any]){
        
        var parmat = [String: Any]()
        
        parmat["pagesize"] = 10
        parmat["pageno"] = currentIndex
        
        parmat["date"] = date
        
        for (key,value) in dic{
            parmat[key] = value
        }
        
        HttpClient.instance.post(path: URLPath.getRankPedometer, parameters: parmat, success: { (respose) in
            //字典转模型,读取相应的数据
            
            
        }) { (error) in
            
            SVProgressHUD.showError(withStatus: error.description)
            
        }
        
    }
    
    // MARK: - 上下拉的刷新的界面情况
    func addRefirsh(){
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            
//            self.getWorklogDataList()
            
        })
        
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            
//            self.getWorklogDataList(indexPage: self.pageNo + 1)
        })
        
        
    }

    
}
