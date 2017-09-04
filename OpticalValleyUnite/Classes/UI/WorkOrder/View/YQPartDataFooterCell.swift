//
//  YQPartDataFooterCell.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/9/1.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit

protocol YQPartDataAllFooterCellButtonDelegate : class{
    
    func partDataFooterMakeSureCheckDelegate()
    
    
}

class YQPartDataFooterCell: UITableViewCell {
    
    // MARK: - 确认勾选的按钮,及其事件
    @IBOutlet weak var makeSureCheck: UIButton!
    
    /// 定义代理
    weak var delegate : YQPartDataAllFooterCellButtonDelegate?
    
    
    
    @IBAction func makeSureCheck(_ sender: Any) {
        
        self.delegate?.partDataFooterMakeSureCheckDelegate()
    }
    
    
    

}
