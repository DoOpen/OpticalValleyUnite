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

    @IBOutlet weak var titleButton: UIButton!
    
    @IBOutlet weak var timeButton: UIButton!
    
    @IBOutlet weak var seachTextField: UITextField!
    
    var selectProject : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //初始设置内容
        titleButton.setTitle(self.title, for: .normal)
        
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
    
    // MARK: - datePickerView的展示
    @IBAction func datePickerButtonClick(_ sender: Any) {
        
        view.endEditing(true)
        let dic =  ["Mon": "星期一", "Tue": "星期二", "Wed": "星期三", "Thu": "星期四", "Fri": "星期五", "Sat": "星期六", "Sun": "星期日"]
        
        SJPickerView.show(withDateType: .dateAndTime, defaultingDate: Date(), userController: self, selctedDateFormot: "yyyy-MM-dd", didSelcted: {date, dateStr in
            var text = dateStr
            
            for (key, value) in dic{
                text = text?.replacingOccurrences(of: key, with: value)
            }
            
            self.timeButton .setTitle(text, for: .normal)
            
        })
    }
    
    
    // MARK: - allProjectPickerView的展示
    @IBAction func allProjectPickerButtonClick(_ sender: Any) {
        view.endEditing(true)
        let temp = ["参与总单量","火警单","误报单"]
        
//        SJPickerView.show(withDataArry2: temp, didSlected: { [weak self] index in
//            self?.projectBtn.setTitle(temp[index].title, for: .normal)
//            self?.selectProject = temp[index]
//        })
        SJPickerView.show(withDataArry: temp, didSlected: { [weak self] index in
            
            if index == 0 {
                self?.titleButton .setTitle("总单量", for: .normal)
            }else{
                self?.titleButton .setTitle(temp[index], for: .normal)
            }
            
            self?.selectProject = temp[index]
            
        })
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



