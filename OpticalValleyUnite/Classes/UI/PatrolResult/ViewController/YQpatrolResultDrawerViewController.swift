//
//  YQpatrolResultDrawerViewController.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/12/9.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit
import SVProgressHUD


class YQpatrolResultDrawerViewController: UIViewController {
    
    ///属性列表
    @IBOutlet weak var calendarLabel: UILabel!
    
    @IBOutlet weak var selectWaysTagsV: RKTagsView!
    
    @IBOutlet weak var trajectoryTagsV: RKTagsView!
    
    var parkID = ""
    
    var patrolRouteArray = NSArray(){
        didSet{
            
            //缓存添加选项设置
            for index in 0 ..< patrolRouteArray.count{
                
                let tag = patrolRouteArray[index] as? NSDictionary
                
                self.selectWaysTagsV.addTag((tag?["wayName"] as? String)!)
                self.setTagsView(tagsView: selectWaysTagsV)
            }
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //0.获取parkID
        let _ = setUpProjectNameLable()
        
        //1.获取路线数据
        getLoadWayNameData()
        
        //2.填充路线设置数据
        let tagA = ["巡查路线设计轨迹","巡查路线实际轨迹","人员执行轨迹"]
        setTagsView(tagsView: trajectoryTagsV,tags: tagA)
        
        //3.获取当前的时间选项
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let stringDate = dateFormatter.string(from: Date())
        self.calendarLabel.text = stringDate
        
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
    
    
    // MARK: - 获取网络数据路线轨迹
    func getLoadWayNameData(){
        
        var par = [String : Any]()
        par["parkId"] = self.parkID
//        par["insPointName"] = pointName
        
        SVProgressHUD.show()
        //查巡查路线
        HttpClient.instance.post(path: URLPath.getVideoPatrolLoadWayName, parameters: par, success: { (response) in
            SVProgressHUD.dismiss()
            //设置数据添加到tagview
            self.patrolRouteArray = response as! NSArray
            
        }) { (error) in
            
            SVProgressHUD.showError(withStatus: "数据加载失败,请检查网络!")
        }
    }
    
    // MARK: - tagsView的默认的设置的方法
    private func setTagsView(tagsView: RKTagsView,tags: [String]? = nil){
        tagsView.editable = false
        tagsView.selectable = true
        tagsView.lineSpacing = 15
        tagsView.interitemSpacing = 15
        tagsView.allowsMultipleSelection = true
//        tagsView.delegate = self
        
        if tags != nil{
            
            for tag in tags!{
                tagsView.addTag(tag)
            }
        }
    }

    
    
    // MARK: - 按钮点击的所有的方法
    @IBAction func datePickerClick(_ sender: Any) {
        
        SJPickerView.show(withDateType: .date, defaultingDate: Date(), userController:self,selctedDateFormot: "yyyy-MM-dd") { (date, dateStr) in
            
            self.calendarLabel.text = dateStr
        }

        
    }
    
    @IBAction func resetButtonClick(_ sender: UIButton) {
        
        self.calendarLabel.text = ""
        self.selectWaysTagsV.deselectAll()
        self.trajectoryTagsV.deselectAll()
        
    }

    @IBAction func compeletButtonClick(_ sender: UIButton) {
        //所有的都要求的是全选的数值
        if self.calendarLabel.text == "" {
            self.alert(message: "请填写时间项!")
        }
        
        if self.selectWaysTagsV.selectedTagIndexes.isEmpty {
            self.alert(message: "请选择巡查线路!")
            
        }
        
        if self.trajectoryTagsV.selectedTagIndexes.isEmpty {
            
            self.alert(message: "请选择执行轨迹!")
        }
        
        //完成规划路径的接口
        var par = [String : Any]()
        par["date"] = self.calendarLabel.text
        
        //查询路线id
        let array = self.selectWaysTagsV.selectedTagIndexes
        var wayIds = ""
        
        for indexes in array {
            
            let typeDict = self.patrolRouteArray[Int(indexes)] as? NSDictionary
            let id = typeDict?["insWayId"] as? Int ?? -1
            if wayIds == "" {
                
                wayIds = "\(id)"
            }else{
                
                wayIds = wayIds + "," + "\(id)"
            }
        }
        par["wayIds"] = wayIds

        
        //查询设计轨迹id
        var orbitType = ""
        let arrayType = self.trajectoryTagsV.selectedTagIndexes
        for indexxxx in arrayType{
            if orbitType == "" {
                orbitType = "\(Int(indexxxx) + 1)"
            }else{
                orbitType = orbitType + "," + "\(Int(indexxxx) + 1)"
            }

        }
        
        par["orbitType"] = orbitType
        SVProgressHUD.show()
        
        HttpClient.instance.post(path: URLPath.getResultInsOrbitList, parameters: par, success: { (respose) in
            SVProgressHUD.dismiss()
            
            let allDrawDict = respose
            
            //发送通知进行传值
            let center = NotificationCenter.default
            let notiesName = NSNotification.Name(rawValue: "resultDrawerLoadWaysNoties")
            center.post(name: notiesName, object: nil, userInfo: ["VideoLoadWaysArray": allDrawDict])

        }) { (error) in
            SVProgressHUD.showError(withStatus: "数据加载失败,请检查网络!")
        }
    
    }
    

}

