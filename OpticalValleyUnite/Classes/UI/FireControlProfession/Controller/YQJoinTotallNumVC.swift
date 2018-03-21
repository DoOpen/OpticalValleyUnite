//
//  YQJoinTotallNumVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/9/15.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import MJRefresh


class YQJoinTotallNumVC:UIViewController{
    
    // MARK: - 控制器的属性情况
    @IBOutlet weak var detailTableV: UITableView!

    @IBOutlet weak var titleButton: UIButton!
    
    @IBOutlet weak var timeButton: UIButton!
    
    @IBOutlet weak var seachTextField: UITextField!
    
    var cellIndex = "fireDetailCell"
    
    var selectProject : String = "" {
        didSet{
        
        }
    }
    
    var currentIndex = 0
    
    //定义的是模型数组
    var dataArray = [YQfireMessage]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //初始设置内容
        titleButton.setTitle(self.title, for: .normal)
        //时间初始化
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: Date())
        
        timeButton.setTitle(dateString, for: .normal)
        
        //添加leftBar属性
        self.setUpLeftBar()
        
        //添加调用接口数据
        requestFireDetailData(title: self.title!, time: nil, location: nil)
        
        //添加上拉下拉刷新界面
        addRefirsh()
        
    }
    
    // MARK: - leftbutton的添加
    func setUpLeftBar(){
        
        let btn = UIButton(frame: CGRect(x: 0,y: 0,width:30,height:30))
        btn.setImage(UIImage(named: "icon_fire_return"), for: .normal)
        btn.addTarget(self, action: #selector(leftBarClick), for: .touchUpInside)
        let left = UIBarButtonItem(customView: btn)
        self.navigationItem.leftBarButtonItem = left
        
    }
    
    // MARK: - leftBarClick的点击事件
    func leftBarClick() {
        
        self.navigationController?.popViewController(animated: true)
        // 发送通知打开抽屉view
        let noties = NotificationCenter.default
        let name = NSNotification.Name(rawValue: "openDrawerNoties")
        noties.post(name: name, object: nil)
        
    }
    
    // MARK: - datePickerView的展示
    @IBAction func datePickerButtonClick(_ sender: Any) {
        
        view.endEditing(true)
        let dic =  ["Mon": "星期一", "Tue": "星期二", "Wed": "星期三", "Thu": "星期四", "Fri": "星期五", "Sat": "星期六", "Sun": "星期日"]
        
        SJPickerView.show(withDateType: .dateAndTime, defaultingDate: Date(), userController: self, selctedDateFormot: "yyyy-MM-dd", didSelcted: {date, dateStr in
            var text = dateStr
            
            for (key, value) in dic{
                text = text?.replacingOccurrences(of: key, with: value)
            }
            
            self.timeButton .setTitle(text, for: .normal)
            
            //调用获取加载数据的方法
            self.requestFireDetailData(title: (self.titleButton.titleLabel?.text)!, time: self.timeButton.titleLabel?.text, location:self
                .seachTextField?.text )
            
        })
    }
    
    
    // MARK: - allProjectPickerView的展示
    @IBAction func allProjectPickerButtonClick(_ sender: Any) {
        view.endEditing(true)
        let temp = ["总单量","火警单","误报单"]
        
//        SJPickerView.show(withDataArry2: temp, didSlected: { [weak self] index in
//            self?.projectBtn.setTitle(temp[index].title, for: .normal)
//            self?.selectProject = temp[index]
//        })
        SJPickerView.show(withDataArry: temp, didSlected: { [weak self] index in
            
            
            self?.selectProject = temp[index]
            self?.titleButton.setTitle(self?.selectProject, for: .normal)
            
            
            // 调用筛选的接口
            self?.requestFireDetailData(title: (self?.selectProject)!, time: self?.timeButton.titleLabel?.text, location:self?
                .seachTextField?.text )
            
        })
    }
    
    // MARK: - 点击搜索执行的方法
    @IBAction func searchImageClick(_ sender: Any) {
        
        self.view.endEditing(true)
        // 调用筛选的接口
        self.requestFireDetailData(title: (self.titleButton.titleLabel?.text)!, time: self.timeButton.titleLabel?.text, location:self
            .seachTextField?.text )
        
    }
    
    
    // MARK: - 获取接口数据的方法
    func requestFireDetailData(title : String, time : String?, location : String?, pageSize : Int = 20, pageIndex : Int = 0 ){
        
        var type = -1
        
        switch title {
            case "总单量":
                type = 0
                
            case "火警单":
                type = 1
                
            case "误报单":
                type = 2
                
            default:
                break
        }
        
        var parameters = [String : Any]()
        
        let token = UserDefaults.standard.object(forKey: Const.SJToken)
        parameters["token"] = token
        parameters["type"] = type
        parameters["time"] = time
        parameters["location"] = location
        parameters["pageIndex"] = pageIndex
        parameters["pageSize"] = pageSize
        
        SVProgressHUD.show(withStatus: "加载中...")
        Alamofire.request(URLPath.basicPath + URLPath.getFireList , method: .post, parameters: parameters).responseJSON { (response) in
            
            SVProgressHUD.dismiss()
            switch response.result {
                
            case .success(_):
                
                if let value = response.result.value as? [String: Any] {
                    
                    guard value["CODE"] as! String == "0" else{
                        
                        guard value["MSG"] as? String != "token无效" else{
                            
                            LoginViewController.loginOut()
                            print("token无效")
                            return
                        }

                        
                        let message = value["MSG"] as! String
                        SVProgressHUD.showError(withStatus: message)
                        
                        return
                    }
                    
                    if let data = value["data"] as? NSDictionary{
                        
                        //字典转模型的操作
                        if let dataList:NSArray = data["data"] as? NSArray {

                            var tempModel = [YQfireMessage]()
                            
                            for dic in dataList{
                                
                                tempModel.append(YQfireMessage.init(dict: dic as! [String : Any]))
                            }
                            
                            //添加上拉下拉的刷新,选项
                            if pageIndex == 0{
                                
                                self.currentIndex = 0
                                self.dataArray = tempModel
                                self.detailTableV.mj_header.endRefreshing()
                                self.detailTableV.mj_footer.resetNoMoreData()
                                
                            }else{
                                
                                if tempModel.count > 0{
                                    
                                    self.currentIndex = pageIndex
                                    self.dataArray.append(contentsOf: tempModel)
                                    self.detailTableV.mj_footer.endRefreshing()
                                    
                                }else{
                                    
                                    self.detailTableV.mj_footer.endRefreshingWithNoMoreData()
                                    
                                }
                            }
                            
                            //刷新表格数据
                            self.detailTableV.reloadData()
                        }
                        
                    }
                    
                    break
                }
                
                break
            case .failure(let error):
                
                debugPrint(error)
                self.alert(message: "请求失败!")
                break
            }
        }
    }
    
    // MARK: - 上下拉的刷新的界面情况
    func addRefirsh(){
        
        detailTableV.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            
            self.requestFireDetailData(title: self.title!, time: self.timeButton.titleLabel?.text, location: self.seachTextField.text)
        })
        
        
        detailTableV.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            
            self.requestFireDetailData(title: self.title!, time: self.timeButton.titleLabel?.text, location: self.seachTextField.text,pageIndex : self.currentIndex + 1)
            
        })
        
    }


}

extension YQJoinTotallNumVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return (dataArray.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : YQFireDetailCell = tableView.dequeueReusableCell(withIdentifier: cellIndex, for: indexPath) as! YQFireDetailCell
        cell.deleage = self as YQFireDetailCellDeleage
        
        cell.fireMessage = self.dataArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        
        return Bundle.main.loadNibNamed("YQJoinTotallHead", owner: nil, options: nil)![0] as? UIView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }


}


extension YQJoinTotallNumVC : YQFireDetailCellDeleage {
    
    func fireDetailCellDetailClickDeleage(model: YQfireMessage) {
        
        switch model.type {
            case 1:
                //跳入火警详情
                let fireAlarm = YQFireAlarmDetailViewController.init(nibName: "YQFireAlarmDetailViewController", bundle: nil)
                
                fireAlarm.workunitID = model.workunitId
                fireAlarm.type = model.type
                
                navigationController?.pushViewController(fireAlarm, animated: true)
                break
            
            case 2:
                //跳入误报详情
                let falsePositives = YQFalsePositivesVC.init(nibName: "YQFalsePositives", bundle: nil)
                falsePositives.workunitID = model.workunitId
                falsePositives.type = model.type
                
                navigationController?.pushViewController(falsePositives, animated: true)
//                self.present(falsePositives, animated: true, completion: nil)
                
                break
            
            default:
                break
        }
    }
}



