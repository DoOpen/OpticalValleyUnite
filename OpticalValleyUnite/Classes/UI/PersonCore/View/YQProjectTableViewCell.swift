//
//  YQProjectTableViewCell.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/10/20.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit

class YQProjectTableViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var selectButton: UIButton!

    var id  = ""

    var model : ProjectModel?{
        
        didSet{
            
            self.name.text = model?.projectName
            id = (model?.projectId)!
            self.selectButton.isSelected = (model?.selected)!
            
        }
    }
    
    

}
