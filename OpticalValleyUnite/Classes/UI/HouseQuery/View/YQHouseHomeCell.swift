//
//  YQHouseHomeCell.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/2/10.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQHouseHomeCell: UITableViewCell {

    @IBOutlet weak var houseNameLabel: UILabel!
    
    @IBOutlet weak var houseNum: UILabel!
    
    @IBOutlet weak var ownerNameLabel: UILabel!
    
    @IBOutlet weak var ownerPhoneLabel: UILabel!
    
    @IBOutlet weak var owerAdressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var model : YQHouseQueryHomeModel?{
        didSet{
         
            houseNameLabel.text = model?.houseName
            houseNum.text = model?.houseCode
            
            if model?.name != "" {
                //通过判断来进行的缓存行高的选项
                
                ownerNameLabel.text = model?.name
                ownerPhoneLabel.text = model?.phone
                owerAdressLabel.text = model?.address
            }
            
        }
    }

}
