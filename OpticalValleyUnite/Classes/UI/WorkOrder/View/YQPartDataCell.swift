//
//  YQPartDataCell.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/8/31.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit


protocol YQPartDataCellSwitchDelegate : class{

    func partDataCellSwitchDelegate(num : String, model : PartsModel)
}

class YQPartDataCell: UITableViewCell {
    
    // MARK: - 加载的属性
    @IBOutlet weak var `switch`: UISwitch!
    
    @IBOutlet weak var part: UILabel!
 
    @IBOutlet weak var partName: UILabel!

    @IBOutlet weak var numText: UITextField!
    
    //   模型的设置是有问题,设置的
    var modelcell : PartsModel?
    {
        didSet{

            self.part.text = modelcell?.position
            self.partName.text = modelcell?.partsName
            
        }
    
    }
    
    /// 定义代理
    weak var delegate : YQPartDataCellSwitchDelegate?
    
    //MARK: - 点击加载方法
    @IBAction func switchClick(_ sender: Any) {
        
        if self.switch.isOn {
            
            self.numText.isUserInteractionEnabled = true
            
            //调用代理,传递值的 数量的情况
            self.delegate?.partDataCellSwitchDelegate(num: self.numText.text!, model : self.modelcell!)
            
            
        }else{
            
            self.numText.isUserInteractionEnabled = false
            
        }
        
    }
    

}
