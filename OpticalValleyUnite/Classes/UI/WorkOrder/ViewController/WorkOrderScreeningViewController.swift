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
    
    
    @IBOutlet weak var projectTagsHeightContstrain: NSLayoutConstraint!
    var models = [ProjectModel](){
        didSet{
            for model in models{
                projectTagsView.addTag(model.projectName)
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
    

    @IBAction func beginBtnClick(_ sender: UIButton) {
        SJPickerView.show(withDateType: .date, defaultingDate: Date(),userController:self, selctedDateFormot: "yyyy-MM-dd") { (date, dateStr) in
            sender.setTitle(dateStr, for: .normal)
            self.startTime = dateStr
        }
    }
    
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

    @IBAction func doneBtnClick() {
        var parmat = [String: Any]()
        let dic = ["待派发": 0,"待处理" : 5, "待评价": 7,"待接收": 1,"已处理": 7, "已接受": 5,"已派发": 1]
        
        if projectTagsView.selectedTagIndexes.first != nil {
            projectModel = models[(projectTagsView.selectedTagIndexes.first!.intValue)]
            parmat["PARK_ID"] = projectModel?.projectId
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
    

}

extension WorkOrderScreeningViewController: RKTagsViewDelegate{
    func tagsViewContentSizeDidChange(_ tagsView: RKTagsView) {
        scrollView.contentSize = CGSize(width: 0, height: 330.0 + tagsView.contentSize.height)
    }
}
