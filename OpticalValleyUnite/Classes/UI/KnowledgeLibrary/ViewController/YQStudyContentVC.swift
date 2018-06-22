//
//  YQStudyContentVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/5/3.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQStudyContentVC: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    var cellID = "studyCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //1.init
        self.title = "学习"

        //2.注册原型cell
        let nib = UINib.init(nibName: "YQKnowledgeStudyCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: cellID)
        
    }

}

extension YQStudyContentVC : UITableViewDelegate,UITableViewDataSource{

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 30
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = YQStudyDetailVC.init(nibName: "YQStudyDetailVC", bundle: nil)
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    
}
