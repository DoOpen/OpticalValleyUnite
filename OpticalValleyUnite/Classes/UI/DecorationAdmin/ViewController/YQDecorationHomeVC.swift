//
//  YQDecorationHomeVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/2/5.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit
import MJRefresh
import SVProgressHUD


class YQDecorationHomeVC: UIViewController {

    var parkID : String = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var pendingButton: UIButton!
    
    @IBOutlet weak var alreadlyButton: UIButton!
    
    //当前选中的button
    var selectButton : UIButton?
    
    //模型数据数组
    var dataArray = [YQDecorationHomeModel](){
        
        didSet{
            
            self.tableView.reloadData()
        }
        
    }
    
    //通知筛选模型
    var notiesPramert : [String : Any]?
    
    //当前索引
    var currentIndex = 0
    
    //
    var cellID = "decorationHomeCell"
    
    var parkName = ""
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //选中的button
        self.pendingButton.isSelected = true
        selectButton = self.pendingButton
        self.title = "装修管理"
        self.automaticallyAdjustsScrollViewInsets = false

        //0.默认要求选择项目
        self.parkName = setUpProjectNameLable()
        
//        if self.parkID == "" {
//            
//            let project = UIStoryboard.instantiateInitialViewController(name: "YQAllProjectSelect")
//            self.navigationController?.pushViewController(project, animated: true)
//        }
        
        //0.默认获取数据
        getDataListFunction(tag: (selectButton?.tag)!,pramert : [String : Any]())

        //1.设置leftRightBar按钮
        addRightBarButtonItem()
        
        //3.添加上下拉的刷新
        addRefirsh()
        
        //4.接受通知
        addNoties()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        let newName  = setUpProjectNameLable()
        
        if self.parkName != newName {
            
            self.parkName = newName
            //1.接口请求listdata,包括的是 筛选条件的查询
            getDataListFunction(tag: (selectButton?.tag)!,pramert : [String : Any]())
        }
        
    }
    
    
    // MARK: - button点击切换按钮点击
    @IBAction func stateButtonClick(_ sender: UIButton) {
        
        //通过的是tag值来进行的判断处理:
        selectButton?.isSelected = false
        sender.isSelected = true
        selectButton = sender
        
        self.dataArray.removeAll()
        
        getDataListFunction(tag: (selectButton?.tag)!)
        
    }
    
    
    // MARK: - 添加默认的项目选择方法
    func setUpProjectNameLable() -> String{
        
        let dic = UserDefaults.standard.object(forKey: Const.YQProjectModel) as? [String : Any]
        
        var projectName  = ""
        
        if dic != nil {
            
            projectName = dic?["PARK_NAME"] as! String
            self.parkID = dic?["ID"] as! String
            
        }else{
            
            projectName = "请选择默认项目"
        }
        
        return projectName
    }
    
    // MARK: - 获取list数据的内容方法
    func getDataListFunction(tag : Int = 0,currentIndex : Int = 0,pageSize : Int = 20,pramert : [String : Any] = [String : Any]()){
    
        var par = [String : Any]()
        par["parkId"] = self.parkID
        par["pageSize"] = pageSize
        par["pageIndex"] = currentIndex
        par["operateType"] = "\(tag)"
//        par["houseId"] = ""
//        par["decorationType"] = ""
        
        if self.parkID == "" {
            
            self.alert(message: "请选择项目", doneBlock: { (alert) in
                let project = UIStoryboard.instantiateInitialViewController(name: "YQAllProjectSelect")
                self.navigationController?.pushViewController(project, animated: true)

            })
            
            return
        }
        
        for (key,value) in pramert {
            
            par[key] = value
        }
        
        SVProgressHUD.show()
        
        HttpClient.instance.post(path: URLPath.getDecorationList, parameters: par, success: { (response) in
            SVProgressHUD.dismiss()
            
            let data = response["data"] as? Array<[String : Any]>
            //字典转模型,数据拼接累加
            if data == nil {
                SVProgressHUD.showError(withStatus: "没有更多数据!")
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.endRefreshing()
                self.dataArray.removeAll()
                
                return
            }
            
            var tempModel = [YQDecorationHomeModel]()
            
            for temp in data! {
                
                tempModel.append(YQDecorationHomeModel.init(dict: temp))
            }
            
            //添加上拉下拉刷新的情况
            if currentIndex == 0 {
                
                self.dataArray = tempModel
                self.tableView.mj_header.endRefreshing()
                
            }else{
                
                if tempModel.count > 0{
                    
                    self.currentIndex = currentIndex
                    
                    self.dataArray.append(contentsOf: tempModel)
                    
                }
                
                self.tableView.mj_footer.endRefreshing()
                
            }

            
        }) { (error) in
            
            SVProgressHUD.showError(withStatus: error.description)
            
        }
        
    
    }

    
    // MARK: - 添加rightBarbutton选项
    func addRightBarButtonItem(){
        
        let button = UIButton()
        button.frame = CGRect.init(x: 0, y: 0, width: 50, height: 40)
        button.setTitle("筛选", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.sizeToFit()
        button.addTarget(self, action: #selector(screenToDecorationVC), for: .touchUpInside)
        
        let barItem = UIBarButtonItem()
        barItem.customView = button
        
        navigationItem.rightBarButtonItem = barItem
        
    }

    
    // MARK: - 跳转到筛选的工作界面
    func screenToDecorationVC (){
        
        let screen = YQDecorationScreenVC.init(nibName: "YQDecorationScreenVC", bundle: nil)

        navigationController?.pushViewController(screen, animated: true)
    }
    

    // MARK: - 上下拉的刷新的界面情况
    func addRefirsh(){
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            
            var par = [String : Any]()
            
            if self.notiesPramert != nil{
                
                for (key,value) in self.notiesPramert! {
                    
                    par[key] = value
                }
            }
            
            self.getDataListFunction(tag: (self.selectButton?.tag)!, currentIndex: 0, pramert: par)
            
        })
        
        
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            
            var par = [String : Any]()
            
            if self.notiesPramert != nil{
                
                for (key,value) in self.notiesPramert! {
                    
                    par[key] = value
                }
            }
            
            self.getDataListFunction(tag: (self.selectButton?.tag)!, currentIndex: self.currentIndex + 1, pramert: par)
            
        })
        
    }
    
    // MARK: - 接受通知方法
    func addNoties(){
    
        let center = NotificationCenter.default
        let notiesName = NSNotification.Name(rawValue: "selectHouseNoties")
        center.addObserver(self, selector: #selector(getScreenHouseID(info :)), name: notiesName, object: nil)
        
        
    }
    
    func getScreenHouseID(info : Notification){
        
        let value = info.userInfo?["selectLocation"] as? String
        let value2 = info.userInfo?["decorationType"] as? Int
        
        var pramert = [String : Any]()
        
        if value != nil {

            pramert["houseId"] = value
        }
        
        if value2 != nil {
        
            pramert["decorationType"] = "\(value2!)"
        }
        
    
        //刷新数据
        getDataListFunction(pramert: pramert)
        
    }
    
    
    deinit {
        
        let center = NotificationCenter.default
        center.removeObserver(self)
        
    }
   

}

extension YQDecorationHomeVC : UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 140
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //跳转到工单执行的页面的情况
        let vc = WorkOrderProgressViewController.loadFromStoryboard(name: "WorkOrder") as! WorkOrderProgressViewController
               let model = dataArray[indexPath.row]
        
        var parmat = [String: Any]()
        parmat["UNIT_STATUS"] = model.UNIT_STATUS
        parmat["PERSONTYPE"] = model.IS_ASSISTANCE_PERSON
        parmat["EXEC_PERSON_ID"] = model.EXEC_PERSON_ID
        parmat["WORKUNIT_ID"] = model.ID
        
        vc.parmate = parmat
        
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? YQDecorationHomeCell
        
        if cell == nil{
            
            cell = Bundle.main.loadNibNamed("YQDecorationHomeCell", owner: nil, options: nil)?[0] as? YQDecorationHomeCell
            
        }
        
        cell?.indexID = (self.selectButton?.tag)!
        cell?.parkName = self.parkName
        cell?.model = self.dataArray[indexPath.row]
        
        return cell!
    }
    

}

