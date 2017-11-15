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
    
    //设置注册 计步设备的
    lazy var counter = {() -> CMPedometer
        
        in
        
        return CMPedometer()
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
        
        //2.添加开启计步器
        self.stepFunctionDidStart()
        
        //3.获取计步的数据内容
        
        
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
            
        }else{
            
            //计步器的对象 就是在这个主队列中进行更新完成的
//            self.counter.startStepCountingUpdates(to: OperationQueue.main, updateOn: 5, withHandler: { (Steps, timestamp, Error) in
//                
//                if (Error != nil) {
//                    
//                    return
//                }
//                
//                print("实际走的数量的情况" + "\(Steps)")
//                
//                self.testLabel.text = "测试显示的步数" + "\(Steps)"
//                
//            })
            
            //获取昨天 和 前天的时间数据
            let date = NSDate()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let dateString = formatter.string(from: date as Date)
            
            _ = formatter.date(from: dateString)
            
//            let yesterday = NSDate.init(timeInterval: -60*60*24*1, since: date as Date)
            let byesterday = NSDate.init(timeInterval: -60*60*24*1, since: date as Date)
            
//            print(yesterday)
//            print(byesterday)
            
            //直接应用的是 CMPedometer 获取系统的健康的应用
            self.counter.queryPedometerData(from: byesterday as Date, to: date as Date , withHandler: { (pedometerData, error) in
                
                let num = pedometerData?.numberOfSteps ?? 0
                let distance = pedometerData?.distance ?? 0
                
                DispatchQueue.main.async {
                    
                    self.testLabel.text = "测试显示的步数" + "\(num)"
                }
                
                
                print("运动的距离是" + "\(distance)")
                
            })
            
        }
    }

    // MARK: - 获取运动的当前步数的方法
    func getStepDataForService(){
        
        //1.获取数据库的上一条的数据来进行的显示
        
        var parameters = [String : Any]()
        parameters["date"] = ""
        
        HttpClient.instance.post(path: URLPath.getMinePedometer, parameters: parameters, success: { (reponse) in
            //读取数据,字典转模型
            
            
            
        }) { (error) in
            
          SVProgressHUD.showError(withStatus: error.description)

        }
        
        
    }
    
    // MARK: - leftbuttonClick的方法
    func leftBarItemButtonClick(){
        
        //返回子系统选择的界面
        //查看是否有缓存的数据
        let data = UserDefaults.standard.object(forKey: Const.YQTotallData) as? NSArray
        //跳转到子系统的选择界面(需要的是逻辑的判断) 如果是只有一条数据的话,直接调到登录界面
        if (data?.count)! > 1{
            
            let systemVC = YQSystemSelectionVC(nibName: "YQSystemSelectionVC", bundle: nil)
            SJKeyWindow?.rootViewController = systemVC
            
            
        }else{// 跳转到登录界面
            
            LoginViewController.loginOut()
            
        }
        
    }
    
    

}

extension YQPedometerViewController : UITableViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = Bundle.main.loadNibNamed("YQStepHead", owner: nil, options: nil)?[0] as? YQStepHeadView
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.backgroundColor =  UIColor.clear
        
        return cell
    }
    
    
}
