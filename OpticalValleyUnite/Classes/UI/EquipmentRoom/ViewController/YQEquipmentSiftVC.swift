//
//  YQEquipmentSiftVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/3/15.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQEquipmentSiftVC: UIViewController {

    //项目查询
    @IBOutlet weak var projectTagsView: RKTagsView!
    
    //工单来源
    @IBOutlet weak var sourceTagsView: RKTagsView!
    
    //工单名称
    @IBOutlet weak var workOrderNameLabel: UITextField!
    
    //工单生成人
    @IBOutlet weak var workOrderSourcePersonLabel: UITextField!
    
    //工单编号
    @IBOutlet weak var workNumberLabel: UITextField!
    
    //开始时间
    @IBOutlet weak var startBtn: UIButton!
    //结束时间
    @IBOutlet weak var endBtn: UIButton!
    
    var startTime: String?
    var endTime: String?
    var status = ""
    
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
 
    var doenBtnClickHandel: (([String: Any]) -> ())?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getProjectData()
        
        setTagsView(tagsView: projectTagsView)
        
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
        if let text = self.siftParmat?["SOURCE_PERSON_NAME"] as? String,text != ""{// SOURCE_PERSON_NAME
            
            workOrderSourcePersonLabel.text = text
        }


    }
    
    // MARK: - 完成按钮点击
    @IBAction func doenBtnClick(_ sender: UIButton) {
        
        var paramert = [String: Any]()
        
        let projectTagsViewIndex = projectTagsView.selectedTagIndexes.first?.intValue
       
        
        let sourceTagsViewIndex = sourceTagsView.selectedTagIndexes.first?.intValue
        
        if let index = projectTagsViewIndex{
            
            paramert["PARK_ID"] = projectData[index].projectId
            
            var dic = [String : Any]()
            dic["ID"] = projectData[index].projectId
            dic["PARK_NAME"] = projectData[index].projectName
            
            UserDefaults.standard.set(dic, forKey: Const.YQProjectModel)
            
        }else {//重置全局的项目选择
            
            UserDefaults.standard.removeObject(forKey: Const.YQProjectModel)
            
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
    
    
    // MARK: - 重置按钮点击
    @IBAction func resetBtnClick(_ sender: UIButton) {
        
        //关联项目的重置
        projectTagsView.deselectAll()
        UserDefaults.standard.removeObject(forKey: Const.YQProjectModel)
        
      
        sourceTagsView.deselectAll()
        
        workOrderNameLabel.text = ""
        workOrderSourcePersonLabel.text = ""
        workNumberLabel.text = ""
        
        startTime = ""
        endTime = ""
        endBtn.setTitle("截止时间", for: .normal)
        startBtn.setTitle("开始时间", for: .normal)
        
        
        if let block = doenBtnClickHandel{
            //通过的是block的回调来进行的传值,如果是需要保存的话,要求保存paramert 的参数
            block([String : Any]())
        }

        
    }
    
    /// 开始时间btn
    @IBAction func beginBtnClick(_ sender: UIButton) {
        
        SJPickerView.show(withDateType: .date, defaultingDate: Date(), userController:self,selctedDateFormot: "yyyy-MM-dd") { (date, dateStr) in
            sender.setTitle(dateStr, for: .normal)
            self.startTime = dateStr
        }

        
    }
    
    /// 截止时间btn
    @IBAction func endBtnClick(_ sender: UIButton) {
        
        SJPickerView.show(withDateType: .date, defaultingDate: Date(), userController:self,selctedDateFormot: "yyyy-MM-dd") { (date, dateStr) in
            sender.setTitle(dateStr, for: .normal)
            self.endTime = dateStr
        }

        
    }
    
    
    // MARK: - 获取项目的网络接口
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



}
