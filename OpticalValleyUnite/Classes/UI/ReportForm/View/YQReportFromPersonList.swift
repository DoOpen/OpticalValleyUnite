//
//  YQReportFromPersonList.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/1/22.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

protocol YQReportFromPersonListDelegate : class {
    
    func reportFromPersonListDelegate(view : UIView, par : [String : Any])
    
}
class YQReportFromPersonList: UIView {
    
    var dataDict = [String : Any](){
        didSet{
            
            var temp = Array<[String : Any]>()
            
            let array = dataDict["persons"] as? Array<[String : Any]>
            let projectName = dataDict["text"] as? String
            self.parkID = dataDict["parkId"] as? String ?? ""
            
            self.projectLabel.text = projectName
            
            if let tempArray = dataDict["nodes"] as? Array<[String : Any]>{
                
                for dic in tempArray {
                    
                    let arr = dic["persons"] as? Array<[String : Any]>
                    
                    for tempDic in arr! {
                        
                        temp.append(tempDic)
                    }
                    
                }
                
            }
            
            for dic in array!{
                
                temp.append(dic)
            }
            
            self.persons = temp
        
        }
        
    }
    
    var parkID = ""
    
    var persons : Array<[String : Any]>? {
        
        didSet{
            
            for temp in persons!{
                
                let name = temp["personName"] as? String
                let post = temp["postName"] as? String
                
                let title = name! + " " + post!
                
                self.tagsView.addTag(title)
            }
            
        }
    
    }
    
    var delegate : YQReportFromPersonListDelegate?
    
    @IBOutlet weak var projectLabel: UILabel!
    
    @IBOutlet weak var tagsView: RKTagsView!
    
    override func awakeFromNib() {
        
        //设置tagsView的属性列表
        tagsView.editable = false
        tagsView.selectable = true
        tagsView.lineSpacing = 20
        tagsView.interitemSpacing = 20
        tagsView.allowsMultipleSelection = false
        tagsView.delegate = self
        

    }
   
}

extension YQReportFromPersonList : RKTagsViewDelegate {
    
    func tagsView(_ tagsView: RKTagsView, shouldSelectTagAt index: Int) -> Bool {
        
        //点击对应的index 的selectTag的选项
        var dict =  self.persons?[index]
        dict?["parkId"] = self.parkID
        
        self.delegate?.reportFromPersonListDelegate(view: self, par: dict!)
        
        tagsView.deselectAll()
        
        return true
        
    }


}
