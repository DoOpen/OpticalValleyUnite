//
//  ExexSwithCell.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/3/31.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit

class ExexSwithCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var selectBtn: UIButton!
    
   

    var doneBtnClickHandle: ((Bool) -> ())?

    var model: ExecChild?{
        didSet{
            titleLabel.text = model?.name
            
            if model!.isDone {
                selectBtn.isEnabled = false
                selectBtn.setTitle(model?.value, for: .normal)
            }else{
                selectBtn.isEnabled = true
                if model?.value == "" {
                    selectBtn.setTitle("请选择", for: .normal)
                }else{
                    selectBtn.setTitle(model?.value, for: .normal)
                }
                

            }
            
         
            
        }
    }

//    @IBAction func doneBtnClick() {
//        if let block = doneBtnClickHandle ,!model!.isDone{
//           
////            block(isDoneSwitch.isOn)
//       
//            
//        }
//    }
    @IBAction func selectBtnClick(_ sender: UIButton) {
        let arry = model!.OPTIONS_LIST
        SJPickerView.show(withDataArry: arry, didSlected: { [weak self] index in
            self?.selectBtn.setTitle(arry[index], for: .normal)
            self?.model?.value = arry[index]
        })
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
}
