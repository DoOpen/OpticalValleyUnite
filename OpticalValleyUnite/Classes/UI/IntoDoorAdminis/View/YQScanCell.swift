//
//  YQScanCell.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/12/19.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit

protocol YQScanCellDelegate : class  {
    
    func scanCellBGButtonClick( indexpath : IndexPath )
    
}


class YQScanCell: UITableViewCell {

    @IBOutlet weak var textView: UITextView!
  
    @IBOutlet weak var BGScanButton: UIButton!
    
    weak var delegate : YQScanCellDelegate?
    
    var indexPath : IndexPath?
    
    
    var model : YQBluetooth?{
        didSet{
            
            self.textView.text = model?.name
            
        }

    }
    
    @IBAction func bgScanButtonClick(_ sender: UIButton) {
        
        self.delegate?.scanCellBGButtonClick(indexpath: self.indexPath!)
        
    }
    
    
}
