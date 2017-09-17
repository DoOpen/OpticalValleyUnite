//
//  YQJoinTotallNumVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/9/15.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit

class YQJoinTotallNumVC:UIViewController{
    
    // MARK: - 控制器的属性情况
    @IBOutlet weak var detailTableV: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //添加leftBar属性
        self.setUpLeftBar()
        
    }
    
    // MARK: - leftbutton的添加
    func setUpLeftBar(){
        
        let btn = UIButton(frame: CGRect(x: 0,y: 0,width:30,height:30))
        btn.setImage(UIImage(named: "icon_fire_return"), for: .normal)
        btn.addTarget(self, action: #selector(leftBarClick), for: .touchUpInside)
        let left = UIBarButtonItem(customView: btn)
        self.navigationItem.leftBarButtonItem = left
        
    }
    
    // MARK: - leftBarClick的点击事件
    func leftBarClick() {
        
        self.navigationController?.popViewController(animated: true)
        // 发送通知打开抽屉view
        let noties = NotificationCenter.default
        let name = NSNotification.Name(rawValue: "openDrawerNoties")
        noties.post(name: name, object: nil)
        
    }

}

extension YQJoinTotallNumVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
//        let view = [Bundle.main.loadNibNamed("YQJoinTotallHead", owner: nil, options: nil)].last as? YQJoinTotallHeadView
        
        return Bundle.main.loadNibNamed("YQJoinTotallHead", owner: nil, options: nil)![0] as? UIView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }


}



