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
    
    ///定义数据模var,  这里应用的是 didset== 相当于set方法,一旦赋值的话,要求的是刷新表格
    var dataPart : [PartsModel]?{
        
        didSet{
            // 当设置完数据之后 就实现刷新
            tableViewFrist.reloadData()
        }
    
    }
    //定义tableView
    var tableViewFrist = UITableView()
    var tableViewSecond = UITableView()
    
    //定义参数数组
    var parmat = [String: Any]()
    
    //已经勾选的数据详情数组
//    var selectData : [PartsModel]?{
//        didSet{
//            
//            tableViewSecond.reloadData()
//        }
//    }
    
    var selectData:NSMutableArray = { return NSMutableArray() }()
    
    var selectIndex : Int = 0
    
    

    // MARK: - view的生命周期方法
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1.设置titie,leftBar和rightBar设置
        title = "使用配件"
        let item=UIBarButtonItem(title: "完成", style: UIBarButtonItemStyle.plain, target: self, action: #selector(rightBarButtonClick))
        self.navigationItem.rightBarButtonItem = item
        
        allPartsButton.isSelected = true
        
        //1.1 给scrollView 来进行添加
        createTableView(1)
        createTableView(2)
    
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
                                
//                               print(dic)
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
        tableViewFrist.register(nib, forCellReuseIdentifier: partCell)
        tableViewSecond.register(nib, forCellReuseIdentifier: partCell)
        
    }
    
    // MARK: - 创建tableView
    func createTableView(_ num : Int ){
        if num == 1{
            let tabelV = UITableView()
            tabelV.dataSource = self as UITableViewDataSource
            tabelV.delegate = self as UITableViewDelegate
            
            contentScrollView.addSubview(tabelV)
            tabelV.frame = contentScrollView.bounds
            
            self.tableViewFrist = tabelV

        }else{
            
            let tabelV = UITableView()
            tabelV.dataSource = self as UITableViewDataSource
            tabelV.delegate = self as UITableViewDelegate
            
            contentScrollView.addSubview(tabelV)
            tabelV.frame.origin = CGPoint(x: UIScreen.main.bounds.width, y: 0)
            tabelV.frame.size = contentScrollView.bounds.size ;
            self.tableViewSecond = tabelV

        }
        
    }

    // MARK: - 点击右边完成按钮
     func rightBarButtonClick(){
        
        //直接调去保存接口进行实现
        // dimiss
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    // MARK: - 配件按钮的选择
    ///所有配件
    @IBAction func allPartsButtonClick() {
        
        allPartsButton.isSelected = true
        selectPartsButton.isSelected = false
        
        self.contentScrollView.setContentOffset(CGPoint(x:0 , y: 0), animated: true)
        
        
    }
    
    ///已选配件
    @IBAction func selectPartsButtonClick() {
        
        allPartsButton.isSelected = false
        selectPartsButton.isSelected = true
        
        self.contentScrollView.setContentOffset(CGPoint(x: self.contentScrollView.bounds.width , y: 0), animated: true)
        
        self.tableViewSecond.reloadData()
        
    }
   
}

extension YQPartsLibaryViewController : UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,YQPartDataCellSwitchDelegate,YQPartDataAllFooterCellButtonDelegate,YQPartDataSelectFooterCellButtonDelegate{
    
    // MARK: - tableView的代理方法
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.tableViewFrist{
            return dataPart?.count ?? 0
            
        }else{
        
            return selectData.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : YQPartDataCell = (tableView.dequeueReusableCell(withIdentifier: partCell, for: indexPath)) as! YQPartDataCell
        if tableView == self.tableViewFrist{
        
            cell.delegate = self as YQPartDataCellSwitchDelegate
            let status = dataPart![indexPath.row]
            //传对应的模型给cell
            cell.modelcell  = dataPart![indexPath.row]
            cell.indexPath = indexPath.row
            
            //添加选择数据
            if cell.switch.isSelected {
                
                selectData.add(status)
                
            }
        
        }else{
            
//            var temp = [String: PartsModel]()
//            temp = (selectData[indexPath.row] as? [String: PartsModel])!
            cell.modelcell = selectData[indexPath.row] as? PartsModel
            cell.indexPath = indexPath.row
 
        }
    
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return Bundle.main.loadNibNamed("YQPartHeadView", owner: nil, options: nil)![0] as? UIView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if tableView == tableViewSecond {
            
            let view = Bundle.main.loadNibNamed("YQPartDataSelect", owner: nil, options: nil)![0] as? YQPartDataSelectCell
            view?.delegate = self as YQPartDataSelectFooterCellButtonDelegate
            
            return view

        }else{
        
            let view = Bundle.main.loadNibNamed("YQPartDataAll", owner: nil, options: nil)![0] as? YQPartDataFooterCell
            view?.delegate = self as YQPartDataAllFooterCellButtonDelegate
            return view
        }
        
    }
    
    
    //headView的高度:
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 44
    }
    //footerView的高度
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
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
                            //  遍历数组,字典转模型,最核心的是,将字典数组,转化成模型来进行
                            //  print(partList)
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
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        self.scrollViewDidEndScrollingAnimation(scrollView)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        //判断上面的显示的按钮的情况
        let value = abs(self.contentScrollView.contentOffset.x / self.contentScrollView.frame.size.width)
        
        if value == 0{
            //allbutton 选择了
            self.allPartsButtonClick()
        }else{
            //selectbutton 选择了
            self.selectPartsButtonClick()
        }

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //判断显示的子view来展示
        self.view.endEditing(true)
        
    }
    
    // MARK: - PartDataCellSwitchDelegate的执行
    func partDataCellSwitchDelegate(num: String,numIndex: Int, model: PartsModel){
        //存储 已选数据的代理方法
//        var newmodel = [Any]()
//        newmodel.append(model)
//        newmodel.append(num)
//        model.partNum = num
        
//        print("点击的行号" + num)
//        print( numIndex )
        //代理的方法,暂时是没有作用的
        
        
//        let indexPath: IndexPath = IndexPath.init(row: numIndex, section: 0)
//        self.tableViewFrist.reloadRows(at: [indexPath], with: .fade)
        
        
//        var temp = [String: PartsModel]()
//        temp["\(numIndex)"] = model
//        self.selectIndex = numIndex
//        self.selectData.add(model)
//        self.tableViewSecond .reloadData()
        
    }
    
    func partDataCellSwitchDelegateMoveModel(numIndex: Int, model: PartsModel) {
        
//        var dic = [String: PartsModel]()
//        for dict in self.selectData{
//            //移除指定内容的 model
////            print(dict)
//            dic = dict as! [String : PartsModel]
//            dic.removeValue(forKey: "\(numIndex)")
        
//        }
        
//        self.selectIndex = numIndex
//        self.tableViewSecond.reloadData()

    }
    
    // MARK: - YQPartDataFooterCellButtonDelegate代理方法
    //已选完成界面的实现
    func partDataFooterCompleteDelegate() {
        //1.现在读取已选数据,思路是 刷新表格,进行数据添加

        //2.以及界面跳转
        self.selectPartsButtonClick()
        self.navigationController?.popViewController(animated: true)
        
    }
    
    //所有界面的 确认勾选的实现
    func partDataFooterMakeSureCheckDelegate() {
        
        //重新加载allPart,清空渲染tableViewSecond数据
        self.selectData.removeAllObjects()
        
        //逻辑调整
        tableViewFrist.reloadData()

        //传递已选配件,pop相应控件
        self.selectPartsButtonClick()
        
    }
    
}



