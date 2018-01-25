//
//  YQReportFormDetailVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/1/16.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit
import SVProgressHUD
import SnapKit

class YQReportFormDetailVC: UIViewController {

    @IBOutlet weak var planLabel: UILabel!
    
    @IBOutlet weak var emergencyLabel: UILabel!
    
    @IBOutlet weak var spontaneousLabel: UILabel!
    
    @IBOutlet weak var darwView: YQDrawView!
    
    @IBOutlet weak var planFinishLabal: UILabel!
    
    @IBOutlet weak var spontaneousFinishLabel: UILabel!
    
    @IBOutlet weak var emergencyFinishLabel: UILabel!
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollViewheightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var planSacleLabel: UILabel!
    @IBOutlet weak var emeSacleLabel: UILabel!
    @IBOutlet weak var snaSacleLabel: UILabel!
    
    var personListArrray = [YQReportFromPersonList]()

    var parkID = ""
    
    var selectTitle = ""
    var type : Int!
    var createTime  = ""
    var id : Int = 0
    
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
            
           
            let dict = response["workUnitPojo"] as? [String : Any]
            
            if dict == nil {
                
                SVProgressHUD.showError(withStatus: "没有更多数据!")
                return
            }
            let planNum = dict?["planTotal"] as? CGFloat ?? 0
            let emergencyTotal = dict?["emergencyTotal"] as? CGFloat ?? 0
            let sourceTotal = dict?["sourceTotal"] as? CGFloat ?? 0
            
            //设置数据的属性赋值!
            self.planLabel.text = "\(Int(planNum))"
            self.emergencyLabel.text = "\(Int(emergencyTotal))"
            self.spontaneousLabel.text = "\(Int(sourceTotal))"
            
            //完成数的比例计算
            let planFinsh = dict?["planFinsh"] as? CGFloat ?? 0
            let emergencyFinsh = dict?["emergencyFinsh"] as? CGFloat ?? 0
            let sourceFinsh = dict?["sourceFinsh"] as? CGFloat ?? 0
            
            var planScale : CGFloat  = 0
            var emergencyScale : CGFloat = 0
            var sourceScale : CGFloat = 0
            
            let totall = planFinsh + emergencyFinsh + sourceFinsh
            
            if planNum != 0{
                
                planScale = planFinsh / totall
                
            }
            
            if emergencyTotal != 0 {
                
               emergencyScale = emergencyFinsh / totall
                
            }
            
            if sourceFinsh != 0 {
                
               sourceScale = sourceFinsh / totall
                
            }
            
            self.darwView.planScale = planScale
            self.darwView.emergencyScale = emergencyScale
            self.darwView.sourceScale = sourceScale
            
            //数据展示和计算绘图
            self.planFinishLabal.text = "\(Int(planFinsh))"
            self.emergencyFinishLabel.text = "\(Int(emergencyFinsh))"
            self.spontaneousFinishLabel.text = "\(Int(sourceFinsh))"
            
            let s1 = String(format: "%.1f",planScale * 100)
            self.planSacleLabel.text = s1 + "%"
            
            let s2 = String(format: "%.1f",emergencyScale * 100)
            self.emeSacleLabel.text = s2 + "%"
            
            let s3 = String(format: "%.1f",sourceScale * 100)
            self.snaSacleLabel.text = s3 + "%"

            
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
            
            
            let dict = response as? [String : Any]
            
            let firstDict = dict?["branch"] as? NSArray
            let array = firstDict?.firstObject as? [String : Any]
            
            if array == nil {
                
                SVProgressHUD.showError(withStatus: "没有更多的数据!")
                return
            }
            
            if let nodes = array?["nodes"] as? Array<[String : Any]>{
                
                for indexTemp in 0..<nodes.count{
                    
                    //循环创建,多个值的情况
                    let view = Bundle.main.loadNibNamed("YQReportFromPersonList", owner: nil, options: nil)?[0] as! YQReportFromPersonList
                    view.dataDict = nodes[indexTemp]
                    view.delegate = self
                    
                    self.personListArrray.append(view)
                    
                    self.contentView.addSubview(view)
                    
                    if indexTemp == 0 {
                        
                        view.snp.makeConstraints({ (maker) in
                            
                            maker.top.equalTo(self.searchBar.snp.bottom)
                            maker.left.right.equalToSuperview()
                            maker.height.equalTo(160)
                            
                        })
                        
                    
                    }else{
                        
                        let viewTemp = self.personListArrray[indexTemp - 1]
                        
                        view.snp.makeConstraints({ (maker) in
                            
                            maker.top.equalTo(viewTemp.snp.bottom)
                            maker.left.right.equalToSuperview()
                            maker.height.equalTo(160)
                            
                        })

                    
                    }
                }
                
                
                self.scrollViewheightConstraint.constant += CGFloat((nodes.count-1) * 160 + 30)
                
            }
            
            
        }) { (error) in
            
             SVProgressHUD.showError(withStatus: "数据加载失败,请检查网络!")
        }
    }
    
    // MARK: - rightBar界面跳转的系类的方法
    // 日报
    func jumpToWorkPlanVC(){
        
        let workPlan = YQWorkPlanVC.init(nibName: "YQWorkPlanVC", bundle: nil)
        workPlan.id = id
        
        navigationController?.pushViewController(workPlan, animated: true)
        
    }
    
    // 周报
    func jumpToWorkHighlights(){
        
        let WorkHighlights = YQWorkHighlightsVC.init(nibName: "YQWorkHighlightsVC", bundle: nil)
        WorkHighlights.id = id
            
        navigationController?.pushViewController(WorkHighlights, animated: true)
    }
    
    
    // 月报
    func jumpToShowWorkHighlightDetail(){
        
        let showDetail = YQWorkHighlightsDetailVC.init(nibName: "YQWorkHighlightsDetailVC", bundle: nil)
        showDetail.create = createTime
        
        navigationController?.pushViewController(showDetail, animated: true)
    
    }
    
 
}

extension YQReportFormDetailVC : YQReportFromPersonListDelegate{
    
    func reportFromPersonListDelegate(view: UIView, par: [String : Any]) {
        
        let reportDetail = UIStoryboard.instantiateInitialViewController(name: "YQReportPersonDetail") as? YQReportFormPersonDetailVC
        reportDetail?.type = self.type
        reportDetail?.parmart = par
        reportDetail?.create = createTime
        reportDetail?.id = id
        
        navigationController?.pushViewController(reportDetail!, animated: true)
        
        
    }

}

extension YQReportFormDetailVC : UISearchBarDelegate{

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        searchBar.endEditing(true)
    
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.endEditing(true)
        self.getWorkUnitPersonListData(personName: searchBar.text!)
        
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.view.endEditing(true)
        searchBar.text = ""
        self.getWorkUnitPersonListData()
        
    }


}
