//
//  WorkOrderTypeChooseViewController.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/1/13.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit

class WorkOrderTypeChooseViewController: UIViewController {
    
    @IBOutlet weak var projectTagsView: RKTagsView!
    @IBOutlet weak var deviceTagsView: RKTagsView!
    
    var didSelectedHandel: ((WorkTypeModel) -> () )?
    
    var models = [WorkTypeModel](){
        
        didSet{
            for model in models{
                projectTagsView.addTag(model.name)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let _ = ["弱电", "土建维修","给排水", "强电","消防", "工程"]
        projectTagsView.editable = false
        projectTagsView.selectable = true
        projectTagsView.lineSpacing = 20
        projectTagsView.interitemSpacing = 20
        projectTagsView.allowsMultipleSelection = false
        //projectTagsView.scrollsHorizontally = true
        
        getWorkTypeList()
        
//        for projects in projects {
//            projectTagsView.addTag(projects)
//        }
        
//        let status = ["电梯", "供冷供热","供冷供热", "已评价"]
//        deviceTagsView.editable = false
//        deviceTagsView.selectable = true
//        deviceTagsView.lineSpacing = 20
//        deviceTagsView.interitemSpacing = 20
//        deviceTagsView.allowsMultipleSelection = false
//        for statu in status {
//            deviceTagsView.addTag(statu)
//        }
        
    }
    
    func getWorkTypeList(){
        
        HttpClient.instance.get(path: URLPath.getWorkTypeList, parameters: nil, success: { (response) in
            
            //添加二级的工单的筛选的界面展示的问题点:
            //筛选,子集的选项列表!
            
            var temp = [WorkTypeModel]()
            
            for dic in response as! Array<[String: Any]>{
                
                let model = WorkTypeModel(parmart: dic)
                temp.append(model)
            }
            self.models = temp
            
            
        }) { (error) in
            print(error)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func rightBtnClick(_ sender: UIBarButtonItem) {
        
        if projectTagsView.selectedTagIndexes.count > 0{
            let index = projectTagsView.selectedTagIndexes.first?.intValue
            if let block = didSelectedHandel{
                block(models[index!])
            }
            
        }
        
        _ = navigationController?.popViewController(animated: true)
    }


}
