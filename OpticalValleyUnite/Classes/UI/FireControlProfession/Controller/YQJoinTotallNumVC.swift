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
    
    //定义的是模型数组
    var dataArray :[YQfireMessage]?{
        didSet{
            //刷新表格数据
            self.detailTableV.reloadData()
        
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //初始设置内容
        titleButton.setTitle(self.title, for: .normal)
        
        //添加leftBar属性
        self.setUpLeftBar()
        
        //添加调用接口数据
        requestFireDetailData(title: self.title!, time: nil, location: nil)
        
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
        let temp = ["参与总单量","火警单","误报单"]
        
//        SJPickerView.show(withDataArry2: temp, didSlected: { [weak self] index in
//            self?.projectBtn.setTitle(temp[index].title, for: .normal)
//            self?.selectProject = temp[index]
//        })
        SJPickerView.show(withDataArry: temp, didSlected: { [weak self] index in
            
            if index == 0 {
                self?.titleButton .setTitle("总单量", for: .normal)
            }else{
                self?.titleButton .setTitle(temp[index], for: .normal)
            }
            
            self?.selectProject = temp[index]
            // 调用筛选的接口
            self?.requestFireDetailData(title: (self?.titleButton.titleLabel?.text)!, time: self?.timeButton.titleLabel?.text, location:self?
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
    func requestFireDetailData(title : String, time : String?, location : String?){
        
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
        
        SVProgressHUD.show(withStatus: "加载中...")
        Alamofire.request(URLPath.basicPath + URLPath.getFireList , method: .post, parameters: parameters).responseJSON { (response) in
            
            SVProgressHUD.dismiss()
            switch response.result {
                
            case .success(_):
                
                if let value = response.result.value as? [String: Any] {
                    
                    guard value["CODE"] as! String == "0" else{
                        let message = value["MSG"] as! String
                        
                        self.alert(message: message)
                        return
                    }
                    
                    if let data = value["data"] as? NSDictionary{
                        //字典转模型的操作
                        if let dataList:NSArray = data["data"] as? NSArray {

                            var model = [YQfireMessage]()
                            
                            for dic in dataList{
                                
                                model.append(YQfireMessage.init(dict: dic as! [String : Any]))
                            }
                            
                            self.dataArray = model
                        
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
    
    

}

extension YQJoinTotallNumVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.dataArray?.count == 0{
            return 10
        }else{
            
            return (dataArray?.count)!
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : YQFireDetailCell = tableView.dequeueReusableCell(withIdentifier: cellIndex, for: indexPath) as! YQFireDetailCell
        cell.deleage = self as YQFireDetailCellDeleage
        
        cell.fireMessage = self.dataArray?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
//        let view = [Bundle.main.loadNibNamed("YQJoinTotallHead", owner: nil, options: nil)].last as? YQJoinTotallHeadView
        
        return Bundle.main.loadNibNamed("YQJoinTotallHead", owner: nil, options: nil)![0] as? UIView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }


}


extension YQJoinTotallNumVC : YQFireDetailCellDeleage {
    
    func fireDetailCellDetailClickDeleage(model: YQfireMessage) {
        
        switch model.type! {
            case "火警单":
                //跳入火警详情
                let fireAlarm = YQFireAlarmDetailViewController(nibName : "YQFireAlarmDetailViewController" , bundle: nil)
                navigationController?.pushViewController(fireAlarm, animated: true)
                fireAlarm.workunitID = model.workunitId
                fireAlarm.type = model.type!
                
                break
            case "误报单":
                //跳入误报详情
                let falsePositives = YQFalsePositivesVC(nibName : "YQFalsePositivesVC" , bundle: nil)
                navigationController?.pushViewController(falsePositives, animated: true)
                falsePositives.workunitID = model.workunitId
                falsePositives.type = model.type!
                
                break
            default:
                break
        }
        
        
    }
    
}



