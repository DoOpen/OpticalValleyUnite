//
//  YQStudyDetailVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/6/21.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQStudyDetailVC: UIViewController {

    @IBOutlet weak var studyTitleLabel: UILabel!
    
    @IBOutlet weak var studyContentTextV: UITextView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var cellID = "StudyDetailCell"
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //1.init
        self.title = "培训详情"
        
        //2.注册原型cell
        let nib = UINib.init(nibName: "YQStudyDetailCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: cellID)
        
        
    }
    
    
    func getDetailDataForServer(){
        
        var par = [String : Any]()
        par["id"] = ""
        
        HttpClient.instance.post(path: URLPath.getNewknowledgeDetail, parameters: par, success: { (response) in
            
            
        }) { (error) in
            
            
        }
        
        
    }
    
    
}

extension YQStudyDetailVC : UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        return cell
    }
    
}
