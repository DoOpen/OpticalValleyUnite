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
    var dataArray = [Any]()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //选中的button
        self.pendingButton.isSelected = true
        selectButton = self.pendingButton
        self.title = "装修管理"
        self.automaticallyAdjustsScrollViewInsets = false

        
        //0.默认要求选择项目
        let _ = setUpProjectNameLable()
        
        if self.parkID == "" {
            
            let project = UIStoryboard.instantiateInitialViewController(name: "YQAllProjectSelect")
            self.navigationController?.pushViewController(project, animated: true)
        }

        //1.设置leftRightBar按钮
        addRightBarButtonItem()
        
    
        //3.添加上下拉的刷新
        addRefirsh()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //1.接口请求listdata,包括的是 筛选条件的查询
        getDataListFunction(tag: (selectButton?.tag)!,pramert : [String : Any]())
        
    }
    
    
    // MARK: - button点击切换按钮点击
    @IBAction func stateButtonClick(_ sender: UIButton) {
        
        //通过的是tag值来进行的判断处理:
        selectButton?.isSelected = false
        sender.isSelected = true
        selectButton = sender
        
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
        
//        SVProgressHUD.show()
//        
//        HttpClient.instance.post(path: URLPath.getDecorationList, parameters: par, success: { (response) in
//            SVProgressHUD.dismiss()
//            
//            let data = response as? Array<[String : Any]>
//            //字典转模型,数据拼接累加
//            
//            
//            
//        }) { (error) in
//            
//            SVProgressHUD.showError(withStatus: error.description)
//            
//        }
        
    
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
            
        })
        
        
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            
            var par = [String : Any]()
            
            
        })
        
    }
   

}

extension YQDecorationHomeVC : UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        return UITableViewCell()
    }
    

}

