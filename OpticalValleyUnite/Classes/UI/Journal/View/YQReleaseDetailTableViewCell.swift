//
//  YQReleaseDetailTableViewCell.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/11/24.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit

class YQReleaseDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var detailLabel: UILabel!

    
    // MARK: - 返回非等高cell的height方法
    func cellForHeight() -> CGFloat {
        // detailLabel.frame.maxY + detailLabel.frame.width + 10
        
        return detailLabel.frame.maxY + 25
    }

}
