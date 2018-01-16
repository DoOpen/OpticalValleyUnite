//
//  YQReportFromViewController.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/1/16.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQReportFromViewController: UIViewController {

    @IBOutlet weak var tabelView: UITableView!
    
    //选择时间的label
    @IBOutlet weak var timeLabel: UILabel!
    
    //选择的title
    var selectTitle = ""
    
    var CellID = "reportFormCell"
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.title = selectTitle
        
        
    }

 
    // MARK: - 添加时间的click方法
    @IBAction func timeLabelClick(_ sender: UIButton) {
        
    }
    
    

}

extension YQReportFromViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 20
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID, for: indexPath)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //跳转到内容选中的详情页,通过title来进行的判断的rightBar的情况
        //顺便的数据展示和回显
        
        
    }
    
    
}
