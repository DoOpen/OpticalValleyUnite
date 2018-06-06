//
//  ViewController.swift
//    OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/1/10.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import Alamofire
import SnapKit
import CoreMotion

let KDistence = 25.0
let KTime = 60 * 15

let mNavigationBarHeight: CGFloat = 84
let Spacing : CGFloat = 14


class HomeViewController: UIViewController,CheckNewBundleVersionProtocol {
    
    @IBOutlet weak var messageBtn: UIButton!
    @IBOutlet weak var scanBtn: UIButton!
    
    var eixtButton : UIButton! = nil
    
    /// 子系统选择的数据
    var systemSelection : NSDictionary = {return NSDictionary() }()
    
    
    /// 模型的数据解析model.swift中的类
    var datas = [SystemMessageModel]()
    
    var locationManager = AMapLocationManager()
    
    var lastUpdateTime = Date().addingTimeInterval(-6.0 * 60.0)
    var workCount = 0
    var dubanCount = 0
    
    /// 上面的4个按钮的拖线的事件
    @IBOutlet weak var top1BtnView: HomeBtnView!
    @IBOutlet weak var top2BtnView: HomeBtnView!
    @IBOutlet weak var top3BtnView: HomeBtnView!
    @IBOutlet weak var top4BtnView: HomeBtnView!
 
    /// 下面的3个按钮的拖线的事件
    @IBOutlet weak var donw1BtnView: HomeBtnView!
    @IBOutlet weak var donw2BtnView: HomeBtnView!
    @IBOutlet weak var donw3BtnView: HomeBtnView!

    var topBtnViewArray = [HomeBtnView]()
    var downBtnViewArray = [HomeBtnView]()
    
    var allPermissionModels = [PermissionModel]()
    var downPermissionModels = [PermissionModel]()
    
    /// 项目选择按钮
    @IBOutlet weak var projectButton: UIButton!
    
    
    /// tabelView的拖线的指针
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var subsystemBtn: UIButton!
    
    /// 天气button显示:
    @IBOutlet weak var weatherBtn: UIButton!
    
    /// 搜索情况
    var search: AMapSearchAPI!
    var locaCity : String = ""
    var weatherTvc : UITableViewController?
    
    ///计步器的功能模块属性
    //设置注册 计步设备的
    lazy var counter = { () -> CMPedometer
        
        in
        return CMPedometer()
    }()
    
    //改版home首页的属性
    /**
     *  自定义的navigationBar,添加默认的xib的情况
     */
    lazy var mCustomOneNavigationBar: UIView = {
        
        let tmp: UIView = UIView.init(frame: CGRect.init(x: 0, y: Spacing, width: SJScreeW, height: mNavigationBarHeight - Spacing))
        tmp.backgroundColor = UIColor.clear
        let v =  Bundle.main.loadNibNamed("YQDefaultHomeNavView", owner: nil, options: nil)?[0] as! UIView
        v.backgroundColor = UIColor.clear
        tmp.addSubview(v)
        v.snp.makeConstraints { (make) in

            make.left.right.top.bottom.equalToSuperview()
        }
        
        return tmp
        
    }()
    
    lazy var mCustomTwoNavigationBar: UIView = {
        
        let tmp: UIView = UIView.init(frame: CGRect.init(x: 0, y: Spacing, width: SJScreeW, height: mNavigationBarHeight - Spacing))
        tmp.backgroundColor = UIColor.clear
        let subV =  Bundle.main.loadNibNamed("YQOtherHomeNavView", owner: nil, options: nil)?[0] as! UIView
        
        subV.backgroundColor = UIColor.clear
        tmp.alpha = 0
        tmp.addSubview(subV)
        
        subV.snp.makeConstraints { (make) in
            
            make.left.right.top.bottom.equalToSuperview()
        }
        
        return tmp
        
    }()
    
    
    lazy var mCustomNavigationBar: UIView = {
        
        let tmp: UIView = UIView()
        
        tmp.backgroundColor = UIColor.init(red: 73/255.0, green: 167/255.0, blue: 238/255.0, alpha: 0.9)
        
        tmp.addSubview(self.mCustomOneNavigationBar)
        tmp.addSubview(self.mCustomTwoNavigationBar)
        
        return tmp
    }()
    
    /**
     *  RefreshHeader
     */
    let mRefreshHeaderHeight: CGFloat = 65
    
    lazy var mRefreshHeader: MYPRefreshHeader = {
        
        let tmp: MYPRefreshHeader = MYPRefreshHeader.init(frame: CGRect.init(x: 0, y: self.mTopOneViewHeight + self.mTopTwoViewHeight - self.mRefreshHeaderHeight, width: kScreenWidth, height: self.mRefreshHeaderHeight))
        tmp.mDelegate = self
        tmp.mRefreshStatus = MRefreshStatus.normal
        
        return tmp
        
    }()
    
    
    /**
     *  TOPView相关
     */
    let mTopOneViewHeight: CGFloat = 90
    let mTopTwoViewHeight: CGFloat = 90
    let mTopThreeViewHeight : CGFloat = 35
    
    lazy var mTopOneView: UIView = {
        let tmp: UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: self.mTopOneViewHeight))
        tmp.backgroundColor = UIColor.clear
        // 放置一些控件增加视觉效果
        let TopView = Bundle.main.loadNibNamed("YQHomeTopView", owner: nil, options: nil)?[0] as! YQHomeTopView
        TopView.backgroundColor = UIColor.init(red: 73/255.0, green: 167/255.0, blue: 238/255.0, alpha: 0.9)
        
        tmp.addSubview(TopView)
        
        self.topBtnViewArray = TopView.topBtnViewArray
        
        TopView.snp.makeConstraints({ (maker) in
            
            maker.left.right.top.bottom.equalToSuperview()
        })
        
        return tmp
    }()
    
    lazy var mTopTwoView: UIView = {
        
        let tmp: UIView = UIView.init(frame: CGRect.init(x: 0, y: self.mTopOneViewHeight, width: kScreenWidth, height: self.mTopTwoViewHeight))
        tmp.backgroundColor = UIColor.white
        
        let contentV = Bundle.main.loadNibNamed("YQHomeContentView", owner: nil, options: nil)?[0] as! YQHomeContentView
        
        tmp.addSubview(contentV)
        
        self.downBtnViewArray = contentV.downBtnViewArray
        
        contentV.snp.makeConstraints({ (maker) in
            
            maker.left.right.top.bottom.equalToSuperview()
        })
        
        return tmp
    }()
    
    lazy var mTopThreeView : UIView = {
        
        let tmp: UIView = UIView.init(frame: CGRect.init(x: 0, y: self.mTopOneViewHeight + self.mTopTwoViewHeight, width: kScreenWidth, height: self.mTopThreeViewHeight))
        tmp.backgroundColor = UIColor.white
        
        let contentV = Bundle.main.loadNibNamed("YQHomeNoticeContentView", owner: nil, options: nil)?[0] as! YQHomeNoticeContentView
        
        tmp.addSubview(contentV)
        
        contentV.snp.makeConstraints({ (maker) in
            
            maker.left.right.top.bottom.equalToSuperview()
        })
        
        return tmp
        
    }()
    
    
    
    lazy var mTopView: UIView = {
        
        let tmp: UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: self.mTopOneViewHeight + self.mTopTwoViewHeight + self.mTopThreeViewHeight))
        
        tmp.addSubview(self.mTopOneView)
        tmp.addSubview(self.mTopTwoView)
        tmp.addSubview(self.mTopThreeView)
        
        return tmp
    }()
    

    
    // MARK: - 视图生命周期方法
    override func viewDidLoad() {
        
        super.viewDidLoad()

        //原始init
        self.automaticallyAdjustsScrollViewInsets = false
        
        //改版的init的方法
        homeInterfaceReversionInit()
        
        //接受权限设置的模块
        getPermission()

        //接受VC的数据通知
        receiveNotes()
        
        //获取app版本号的方法
        checkNewBundleVersion(isBlack: true)
        
        //再次获取计步数据
        stepFunctionDidStart()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationItem.title = "光谷联合"
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        //设置定位
        setUpLocation()
        
        //接受服务消息通知
        getNotice()
        
        //搜索
        initSearch()
        
        //获取项目选择title
        let name = setUpProjectNameLable()
        self.projectButton.setTitle(name, for: .normal)
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //调用获取工单的数量
        getStaticWorkunitDB()
        
    }
    
    // MARK: - home界面改版的init方法
    func homeInterfaceReversionInit(){
        
        // 使用自定义的NavigationBar
        self.navigationController?.view.sendSubview(toBack: (self.navigationController?.navigationBar)!)
        
        self.view.addSubview(mCustomNavigationBar)
        
        mCustomNavigationBar.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(self.tableView.snp.top)
        }
        
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(self.mTopOneViewHeight + self.mTopTwoViewHeight, 0, 0, 0)
        
        self.tableView.contentSize = CGSize.init(width: 0, height: SJScreeH + 200)
        self.tableView.showsVerticalScrollIndicator = true
        
        //初始化的刷新控件
        self.resetTableHeaderView(tableview: tableView, height: self.mTopOneViewHeight + self.mTopTwoViewHeight + self.mTopThreeViewHeight)
        
        self.tableView.addSubview(self.mTopView)
        
    }
    
    // MARK: - 搜索天气功能
    func initSearch() {
        
        search = AMapSearchAPI()
        search.delegate = self
    }

    
    // MARK: - 接受服务器系统推送消息
    func getSystemMessage(){
        
        HttpClient.instance.get(path: URLPath.systemMessage, parameters: nil, success: { (respose) in
            
            var temp = [SystemMessageModel]()
            for dic in respose as! Array<[String: Any]>{
                temp.append(SystemMessageModel(parmart: dic))
            }
            self.datas = temp
            self.tableView.reloadData()
        
        }) { (error) in
            print(error)
        }
        
    }
    
    // MARK: - 接受服务系统推送消息通知
    func getNotice(){
        
        HttpClient.instance.get(path: URLPath.getNoticeList, parameters: nil, success: { (respose) in
            
            var temp = [SystemMessageModel]()
            
            if let dic = respose as? [String: Any]{
                for dic2 in dic["data"] as! Array<[String: Any]>{
                    temp.append(SystemMessageModel(parmart: dic2))
                }
                self.datas = temp
                self.tableView.reloadData()
            }
            
            
        }) { (error) in
            print(error)
        }
    }
    
    
    func setPermission(arry: Array<[String: Any]>){
        
        self.allPermissionModels.removeAll()
        var topArry = [PermissionModel]()
        var downArry = [PermissionModel]()
        
        for dic in arry {
            
            let model = PermissionModel(json:dic)
            
            if model?.iSTOP == 0{
                
                topArry.append(model!)
            }else{
                
                downArry.append(model!)
            }
            
        }
        
        downPermissionModels = downArry
        
        self.allPermissionModels.append(contentsOf: topArry)
        self.allPermissionModels.append(contentsOf: downArry)
        self.settopArry(topArry: topArry, donwArry: downArry)

    }
    
    // MARK: - 获取不同管理员权限的方法,首页数据获取核心方法 getModules的接口
    func getPermission(){
        
        let data = UserDefaults.standard.object(forKey: Const.YQTotallData) as? NSArray
        if data == nil {
            
            return
        }
        
        if data?.count == 1 {
            
            self.subsystemBtn.isHidden = true
        }

    
        //注意的是:通过的是子系统选择的界面功能取消   URLPath.getModules 的网络请求
        
        let systemData = UserDefaults.standard.object(forKey: Const.YQSystemSelectData)
        if  systemData == nil {
            
            return
        }
        
        systemSelection = systemData as! NSDictionary
        
        
        //新增 获取集团版 和 项目版  的区别 来进行的操作 //注意的是 2是集团版 3是项目版
        let isgroup = systemSelection["isGroup"] as? Int ?? -1
        UserDefaults.standard.set(isgroup, forKey: Const.YQIs_Group)
        
        if systemSelection.count > 0 {
            
            
            let array : NSArray = systemSelection["appModules"] as! [[String : Any]] as NSArray
            let tempArray = NSMutableArray()
            tempArray.addObjects(from: array as! [Any])
            
            var sortArray : NSMutableArray = {return NSMutableArray()}()
            
            //解决bug: 需要通过的是 "SORT" : 2 的值来进行对数据来重新排序
            for _ in 0..<tempArray.count {
                
                for yyyy in 0..<tempArray.count - 1 {
                
                    let sortTemp = tempArray[yyyy] as! [String : Any]
                    let SORT = sortTemp["sort"] as? Int
                    
                    let sortTemp1 = tempArray[yyyy + 1] as! [String : Any]
                    let SORT1 = sortTemp1["sort"] as? Int

                    if SORT! > SORT1! {
                        //交换元素
                        tempArray.exchangeObject(at: yyyy, withObjectAt: yyyy + 1)
                        
                    }
                }
            }
            
            sortArray = tempArray
            
            //设置权限的模块功能
            self.setPermission(arry: sortArray as! Array<[String : Any]> )
            
            if sortArray.count > 1 {
                
                let app = sortArray[0] as! [String : Any]
//                let app_res = app["app_res"] as? NSArray
//                let temp = app_res?[0] as? [String : Any]
                let reportName = (app["appModuleName"] as? String)!
                
                //设置保存电梯和普通的报事全局保存
                UserDefaults.standard.set(reportName, forKey: Const.YQReportName)

            }
        
            do {
                
                //Convert to Data
                let jsonData = try JSONSerialization.data(withJSONObject: systemSelection, options: JSONSerialization.WritingOptions.prettyPrinted)
                
                //Do this for print data only otherwise skip
                if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                    print(JSONString)
                    
                    UserDefaults.standard.set(JSONString, forKey: "PermissionModels")
                }
                
            } catch {
                
                print("转换错误 ")
            }

        }else{
            //弹框提示网络出现异常
        
        }

    }
    
    
    // MARK: - 计步功能的模块实现
    func stepFunctionDidStart() {
        
        if !CMPedometer.isStepCountingAvailable() {
            
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
                    
                    HttpClient.instance.post(path: URLPath.getSavePedometerData, parameters: parameter, success: { (respose) in
                        
                        
                    }, failure: { (error) in
                        
                    })
                }
                
            })
        }
    }
    

    // MARK: - 接受系统的通知
    func receiveNotes(){
        
        let center = NotificationCenter.default//创建通知
        
        center.addObserver(self, selector: #selector(systemSelectionreceiveValue(info:)), name: NSNotification.Name(rawValue: "systemSelectionPassValue"), object: nil)//单个值得传递
        center.addObserver(self, selector: #selector(systemSelectionreceiveValue(info:)), name: NSNotification.Name(rawValue: "systemSelectionPassValue"), object: nil)
        
    }
    
    // MARK: - 通知实现的方法
     func systemSelectionreceiveValue(info:NSNotification){
        
        let dic = info.userInfo! as NSDictionary
        self.systemSelection = dic
        
    }
    
    
    //MARK: - 获取消息工单数量接口
    func getStaticWorkunitDB(){
        
        HttpClient.instance.get(path: URLPath.getStaticWorkunitDB, parameters: nil, success: { (respose) in
            
            if let dic = respose as? [String: Any]{
                
                let workCount = dic["DBSX"] as? Int ?? 0
                let dubanCount = dic["DDB"] as? Int ?? 0
                let tatolCount = workCount + dubanCount
                self.dubanCount = dubanCount
                self.workCount = workCount
                if tatolCount >= 0 {
                    
                    self.messageBtn.badge(text: "\(tatolCount)")
                    
                    DispatchQueue.main.async {
                        //设置 系统app的显示的图标的选项的情况
                        UIApplication.shared.applicationIconBadgeNumber = tatolCount
                        //偏好的保存: badgeNumber
                        UserDefaults.standard.set(tatolCount, forKey: Const.YQBadgeNumber)
                        
                    }
                }
            }
            
        }) { (error) in
            print(error)
        }
    }
    
    // MARK: - 赋值topView和downView的赋值方法
    func settopArry(topArry:[PermissionModel],donwArry: [PermissionModel]){
        
        let imageDic = ["报事": "报事","工单": "工单","签到": "qiandao-1","扫描": "扫描","定位": "dingwei","待办事项": "daiban", "督办": "btn_duban","门禁": "intodoor","丽岛学院": "xueyuan","电梯报事":"报事","日志":"日志","计步器":"step","视频巡查" : "xuncha","巡查结果" : "xunguan","工作报告" : "more_icon_work_report","房屋管理" : "房屋查询","设备房" : "设备房","装修管理" : "装修管理","工单查询" : "more_icon_demand","总经理邮箱" : "gmMail"]
        
        for (index,model) in topArry.enumerated(){
            
            if index >= 4{
                break
            }
            let imageName = imageDic[model.aPPMODULENAME] ?? ""
            topBtnViewArray[index].imageView.image = UIImage(named:imageName)
            
            //设置appicon的名字
            if(model.aPPMODULENAME == "电梯报事"){
                
                topBtnViewArray[index].textLabel.text = "报事"

            }else{
                
                topBtnViewArray[index].textLabel.text = model.aPPMODULENAME
            }
            
            topBtnViewArray[index].textLabel.textColor = UIColor.white
            topBtnViewArray[index].clickHandle = { [weak self] in
            self?.actionPush(text: model.aPPMODULENAME)
                
            }
        }
        
        let count = [3,donwArry.count].min()!
        
        _ = downBtnViewArray.map{ btnView in
            
            btnView.isHidden = true
        }
        
        for (index,model) in donwArry.enumerated(){
            
            if index >= count{
                
                if index < 3{
                    downBtnViewArray[index].isHidden = true
                }
                
            }else{
                
                let imageName = imageDic[model.aPPMODULENAME] ?? ""
                downBtnViewArray[index].imageView.image = UIImage(named:imageName)
                downBtnViewArray[index].textLabel.text = model.aPPMODULENAME
                downBtnViewArray[index].isHidden = false
                downBtnViewArray[index].clickHandle = { [weak self] in
                    self?.actionPush(text: model.aPPMODULENAME)
                }
            }
        }
        
    }
    
    // MARK: - 添加全局的项目选择的方法
    @IBAction func projectSelectClick(_ sender: UIButton) {
        
        let project = UIStoryboard.instantiateInitialViewController(name: "YQAllProjectSelect")
        navigationController?.pushViewController(project, animated: true)
        
    }
    
    // MARK: - 全部按钮点击界面跳转的方法
    /// 中间全部按钮的点击跳转
    @IBAction func pushToAllVc(){
        
        if !allPermissionModels.isEmpty{
            
            let vc = AllViewController.loadFromStoryboard(name: "Home") as! AllViewController
            vc.models = allPermissionModels
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    //MARK: - 设置定位的方法;
    func setUpLocation() {
        
        locationManager.distanceFilter = KDistence
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.locatingWithReGeocode = true
//        locationManager.reGeocodeTimeout = KTime
        locationManager.locationTimeout = KTime
        
        if Double(UIDevice.current.systemVersion.components(separatedBy: ".").first!)! >= 9.0{
            
            locationManager.allowsBackgroundLocationUpdates = true
            
        }else{
            
            locationManager.pausesLocationUpdatesAutomatically = false
        }
        
        locationManager.delegate = self
    
        locationManager.startUpdatingLocation()
    }
    
    // MARK: - 添加默认的项目选择方法
    func setUpProjectNameLable() -> String{
        
        let dic = UserDefaults.standard.object(forKey: Const.YQProjectModel) as? [String : Any]
        
        var projectName  = ""
        
        if dic != nil {
            
            projectName = dic?["PARK_NAME"] as! String
        }else{
            
            projectName = "项目选择"
        }
        
        return projectName
    }
    
    
    //MARK: -top和down按钮组点击界面跳转的方法;
    /// action Push ---> 中间系列的按钮点击的navVC的界面的跳转!
    //  注意的是 有待办的事项没有设置过来
    func actionPush(text:String){
        switch text {
        case "报事":
            
            let vc = UIStoryboard(name: "ReportMaster", bundle: nil).instantiateInitialViewController()
            
            navigationController?.pushViewController(vc!, animated: true)
//            surveillanceWorkOrderBtnClick()
        case "电梯报事":
            
            let vc = UIStoryboard(name: "ReportMaster", bundle: nil).instantiateInitialViewController()
            
            navigationController?.pushViewController(vc!, animated: true)
            
        case "工单":
            
            let WO = UIStoryboard.instantiateInitialViewController(name: "YQWorkOrderFirst")
            navigationController?.pushViewController(WO, animated: true)
            
        case "签到":
            
            let vc = UIStoryboard(name: "SignIn", bundle: nil).instantiateInitialViewController()
            navigationController?.pushViewController(vc!, animated: true)
        case "定位":
            
            let vc = UIStoryboard(name: "Map", bundle: nil).instantiateInitialViewController()
            navigationController?.pushViewController(vc!, animated: true)
        case "扫描":
            
            scanBtnClick()
//            surveillanceWorkOrderBtnClick()
        case "督办":
            
            surveillanceWorkOrderBtnClick()
            
        case "日志":
            //测试日志模块
            let journa = UIStoryboard.instantiateInitialViewController(name: "YQJournal")
            
//            navigationController?.pushViewController(journa, animated: true)
            self.present(journa, animated: true, completion: nil)
            
        case "计步器":
            
            let step = UIStoryboard.instantiateInitialViewController(name: "YQPedometerVC")
            
            //            navigationController?.pushViewController(journa, animated: true)
            self.present(step, animated: true, completion: nil)
        
        case "工作报告":
            
            let report = YQReportFormFirstVC.init(nibName: "YQReportFormFirstVC", bundle: nil)
            self.navigationController?.pushViewController(report, animated: true)
        
        case "房屋管理" :
            let house = UIStoryboard.instantiateInitialViewController(name: "YQHouseHome")
            self.navigationController?.pushViewController(house, animated: true)
            
        case "装修管理" :
            let decoration = UIStoryboard.instantiateInitialViewController(name: "YQDecorationHome")
            self.navigationController?.pushViewController(decoration, animated: true)
        
        case "设备房" :
            let equipVC = YQEquipmentFristVC.init(nibName: "YQEquipmentFristVC", bundle: nil)
             self.navigationController?.pushViewController(equipVC, animated: true)
            
        case "工单查询" :
            let allWorkUnit = UIStoryboard.instantiateInitialViewController(name: "YQAllWorkUnitHome")
            self.navigationController?.pushViewController(allWorkUnit, animated: true)

        case "总经理邮箱" :
            
            let generalMailVC = YQGeneralManagerFirstVC.init(nibName: "YQGeneralManagerFirstVC", bundle: nil)
            self.navigationController?.pushViewController(generalMailVC, animated: true)
            
        default: break
            
        }
    }
    
    
    
    func uploadLocation(parmat: [String: Any]){
        
//        if lastUpdateTime.timeIntervalSinceNow < -3.0 * 60{
        
            lastUpdateTime = Date()
        
            HttpClient.instance.post(path: URLPath.updateLocation, parameters: parmat, success: { (response) in
                print("上传位置成功")
                
                
            }) { (error) in
                
                print(error)
            }
        
//        }
        
    }
    
    // MARK: - 天气按钮的点击情况
    @IBAction func weatherButtonClick(_ sender: UIButton) {
        
        //加载未来的信息
        self.searchForcastWeather( city : self.locaCity )
        
    }
    

    // MARK: - leftbar消息按钮的点击事件
    /// leftbar消息按钮的点击事件的
    @IBAction func messageBtnClick() {
        
        let bool1 = allPermissionModels.contains { (model) -> Bool in
            
            model.aPPMODULENAME == "工单"
        }
        
        let bool2 = allPermissionModels.contains { (model) -> Bool in
            
            model.aPPMODULENAME == "督办"
        }

        if bool1 && bool2{//这个逻辑是 工单和 督办都有选项的值情况
            
            MessageView.show(workOrderCount: workCount, surveillanceWorkOrder: dubanCount)
            
        }else if bool1{// 只有工单
            
            actionPush(text:"工单")
            
        }else if bool2{// 只有督办
            
            actionPush(text:"督办")
            
        }else{// 全都没有的情况
            
            MessageView.show(workOrderCount: workCount, surveillanceWorkOrder: dubanCount)
        }

    }
    
  
    /// rightBar扫描二维码的事件的点击:
    @IBAction func scanBtnClick() {
        
//        pushToDeviceViewController()
//        return  
        
        if Const.SJIsSIMULATOR {
            
            alert(message: "模拟器不能使用扫描")
            return
        }
        
        let device = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
        
//        let device = AVCaptureDeviceDiscovery
        if device != nil {
            
            let status = PHPhotoLibrary.authorizationStatus()
            
            if status == .authorized{
                
                let vc = SGScanningQRCodeVC()
                vc.delegate = self
                navigationController?.pushViewController(vc, animated: true)
                
            }else if status == .notDetermined{
                
                PHPhotoLibrary.requestAuthorization({ (authorizationStatus) in
                    
                })
                
            }else{
                
                self.alert(message: "授权失败")
            }
        }
    }
    
    
    // MARK: - 添加按钮悬浮的点击事件
    @IBAction func suspendButtonClick(_ sender: Any) {
        
        let data = UserDefaults.standard.object(forKey: Const.YQTotallData) as? NSArray
        
        if UserDefaults.standard.object(forKey: Const.YQTotallData) == nil {
            
             LoginViewController.loginOut()
        }
        
        
        //跳转到子系统的选择界面(需要的是逻辑的判断) 如果是只有一条数据的话,直接调到登录界面
        if (data?.count)! > 1{
            
            let systemVC = YQSystemSelectionVC(nibName: "YQSystemSelectionVC", bundle: nil)
            SJKeyWindow?.rootViewController = systemVC

        
        }else{// 跳转到登录界面
            
            LoginViewController.loginOut()

        }
        
        
    }
    
    
//    func addSuspendButton(){
//        
//        let button = UIButton()
//        button.setImage( UIImage(named : "btn_home_quit_nor" ), for: UIControlState.normal)
//        
//        button.setImage( UIImage(named : "btn_home_quit_p" ), for: UIControlState.highlighted)
//        button.frame = CGRect(x: 100, y: 100, width: 60, height: 60)
//        
//        button.backgroundColor = UIColor.blue
//        view.addSubview(button)
//        self.eixtButton = button
//        
//        //设置约束布局
//        button.snp.makeConstraints { (make) in
//            make.right.equalTo(40)
//            make.bottom.equalTo(100)
//            make.height.equalTo(60)
//            make.width.equalTo(60)
//        }
//        
//        view.bringSubview(toFront: button)
//    
//    }
    
    
    func surveillanceWorkOrderBtnClick() {
        let vc = SurveillanceWorkOrderViewController.loadFromStoryboard(name: "WorkOrder")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    fileprivate func pushToDeviceViewController(equipmentId: String){
        
        let vc = DeviceViewController.loadFromStoryboard(name: "Home") as! DeviceViewController
        vc.equipmentId = equipmentId
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // MARK: - 获取当前的天气接口
    func searchLiveWeather( city : String) {
        
        let req:AMapWeatherSearchRequest! = AMapWeatherSearchRequest.init()
        req.city = city
        self.locaCity = city
        
        req.type = AMapWeatherType.live
        
        self.search.aMapWeatherSearch(req)
    }

    // MARK: - 获取未来的天气接口
    func searchForcastWeather( city : String ) {
        
        let req:AMapWeatherSearchRequest! = AMapWeatherSearchRequest.init()
        
        req.city = city
        req.type = AMapWeatherType.forecast
        
        self.search.aMapWeatherSearch(req)
    }
   
    
    // MARK: - 控制器dealloc的方法
    deinit{
        
        //移除通知监听
        NotificationCenter.default.removeObserver(self)
        
    }
    
    
}

/// 全局的extension的tableView的数据源和代理的方法
/// 订单数据的tabelView 代理和 数据源方法
extension HomeViewController: UITableViewDelegate, UITableViewDataSource,MYPRefreshHeaderDelegate{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "message") as! SystemMessageCell
        
        cell.model = datas[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = SystemMessageViewController.loadFromStoryboard(name: "Home") as! SystemMessageViewController
                navigationController?.pushViewController(vc, animated: true)
        vc.model = datas[indexPath.row]

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 120
    }
    
    
    /**
     *  处理滑动时候的状态变化
     */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 获取当前的offsetY
        let tmpOffsetY: CGFloat = scrollView.contentOffset.y
        
        if tmpOffsetY <= 0 {
            mTopView.frame = CGRect.init(x: 0, y: tmpOffsetY, width: kScreenWidth, height: mTopOneViewHeight + mTopTwoViewHeight)
            
            // 内部子控件恢复正常
            // 凡是在else里处理过的控件，在该条件里面都需要恢复到初始状态
            mCustomTwoNavigationBar.alpha = 0
            mCustomOneNavigationBar.alpha = 1
            mTopOneView.alpha = 1
            mTopOneView.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: mTopOneViewHeight)
        }
        else {
            // 上滑处理联动效果
            
            // 1.处理navigationBar
            let navigationBarSwitchPointY: CGFloat = 40
            
            if tmpOffsetY <= navigationBarSwitchPointY {
                mCustomTwoNavigationBar.alpha = 0
                mCustomOneNavigationBar.alpha = 1 - tmpOffsetY/navigationBarSwitchPointY
            }
            else {
                mCustomOneNavigationBar.alpha = 0
                mCustomTwoNavigationBar.alpha = (tmpOffsetY - navigationBarSwitchPointY)/navigationBarSwitchPointY
            }
            
            // 2.处理逐渐需要隐藏的mTopOneView
            // 该值是根据mTopOneView的高度和内部button的高度确定的,mTopOneView.height - btn.height
            let topOneViewSwitchPointY: CGFloat = mTopOneViewHeight/2.0
            
            if tmpOffsetY <= topOneViewSwitchPointY {
                mTopOneView.alpha = 1 - tmpOffsetY/topOneViewSwitchPointY
                // 高度处理
                mTopOneView.frame = CGRect.init(x: 0, y: tmpOffsetY/2.0, width: kScreenWidth, height: mTopOneViewHeight)
            }
            else {
                
            }
        }
        
        // 下拉刷新相关
        if tmpOffsetY < 0 {
            // 如果此时正在刷新，做特殊处理
            if mRefreshHeader.mRefreshStatus == .refreshing {
                return
            }
            
            let refreshStatusSwitchPoint: CGFloat = mRefreshHeaderHeight
            
            if tmpOffsetY > -refreshStatusSwitchPoint {
                mRefreshHeader.mRefreshStatus = .normal
            }
            else {
                mRefreshHeader.mRefreshStatus = .willRefresh
            }
        }
        
    }
    
    /**
     *  结束拖动
     */
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // decelerate: 该值为true的时候表示scrollview在停止拖动之后还会向前滑动一段距离，并且在结束之后调用scrollViewDidEndDecelerating方法
        // decelerate: 该值为NO的时候表示scrollview在停止拖拽之后立即停止滑动
        if !decelerate {
            // 如果已经停止滑动了，立刻判断是否需要处理mTopOneView
            self.checkCurrentContentOffset(scrollView)
        }
        
        // 判断此时是否需要刷新
        let tmpOffsetY: CGFloat = scrollView.contentOffset.y
        
        // 该值需要和上面保持一致
        let refreshStatusSwitchPoint: CGFloat = mRefreshHeaderHeight
        if tmpOffsetY < -refreshStatusSwitchPoint {
            // 如果此时正在刷新，做特殊处理
            if mRefreshHeader.mRefreshStatus == .refreshing {
                return
            }
            // 恢复原样先
            self.tableView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
            // 开始刷新
            mRefreshHeader.mRefreshStatus = .refreshing
        }
    }
    
    /**
     *  减速停止
     */
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.checkCurrentContentOffset(scrollView)
    }
    
    /**
     *  动画停止(暂时不使用,只有动画修改contentoffset或者scrollRectToVisible的时候才会调用)
     *  现在采用在"checkCurrentContentOffset"方法中人为动画同时修改contentoffset和alpha的方式,避免alpha的突然变化
     */
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        // 避免因为对mTopOneView的操作导致alpha的显示问题
        // 不在"heckCurrentContentOffset"方法中操作的原因是为了避免alpha的突然变化
        let tmpOffsetY: CGFloat = scrollView.contentOffset.y
        if tmpOffsetY == 0 {
            mTopOneView.alpha = 1
        }
        else {
            mTopOneView.alpha = 0
        }
    }
    
    /**
     *  检测当前坐标，判断mTopOneView需要显示还是隐藏
     */
    func checkCurrentContentOffset(_ scrollView: UIScrollView) {
        let tmpOffsetY: CGFloat = scrollView.contentOffset.y
        // 设置 >0 的判断单纯的是为了让这个方法只处理是否隐藏mTopOneView的事件
        if tmpOffsetY > 0 {
            // 设置状态变化的点，保持和上面的设值统一
            let topOneViewSwitchPointY: CGFloat = mTopOneViewHeight/2.0
            if tmpOffsetY <= topOneViewSwitchPointY {
                // 恢复原样
                UIView.animate(withDuration: 0.3, animations: {
                    self.tableView.contentOffset = CGPoint.init(x: 0, y: 0)
                    self.mTopOneView.alpha = 1
                }, completion: nil)
            }
            else if tmpOffsetY > topOneViewSwitchPointY && tmpOffsetY < mTopOneViewHeight {
                // 隐藏mTopOneView
                UIView.animate(withDuration: 0.3, animations: {
                    self.tableView.contentOffset = CGPoint.init(x: 0, y: self.mTopOneViewHeight)
                    self.mTopOneView.alpha = 0
                }, completion: nil)
            }
            else {
                
            }
        }
    }
   
    
    /**
     *  刷新相关
     */
    func mStartRefreshing(refreshHeader: MYPRefreshHeader) {
        weak var weakSelf = self
        UIView.animate(withDuration: 0.3, animations: {
            self.resetTableHeaderView(tableview: self.tableView ,height: self.mTopOneViewHeight + self.mTopTwoViewHeight + self.mRefreshHeaderHeight)
            self.tableView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
        }) { (result) in
            // 效果,3S之后停止刷新
            // 实际使用中，根据网络返回接口自行调用
            DispatchQueue.global().async {
                sleep(3)
                DispatchQueue.main.async {
                    weakSelf?.mRefreshHeader.mRefreshStatus = .none
                }
            }
        }
    }
    
    func mEndRefreshing(refreshHeader: MYPRefreshHeader) {
        if self.tableView.frame.height != self.mTopOneViewHeight + self.mTopTwoViewHeight {
            UIView.animate(withDuration: 0.3, animations: {
                self.resetTableHeaderView(tableview: self.tableView, height: self.mTopOneViewHeight + self.mTopTwoViewHeight)
                // 停止刷新的时候是否需要会到contentoffset为(0,0)的状态根据需求确定

            }) { (result) in

            }
        }
    }

    /**
     *  设置TableHeaderView
     *  该方法的主要作用在于在需要刷新的时候动态修改headerview的高度以显示refreshHeader
     */
    func resetTableHeaderView(tableview: UITableView,height: CGFloat) {
        // 设置headerView
        let tmpHeaderView: UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: height))
        tmpHeaderView.backgroundColor = UIColor.clear
        tableview.tableHeaderView = tmpHeaderView

        // 修改refreshHeader的frame并重新添加到tableheaderview上面
        mRefreshHeader.frame = CGRect.init(x: 0, y: height - mRefreshHeaderHeight, width: kScreenWidth, height: mRefreshHeaderHeight)
        tableview.tableHeaderView?.addSubview(mRefreshHeader)

        // 将topView放置到最上方,如果已经添加了的话
        if tableview.subviews.contains(mTopView) {
            
            tableview.bringSubview(toFront: mTopView)
        }
        
    }

    
}


extension HomeViewController: AMapLocationManagerDelegate,AMapSearchDelegate{
    
    // MARK: - 连续地理定位的执行操作
    func amapLocationManager(_ manager: AMapLocationManager!, didUpdate location: CLLocation!, reGeocode: AMapLocationReGeocode!) {
        
        print("location:lat:\(location.coordinate.latitude); lon:\(location.coordinate.longitude); reGeocode:\(reGeocode)")
        
        var parmet = [String: Any]()
        parmet["mapLat"] = location.coordinate.latitude
        parmet["mapLng"] = location.coordinate.longitude
        
        if !User.isLogin(){
            
            return
        }

        if let latitude = UserDefaults.standard.object(forKey: "SJlatitude") as? CLLocationDegrees,let longitude = UserDefaults.standard.object(forKey: "SJlongitude") as? CLLocationDegrees{
            
            let lastCLLocation = CLLocation(latitude: latitude, longitude: longitude)
            let nowCLLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let distance = lastCLLocation.distance(from: nowCLLocation)
            
            if distance < KDistence{
                return
            }
            
        }else{
            
            UserDefaults.standard.set(location.coordinate.latitude, forKey: "SJlatitude")
            UserDefaults.standard.set(location.coordinate.longitude, forKey: "SJlongitude")
        }

        if reGeocode != nil
        {
            parmet["reserver"] = reGeocode.formattedAddress
            uploadLocation(parmat: parmet)
            //获取的是 逆地理的信息情况(各种的应用的参数)
            self.searchLiveWeather(city: reGeocode.city!)
            
        }else{
            
            HttpClient.instance.getAddress(lat: location.coordinate.latitude, lon: location.coordinate.longitude, succses: { (address) in
                
                if let address = address{
                    
                    parmet["reserver"] = address
                    let str = NSString.init(string: address)
                    let cityRange = str.range(of: "市")
                    let newRange = NSRange.init(location: 0, length: cityRange.location + 1)
                    let cityString = str.substring(with: newRange)
                    let newCityArray = cityString.components(separatedBy: "省")
                    let newCityString = newCityArray.last
                    
                    self.searchLiveWeather(city: newCityString!)
                    
                    self.uploadLocation(parmat: parmet)
                }
            })

        }
    }
    
    
    //MARK: - AMapSearchDelegate
    func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
        
        let _:NSError? = error as NSError
        NSLog("Error:\(error)")
    }
    
    func onWeatherSearchDone(_ request: AMapWeatherSearchRequest!, response: AMapWeatherSearchResponse!) {
        
        if (request.type == AMapWeatherType.live)
        {
            if (response.lives.count == 0)
            {
                return;
            }
            
            let liveWeather:AMapLocalWeatherLive! = response.lives.first
            
            if (liveWeather != nil)
            {
                //数据是 liveWeather
                let weather = liveWeather.weather
                let temperature = liveWeather.temperature
                let all = weather! + " " + temperature! + "℃"
                
                self.weatherBtn.setTitle(all, for: .normal)
                
            }
            
        } else {
            
            if (response.forecasts.count == 0)
            {
                return;
            }
            
            let forecast:AMapLocalWeatherForecast! = response.forecasts.first
            
            if (forecast != nil)
            {
                //数据是 forecast
                //创建coverView 来添加天气内容框
                let weatherV =  UIStoryboard.instantiateInitialViewController(name: "YQHomeWeather") as! YQHomeWeatherTVC
                weatherV.dataArray = forecast.casts
                
                self.weatherTvc = weatherV
                let subView = weatherV.view
                
                subView?.frame = CGRect.init(x: 10, y: 200, width: SJScreeW - 20, height: SJScreeH - 400)
                
                let _ = CoverView.show(view: subView!)
                
            }
        }
        
    }

    
}


extension HomeViewController:SGScanningQRCodeVCDelegate{
    
    func didScanningText(_ text: String!) {
        
        if text.contains("equipment"){//区分是否是自己的二维码的情况
            
            let str = text.components(separatedBy: ":").last
            
            if let str = str{
                
                self.navigationController?.popViewController(animated: false)
                pushToDeviceViewController(equipmentId: str)
                
            }
            
        }else{
        
            self.alert(message: "非可识别二维码!")
            
        }
    }
    

}
