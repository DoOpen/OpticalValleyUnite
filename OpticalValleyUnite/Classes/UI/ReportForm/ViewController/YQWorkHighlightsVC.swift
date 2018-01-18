//
//  YQWorkHighlightsVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/1/18.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQWorkHighlightsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var cellID = "WorkHighlights"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //注册原型cell 设置cell的每个的行高的情况
        let nib = UINib(nibName: "YQAddHighlights", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellID)

        //设置footer添加的按钮
        
    }

    @IBAction func cancelButtonClick(_ sender: UIButton) {
        
        
        
    }
    
    @IBAction func makeSureButtonClick(_ sender: UIButton) {
        
        
        
    }
    
 
}

extension YQWorkHighlightsVC : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        let boutton = UIButton()
        view.addSubview(boutton)
        
        return view
        
    }
    
}

