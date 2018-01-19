//
//  YQAddHighlights.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/1/18.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQAddHighlights: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var highLightsText: UITextField!
    
    @IBOutlet weak var hightLightContentTextView: SJTextView!
    
    @IBOutlet weak var pictureAddView: SJAddView!
    
    override func awakeFromNib() {
        
        self.hightLightContentTextView.placeHolder = "亮点内容"
        let dfmatter = DateFormatter()
        dfmatter.dateFormat="yyyy-MM-dd"

        self.timeLabel?.text = dfmatter.string(from: Date())
        
    }
  
}
