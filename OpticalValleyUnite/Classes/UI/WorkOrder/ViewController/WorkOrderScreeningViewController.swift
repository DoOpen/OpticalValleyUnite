//
//  WorkOrderScreeningViewController.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/1/12.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit

class WorkOrderScreeningViewController: UIViewController {

    @IBOutlet weak var projectTagsView: RKTagsView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var workOrderStatusTagsView: RKTagsView!
    @IBOutlet weak var workOrderTipView: UIView!
    
    @IBOutlet weak var startTimeBnt: UIButton!
    
    @IBOutlet weak var endTimeBnt: UIButton!
    
    @IBOutlet weak var projectTagsHeightContstrain: NSLayoutConstraint!
    
    var models = [ProjectModel](){
        
        didSet{
            
            let dic = UserDefaults.standard.object(forKey: Const.YQProjectModel) as? [String : Any]
            
            var projectname = ""
            
            var indexNum = -1
            
            if dic != nil {
                
                projectname = (dic?["PARK_NAME"] as? String)!
            }

            for index in 0 ..< models.count{
                
                let model = models[index]
                
                if projectname == model.projectName{
                    
                    model.selected = true
                    indexNum = index
                }
                projectTagsView.addTag(model.projectName)
            }
            
            if indexNum == -1 {
                return
            }else{
                
               projectTagsView.selectTag(at: indexNum)
            }
            
        }
        
    }
    
    var models2 = [String]()
    
    var doneBtnClickHandel: (([String: Any]) -> ())?
    
    var type = 0
    var projectModel: ProjectModel?
    var startTime: String?
    var endTime: String?
    var status: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        projectTagsView.editable = false
        projectTagsView.selectable = true
        projectTagsView.lineSpacing = 20
        projectTagsView.interitemSpacing = 20
        projectTagsView.allowsMultipleSelection = false
        projectTagsHeightContstrain.priority = 1
        projectTagsView.delegate = self

        var status = [String]()
        if type == 0{
            status = [ "待派发", "待处理", "待评价","待接收"]
        }else if type == 1{
            status = ["已处理", "已接受","已派发"]
        }else if type == 2{
            workOrderStatusTagsView.isHidden = true
            workOrderTipView.isHidden = true
        }
        models2 = status
        
        
        workOrderStatusTagsView.editable = false
        workOrderStatusTagsView.selectable = true
        workOrderStatusTagsView.lineSpacing = 20
        workOrderStatusTagsView.interitemSpacing = 20
        workOrderStatusTagsView.allowsMultipleSelection = false
        for statu in status {
            workOrderStatusTagsView.addTag(statu)
        }
        
        getWorkTypeList()
        
    }
    
    
    // MARK: - 开始时间按钮点击
    @IBAction func beginBtnClick(_ sender: UIButton) {
        SJPickerView.show(withDateType: .date, defaultingDate: Date(),userController:self, selctedDateFormot: "yyyy-MM-dd") { (date, dateStr) in
            sender.setTitle(dateStr, for: .normal)
            self.startTime = dateStr
        }
    }
    
    
    // MARK: - 截止时间按钮点击
    @IBAction func endBtnClick(_ sender: UIButton) {
        SJPickerView.show(withDateType: .date, defaultingDate: Date(), userController:self, selctedDateFormot: "yyyy-MM-dd") { (date, dateStr) in
            sender.setTitle(dateStr, for: .normal)
            self.endTime = dateStr
        }
    }
    

    func getWorkTypeList(){
        
        HttpClient.instance.get(path: URLPath.getParkList, parameters: nil, success: { (response) in

            
            var temp = [ProjectModel]()
            for dic in response as! Array<[String: Any]> {
                temp.append(ProjectModel(parmart: dic))
            }
            self.models = temp
        
            
        }) { (error) in
            
        }
    }

    // MARK: - 完成,确定按钮的点击方法
    @IBAction func doneBtnClick() {
        
        var parmat = [String: Any]()
        
        let dic = ["待派发": 0,"待处理" : 5, "待评价": 7,"待接收": 1,"已处理": 7, "已接受": 5,"已派发": 1]
        
        if projectTagsView.selectedTagIndexes.first != nil {
            
            projectModel = models[(projectTagsView.selectedTagIndexes.first!.intValue)]
            
            parmat["PARK_ID"] = projectModel?.projectId
            
            //重新传递的是 项目模型
            var dic = [String : Any]()
            dic["ID"] = projectModel?.projectId
            dic["PARK_NAME"] = projectModel?.projectName
            
            UserDefaults.standard.set(dic, forKey: Const.YQProjectModel)
            
        }
        
        if workOrderStatusTagsView.selectedTagIndexes.first != nil {
            let str = models2[(workOrderStatusTagsView.selectedTagIndexes.first!.intValue)]
            parmat["UNIT_STATUS"] = dic[str]
        }
        if let startTime = startTime{
            parmat["STAR"] = startTime
        }
        if let endTime = endTime{
            parmat["END"] = endTime
        }
        
        if let block = doneBtnClickHandel{
            
            block(parmat)
        }
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    
    
    // MARK: - 重置设置按钮
    @IBAction func resetBtnClick(_ sender: UIButton) {
        
        //重置时间
        startTime = ""
        endTime = ""
        startTimeBnt.setTitle("开始时间", for: .normal)
        endTimeBnt.setTitle("结束时间", for: .normal)
        
        //重新设置加载模型
        if self.models.count > 0{
            
            self.models.removeAll()
            projectTagsView.removeAllTags()

            getWorkTypeList()
        
        }
        
        //重置没有清空缓存,可以考虑的是重置之后清除缓存
//        UserDefaults.standard.removeObject(forKey: Const.YQProjectModel)
        
    }
}

extension WorkOrderScreeningViewController: RKTagsViewDelegate{
    
    // MARK: - RKTagsView的代理的方法
    func tagsViewContentSizeDidChange(_ tagsView: RKTagsView) {
        scrollView.contentSize = CGSize(width: 0, height: 330.0 + tagsView.contentSize.height)
    }

}
