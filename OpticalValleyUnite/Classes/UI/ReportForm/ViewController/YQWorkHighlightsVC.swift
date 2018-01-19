//
//  YQWorkHighlightsVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/1/18.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit
import SnapKit

class YQWorkHighlightsVC: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    var cellID = "WorkHighlights"
    
    var height = 300
    
    var childsArray = [YQAddHighlights]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "工作亮点"
        
        let view =  Bundle.main.loadNibNamed("YQAddHighlights", owner: nil, options: nil)?[0] as! YQAddHighlights
        view.frame = CGRect.init(x: 0, y: 0, width: Int(SJScreeW), height: height)
        childsArray.append(view)
        
        self.scrollView.contentSize = CGSize.init(width: 0, height:childsArray.count * (height + 5))
        
        self.scrollView.addSubview(view)
        
    }

    //取消
    @IBAction func cancelButtonClick(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }
    
    //确定
    @IBAction func makeSureButtonClick(_ sender: UIButton) {
        
        
    }
    
    //添加
    @IBAction func addButtonClick(_ sender: UIButton) {
        
        let view =  Bundle.main.loadNibNamed("YQAddHighlights", owner: nil, options: nil)?[0] as! YQAddHighlights
        let y = childsArray.count * (height + 5)
        
        view.frame = CGRect.init(x: 0, y: y, width: Int(SJScreeW), height: height)
    
        self.scrollView.addSubview(view)
        childsArray.append(view)
        
        self.scrollView.contentSize = CGSize.init(width: 0, height:childsArray.count * (height + 5))
        
        
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

