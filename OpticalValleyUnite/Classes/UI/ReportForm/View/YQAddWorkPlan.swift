//
//  YQAddWorkPlan.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/1/18.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

protocol YQAddWorkPlanEditDelegate : class {
    
    func addWorkPlanEditDelegate(string : String, type : String,indexRow : Int)
}


class YQAddWorkPlan: UITableViewCell,UITextViewDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var backlogText: UITextField!
    
    @IBOutlet weak var backLogDetailText: SJTextView!
    
    override func awakeFromNib() {
        
        self.backLogDetailText.placeHolder = "待办事项内容"
        self.backlogText.delegate = self
        self.backLogDetailText.delegate = self
        
    }
    var indexPathRow : Int?
    var delegate : YQAddWorkPlanEditDelegate?
    
    var model : YQAddWorkPlanModel?{
        
        didSet{
            
            let dfmatter = DateFormatter()
            dfmatter.dateFormat="yyyy-MM-dd"
            self.backlogText.text = ""
            self.backLogDetailText.text = ""
            
            self.timeLabel.text = dfmatter.string(from: Date())
            
            if model?.backlog != ""{
                
                self.backlogText.text = model?.backlog
            }
            
            if model?.backLogDetail != "" {
                
                self.backLogDetailText.placeHolder = ""
                self.backLogDetailText.text = model?.backLogDetail
            }
        
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        self.delegate?.addWorkPlanEditDelegate(string: textField.text!, type: "field",indexRow : indexPathRow!)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
          self.delegate?.addWorkPlanEditDelegate(string: textView.text!, type: "View",indexRow : indexPathRow!)
    }
  
}
