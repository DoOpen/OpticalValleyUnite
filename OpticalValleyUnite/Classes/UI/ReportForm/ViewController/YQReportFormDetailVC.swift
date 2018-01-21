//
//  YQReportFormDetailVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/1/16.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit
import SVProgressHUD

class YQReportFormDetailVC: UIViewController {

    @IBOutlet weak var planLabel: UILabel!
    
    @IBOutlet weak var emergencyLabel: UILabel!
    
    @IBOutlet weak var spontaneousLabel: UILabel!
    
    @IBOutlet weak var darwView: YQDrawView!
    
    @IBOutlet weak var planFinishLabal: UILabel!
    
    @IBOutlet weak var spontaneousFinishLabel: UILabel!
    
    @IBOutlet weak var emergencyFinishLabel: UILabel!
    
    var parkID = ""
    
    var selectTitle = ""
    var type : Int!
    var createTime  = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.title = selectTitle
        
        //获取项目parkID的情况
        let _ = setUpProjectNameLable()

        addRightBarButtonItem()
        //要求连续调用的是两个接口
        
        getWorkUnitQueryData()
        
    }

    func addRightBarButtonItem(){
        
        switch type {
        case 1://日报
            let button = UIButton()
            button.frame = CGRect.init(x: 0, y: 0, width: 50, height: 40)
            button.setTitle("工作计划", for: .normal)
            button.setTitleColor(UIColor.gray, for: .normal)
            button.sizeToFit()
            button.addTarget(self, action: #selector(jumpToWorkPlanVC), for: .touchUpInside)
            
            let barItem = UIBarButtonItem()
            barItem.customView = button
            
            navigationItem.rightBarButtonItem = barItem
            
            break
        case 2://周报
            
            let button = UIButton()
            button.frame = CGRect.init(x: 0, y: 0, width: 50, height: 40)
            button.setTitle("工作亮点", for: .normal)
            button.setTitleColor(UIColor.gray, for: .normal)
            button.sizeToFit()
            
            button.addTarget(self, action: #selector(jumpToWorkHighlights), for: .touchUpInside)
            
            let barItem = UIBarButtonItem()
            barItem.customView = button
            
            navigationItem.rightBarButtonItem = barItem
            
            break
        case 3://月报
            
            let button = UIButton()
            button.frame = CGRect.init(x: 0, y: 0, width: 50, height: 40)
            button.setTitle("工作亮点", for: .normal)
            button.setTitleColor(UIColor.gray, for: .normal)
            button.sizeToFit()
            
            button.addTarget(self, action: #selector(jumpToShowWorkHighlightDetail), for: .touchUpInside)
            
            let barItem = UIBarButtonItem()
            barItem.customView = button
            
            navigationItem.rightBarButtonItem = barItem
            
            break
        default:
            
            break
            
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

    // MARK: - 获取两个数据接口的数据
    func getWorkUnitQueryData(){
        
        var par = [String : Any]()
        par["parkId"] = parkID
        par["reportType"] = type
        par["createTime"] = createTime
        
        SVProgressHUD.show()
        
        HttpClient.instance.post(path: URLPath.getReportWorkUnitQuery, parameters: par, success: { (response) in
            
           
            let dict = response as? [String : Any]
            
            if dict == nil {
                
                SVProgressHUD.showError(withStatus: "没有更多数据!")
                return
            }
            let planNum = dict?["planTotal"] as? Int ?? 0
            let emergencyTotal = dict?["emergencyTotal"] as? Int ?? 0
            let sourceTotal = dict?["sourceTotal"] as? Int ?? 0
            
            //设置数据的属性赋值!
            self.planLabel.text = "\(planNum)"
            self.emergencyLabel.text = "\(emergencyTotal)"
            self.spontaneousLabel.text = "\(sourceTotal)"
            
            //完成数的比例计算
            let planFinsh = dict?["planFinsh"] as? Int ?? 0
            let emergencyFinsh = dict?["emergencyFinsh"] as? Int ?? 0
            let sourceFinsh = dict?["sourceFinsh"] as? Int ?? 0
            
            var planScale : Double  = 0
            var emergencyScale : Double = 0
            var sourceScale : Double = 0
            
            let totall = planNum + emergencyTotal + sourceTotal
            
            if planNum != 0{
                
                planScale = Double (planFinsh / totall)
                
            }
            
            if emergencyTotal != 0 {
                
               emergencyScale = Double (emergencyFinsh / totall)
                
            }
            
            if sourceScale != 0 {
                
               sourceScale = Double(sourceFinsh / totall)
                
            }
            
            self.darwView.planScale = planScale
            self.darwView.emergencyScale = emergencyScale
            self.darwView.sourceScale = sourceScale
            
            //数据展示和计算绘图
            self.planFinishLabal.text = "\(planFinsh)"
            self.emergencyFinishLabel.text = "\(emergencyFinsh)"
            self.spontaneousFinishLabel.text = "\(sourceFinsh)"
            
            //重绘一下
            self.darwView.setNeedsDisplay()
            
            //再调用人员list的数据
            self.getWorkUnitPersonListData()
            
            
        }, failure: { (error) in
            
            SVProgressHUD.showError(withStatus: "数据加载失败,请检查网络!")
            
        })
        
    }
    
    func getWorkUnitPersonListData(personName : String = ""){
        
        var par = [String : Any]()
        
        if personName != ""{
            
            par["personName"] = personName
        }
        par["parkId"] = parkID
        
        HttpClient.instance.post(path: URLPath.getReportWorkUnitPList, parameters: par, success: { (response) in
            
            SVProgressHUD.dismiss()
            
            
        }) { (error) in
            
             SVProgressHUD.showError(withStatus: "数据加载失败,请检查网络!")
        }
    }
    
    // MARK: - rightBar界面跳转的系类的方法
    // 日报
    func jumpToWorkPlanVC(){
        
        let workPlan = YQWorkPlanVC.init(nibName: "YQWorkPlanVC", bundle: nil)
        
        navigationController?.pushViewController(workPlan, animated: true)
        
    }
    
    // 周报
    func jumpToWorkHighlights(){
        
        let WorkHighlights = YQWorkHighlightsVC.init(nibName: "YQWorkHighlightsVC", bundle: nil)
        
        navigationController?.pushViewController(WorkHighlights, animated: true)
    }
    
    
    // 月报
    func jumpToShowWorkHighlightDetail(){
        
        let showDetail = YQWorkHighlightsDetailVC.init(nibName: "YQWorkHighlightsDetailVC", bundle: nil)
        
        navigationController?.pushViewController(showDetail, animated: true)
    
    }
    
 
}
