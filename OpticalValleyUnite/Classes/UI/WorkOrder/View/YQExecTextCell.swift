//
//  YQExecTextCell.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/11/27.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit

protocol YQExecTextCellDelegate : class {

    func ExecTextCellEndTextEidtingDelegate(ExecTextCell : UITableViewCell,textString : String , indexPath : IndexPath)

}

class YQExecTextCell: UITableViewCell {
    // MARK: - cell 的属性列表
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var testView: SJTextView!
    
    weak var delegate : YQExecTextCellDelegate?
    
    var indexpath : IndexPath?
    
    //数据模型
    var model : ExecChild?{
        didSet{
            
            self.titleLabel.text = model?.name
            
            self.testView.text = model?.value
        }
        
    }
    
    override func awakeFromNib() {
        
        self.testView.delegate = self as UITextViewDelegate
        
    }
   
    
}

extension YQExecTextCell : UITextViewDelegate{
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        //传递文本数据,传递文本数据
        self.delegate?.ExecTextCellEndTextEidtingDelegate(ExecTextCell: self, textString: self.testView.text, indexPath: self.indexpath!)
        
    }
    
    
}
