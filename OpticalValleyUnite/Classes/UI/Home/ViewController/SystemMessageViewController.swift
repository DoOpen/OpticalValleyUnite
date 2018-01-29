//
//  SystemMessageViewController.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/1/24.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit

class SystemMessageViewController: UIViewController {


    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var departmentLabel: UILabel!
    
    var model: SystemMessageModel?
    
    @IBOutlet weak var contantViewHeightConstraint: NSLayoutConstraint!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleView.text = model?.title
        timeLabel.text = model?.time
//        contentLabel.text = model?.content
        departmentLabel.text = model?.department
        
        let text = model!.content
        
        do{
            let str = try! NSMutableAttributedString(data: text.data(using: .unicode)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
            contentLabel.attributedText = str
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.contantViewHeightConstraint.constant  = self.timeLabel.maxY
        
        view.setNeedsLayout()
        
    }



}
