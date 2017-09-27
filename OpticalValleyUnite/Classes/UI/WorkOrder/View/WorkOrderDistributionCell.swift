//
//  WorkOrderDistributionCell.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/1/13.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit
import Kingfisher

class WorkOrderDistributionCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!

    @IBOutlet weak var contentLabel: UILabel!
    
    //备注的消息label
    @IBOutlet weak var markLabel: UILabel!
    
    var imageViews = [UIImageView]()
    var labels = [UILabel]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var model: WorkHistoryModel?{
        didSet{
            if let model = model{
                
                if let model2 = model2{
                    
                    var text = ""
                    timeLabel.text = model.time
                    
                    markLabel.text = "备注" + model.DESCRIPTION
                    
                    guard model2.assesNamae != "" else {
                        text = "派发人:  \(model.person_name )    执行人:  \(model2.exexName )     协助人:        管理人: \(model2.managerNmae )"
                        contentLabel.text = text
                        contentLabel.setLineSpacing(10)
                        return
                    }
                    
                    text = "派发人:  \(model.person_name)    执行人:  \(model2.exexName)     协助人:   \(model2.assesNamae)    管理人:  \(model2.managerNmae )"
                    contentLabel.text = text
                    contentLabel.setLineSpacing(10)
                }
                
            }
        }
    }
    
    var model2: WorkOrderDetailModel?
    
}
