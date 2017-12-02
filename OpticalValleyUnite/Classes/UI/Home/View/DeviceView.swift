//
//  DeviceView.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/7/10.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit

class DeviceView: UIView {

    var deriveCodeLabel: UILabel!{
        get{
            return getLabel(tag:1)
        }
    }
    var deriveNameLabel: UILabel!{
        get{
            return getLabel(tag:2)
        }
    }
    var typeLabel: UILabel!{
        get{
            return getLabel(tag:3)
        }
    }
    var deriveModel: UILabel!{
        get{
            return getLabel(tag:4)
        }
    }
    var addressLabel: UILabel!{
        get{
            return getLabel(tag:5)
        }
    }
    
    private func getLabel(tag: Int) -> UILabel{
        
        let label = self.viewWithTag(tag) as! UILabel
        return label
    }
    
    var model: Equipment?{
        
        didSet{
            
            if let model = model{
                
                deriveCodeLabel.text = model.equip_code
                deriveNameLabel.text = model.name
                typeLabel.text = model.type_name
                deriveModel.text = model.model_name
                addressLabel.text = model.address
                
                setNeedsLayout()
                setNeedsDisplay()
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        deriveCodeLabel.text = ""
        deriveNameLabel.text = ""
        typeLabel.text = ""
        deriveModel.text = ""
        addressLabel.text = ""
    }

}
