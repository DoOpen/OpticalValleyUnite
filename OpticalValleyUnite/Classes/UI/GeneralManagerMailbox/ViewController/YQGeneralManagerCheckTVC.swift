//
//  YQGeneralManagerCheckTVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/4/14.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh

class YQGeneralManagerCheckTVC: UITableViewController {

    //用户的权限
    var UserRule :Int64 = 2
    var currentIndex = 0
    var selectType = 0
    
    var cellID = "checkOutCell"
    
    //模型数组
    var dataArray = [YQGeneralCheckOutModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //1.init
        self.title = "反馈"
        
        //2.添加右边的bar
        setupRightAndLeftBarItem()
        
        //默认调去全部数据
        getListDataForService(type: 1)
        self.selectType = 1
        
        //3.上拉下拉刷新
        addRefirsh()
       
    }
    
    // MARK: - 自定义的right_left barItem
    func setupRightAndLeftBarItem(){
        
        let right_add_Button = UIButton()
        
        right_add_Button.frame = CGRect(x : 0, y : 0, width : 60, height : 40)
        right_add_Button.setTitle("全部", for: .normal)
        
        right_add_Button.setTitle("待处理", for: .selected)
        
        //设置font
        right_add_Button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        right_add_Button.setTitleColor(UIColor.blue, for: .normal)
        right_add_Button.addTarget(self, action: #selector(addRightBarItemButtonClick(button :)), for: .touchUpInside)
        
        let  right2Bar = UIBarButtonItem()
        right2Bar.customView = right_add_Button
        
        self.navigationItem.rightBarButtonItems = [right2Bar]
    }
    
    func addRightBarItemButtonClick(button : UIButton){
        //选项取反
        button.isSelected = !button.isSelected
        
        //两个接口轮流倒
        switch (button.titleLabel?.text)! {
            case "全部":
                getListDataForService(type: 1)
                self.selectType = 1
                
                break
            case "待处理":
                getListDataForService(type: 0)
                self.selectType = 0
                
                break
            
            default:
                break
        }
    }
    
    // MARK: - 获取查看的数据
    func getListDataForService(type : Int,pageSize : Int = 20,pageIndex : Int = 0){
        
        var par = [String : Any]()
        par["status"] = type
        
        SVProgressHUD.show()
        
        HttpClient.instance.post(path: URLPath.getemailList, parameters: par, success: { (response) in
            
            SVProgressHUD.dismiss()
            //获取数据,字典转模型的操作
            let feedBackList = response["feedbackList"] as? [String : Any]
            
            if feedBackList != nil {
                
                let data = feedBackList!["data"] as? Array<[String : Any]>
                
                if data == nil {
                    
                    SVProgressHUD.showError(withStatus: "没有加载更多数据!")
                    self.tableView.mj_header.endRefreshing()
                    self.tableView.mj_footer.endRefreshing()

                    return
                    
                }else {
                    var tempModel = [YQGeneralCheckOutModel]()
                    
                    for dict in data!{
                        tempModel.append(YQGeneralCheckOutModel.init(dict: dict))
                    }
                    //添加上拉下拉刷新的情况
                    if pageIndex == 0 {
                        
                        self.dataArray = tempModel
                        self.tableView.mj_header.endRefreshing()
                        
                    }else{
                        
                        if tempModel.count > 0{
                            
                            self.currentIndex = pageIndex
                            self.dataArray.append(contentsOf: tempModel)
                        }
                        
                        self.tableView.mj_footer.endRefreshing()
                    }
                    
                    self.dataArray = tempModel
                    
                    self.tableView.reloadData()
                    
                }
            }

        }, failure: { (error) in
            
            SVProgressHUD.showError(withStatus: "数据加载失败,请检查网络!")
        })
    }
    
    // MARK: - 上下拉的刷新的界面情况
    func addRefirsh(){
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            
            self.getListDataForService(type: self.selectType)
        })
        
        
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            
            self.getListDataForService(type: self.selectType,pageIndex: self.currentIndex + 1)
            
        })
        
    }


    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.dataArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:cellID , for: indexPath) as! YQGeneralManagerCheckCell
        
        cell.model = self.dataArray[indexPath.row]
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //点击跳转详情
        let status = self.dataArray[indexPath.row].status
        
        if status == 0{//未处理
          /*
             0 经理 1总经理 3其他角色
             */
            if UserRule == 0{//经理
                
                let MDetailVC = YQGenaralManagerCheckDetailVC.init(nibName: "YQGenaralManagerCheckDetailVC", bundle: nil)
                MDetailVC.id = "\(self.dataArray[indexPath.row].id)"
                self.navigationController?.pushViewController(MDetailVC, animated: true)
                
            }else{//总经理
                
                let gmDetailVC = YQGenaralManagerCheckAlreadyDetailVC.init(nibName: "YQGenaralManagerCheckAlreadyDetailVC", bundle: nil)
               gmDetailVC.id = "\(self.dataArray[indexPath.row].id)"
                self.navigationController?.pushViewController(gmDetailVC, animated: true)
            }
            
            
        }else{//已处理
            
            let detailVC = YQGenaralFeedBackDetailVC.init(nibName: "YQGenaralFeedBackDetailVC", bundle: nil)
            
            detailVC.id = "\(self.dataArray[indexPath.row].id)"
            
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
        
        
    }



}
