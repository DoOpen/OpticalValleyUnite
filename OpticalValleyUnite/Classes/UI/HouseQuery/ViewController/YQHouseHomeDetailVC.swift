//
//  YQHouseHomeDetailVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/2/19.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQHouseHomeDetailVC: UIViewController {

    var dataArray = ["业主亲属&租户","设备清单","工单列表"]
    
    @IBOutlet weak var tableView: UITableView!
    
    /// 房屋详细信息
    @IBOutlet weak var houseNum: UILabel!
    @IBOutlet weak var ownerName: UILabel!
    @IBOutlet weak var ownerTel: UILabel!
    
    var cellID = "houseDetailCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "房屋巡查详情"

    
    
    }
    
    // MARK: - 查询按钮的点击事件
    @IBAction func searchButtonClick(_ sender: UIButton) {
        
        
    }
    
}

extension YQHouseHomeDetailVC : UITableViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //点击的跳转到详情的界面
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        cell?.textLabel?.text = self.dataArray[indexPath.row]
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    

}
