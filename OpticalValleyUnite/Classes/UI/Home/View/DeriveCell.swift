//
//  DeriveCell.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/7/6.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit

class DeriveCell: UITableViewCell {
    @IBOutlet weak var deriveCodeLabel: UILabel!
    @IBOutlet weak var deriveNameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var deriveModel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var selectBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var select:Bool = false{
        didSet{
            selectBtn.isSelected = select
        }
    }
    
    var model: Equipment?{
        didSet{
            if let model = model{
                deriveCodeLabel.text = model.equip_code
                deriveNameLabel.text = model.name
                typeLabel.text = model.type_name
                deriveModel.text = model.model_name
                addressLabel.text = model.address
            }
        }
    }



}
