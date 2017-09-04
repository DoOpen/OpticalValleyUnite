//
//  YQPartDataSelectCell.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/9/4.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit

protocol YQPartDataSelectFooterCellButtonDelegate : class{
    
    func partDataFooterCompleteDelegate()
    
}

class YQPartDataSelectCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    /// 定义代理
    weak var delegate : YQPartDataSelectFooterCellButtonDelegate?
    
    // MARK: - 完成按钮的点击事件
    @IBAction func complete(_ sender: Any) {
        
        self.delegate?.partDataFooterCompleteDelegate()
        
    }

}
