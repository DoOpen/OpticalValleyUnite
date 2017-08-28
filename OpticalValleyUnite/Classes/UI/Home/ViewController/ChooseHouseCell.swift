//
//  ChooseHouseCell.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/1/14.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit

class ChooseHouseCell: UITableViewCell {
    @IBOutlet weak var selectImageView: UIImageView!

    @IBOutlet weak var addressLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func setSelectCellClick(_ selected: Bool){
        selectImageView.isHidden = !selected
    }

}
