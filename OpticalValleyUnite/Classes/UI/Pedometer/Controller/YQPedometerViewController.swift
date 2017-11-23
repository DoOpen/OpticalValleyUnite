//
//  YQPedometerViewController.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/11/10.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit
import SVProgressHUD
import CoreMotion
import MJRefresh

class YQPedometerViewController: UIViewController {
    
    // MARK: - 属性列表
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var backGroudImageV: UIImageView!
    
    @IBOutlet weak var testLabel: UILabel!
    
    /// 要求设置数据的属性列表
    @IBOutlet weak var stepLabel: UILabel!
    
    @IBOutlet weak var projectRankingButton: UIButton!
    
    @IBOutlet weak var departmentRankingButton: UIButton!
    
    var cellID = "stepsCell"
    var currentIndex  = 1
    var type = 1
    
    /// rank模型的数据
    var rankData = [YQStepShowModel](){
        
        didSet{
            
            self.tableView.reloadData()
        }
    
    }
    
    //设置注册 计步设备的
    lazy var counter = { () -> CMPedometer
        
        in
        
        return CMPedometer()
    }()
    
    
    lazy var yesterday : String = { () -> String
        in
        
        let date = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let yes = formatter.string(from: date as Date)
        
        return yes
        
    }()


    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //0.0获取集团版项目版的数据属性
        //获取集团和 项目版的参数
        let isgroup = UserDefaults.standard.object(forKey: Const.YQIs_Group) as? Int ?? -1
        if isgroup == 2 || isgroup == -1 {//集团版
            type = 1
            
        }else{//项目版
            
            type = 2
        }

        
        //1.0设置leftbar的返回界面
        let btn = UIButton()
        btn.frame = CGRect(x: 0, y: 0, width: 40, height: 40 )
        btn.setImage(UIImage(named: "return"), for: .normal)
        btn.addTarget(self, action: #selector(leftBarItemButtonClick), for: .touchUpInside)
        
        let leftBar = UIBarButtonItem()
        leftBar.customView = btn
        
        self.navigationItem.leftBarButtonItem = leftBar
        
//        //1.1设置rightBar的历史点击事件
//        let rightBtn = UIButton()
//        rightBtn.frame = CGRect(x: 0,y : 0, width: 40, height: 40)
//        
//        rightBtn.setTitle("历史", for: .normal)
//        rightBtn.addTarget(self, action: #selector(rightBarItemButtonClick), for: .touchUpInside)
//        
//        let rightBar = UIBarButtonItem()
//        rightBar.customView = rightBtn
//        
//        self.navigationItem.rightBarButtonItem = rightBar
        
        
        //1.2 隐藏nav导航栏背景,去线的功能,设置navtitle的富文本的属性
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        let attr: NSMutableDictionary! = [NSForegroundColorAttributeName: UIColor.white]
         UINavigationBar.appearance().titleTextAttributes = attr as? [String : Any]
        
        //1.3 先保存上传计步数据
        stepFunctionDidStart()
        
        
        //2.获取计步的数据内容(登录界面进行的存取 计步器的内容,拿去数据)
        getStepDataForService()
        
        
        //3.添加刷新的情况
        addRefirsh()
        
    }
    
    // MARK: - 项目,部门排序详情界面的跳转
    @IBAction func rankDetailJumpClick(_ sender: UIButton) {
        
        let rankDetail = UIStoryboard.instantiateInitialViewController(name: "YQStepScreen") as? YQStepScreenViewController
        rankDetail?.type = sender.tag
        
        navigationController?.pushViewController(rankDetail!, animated: true)
    }
    
    
    // MARK: - 计步功能的模块实现
    func stepFunctionDidStart() {
        
        if !CMPedometer.isStepCountingAvailable() {
            
            self.alert(message: "设备不可用! 支持5s及以上的机型")
            return
            
        }else{
            
            //获取昨天 和 前天的时间数据
            let date = NSDate()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let formatter1 = DateFormatter()
            formatter1.dateFormat = "yyyy-MM-dd"
            let temp = formatter1.string(from: date as Date)
            let tempstring = temp.appending(" 00:00:00")
            
            let nowdate = formatter.date(from: tempstring)
            
            //直接应用的是 CMPedometer 获取系统的健康的应用
            self.counter.queryPedometerData(from: nowdate!, to: date as Date , withHandler: { (pedometerData, error) in
                
                let num = pedometerData?.numberOfSteps ?? 0
                //上传前一天的步数
                
                DispatchQueue.main.async {
                    
                    var parameter = [String : Any]()
                    parameter["date"] = temp
                    
                    parameter["steps"] = num
                    
                    self.stepLabel.text = "\(num)"
                    
                    HttpClient.instance.post(path: URLPath.getSavePedometerData, parameters: parameter, success: { (respose) in
                        
                        
                    }, failure: { (error) in
                        
                    })
                }
                
            })
        }
        
    }
    
    
    // MARK: - 获取运动的当前步数的方法
    func getStepDataForService(){
        
        //1.获取数据库的上一条的数据来进行的显示
        var parameters = [String : Any]()
        parameters["date"] = yesterday
        
        HttpClient.instance.post(path: URLPath.getMinePedometer, parameters: parameters, success: { (reponse) in
            
            let num1 = (reponse["projectRankno"])!
            let num2 = (reponse["departmentRankno"])!
            //读取数据,字典转模型
            DispatchQueue.main.async {
                //设置项目排名
                let project = "第" + "\(num1!)"  + "名"
                let depart = "第" + "\(num2!)" + "名"
                self.projectRankingButton.setTitle(project, for: .normal)
                self.departmentRankingButton.setTitle(depart, for: .normal)
                
            }
            
            
        }) { (error) in
            
          SVProgressHUD.showError(withStatus: error.description)

        }
        
        //获取list 这个项目版的数据的渲染
        parameters["type"] = type //默认的显示的是集团版项目的筛选\
        parameters["pagesize"] = 20
        parameters["pageno"] = currentIndex
        
        getRankForAllData(dic: parameters)
        
    }
    
    // MARK: - leftbuttonClick的方法
    func leftBarItemButtonClick(){
        
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
//            
//        }
        
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    // MARK: - rightBarItemButtonClick的方法
    func rightBarItemButtonClick(){
        
        //
    
    
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
        
        HttpClient.instance.post(path: URLPath.getRankPedometer, parameters: parmat, success: { (respose) in
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
            self.stepFunctionDidStart()
            self.getStepDataForService()
            
            self.getRankForAllData(indexPage: 1 ,dic : par)
            
        })

        
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            
            var par = [String : Any]()
            par["type"] = self.type
            par["date"] = self.yesterday

            self.getRankForAllData(indexPage: self.currentIndex + 1 ,dic : par)
            
        })
        
    }
    
    

    

}


extension YQPedometerViewController : UITableViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.rankData.count 
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = Bundle.main.loadNibNamed("YQStepHead", owner: nil, options: nil)?[0] as? YQStepHeadView
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? YQStepStatisticsView
        if cell == nil {
            
            cell = Bundle.main.loadNibNamed("YQStepStatistics", owner: nil, options: nil)?[0] as? YQStepStatisticsView
            
        }
        
        cell?.backgroundColor =  UIColor.clear
        
        cell?.indepathrow = indexPath.row
        cell?.indexHeadImageHidde = true
        cell?.type = self.type
        cell?.model = self.rankData[indexPath.row]
        
        
        return cell!
    }
    
    
}
