//
//  YQJournalCellView.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/10/11.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit
import Kingfisher


class YQJournalCellView: UITableViewCell{

    
    @IBOutlet weak var imageV: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!

    @IBOutlet weak var postLabel: UILabel!
    
    @IBOutlet weak var tempTimeLabel: UILabel!

    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var bottomimageV: UIImageView!
    //模型属性
    var model : YQWorkLogListModel?{
        didSet{
            
            if model?.personName == "" {
                
                return
            }
            
            nameLabel.text = model?.personName ?? ""
            timeLabel.text = model?.createTime ?? ""
            workID = (model?.worklogId)!
            postLabel.text = model?.post ?? ""
            
            //注意的是:这里的符号的正负代表的
            let index =  model?.createTime?.index( (model?.createTime?.startIndex)!, offsetBy: 10)
            
            tempTimeLabel.text = (model?.createTime?.substring(to: index!))! + "工作日志"
            
            if model?.avatar != nil {
                
                imageV.kf.setImage(with:URL(string : (model?.avatar)!) , placeholder: UIImage(named: "userIcon"), options: nil, progressBlock: nil, completionHandler: nil)
                
            }else{
                
                imageV.kf.setImage(with: nil, placeholder: UIImage(named: "userIcon"))
            }
            
            
            //取出字段的数组的里面的title的内容的情况
            if (model?.todoList?.count)! < 1 {
                
                self.detailAarry = self.model?.todoList
                
                self.detailLabel.text = ""
                
                return
            }
            
            for temp in 0 ..< (model?.todoList?.count)! {
                
                let dic = model?.todoList?[temp]
                
                if let titleDic : [String : Any] = dic as? [String : Any] {
                
                    let title = titleDic["title"] as! String
                    
                    if temp == 0 {
                        
                        self.detailLabel.text = "1." + title
                    }else{
                    
                        self.detailLabel.text = self.detailLabel.text! + "\n" + "\(temp + 1)." + title
                    }
                }
            }
            
            detailAarry = model?.todoList
            
            setNeedsLayout()
            setNeedsDisplay()
            
        }
    }
    
    //workID
    var workID : Int64 = -1
    
    //设置详情数组
    var detailAarry : NSArray?
    
    
    override func awakeFromNib() {
        
        self.detailLabel.lineBreakMode = NSLineBreakMode.byWordWrapping

    }
    
    // MARK: - 返回非等高cell的height方法
    func cellForHeight() -> CGFloat {
        // detailLabel.frame.maxY + detailLabel.frame.width + 10
        
//        print(detailLabel.frame.maxY + 15)
        
        return detailLabel.frame.maxY + 25
    }

    
    
}
