//
//  YQAllWorkUnitScreenVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/3/7.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQAllWorkUnitScreenVC: UIViewController {

    //项目选择框架
    @IBOutlet weak var projectTagsView: RKTagsView!
    
    //工单分类
    @IBOutlet weak var workTypeTagsView: RKTagsView!
    
    //工单类型
    @IBOutlet weak var reportTypeTagsView: RKTagsView!
    
    //是否是设备工单
    @IBOutlet weak var deviceTagsView: RKTagsView!
    
    //新增的 --> 是否是 自发
    @IBOutlet weak var spontaneousTagsView: RKTagsView!
    
    //工单状态的(待执行,待评价... 工单的状态执行)
    @IBOutlet weak var workStatusTagView: RKTagsView!
    
    //工单来源(执行内容)
    @IBOutlet weak var sourceTagsView: RKTagsView!
    
    
    ///输入的筛选的条件
    //工单名称
    @IBOutlet weak var workOrderNameLabel: UITextField!
    
    //工单生成人
    @IBOutlet weak var workOrderSourcePersonLabel: UITextField!
    
    //工单编号
    @IBOutlet weak var workNumberLabel: UITextField!
    
    //新增的工单执行人
    //工单执行人
    @IBOutlet weak var workOrderImplementPersonTextField: UITextField!
    
    
    ///开始和 结束的 按钮的
    @IBOutlet weak var startBtn: UIButton!
    
    @IBOutlet weak var endBtn: UIButton!
    
    //项目的收起,执行的约束
    @IBOutlet weak var projectHeightConstraint: NSLayoutConstraint!
    
    
    // "待派发","待接收","协助查看","待执行","待评价","已关闭"
    let workStatus = ["待派发","待接收","已退回","待执行","待评价","已关闭"] //暂时设置为nil,字面量的赋值取消
    
    var startTime: String?
    var endTime: String?
    var status = ""
    
    var isAll = 2
    
    
    /// 父级的筛选条件的
    var siftParmat: [String: Any]?
    
    /// 项目选择的
    var projectData = [ProjectModel](){
        didSet{
            
            let projectname = getUserDefaultsProject()

            var indexNum = -1
            
            for index in 0 ..< projectData.count{
                
                let tag = projectData[index]
                
                if projectname == tag.projectName{
                    
                    tag.selected = true
                    indexNum = index
                }
                
                self.projectTagsView.addTag(tag.projectName)
            }
            
            if indexNum == -1 {
                
                return
                
            }else{
                
                self.projectTagsView.selectTag(at: indexNum)
            }
        }
    }

    var workTypeData = [WorkTypeModel](){
        
        didSet{
            
            let WORKTYPE_ID = self.siftParmat?["WORKTYPE_ID"] as? String
            
            //通过参数来进行相应判断
            if WORKTYPE_ID != ""{
                
                //获取的网络数据来进行的渲染的
                for(index ,tag) in workTypeData.enumerated() {
                    
                    self.workTypeTagsView.addTag(tag.name)
                    
                    if WORKTYPE_ID == tag.id {
                        
                        self.workTypeTagsView.selectTag(at: index)

                    }
                }
                
                
            }else{
                
                //获取的网络数据来进行的渲染的
                for tag in workTypeData{
                    
                    self.workTypeTagsView.addTag(tag.name)
                    
                }
            }
        }
    }
    
    
    var doneBtnClickHandel: (([String: Any]) -> ())?


    override func viewDidLoad() {
        super.viewDidLoad()

        getProjectData()
        
        getWorkTypeData()
        
        setTagsView(tagsView: projectTagsView)
        
        setTagsView(tagsView: workTypeTagsView)
        
        // reportType 的设置
        setTagsView(tagsView: reportTypeTagsView,tags: ["计划工单","应急工单"])
        
        let reportTypeIndex = self.siftParmat?["WORKUNIT_TYPE"] as? Int ?? -1
        if reportTypeIndex != -1 {
        
            self.reportTypeTagsView.selectTag(at: reportTypeIndex - 1)
        }
        
        
        setTagsView(tagsView: deviceTagsView,tags: ["是","否"])
        
        let is_equip = self.siftParmat?["is_equip"] as? Int ?? -1
        
        if is_equip == 1 { //是 设备
            
            deviceTagsView.selectTag(at: 0)
            
        }else if is_equip == 2 { //否 设备
            
            deviceTagsView.selectTag(at: 1)
        }
        
        // spontaneousTagsView 的设置 自发和非自发的情况
        setTagsView(tagsView: spontaneousTagsView, tags: ["自发工单","非自发工单"])
        
        let spontaneous = self.siftParmat?["self"] as? Int ?? -1
        switch spontaneous {
            case 1:
                self.spontaneousTagsView.selectTag(at: spontaneous - 1)
                break
            case 2:
                self.spontaneousTagsView.selectTag(at: spontaneous - 1)
                break
            default:
                break
        }
        
        // workStatus 的设置(工单的设置的状态的添加)
        setTagsView(tagsView: workStatusTagView,tags: workStatus )
        
        let workS = self.siftParmat?["UNIT_STATUS"] as? Int ?? -1
        
        //查询的工单的显示和 执行的工单不一样的情况
        //let dic = ["待派发": 0,"待执行" : 5, "待评价": 7,"待接收": 1,"已关闭": 8,"已退回" : 4]
        //["待派发","待接收","已退回","待执行","待评价","已关闭"]
        switch workS {
        case 0://待派发
            self.workStatusTagView.selectTag(at: 0)
            break
        case 5://待执行
            self.workStatusTagView.selectTag(at: 3)
            break
        case 7://待评价
            self.workStatusTagView.selectTag(at: 4)
            break
        case 1://待接受
            self.workStatusTagView.selectTag(at: 1)
            break
        case 8://已关闭
            self.workStatusTagView.selectTag(at: 5)
            break
        case 4://已退回
            self.workStatusTagView.selectTag(at: 2)
            break
        default:
            break
        }
        
        
        setTagsView(tagsView: sourceTagsView,tags: ["系统后台","员工app","业主app"])
        
        let sourse = self.siftParmat?["sourse"] as? Int ?? -1
        switch sourse {
        case 1:
            sourceTagsView.selectTag(at: 0)
            break
        case 2:
            sourceTagsView.selectTag(at: 1)
            break
        case 3:
            sourceTagsView.selectTag(at: 2)
            break
            
        default:
            break
        }
        
        //        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
        //            let arry = ["丽岛2046","光谷软件园","创意天地"]
        //
        //        }
        
        //补充选项,开始时间和结束时间
        if let STARTime =  self.siftParmat?["STAR"] as? String {
            
            self.startTime = STARTime
            startBtn.setTitle(STARTime, for: .normal)
        }
        
        if let ENDTime =  self.siftParmat?["END"] as? String {
            
            self.endTime = ENDTime
            endBtn.setTitle(ENDTime, for: .normal)
        }
        
        //工单的查询和筛选的条件
        if let text = self.siftParmat?["ID"] as? String,text != ""{
            workNumberLabel.text = text
        }
        if let text = self.siftParmat?["NAME"] as? String,text != ""{
            
            workOrderNameLabel.text = text
        }
        if let text = self.siftParmat?["SOURCE_PERSON_NAME"] as? String,text != ""{
            
            workOrderSourcePersonLabel.text = text
        }
        
        if let text = self.siftParmat?["EXEC_PERSON_NAME"] as? String,text != ""{
            
            workOrderImplementPersonTextField.text = text
        }
        
    }
    
    // MARK: - 点击的收起,展开的效果
    @IBAction func springProjectButtonClick(_ sender: UIButton) {
        

        if sender.isSelected {
            
            //调节死约束
            sender.setTitle("收起", for: .normal)
            self.projectHeightConstraint.constant = 100
            
            view.setNeedsLayout()
            
        }else{
            
            //设置活约束
            sender.setTitle("展开", for: .normal)
            self.projectHeightConstraint.constant = self.projectTagsView.contentSize.height
            
            view.setNeedsLayout()

        }
        
        sender.isSelected = !sender.isSelected
        
    }
    
    
    // MARK: - 开始,结束按钮的点击执行事件
    @IBAction func beginBtnClick(_ sender: UIButton) {
        
        SJPickerView.show(withDateType: .date, defaultingDate: Date(), userController:self,selctedDateFormot: "yyyy-MM-dd") { (date, dateStr) in
            sender.setTitle(dateStr, for: .normal)
            self.startTime = dateStr
        }
 
    }
    
    @IBAction func endBtnClick(_ sender: UIButton) {
        
        SJPickerView.show(withDateType: .date, defaultingDate: Date(), userController:self,selctedDateFormot: "yyyy-MM-dd") { (date, dateStr) in
            sender.setTitle(dateStr, for: .normal)
            self.endTime = dateStr
        }

    }
    
    
    // MARK: - 重置,确定按钮的点击执行事件
    @IBAction func resetBtnClick(_ sender: UIButton) {
        
        //项目重置,移除归档
        projectTagsView.deselectAll()
        UserDefaults.standard.removeObject(forKey: Const.YQProjectModel)
        
        workTypeTagsView.deselectAll()
        reportTypeTagsView.deselectAll()
        deviceTagsView.deselectAll()
        workStatusTagView.deselectAll()
        sourceTagsView.deselectAll()
        spontaneousTagsView.deselectAll()
        
        
        workOrderNameLabel.text = ""
        workOrderSourcePersonLabel.text = ""
        workNumberLabel.text = ""
        workOrderImplementPersonTextField.text = ""

        startTime = ""
        endTime = ""
        endBtn.setTitle("截止时间", for: .normal)
        startBtn.setTitle("开始时间", for: .normal)
        
        //重置没有清空缓存,可以考虑的是重置之后,就清除缓存
        //        UserDefaults.standard.removeObject(forKey: Const.YQProjectModel)
        
        if let block = doneBtnClickHandel{
            //通过的是block的回调来进行的传值,如果是需要保存的话,要求保存paramert 的参数
            block([String : Any]())
        }

        
    }
    
    @IBAction func doenBtnClick(_ sender: UIButton) {
        
        var paramert = [String: Any]()
        
        let projectTagsViewIndex = projectTagsView.selectedTagIndexes.first?.intValue ?? -1
        let workTypeTagsViewIndex = workTypeTagsView.selectedTagIndexes.first?.intValue
        
        let reportTypeTagsViewIndex = reportTypeTagsView.selectedTagIndexes.first?.intValue
        
        let deviceTagsViewIndex = deviceTagsView.selectedTagIndexes.first?.intValue
        
        let workStatusTagsViewIndex = workStatusTagView.selectedTagIndexes.first?.intValue
        
        let sourceTagsViewIndex = sourceTagsView.selectedTagIndexes.first?.intValue
        
        let spontaneousTagsViewIndex = spontaneousTagsView.selectedTagIndexes.first?.intValue
        
        if  projectTagsViewIndex != -1{
            
            paramert["PARK_ID"] = projectData[projectTagsViewIndex].projectId
            
            var dic = [String : Any]()
            dic["ID"] = projectData[projectTagsViewIndex].projectId
            dic["PARK_NAME"] = projectData[projectTagsViewIndex].projectName
            
            UserDefaults.standard.set(dic, forKey: Const.YQProjectModel)
            
        }else{//重置全局的项目选择
            
            var parkString = ""
            
            for projectModel in projectData{
                if parkString == "" {
                    
                    parkString = projectModel.projectId
                    
                }else{
                    
                    parkString = parkString + "," + projectModel.projectId
                }
                
            }
            paramert["PARK_ID"]  = parkString
            UserDefaults.standard.removeObject(forKey: Const.YQProjectModel)
            
        }
        
        if let index = workTypeTagsViewIndex{
            
            paramert["WORKTYPE_ID"] = workTypeData[index].id
        }
        
        /*
         要求实现的是 将工单类型的筛选条件也拿出来到最外层,这里是不显示,不传值的
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
        */
        if let index = workStatusTagsViewIndex{

           let dic = ["待派发": 0,"待执行" : 5, "待评价": 7,"待接收": 1,"已关闭": 8,"已退回" : 4]
            
            paramert["UNIT_STATUS"] = dic[workStatus[index]]
            
        }
        
        //自发和非自发工单的情况
        if let index =  spontaneousTagsViewIndex {
        
            paramert["self"] = index + 1
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
        if let text = workOrderImplementPersonTextField.text,text != ""{
            paramert["EXEC_PERSON_NAME"] = text
        }
        
        if let block = doneBtnClickHandel{
            //通过的是block的回调来进行的传值,如果是需要保存的话,要求保存paramert 的参数
            block(paramert)
        }
        
        doneBtnClickHandel = nil

    }
    
    // MARK: - 获取默认的项目的值来显示
    func getUserDefaultsProject() -> String {
        
        let dic = UserDefaults.standard.object(forKey: Const.YQProjectModel) as? [String : Any]
        
        var projectName  = ""
        
        if dic != nil {
            projectName = dic?["PARK_NAME"] as! String
        }
        
        return projectName
        
    }

    private func setTagsView(tagsView: RKTagsView,tags: [String]? = nil){
        
        tagsView.editable = false
        tagsView.selectable = true
        tagsView.lineSpacing = 15
        tagsView.interitemSpacing = 15
        tagsView.allowsMultipleSelection = false
        
        if tags != nil{
            
            for tag in tags!{
                tagsView.addTag(tag)
            }
        }
    }

    // MARK: - 获取项目的网络接口
    private func getProjectData(){
        
        var par = [String : Any]()
        
        //获取集团和 项目版的参数
        let isgroup = UserDefaults.standard.object(forKey: Const.YQIs_Group) as? Int ?? -1
        
        //根据需求来进行的查询区分, 集团版和 项目版的
        if self.isAll == 1 {
            
            if isgroup == 2 {//集团版
                
                par["isAll"] = 1 // 1是查全部的项目; 2是关联自己的项目
                
            }else{//项目版
                
                par["isAll"] = 2
            }
            
        }

        HttpClient.instance.get(path: URLPath.getParkList, parameters: par, success: { (response) in

            var temp = [ProjectModel]()
            
            for dic in response as! Array<[String: Any]> {
                temp.append(ProjectModel(parmart: dic))
            }
            
            self.projectData = temp
            
        }) { (error) in
            
        }
    }

    
    // MARK: - 获取工单类型的网络接口方法
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
    

}
