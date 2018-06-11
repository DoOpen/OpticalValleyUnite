//
//  YQAllWorkUnitHomeVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/3/6.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh

class YQAllWorkUnitHomeVC: UIViewController {

    
    @IBOutlet weak var totallBtn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var waitHandleBtn: UIButton!
    
    var currentBtn : UIButton!
    
    ///
    //dataAarry
    var currentDatas = [WorkOrderModel2]()
    
    //currentIndex
    var pageNo = 0
    
    var siftsiftParmat : [String : Any]?
    
    var siftVc: YQAllWorkUnitScreenVC?
    
    //项目id
    var parkID = ""
    
    //集团版和项目版的情况
    var isgroup = -1
    
    var coverView : CoverView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "全部工单"
        self.waitHandleBtn.isSelected = true
        self.currentBtn = self.waitHandleBtn
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        //添加上拉,下拉
        addRefirsh()
        
        //注册cell
        let nib = UINib(nibName: "WorkOrder2Cell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        
        //1.添加rightBarButton
        addLeftRightBarButtonFunction()
        
        //2.默认的调取处理的数据
        self.parkID = setUpProjectNameLable()
        
        if self.parkID == "" {
            
            let project = UIStoryboard.instantiateInitialViewController(name: "YQAllProjectSelect") as! YQAllProjectSelectVC
            project.isAll = 1 //查所有项目
            
            self.navigationController?.pushViewController(project, animated: true)
            
            //这里是不选项目直接查全部的工单
            //新增的需求是: 是项目版的情况,必须要选项项目;集团版,可以不选项目
            //获取集团和 项目版的参数
            isgroup = UserDefaults.standard.object(forKey: Const.YQIs_Group) as? Int ?? -1

            if isgroup == 2 {//集团版
                //允许查全部 所有的
            }else{//项目版
                
                return
            }

        }

        self.getDataForServer(tag: self.currentBtn.tag)
        
        acceptNoticeFunction()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //通过项目来进行获取项目情况
        let newParkID = setUpProjectNameLable()
        
        //获取网络数据请求
        if newParkID != self.parkID {
            
            self.parkID = newParkID
            
            self.getDataForServer(tag: self.currentBtn.tag)
        }
        
    }
    
    
    // MARK: - 点击按钮的状态切换
    @IBAction func selectButtonClick(_ sender: UIButton) {
        
        self.currentBtn.isSelected = false
        sender.isSelected = true
        self.currentBtn = sender
        
        //设置选中的btn的网络数据请求
        self.getDataForServer(tag: self.currentBtn.tag)
        
    }
    
    
    // MARK: - 添加左右barItem的情况
    func addLeftRightBarButtonFunction(){
        
        let rightBtn = UIButton()
        rightBtn.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        rightBtn.setImage(UIImage.init(name: "筛选"), for: .normal)
        rightBtn.addTarget(self, action: #selector(rightBarButtonClick), for: .touchUpInside)
        let batItem2 = UIBarButtonItem()
        batItem2.customView = rightBtn
        
        self.navigationItem.rightBarButtonItem = batItem2
        
    }
    
    func rightBarButtonClick(){
        //跳转到筛选的界面情况
        let vc = UIStoryboard.instantiateInitialViewController(name: "YQAllWorkUnitScreen") as! YQAllWorkUnitScreenVC
        vc.isAll = 1
        
        //传递筛选条件,进行缓存和保存
        vc.siftParmat = self.siftsiftParmat
        
        siftVc = vc
        
        let subView = vc.view
        subView?.frame = CGRect(x: 100, y: 0, width: SJScreeW - 100, height: SJScreeH)
        
        self.coverView =  CoverView.show(view: subView!)
        
        //点击筛选的完成的 block的回调的情况
        /*
         实现的思路是: 综合拼接响应的筛选的结果
         */
        vc.doneBtnClickHandel = { parmat in

            if parmat.isEmpty{//为空的话
                
                self.siftsiftParmat = nil
                self.parkID = ""
                //在闭包的 回调中 拿到了选择的参数, 进行重新的网络请求,数据的刷新
                self.getDataForServer(tag: (self.currentBtn?.tag)!)
                
            }else{
                
                self.siftsiftParmat = parmat
                self.getDataForServer(tag: (self.currentBtn?.tag)!)
                
            }
            
            subView?.superview?.removeFromSuperview()
            self.siftVc = nil
        }

    }

    // MARK: - 获取网络数据详情方法
    func getDataForServer(tag : Int, pageSize : Int = 20, pageIndex : Int = 0,dict : [String : Any] = [String : Any]()){
        
        //通过项目来进行的必填parkID
        var par = [String : Any]()
        par["pageIndex"] = pageIndex
        par["pageSize"] = pageSize
        par["PARK_ID"] = self.parkID
        par["isClosed"] = tag
        
        if self.parkID == "" {
        
            if isgroup != 2{//不是集团版,必须要求选择项目
                
                self.alert(message: "请选择查询项目!", doneBlock: { (alerter) in
                    let project = UIStoryboard.instantiateInitialViewController(name: "YQAllProjectSelect") as! YQAllProjectSelectVC
                    project.isAll = 1 //查所有项目
                    
                    self.navigationController?.pushViewController(project, animated: true)

                })
                
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.endRefreshing()
                return
            }
        }

        //经过筛选项,筛选的条件
        if let dic = siftsiftParmat{
            
            for (key,value) in dic{
                
                if key != "SOURCE_PERSON_NAME" && key != "EXEC_PERSON_NAME"{
                    
                    par[key] = value
                }
            }
        }

        SVProgressHUD.show()
        
        //其余的都是,相应的筛选条件
        HttpClient.instance.post(path: URLPath.getAllworkunitList, parameters: par, success: { (response) in
            
            SVProgressHUD.dismiss()
            
            let totalCount = response["totalCount"] as? Int ?? 0
            
            switch tag {
                case 1://已完成
                    self.totallBtn.setTitle("已处理工单总数: " + "\(totalCount)", for: .normal)
                    break
                
                case 2://未完成
                    self.totallBtn.setTitle("待处理工单总数: " + "\(totalCount)", for: .normal)
                    break
                
                default:
                    break
            }

            let data = response["data"] as? Array<[String: Any]>
            
            if data == nil {
                
                SVProgressHUD.showError(withStatus: "没有更多数据!")
                self.currentDatas.removeAll()
                
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.endRefreshing()
                
                return
            }

            var temp = [WorkOrderModel2]()
            
            for dic in data!  {
                
                let model = WorkOrderModel2(parmart: dic)
                
                temp.append(model)
            }
            
            if pageIndex == 0{
                
                self.pageNo = 0
                self.currentDatas = temp
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.resetNoMoreData()
                
            }else{
                
                if temp.count > 0{
                    
                    self.pageNo = pageIndex
                    self.currentDatas.append(contentsOf: temp)
                    self.tableView.mj_footer.endRefreshing()
                    
                }else{
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                    
                }
            }
            
            self.tableView.reloadData()

        }) { (error) in
            
            SVProgressHUD.showError(withStatus: "网络数据加载失败,请检查网络!")
        }
        
    }
    
    // MARK: - 添加默认的项目选择方法
    func setUpProjectNameLable() -> String{
        
        let dic = UserDefaults.standard.object(forKey: Const.YQProjectModel) as? [String : Any]
        
        var projectId  = ""
        
        if dic != nil {
            
            projectId = (dic?["ID"] as? String)!
        }
        
        return projectId
    }

    // MARK: - 上下拉的刷新的界面情况
    func addRefirsh(){
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            
            self.getDataForServer(tag: self.currentBtn.tag)
        })
        
        
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            
            self.getDataForServer(tag: self.currentBtn.tag,pageIndex : self.pageNo + 1)

        })
    }
    
    
    // MARK: - 接受通知的方法
    func acceptNoticeFunction(){
        //更新约束的通知
        let center = NotificationCenter.default
        let notiesName = NSNotification.Name(rawValue: "workerSiftPersonVCNotice")
        
        center.addObserver(self, selector: #selector(updateCoverViewFunction), name: notiesName, object: nil)
    }
    
    
    func updateCoverViewFunction(){
        
        self.coverView?.removeFromSuperview()
        
        let vc = PeopleListViewController.loadFromStoryboard(name: "WorkOrder") as! PeopleListViewController
        //传递的是执行人的type,通过type来设置相应的 是 执行人还是协助人
        vc.type = 0 // "选择执行人" 的 type值
        vc.isWorkOrderSift = true
        vc.parkId = self.parkID
        
        //block的多对多
        vc.doneBtnClickHandel = siftVc?.didSelecte
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
        
    }

    
}

extension YQAllWorkUnitHomeVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return currentDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: WorkOrder2Cell //注意的是,细小的bug 两个的cell是不同的模型,应用的WorkOrder2Cell-> 2的cell模型
        
        cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! WorkOrder2Cell
        cell.model2 = currentDatas[indexPath.row]
        
        return cell
    }
 
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = WorkOrderProgressViewController.loadFromStoryboard(name: "WorkOrder") as! WorkOrderProgressViewController
        //        vc.workModelId = currentDatas[indexPath.row].workOrderId
        let model = currentDatas[indexPath.row]
        
        var parmat = [String: Any]()
        parmat["UNIT_STATUS"] = model.status
        parmat["PERSONTYPE"] = model.PERSONTYPE
        parmat["EXEC_PERSON_ID"] = model.execPersionId
        parmat["WORKUNIT_ID"] = model.workOrderId
        
        vc.parmate = parmat
        // 执行的工单的 回退之后 进行的list的刷新, 要求的补全逻辑的代码
        //    vc.listVc = self
        navigationController?.pushViewController(vc, animated: true)
        
    }

    
}

