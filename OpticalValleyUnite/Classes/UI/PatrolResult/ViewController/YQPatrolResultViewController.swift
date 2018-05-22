//
//  YQPatrolResultViewController.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/12/9.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh
import KYDrawerController

class YQPatrolResultViewController: UIViewController {
    ///属性列表
    @IBOutlet weak var pointSearch: UITextField!

    @IBOutlet weak var personNameSearch: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    var currentIndex = 0
    
    var parkId = ""
    
    /// 模型数组
    var dataArray = [YQResultCellModel](){
        
        didSet{
            
            self.tableView.reloadData()
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //2. 获取map数据
        let _ = setUpProjectNameLable()
        
        if self.parkId == "" {
            
            let project = UIStoryboard.instantiateInitialViewController(name: "YQAllProjectSelect")
            self.navigationController?.pushViewController(project, animated: true)
        }

        //2.实现上拉下拉刷新
        addRefirsh()
        
        addLeftRightBarButtonFunction()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let _ = setUpProjectNameLable()
        //1.获取数据
        makeUpData()
    }
    
    
    func makeUpData(pageIndexxxxx : Int = 0,pageSize : Int = 20, dic : [String : Any] = [String : Any]()) {
        
        var par = [String : Any]()
        
        par["pageIndex"] = pageIndexxxxx
        par["pageSize"] = pageSize
        par["insPointName"] = self.pointSearch.text
        par["personName"] = self.personNameSearch.text
        par["parkId"] = self.parkId
        
        SVProgressHUD.show()
        
        HttpClient.instance.post(path: URLPath.getResultList, parameters: par, success: { (respose) in
            
            SVProgressHUD.dismiss()
            
            let array = respose["data"] as? NSArray
            
            if array == nil {
                
                SVProgressHUD.showError(withStatus: "查询数据为空")
                self.dataArray.removeAll()
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.endRefreshing()
                return
                
            }
            
            //拿到数据字典转模型
            var temp = [YQResultCellModel]()
            
            for dic in array! {
                
                temp.append(YQResultCellModel.init(dict: dic as! [String : Any]))
            }

            
            if pageIndexxxxx == 0 {
            
                if respose["data"] as? NSArray == nil {
                    
                    self.dataArray.removeAll()
                    self.tableView.mj_header.endRefreshing()
                    self.tableView.mj_footer.endRefreshing()
                    
                    return
                }
                
                self.dataArray = temp
                self.tableView.mj_header.endRefreshing()
                
            }else{
                
                if temp.count > 0{
                    
                    self.currentIndex = pageIndexxxxx
                    
                    self.dataArray.append(contentsOf: temp)
                    
                }
                
                self.tableView.mj_footer.endRefreshing()

            }
            
        }) { (error) in
            
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            SVProgressHUD.showError(withStatus: "数据加载失败,请检查网络!")
            
        }
        
    }
    
    // MARK: - 添加默认的项目选择方法
    func setUpProjectNameLable() -> String{
        
        let dic = UserDefaults.standard.object(forKey: Const.YQProjectModel) as? [String : Any]
        
        var projectName  = ""
        
        if dic != nil {
            
            projectName = dic?["PARK_NAME"] as! String
            self.parkId = dic?["ID"] as! String
            
            
        }else{
            
            projectName = "请选择默认项目"
        }
        
        return projectName
    }

    
    // MARK: - 添加左右barItem的情况
    func addLeftRightBarButtonFunction(){
        
        let leftBtn = UIButton()
        leftBtn.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        leftBtn.setImage(UIImage(named: "icon_fire_return"), for: .normal)
        leftBtn.addTarget(self, action: #selector(leftBarButtonClick), for: .touchUpInside)
        
        let barItem = UIBarButtonItem()
        barItem.customView = leftBtn
        
        self.navigationItem.leftBarButtonItem = barItem
    
    }
    func leftBarButtonClick() {
//        //返回子系统选择的界面
//        //查看是否有缓存的数据
//        let data = UserDefaults.standard.object(forKey: Const.YQTotallData) as? NSArray
//        //跳转到子系统的选择界面(需要的是逻辑的判断) 如果是只有一条数据的话,直接调到登录界面
//        if (data?.count)! > 1{
//            
//            let systemVC = YQSystemSelectionVC(nibName: "YQSystemSelectionVC", bundle: nil)
//            SJKeyWindow?.rootViewController = systemVC
//            
//            
//        }else{// 跳转到登录界面
//            
//            LoginViewController.loginOut()
//        }
        
        self.dismiss(animated: true, completion: nil)

        
    }
    
    // MARK: - 上下拉的刷新的界面情况
    func addRefirsh(){
    
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            
            self.makeUpData()
            
        })
        
        
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            
            self.makeUpData(pageIndexxxxx: self.currentIndex + 1)
            
        })
        
    }

    // MARK: - 巡查轨迹ButtonItem的点击事件
    @IBAction func patrolResultClick(_ sender: UIBarButtonItem) {
        
        let resultMap = UIStoryboard.instantiateInitialViewController(name: "YQResultMapView")
        
        let mainViewController   = resultMap
        let drawerViewController = YQpatrolResultDrawerViewController()
        // 初始化drawer抽屉的情况
        let drawerController     = KYDrawerController(drawerDirection: .right, drawerWidth: 300)
        drawerController.mainViewController =  mainViewController
        
        drawerController.drawerViewController = drawerViewController

        
//        navigationController?.pushViewController(drawerController, animated: true)
        
        self.present(drawerController, animated: true, completion: nil)
        
    }
    
    @IBAction func searchButtonClick(_ sender: UIButton) {
        
        if pointSearch.text == "" && personNameSearch.text == "" {
            
            self.alert(message: "请填写输入搜索条件")
            
        }else{
            
            self.view.endEditing(true)
            
            self.makeUpData()
        }
        
    }
    
    

}

extension YQPatrolResultViewController : UITableViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArray.count
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = Bundle.main.loadNibNamed("YQResultCellHead", owner: nil, options: nil)?[0] as? YQResultCellHeadView
        
        return view
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as? YQResultViewCell
        cell?.indexpathRow = indexPath.row
        cell?.delegate = self
        cell?.model = self.dataArray[indexPath.row]
        
        return cell!
    }

}

extension YQPatrolResultViewController : YQResultViewCellDelegate{
    
    func resultViewCellDelegate(view: UIView, indexRow: Int) {
        //传递参数, 跳转到详情页面
        let detail = UIStoryboard.instantiateInitialViewController(name : "YQResultDetail") as? YQResultDetailViewController
        
        let model = self.dataArray[indexRow]
        detail?.insResultId = model.insResultId
        
        navigationController?.pushViewController(detail!, animated: true)
        
    }

}
