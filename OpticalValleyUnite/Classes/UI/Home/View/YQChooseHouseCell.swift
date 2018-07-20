//
//  YQChooseHouseCell.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/5/17.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQChooseHouseCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var selectImageView: UIImageView!
    
    
    func setSelectCellClick(_ selected: Bool){
        
        selectImageView.isHidden = !selected
    }
    
    var model : YQChooseHouseModel?{
        
        didSet{
            
            let string = (model?.unitNo)! + "单元"
            let string1 = (model?.groundNo)! + "楼层"
            let string2 = (model?.houseCode)! + "室"
            
            self.titleLabel.text = (model?.stageName)!  + "-" + (model?.buildName)! + "_" + string + string1 + string2
            
        }
        
    }

}
