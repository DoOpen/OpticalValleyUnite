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
    var currentIndex  = 0
    var type = 1
    
    /// rank模型的数据
    var rankData = [YQStepShowModel](){
        
        didSet{
            
            self.tableView.reloadData()
        }
    
    }
    
    //设置注册 计步设备的
//    lazy var counter = { () -> CMPedometer
//        
//        in
//        
//        return CMPedometer()
//    }()
    
    lazy var yesterday : String = { () -> String
        in
        
        let date = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let byesterday = NSDate.init(timeInterval: -60*60*24*1, since: date as Date)
        
        let yes = formatter.string(from: byesterday as Date)
        
        return yes
        
    }()


    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //1.设置leftbar的返回界面
        let btn = UIButton()
        btn.frame = CGRect(x: 0, y: 0, width: 40, height: 40 )
        
        btn.setImage(UIImage(named: "icon_fire_return"), for: .normal)
        btn.addTarget(self, action: #selector(leftBarItemButtonClick), for: .touchUpInside)
        
        let leftBar = UIBarButtonItem()
        leftBar.customView = btn
        
        self.navigationItem.leftBarButtonItem = leftBar
        
        //2.获取计步的数据内容(登录界面进行的存取 计步器的内容,拿去数据)
        getStepDataForService()
        
        stepFunctionDidStart()
        
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
        
        //获取昨天 和 前天的时间数据
//        let date = NSDate()
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        
//        var dateString = formatter.string(from: date as Date)
//        
////        let index =  dateString.index( (dateString.startIndex)!, offsetBy: 10)
////        dateString.remove(at: dateString.index(after: 8))
//
////        let replaceRangeAll = dateString.index(after: " ")...dateString.index(before:dateString.endIndex)
////
////        dateString.replaceSubrange(replaceRangeAll, with: "08:00:00")
//        
//        let dateNow = formatter.date(from: dateString)
//        
//        //            let yesterday = NSDate.init(timeInterval: -60*60*24*1, since: date as Date)
//        let byesterday = NSDate.init(timeInterval: -60*60*24*1, since: dateNow!)
        
        
    
        if !CMPedometer.isStepCountingAvailable() {
            
            self.alert(message: "设备不可用! 支持5s及以上的机型")
            
        }
        
        
//        else{
//            
//            //计步器的对象 就是在这个主队列中进行更新完成的
////            self.counter.startStepCountingUpdates(to: OperationQueue.main, updateOn: 5, withHandler: { (Steps, timestamp, Error) in
////                
////                if (Error != nil) {
////                    
////                    return
////                }
////                
////                print("实际走的数量的情况" + "\(Steps)")
////                
////                self.testLabel.text = "测试显示的步数" + "\(Steps)"
////                
////            })
//            
//            //获取昨天 和 前天的时间数据
//            let date = NSDate()
//            let formatter = DateFormatter()
//            formatter.dateFormat = "yyyy-MM-dd"
//            
//            let dateString = formatter.string(from: date as Date)
//            
//            _ = formatter.date(from: dateString)
//            
////            let yesterday = NSDate.init(timeInterval: -60*60*24*1, since: date as Date)
//            let byesterday = NSDate.init(timeInterval: -60*60*24*1, since: date as Date)
//            
////            print(yesterday)
////            print(byesterday)
//            
//            //直接应用的是 CMPedometer 获取系统的健康的应用
//            self.counter.queryPedometerData(from: byesterday as Date, to: date as Date , withHandler: { (pedometerData, error) in
//                
//                let num = pedometerData?.numberOfSteps ?? 0
//                let distance = pedometerData?.distance ?? 0
//                
//                DispatchQueue.main.async {
//                    
//                    self.testLabel.text = "测试显示的步数" + "\(num)"
//                }
//                
//                
//                print("运动的距离是" + "\(distance)")
//                
//            })
//            
//        }
        
    }
    
    

    // MARK: - 获取运动的当前步数的方法
    func getStepDataForService(){
        
        //1.获取数据库的上一条的数据来进行的显示
        var parameters = [String : Any]()
        parameters["date"] = yesterday
        
        HttpClient.instance.post(path: URLPath.getMinePedometer, parameters: parameters, success: { (reponse) in
            //读取数据,字典转模型
            DispatchQueue.main.async {
                //设置项目排名
                let project = "第" + "\(reponse["projectRankno"])"  + "名"
                let depart = "第" + "\(reponse["departmentRankno"])" + "名"
                self.projectRankingButton.setTitle(project, for: .normal)
                self.departmentRankingButton.setTitle(depart, for: .normal)
                self.stepLabel.text = "\(reponse["steps"])"
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
    
    // MARK: - 获取list的数据,整体的列表的数据刷新
    func getRankForAllData(indexPage : Int = 0 , date : String = "", dic : [String : Any]  = [String: Any]()){
        
        var parmat = [String: Any]()
        
        parmat["pagesize"] = 20
        parmat["pageno"] = currentIndex
        
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
            
            if indexPage == 0{
                
                self.currentIndex = 0
                self.rankData = temp
                self.tableView.mj_header.endRefreshing()
                
            }else{
                
                if temp.count > 0{
                    self.currentIndex = indexPage + 1
                    
                    self.rankData.append(contentsOf: temp)
                    self.tableView.mj_footer.endRefreshing()
                    
                }else{

                    self.tableView.mj_footer.endRefreshing()
                }
            }

        }) { (error) in
            
            SVProgressHUD.showError(withStatus: error.description)
            
            self.tableView.mj_footer.endRefreshing()

        }
        
    }

    
    // MARK: - 上下拉的刷新的界面情况
    func addRefirsh(){
        
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            
            var par = [String : Any]()
            par["type"] = self.type
            par["date"] = self.yesterday

            
            self.getRankForAllData(indexPage: self.currentIndex + 1)
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? YQStepStatisticsView
        if cell == nil {
            
            cell = Bundle.main.loadNibNamed("YQStepStatistics", owner: nil, options: nil)?[0] as? YQStepStatisticsView
            
        }
        
        cell?.backgroundColor =  UIColor.clear
        
        cell?.type = self.type
        cell?.model = self.rankData[indexPath.row]
        
        
        return cell!
    }
    
    
}
