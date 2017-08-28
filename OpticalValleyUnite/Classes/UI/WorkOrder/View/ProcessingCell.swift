//
//  ProcessingCell.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/4/26.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit

class ProcessingCell: UITableViewCell {
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    

    var model: WorkHistoryModel?{
        didSet{
            if let model = model{
                
                TimeLabel.text = model.time
                nameLabel.text = model.person_name
                
  
                contentLabel.text = model.content
                
                
            }
            
        }
    }
    

    
}
