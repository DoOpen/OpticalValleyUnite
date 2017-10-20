//
//  WorkOrderSiftViewController.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/7/18.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit

class WorkOrderSiftViewController: UIViewController {

    @IBOutlet weak var projectTagsView: RKTagsView!
    
    @IBOutlet weak var workTypeTagsView: RKTagsView!
    
    //工作分类视图框(应急工单 和 计划工单的类型)
    @IBOutlet weak var reportTypeTagsView: RKTagsView!
    
    @IBOutlet weak var deviceTagsView: RKTagsView!
    
    //工单状态是不要的!(["待派发","待接收","协助查看","待执行","待评价","已关闭"])
    @IBOutlet weak var workStatusTagView: RKTagsView!
    
    
    @IBOutlet weak var sourceTagsView: RKTagsView!
    
    @IBOutlet weak var workOrderNameLabel: UITextField!
    @IBOutlet weak var workOrderSourcePersonLabel: UITextField!
    @IBOutlet weak var workNumberLabel: UITextField!
    
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var endBtn: UIButton!
    
    // "待派发","待接收","协助查看","待执行","待评价","已关闭"
    let workStatus = [String : Any]() //暂时设置为nil,字面量的赋值取消
    

    var startTime: String?
    var endTime: String?
    var status = ""
    var projectData = [ProjectModel](){
        didSet{
            for tag in projectData{
                self.projectTagsView.addTag(tag.projectName)
            }
        }
    }
    var workTypeData = [WorkTypeModel](){
        didSet{
            for tag in workTypeData{
                self.workTypeTagsView.addTag(tag.name)
            }
        }
    }
    
    var doenBtnClickHandel: (([String: Any]) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getProjectData()
        getWorkTypeData()
        
        setTagsView(tagsView: projectTagsView)
        setTagsView(tagsView: workTypeTagsView)
        
// reportType 的设置
//        setTagsView(tagsView: reportTypeTagsView,tags: ["计划工单","应急工单"])
        setTagsView(tagsView: deviceTagsView,tags: ["是","否"])
        
// workStatus 的设置
//        setTagsView(tagsView: workStatusTagView,tags: workStatus as! [String])
        
        setTagsView(tagsView: sourceTagsView,tags: ["系统后台","员工app","业主app"])
        
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
//            let arry = ["丽岛2046","光谷软件园","创意天地"]
//            
//        }
       
    }
    
    
    // MARK: - 开始日期的点击方法
    @IBAction func beginBtnClick(_ sender: UIButton) {
        SJPickerView.show(withDateType: .date, defaultingDate: Date(), userController:self,selctedDateFormot: "yyyy-MM-dd") { (date, dateStr) in
            sender.setTitle(dateStr, for: .normal)
            self.startTime = dateStr
        }
    }
    
    
    // MARK: - 结束日期的点击方法
    @IBAction func endBtnClick(_ sender: UIButton) {
        SJPickerView.show(withDateType: .date, defaultingDate: Date(), userController:self,selctedDateFormot: "yyyy-MM-dd") { (date, dateStr) in
            sender.setTitle(dateStr, for: .normal)
            self.endTime = dateStr
        }
    }
    
    
    // MARK: - 重置按钮的点击
    @IBAction func resetBtnClick() {
        projectTagsView.deselectAll()
        workTypeTagsView.deselectAll()
        reportTypeTagsView.deselectAll()
        deviceTagsView.deselectAll()
        workStatusTagView.deselectAll()
        sourceTagsView.deselectAll()
        
        workOrderNameLabel.text = ""
        workOrderSourcePersonLabel.text = ""
        workNumberLabel.text = ""
        
        startTime = ""
        endTime = ""
        endBtn.setTitle("截止时间", for: .normal)
        startBtn.setTitle("开始时间", for: .normal)
    }
    
    private func getProjectData(){
        HttpClient.instance.get(path: URLPath.getParkList, parameters: nil, success: { (response) in
            
            
            var temp = [ProjectModel]()
            for dic in response as! Array<[String: Any]> {
                temp.append(ProjectModel(parmart: dic))
            }
            self.projectData = temp
            
            
            
        }) { (error) in
            
        }
    }
    
    private func getWorkTypeData(){
        
        HttpClient.instance.get(path: URLPath.getWorkTypeList, parameters: nil, success: { (response) in
            
            var temp = [WorkTypeModel]()
            for dic in response as! Array<[String: Any]>{
                let model = WorkTypeModel(parmart: dic)
                temp.append(model)
            }
            self.workTypeData = temp
            
            
        }) { (error) in
            print(error)
        }
    }
    
    
    // MARK: - 点击完成时候实现的逻辑处理方法
    
    @IBAction func doenBtnClick() {
        
        var paramert = [String: Any]()
        
        let projectTagsViewIndex = projectTagsView.selectedTagIndexes.first?.intValue
        let workTypeTagsViewIndex = workTypeTagsView.selectedTagIndexes.first?.intValue
        let reportTypeTagsViewIndex = reportTypeTagsView.selectedTagIndexes.first?.intValue
        let deviceTagsViewIndex = deviceTagsView.selectedTagIndexes.first?.intValue
        let workStatusTagsViewIndex = workStatusTagView.selectedTagIndexes.first?.intValue
        let sourceTagsViewIndex = sourceTagsView.selectedTagIndexes.first?.intValue
        
        if let index = projectTagsViewIndex{
            paramert["PARK_ID"] = projectData[index].projectId
        }
        if let index = workTypeTagsViewIndex{
            paramert["WORKTYPE_ID"] = workTypeData[index].id
        }
        
        /*
         要求实现的是 将工单类型的筛选条件也拿出来到最外层
         
        */
        if let index = reportTypeTagsViewIndex{
            paramert["WORKUNIT_TYPE"] = index + 1
        }
        
        
        if let index = deviceTagsViewIndex{
            paramert["is_equip"] = index + 1
        }
        
        
        /*
         要求的实现的 逻辑是 将 workStatusTagsView 拿出来到外面来进行筛选
         
         还有的是,应急工单和  计划工单也是拿出来进行筛选了
         if let index = workStatusTagsViewIndex
         
         */
        if workStatusTagsViewIndex != nil{
//            let dic = ["待派发": 11,"待执行" : 22, "待评价": 31,"待接收": 21,"已处理": 7, "已接受": 5,"协助查看": 5]
//            paramert["operateType"] = dic[workStatus[index]]
        }
        
        if let index = sourceTagsViewIndex{
            paramert["sourse"] = index + 1
        }
        if startTime != ""{
            paramert["STAR"] = startTime
        }
        if endTime != ""{
            paramert["END"] = endTime
        }
        
        if let text = workNumberLabel.text,text != ""{
            paramert["ID"] = text
        }
        if let text = workOrderNameLabel.text,text != ""{
            paramert["NAME"] = text
        }
        if let text = workOrderSourcePersonLabel.text,text != ""{
            paramert["SOURCE_PERSON_NAME"] = text
        }
        
        if let block = doenBtnClickHandel{
            //通过的是block的回调来进行的传值,如果是需要保存的话,要求保存paramert 的参数
            block(paramert)
        }
        doenBtnClickHandel = nil
        
    }
    

    private func setTagsView(tagsView: RKTagsView,tags: [String]? = nil){
        tagsView.editable = false
        tagsView.selectable = true
        tagsView.lineSpacing = 15
        tagsView.interitemSpacing = 15
        tagsView.allowsMultipleSelection = false
//        projectTagsView.delegate = self
        
        if tags != nil{
            for tag in tags!{
                tagsView.addTag(tag)
            }
        }
        
    }

}

extension WorkOrderSiftViewController: RKTagsViewDelegate{


}
