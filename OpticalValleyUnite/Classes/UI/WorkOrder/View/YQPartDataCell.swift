//
//  YQPartDataCell.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/8/31.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit


protocol YQPartDataCellSwitchDelegate : class{

    func partDataCellSwitchDelegate(num : String,numIndex: Int, model : PartsModel)
    
    func partDataCellSwitchDelegateMoveModel( numIndex : Int,model : PartsModel)
    
}

class YQPartDataCell: UITableViewCell {
    
    // MARK: - 加载的属性
    @IBOutlet weak var `switch`: UIButton!
    
    @IBOutlet weak var part: UILabel!
 
    @IBOutlet weak var partName: UILabel!

    @IBOutlet weak var numText: UITextField!
    
    // 缓存行号
    var indexPath : Int = 0
    
    // 模型的设置是有问题,设置的
    var modelcell : PartsModel?
    {
        didSet{

            self.part.text = modelcell?.position
            self.partName.text = modelcell?.partsName
            self.numText.text = modelcell?.partNum
            
        }
    }
    
    /// 定义代理
    weak var delegate : YQPartDataCellSwitchDelegate?
    
    //MARK: - 点击加载方法
    @IBAction func switchClick(_ sender: Any) {
        
        self.switch.isSelected = !self.switch.isSelected
        
        if self.switch.isSelected {
            
            self.numText.isUserInteractionEnabled = true
//            modelcell?.partNum = self.numText.text
            //调用代理,传递值的 数量的情况
//            self.delegate?.partDataCellSwitchDelegate(num: self.numText.text!,numIndex: self.indexPath, model : self.modelcell!)
            
        }else{
            
            self.numText.isUserInteractionEnabled = false
//            self.delegate?.partDataCellSwitchDelegateMoveModel(numIndex: self.indexPath, model: self.modelcell!)
            
        }
        
    }
    
    override func awakeFromNib() {
        
        self.numText.delegate = self
        
    }

    

}

extension YQPartDataCell : UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        //合成模型:
        var dict = [String : Any]()
        dict["position"] = self.part.text
        dict["partsName"] = self.partName.text
        dict["partNum"] = self.numText.text
        dict["partsId"] = modelcell?.partsId
        
        let newModel = PartsModel(dict: dict as [String : AnyObject])
//        newModel!.partNum = self.part.text
//        newModel!.partsName = self.partName.text
        
        self.delegate?.partDataCellSwitchDelegate(num: "", numIndex: self.indexPath, model: newModel)
        
    }
   
}
