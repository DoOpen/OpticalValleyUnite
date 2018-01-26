//
//  YQReportFormPersonDetailVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/1/21.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit
import SVProgressHUD
import Kingfisher


class YQReportFormPersonDetailVC: UIViewController {

    var type : Int!
    
    var parmart : [String : Any]!
    var create  = ""
    
    var id : Int = 0 
    
    ///属性的列表
    @IBOutlet weak var iconImageV: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var projectName: UILabel!
    //总数
    @IBOutlet weak var workOrderNumLabel: UILabel!
    
    @IBOutlet weak var typeLabel: UILabel!
    
    //工作完成数
    @IBOutlet weak var typeWorkNumLabel: UILabel!
    
    @IBOutlet weak var typeCompleteLabel: UILabel!
    
    /// drawView
    @IBOutlet weak var planView: YQDrawPlanView!
    
    @IBOutlet weak var planLabel: UILabel!
    
    @IBOutlet weak var planCompleteLabel: UILabel!
    
    @IBOutlet weak var planScale: UILabel!
    
    @IBOutlet weak var emergencyView: YQDrawEmergencyView!
    
    @IBOutlet weak var emelabel: UILabel!
    @IBOutlet weak var emeScale: UILabel!
    
    @IBOutlet weak var emeCompleteLabel: UILabel!
    
    @IBOutlet weak var spontaneousView: YQDrawSpontaneousView!
    
    @IBOutlet weak var sponCompleteLabel: UILabel!
    
    @IBOutlet weak var sponScale: UILabel!
    
    @IBOutlet weak var sponLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "工作记录详情"
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        addRightBarButtonItem()
        
        //获取的是工单的数据
        getDataForService()
        
    }
    
    // MARK: - 添加rightBar按钮的点击的情况
    func addRightBarButtonItem(){
        
        self.projectName.text = parmart["postName"] as? String
        
        switch type {
        case 1://日报
            
            let button = UIButton()
            button.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
            button.setTitle("工作计划", for: .normal)
            button.setTitleColor(UIColor.gray, for: .normal)
            button.sizeToFit()
            button.addTarget(self, action: #selector(jumpToWorkPlanVC), for: .touchUpInside)
            
            let barItem = UIBarButtonItem()
            barItem.customView = button
            
            navigationItem.rightBarButtonItem = barItem
            
            self.typeLabel.text = "当日完成工单"
            self.typeCompleteLabel.text = "今日工单数量"
            
            break
        case 2://周报
            
            let button = UIButton()
            button.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
            button.setTitle("工作日志", for: .normal)
            button.setTitleColor(UIColor.gray, for: .normal)
            button.sizeToFit()
            
            button.addTarget(self, action: #selector(jumpToShowWorkJournal), for: .touchUpInside)
            
            let barItem = UIBarButtonItem()
            barItem.customView = button
            
            navigationItem.rightBarButtonItem = barItem
            
            self.typeLabel.text = "本周完成工单"
            self.typeCompleteLabel.text = "本周工单数量"
            
            break
        case 3://月报
            
            let button = UIButton()
            button.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
            button.setTitle("工作日志", for: .normal)
            button.setTitleColor(UIColor.gray, for: .normal)
            button.sizeToFit()
            
            button.addTarget(self, action: #selector(jumpToShowWorkJournal), for: .touchUpInside)
            
            let barItem = UIBarButtonItem()
            barItem.customView = button
            
            navigationItem.rightBarButtonItem = barItem
            
            self.typeLabel.text = "本月完成工单"
            self.typeCompleteLabel.text = "本月工单数量"
            
            break
        default:
            
            break
            
        }
    }

    // MARK: - rightBar界面跳转的系类的方法
    // 日报
    func jumpToWorkPlanVC(){
        
        let workPlan = YQWorkPlanVC.init(nibName: "YQWorkPlanVC", bundle: nil)
        workPlan.id = id
        
        navigationController?.pushViewController(workPlan, animated: true)
        
    }

    func jumpToShowWorkJournal(){
    
        //测试日志模块
        let journa = UIStoryboard.instantiateInitialViewController(name: "YQJournal")
        self.present(journa, animated: true, completion: nil)
    
    }
    
    // MARK: - 获取的数据的方法
    func getDataForService(){
    
        var par = [String : Any]()
        par["personId"] = parmart["personId"]
        par["reportType"] = type
        par["createTime"] = self.create
        par["parkId"] = parmart["parkId"]
        
        SVProgressHUD.show()
        
        HttpClient.instance.post(path: URLPath.getReportWorkUnitQuery, parameters: par, success: { (response) in
            
            SVProgressHUD.dismiss()
            
            if response is [String : Any] {
                
                let iconString = response["potos"] as? String ?? ""
                self.userNameLabel.text = response["personName"] as? String
                
                self.iconImageV.layer.masksToBounds = true
                self.iconImageV.layer.cornerRadius = 40
                
                var url = URL(string: "")
                
                if (iconString.contains("http")){
                    
                    url = URL(string: iconString)
                    
                    self.iconImageV.kf.setImage(with: url, placeholder: UIImage.init(name: "userIcon"), options: nil, progressBlock: nil, completionHandler: nil)
                
                }else{
                    
                    let basicPath = URLPath.systemSelectionURL
                    let newString = basicPath.replacingOccurrences(of: "/api/", with: "") + "/" + iconString
                    
                    url = URL(string: newString)
                    
                    self.iconImageV.kf.setImage(with: url, placeholder: UIImage.init(name: "userIcon"), options: nil, progressBlock: nil, completionHandler: nil)
                }
                
                let dataDict = response["workUnitPojo"] as? [String : Any]
                self.workOrderNumLabel.text = "\(dataDict?["total"] as? Int ?? 0)"
                self.typeWorkNumLabel.text = "\(dataDict?["finshTotal"] as? Int ?? 0)"
                
                //计划工单
                let planFinsh = dataDict?["planFinsh"] as? CGFloat ?? 0
                let planNoFinsh = dataDict?["planNoFinsh"] as? CGFloat ?? 0
                //应急工单
                let emergencyFinsh = dataDict?["emergencyFinsh"] as? CGFloat ?? 0
                let emergencyNoFinsh = dataDict?["emergencyNoFinsh"] as? CGFloat ?? 0
                //巡检工单
                let allFinshTotal = dataDict?["allFinshTotal"] as? CGFloat ?? 0
                let allNoFinshTotal = dataDict?["allNoFinshTotal"] as? CGFloat ?? 0
                
                
                if Int(planFinsh) > 0 {
                
                    self.planView.planScale = planFinsh / (planFinsh + planNoFinsh)
                    
                    self.planView.setNeedsDisplay()
                
                }
                
                if Int(emergencyFinsh) > 0 {
                    self.emergencyView.emergencyScale = emergencyFinsh / (emergencyFinsh + emergencyNoFinsh)
                    
                    self.emergencyView.setNeedsDisplay()
                }
                
                if Int(allFinshTotal) > 0 {
                    
                    self.spontaneousView.sourceScale = allFinshTotal / (allFinshTotal + allNoFinshTotal)
                    
                    self.spontaneousView.setNeedsDisplay()
                
                }
                
                self.planLabel.text = "\(Int(planFinsh) + Int(planNoFinsh))"
                self.planCompleteLabel.text = "\(Int(planFinsh))"
                let s = String(format: "%.1f", self.planView.planScale * 100)
                self.planScale.text = s + "%"
                
                self.emelabel.text = "\(Int(emergencyFinsh) + Int(emergencyNoFinsh))"
                self.emeCompleteLabel.text = "\(Int(emergencyFinsh))"
                let s1 = String(format: "%.1f", self.emergencyView.emergencyScale * 100)
                self.emeScale.text = s1 + "%"
                
                self.sponLabel.text = "\(Int(allFinshTotal) + Int(allNoFinshTotal))"
                self.sponCompleteLabel.text = "\(Int(allFinshTotal))"
                let s2 = String(format: "%.1f", self.spontaneousView.sourceScale * 100)
                self.sponScale.text =  s2 + "%"
                
                
            }else{
            
                SVProgressHUD.showError(withStatus: "没有加载更多的数据!")
            }
            
        
        }) { (error) in
            
            SVProgressHUD.showError(withStatus: "数据加载失败,请检查网络!")
        }
    
    }

}
