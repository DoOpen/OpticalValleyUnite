//
//  YQEquipmentListCell.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/2/20.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQEquipmentListCell: UITableViewCell {

    @IBOutlet weak var equipmentName: UILabel!
    
    @IBOutlet weak var equipmentNum: UILabel!
    
    @IBOutlet weak var equipmentCategory: UILabel!
    
    @IBOutlet weak var equpmentState: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var model : YQEquipmentListModel?{
        
        didSet{
            
            self.equipmentName.text = model?.name
            
            self.equipmentNum.text = model?.equipName
            
            
            self.equipmentCategory.text = model?.typeName
            
            self.equpmentState.text = model?.equipStatus
            
            
        }

    }
    
    
}
