//
//  YQPartsLibaryViewController.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/8/29.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire


class YQPartsLibaryViewController: UIViewController {
    
    // MARK: - 所有属性的情况
    ///所有配件
    @IBOutlet weak var allPartsButton: UIButton!
    ///已选配件
    @IBOutlet weak var selectPartsButton: UIButton!
    ///searchBar
    @IBOutlet weak var searchBar: UISearchBar!
    ///内容滚动视图
    @IBOutlet weak var contentScrollView: UIScrollView!
    
//    let tabelView 
    
    var dataPart : [String] = [String]()
    
    var HistoryModel = [WorkHistoryModel]()
    

    // MARK: - view的生命周期方法
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1.设置titie,leftBar和rightBar设置
        title = "使用配件"
        let item=UIBarButtonItem(title: "完成", style: UIBarButtonItemStyle.plain, target: self, action: #selector(rightBarButtonClick))
        self.navigationItem.rightBarButtonItem = item
        
        allPartsButton.isSelected = true
        
        //1.1 给scrollView 来进行添加
        let tabelV = UITableView()
        tabelV.dataSource = self as UITableViewDataSource
        tabelV.delegate = self as UITableViewDelegate
        tabelV.estimatedRowHeight = 100.0
        tabelV.rowHeight = UITableViewAutomaticDimension
        tabelV.tableHeaderView = Bundle.main.loadNibNamed("YQPartHeadView", owner: nil, options: nil)![0] as? UIView
        
        contentScrollView.addSubview(tabelV)
        tabelV.frame = contentScrollView.bounds
        
        let width = 2 * UIScreen.main.bounds.width
        contentScrollView.contentSize = CGSize(width: width, height: 0)
        self.automaticallyAdjustsScrollViewInsets = false
        
        //2.网络请求
        //设置参数
        var parmat = [String: Any]()
        parmat["token"] =  UserDefaults.standard.object(forKey: Const.SJToken)
        parmat["parkId"] = UserDefaults.standard.object(forKey: Const.YQParkID)
        parmat["pageIndex"] = 0
        parmat["pageSize"] = 20
        
        SVProgressHUD.show(withStatus: "加载任务中")
//        HttpClient.instance.get(path: URLPath.getPartsHome, parameters: parmat, success: { (response) in
//            SVProgressHUD.dismiss()
//            
//            
//        }) { (error) in
//            
//            print(error)
//            
//        }
        
        Alamofire.request(URLPath.basicPath + URLPath.getPartsHome,  parameters: parmat).responseJSON { (response) in
            
            SVProgressHUD.dismiss()
            
            
            
            
        }

        //3.UI数据
        
        
    }

    // MARK: - 点击右边完成按钮
     func rightBarButtonClick(){
        //直接调去保存接口进行实现
        
        
        // dimiss
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    // MARK: - 配件按钮的选择
    ///所有配件
    @IBAction func allPartsButtonClick(_ sender: UIButton) {
        allPartsButton.isSelected = true
        selectPartsButton.isSelected = false
        
        
        
    }
    ///已选配件
    @IBAction func selectPartsButtonClick(_ sender: UIButton) {
        allPartsButton.isSelected = false
        selectPartsButton.isSelected = true
        
        
    }
   
}

extension YQPartsLibaryViewController : UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: WorkOrder2Cell
        
        
        cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! WorkOrder2Cell
//        cell.model = dataPart[indexPath.row]
        
        return cell
    }
    
    //headView的高度:
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 44
    }

//    ///headview的实现
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        
//        let view = YQPartShowHeadView.loadFromXib() as! YQPartShowHeadView
//        
//        
//        return view
//    }
    
}



