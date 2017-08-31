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


let partCell = "partCell"

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
    
    ///定义数据模型,  这里应用的是 didset== 相当于set方法,一旦赋值的话,要求的是刷新表格
    var dataPart : [PartsModel]?{
        
        didSet{
            // 当设置完数据之后 就实现刷新
            tableView.reloadData()
        }
    
    }
    //定义tableView
    var tableView = UITableView()
    //定义参数数组
    var parmat = [String: Any]()

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
//        tabelV.estimatedRowHeight = 100.0
//        tabelV.rowHeight = UITableViewAutomaticDimension
//        tabelV.tableHeaderView = Bundle.main.loadNibNamed("YQPartHeadView", owner: nil, options: nil)![0] as? UIView
        
        contentScrollView.addSubview(tabelV)
        tabelV.frame = contentScrollView.bounds
        self.tableView = tabelV
        
        let width = 2 * UIScreen.main.bounds.width
        contentScrollView.contentSize = CGSize(width: width, height: 0)
        automaticallyAdjustsScrollViewInsets = false
        
        //2.网络请求
        //设置参数
        parmat["token"] =  UserDefaults.standard.object(forKey: Const.SJToken)
        parmat["parkId"] = UserDefaults.standard.object(forKey: Const.YQParkID)
        parmat["pageIndex"] = 0
        parmat["pageSize"] = 20
        parmat["partsName"] = ""

        SVProgressHUD.show(withStatus: "加载任务中")
        
        /// 网络数据请求框架,有bug 网络请求无法使用
//        HttpClient.instance.get(path: URLPath.getPartsHome, parameters: parmat, success: { (response) in
//            SVProgressHUD.dismiss()
//            
//            
//        }) { (error) in
            
//            print(error)
//            
//        }
        
        Alamofire.request(URLPath.basicPath + URLPath.getPartsHome,  parameters: parmat).responseJSON { (response) in
            
            SVProgressHUD.dismiss()
            
            switch response.result {
                
            case .success(_):
                
                if let value = response.result.value as? [String: Any] {

                    if let data:NSDictionary = value["data"] as? NSDictionary {
                    
                        if let partList:NSArray = data["list"] as? NSArray {
                            //遍历数组,字典转模型,最核心的是,将字典数组,转化成模型来进行
//                            print(partList)
                            
                            var model = [PartsModel]()
                            
                            for dic in partList{
                                
//                                print(dic)
                                model.append(PartsModel(dict: dic as! [String : AnyObject]))
                            }
                            
                            //模型赋值 传值!
                            self.dataPart = model
//                            print(model)
                    
                        }
                        
                        break
                    }
                    break
                }
                break
                
            case .failure(let error):
                
                debugPrint(error)
                break
            }

        }
        
        //3.UI数据
        let nib = UINib.init(nibName: "YQPartDataCell", bundle: nil)
        
        //4.注册原型cell 
        tableView.register(nib, forCellReuseIdentifier: partCell)
        
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

extension YQPartsLibaryViewController : UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate{
    
    // MARK: - tableView的代理方法
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataPart?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : YQPartDataCell = (tableView.dequeueReusableCell(withIdentifier: partCell, for: indexPath)) as! YQPartDataCell
        
        let status = dataPart![indexPath.row]
        
        cell.part.text = status.position
        cell.partName.text = status.partsName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return Bundle.main.loadNibNamed("YQPartHeadView", owner: nil, options: nil)![0] as? UIView
        
    }
    
    //headView的高度:
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 44
    }
    
    // MARK: - seachBar的代理方法
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        parmat["partsName"] = self.searchBar.text
        //搜索点击实现的方法:(发送请求数据刷新)
        SVProgressHUD.show(withStatus: "搜索中")
        
        Alamofire.request(URLPath.basicPath + URLPath.getPartsHome,  parameters: parmat).responseJSON { (response) in
            
            SVProgressHUD.dismiss()
            
            switch response.result {
                
            case .success(_):
                
                if let value = response.result.value as? [String: Any] {
                    
                    if let data:NSDictionary = value["data"] as? NSDictionary {
                        
                        if let partList:NSArray = data["list"] as? NSArray {
                            //遍历数组,字典转模型,最核心的是,将字典数组,转化成模型来进行
                            //                            print(partList)
                            
                            var model = [PartsModel]()
                            
                            for dic in partList{
                                
                                model.append(PartsModel(dict: dic as! [String : AnyObject]))
                            }
                            
                            //模型赋值 传值!
                            self.dataPart = model
                            
                        }
                        
                        break
                    }
                    break
                }
                break
                
            case .failure(let error):
                
                debugPrint(error)
                break
            }
        }
        //设置为关闭
        self.searchBar.text = nil
        self.searchBar.endEditing(true)
    }
    
    // MARK: - scrollView的代理方法,滚动执行的方法
    
    
}



