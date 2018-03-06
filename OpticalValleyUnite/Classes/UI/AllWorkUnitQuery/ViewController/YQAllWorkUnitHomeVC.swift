//
//  YQAllWorkUnitHomeVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/3/6.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQAllWorkUnitHomeVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var waitHandleBtn: UIButton!
    var currentBtn : UIButton!
    
    ///
    //dataAarry
    var currentDatas = [WorkOrderModel2]()
    
    //currentIndex
    var pageNo = 0
    
    var siftsiftParmat : [String : Any]?
    
    var siftVc: WorkOrderSiftViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "全部工单"
        self.waitHandleBtn.isSelected = true
        self.currentBtn = self.waitHandleBtn
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        //获取网络数据请求
        
    
    }
    
    
    // MARK: - 点击按钮的状态切换
    @IBAction func selectButtonClick(_ sender: UIButton) {
        
        self.currentBtn.isSelected = false
        sender.isSelected = true
        self.currentBtn = sender
        
        //设置选中的btn的网络数据请求
        
        
        
    }
    
    
    // MARK: - 获取网络数据详情方法
    func getDataForServer(tag : Int, pageSize : Int = 20, pageIndex : Int = 0,dict : [String : Any] = [String : Any]()){
        
        
        
    }
    

   
}

extension YQAllWorkUnitHomeVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return currentDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: WorkOrder2Cell //注意的是,细小的bug 两个的cell是不同的模型,应用的WorkOrder2Cell-> 2的cell模型
        
        cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! WorkOrder2Cell
        cell.model2 = currentDatas[indexPath.row]
        
        return cell
    }
 

    
}

