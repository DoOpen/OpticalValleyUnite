//
//  YQReportFromViewController.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/1/16.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh

class YQReportFromViewController: UIViewController {

    @IBOutlet weak var tabelView: UITableView!
    
    //选择时间的label
    @IBOutlet weak var timeLabel: UILabel!
    
    //选择的title
    var selectTitle = ""
    var type : Int?
    
    var parkID : String = ""
    var currentIndex : Int = 0
    
    
    @IBOutlet weak var startTimeButtonClick: UIButton!
    var startTime : Date?
    
    @IBOutlet weak var endTimeButtonClick: UIButton!
    var endTime : Date?
    
    var CellID = "reportFormCell"
    
    var dataArray = [YQReportFormDetailModel](){
        
        didSet{
            
            self.tabelView.reloadData()
        }
        
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.title = selectTitle
        
        //添加上下拉的刷新
        addRefirsh()
        
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let _ = setUpProjectNameLable()
        
        self.getTypeReportFromData(type: type!)
        
    }
   
 
    // MARK: - 添加时间的click方法
    @IBAction func timeLabelClick(_ sender: UIButton) {
        //调用查询的时间的筛选的接口
        var par = [String : Any]()
        
        if !(self.endTimeButtonClick.titleLabel?.text?.contains("选择"))!{
        
            par["endTime"] = self.endTimeButtonClick.titleLabel?.text
        }
        
        if !(self.startTimeButtonClick.titleLabel?.text?.contains("选择"))!{
        
            par["startTime"] = self.startTimeButtonClick.titleLabel?.text
        }
        
        getTypeReportFromData(type: type!, parmeter: par)
        
    }
    
    @IBAction func startTimeClick(_ sender: UIButton) {
        
        SJPickerView.show(withDateType: .date, defaultingDate: Date(), userController: self, selctedDateFormot: "yyyy-MM-dd") { (date, string) in
            
            self.startTime = date
            
            if self.endTime != nil {
            
                if self.startTime! > self.endTime! {
                    
                    SVProgressHUD.showError(withStatus: "起始的时间不能大于结束时间!")
                    
                    self.startTime = nil
                    return
                }
            }
            self.startTimeButtonClick.setTitle(string, for: .normal)
        }
        
    }
    
    @IBAction func endTimeClick(_ sender: UIButton) {
        
        SJPickerView.show(withDateType: .date, defaultingDate: Date(), userController: self, selctedDateFormot: "yyyy-MM-dd") { (date, string) in
            
            self.endTime = date
            if self.startTime != nil {
            
                if self.startTime! > self.endTime! {
                    
                    SVProgressHUD.showError(withStatus: "结束时间不能小于开始时间!")
                    self.endTime = nil
                    
                    return
                }
            
            }
            
            self.endTimeButtonClick.setTitle(string, for: .normal)
        }
    }
    
    // MARK: - 上下拉的刷新的界面情况
    func addRefirsh(){
        
        tabelView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            
            var par = [String : Any]()
            
            if !(self.endTimeButtonClick.titleLabel?.text?.contains("选择"))!{
                
                par["endTime"] = self.endTimeButtonClick.titleLabel?.text
            }
            
            if !(self.startTimeButtonClick.titleLabel?.text?.contains("选择"))!{
                
                par["startTime"] = self.startTimeButtonClick.titleLabel?.text
            }


            self.getTypeReportFromData(type: self.type!, pageIndex: 0, pageSize: 20,parmeter: par)
            
        })
        
        
        tabelView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            
            var par = [String : Any]()
            
            if !(self.endTimeButtonClick.titleLabel?.text?.contains("选择"))!{
                
                par["endTime"] = self.endTimeButtonClick.titleLabel?.text
            }
            
            if !(self.startTimeButtonClick.titleLabel?.text?.contains("选择"))!{
                
                par["startTime"] = self.startTimeButtonClick.titleLabel?.text
            }

            self.getTypeReportFromData(type: self.type!, pageIndex: self.currentIndex + 1, pageSize: 20,parmeter: par)
            
        })
        
    }

   
    
    // MARK: - 获取type对应的数据
    func getTypeReportFromData(type : Int ,pageIndex : Int = 0,pageSize : Int = 20,parmeter : [String : Any] = [String : Any]()){
        var par = [String : Any]()
        par["reportType"] = type
        par["parkId"] = parkID
        par["pageIndex"] = pageIndex
        par["pageSize"] = pageSize
        
        if parkID == ""{
        
            self.alert(message: "请选择项目!", doneBlock: { (action) in
                
                let project = UIStoryboard.instantiateInitialViewController(name: "YQAllProjectSelect")
                self.navigationController?.pushViewController(project, animated: true)
            })
            
            return
        }
        
        
        for (key,value) in parmeter{
            
            par[key] = value
        }

        
        SVProgressHUD.show()
        
        HttpClient.instance.post(path: URLPath.getReportFormList, parameters: par, success: { (response) in
            SVProgressHUD.dismiss()
            
            let array = response["data"] as? Array<[String : Any]>
            
            if array == nil {
                SVProgressHUD.showError(withStatus: "没有更多的数据!")
                
                self.dataArray.removeAll()
                return
            }
            
            var temp = [YQReportFormDetailModel]()
            
            for dic in array! {
                
                temp.append(YQReportFormDetailModel.init(dict: dic))
                
            }
            
            
            //添加上拉下拉刷新的情况
            if pageIndex == 0 {
                
                if response["data"] as? NSArray == nil {
                    
                    self.dataArray.removeAll()
                    self.tabelView.mj_header.endRefreshing()
                    self.tabelView.mj_footer.endRefreshing()
                    
                    return
                }
                
                self.dataArray = temp
                self.tabelView.mj_header.endRefreshing()
                
            }else{
                
                if temp.count > 0{
                    
                    self.currentIndex = pageIndex
                    
                    self.dataArray.append(contentsOf: temp)
                    
                }
                
                self.tabelView.mj_footer.endRefreshing()
                
            }
            
        }) { (error) in
           
            SVProgressHUD.showError(withStatus: "数据加载失败,请检查网络!")
        }
        
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


}

extension YQReportFromViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArray.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID, for: indexPath) as! YQReportFromDetailCell
        
        cell.model = self.dataArray[indexPath.row]
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //跳转到内容选中的详情页,通过title来进行的判断的rightBar的情况
        //顺便的数据展示和回显
        let reportDetail = UIStoryboard.instantiateInitialViewController(name: "YQReportFormDetail") as? YQReportFormDetailVC
        let model = self.dataArray[indexPath.row]
        
        reportDetail?.selectTitle = model.reportTitle
        reportDetail?.type  = self.type
        reportDetail?.createTime = model.createTime
        reportDetail?.id = model.id

        navigationController?.pushViewController(reportDetail!, animated: true)
        
        
    }
    
    
}
