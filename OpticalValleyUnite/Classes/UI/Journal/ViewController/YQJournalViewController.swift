//
//  YQJournalViewController.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/10/11.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit

class YQJournalViewController: UIViewController {
    
    // MARK: - 属性列表
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - 视图生命周期方法
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //1.添加设置barItem
        setupRightAndLeftBarItem()
        
        //2.设置偏移量的问题
        self.automaticallyAdjustsScrollViewInsets = false
        
        //3.注册原型cell
        let nib = UINib.init(nibName: "YQJournalCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "journalCell")
        
        //4.设置cell的行高属性和 预估行高
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        
        //5.设置添加上下拉刷新
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //3.日志列表的数据
//        getWorklogDataList()
        
    }
    
    // MARK: - 获取日志数据列表
    func getWorklogDataList(){
        
        let paramerters = [String : Any]()
        
        HttpClient.instance.get(path: URLPath.getWorklogList, parameters: paramerters, success: { (response) in
            
            
            
        }) { (error) in
            
            self.alert(message: error.debugDescription)
            
        }
    
    }
    
    // MARK: - 自定义的right_left barItem
    func setupRightAndLeftBarItem(){
        
        // 自定义的navigetion right left barItem情况
        // left
        let leftButton = UIButton()
        leftButton.frame = CGRect(x:0,y:0,width: 40, height:40)
        leftButton.setImage(UIImage(named: "icon_fire_return"), for: .normal)
        leftButton.addTarget(self, action: #selector(leftBarItemButtonClick), for: .touchUpInside)
        
        let leftBarItem = UIBarButtonItem()
        leftBarItem.customView = leftButton
        
        self.navigationItem.leftBarButtonItem = leftBarItem
        
        //right
        let right_select_Button = UIButton()
        right_select_Button.frame = CGRect(x : 0, y : 0, width : 20, height : 40)
        
        right_select_Button.setImage(UIImage(named: "筛选"), for: .normal)
        right_select_Button.addTarget(self, action: #selector(selectRightBarItemButtonClick), for: .touchUpInside)
        
        let right_add_Button = UIButton()
        right_add_Button.frame = CGRect(x : 0, y : 0, width : 20, height : 40)
        
        right_add_Button.setImage(UIImage(named: "发布"), for: .normal)
        right_add_Button.addTarget(self, action: #selector(addRightBarItemButtonClick), for: .touchUpInside)
        
        let  right1Bar = UIBarButtonItem()
        right1Bar.customView = right_select_Button
        let  right2Bar = UIBarButtonItem()
        right2Bar.customView = right_add_Button
        
        self.navigationItem.rightBarButtonItems = [right1Bar,right2Bar]
        
    }
    
    //MARK: - leftBarItemButtonClick方法
    func leftBarItemButtonClick(){
        //返回子系统选择的界面
        //查看是否有缓存的数据
        let data = UserDefaults.standard.object(forKey: Const.YQTotallData) as? NSArray
        //跳转到子系统的选择界面(需要的是逻辑的判断) 如果是只有一条数据的话,直接调到登录界面
        if (data?.count)! > 1{
            
            let systemVC = YQSystemSelectionVC(nibName: "YQSystemSelectionVC", bundle: nil)
            SJKeyWindow?.rootViewController = systemVC
            
            
        }else{// 跳转到登录界面
            
            LoginViewController.loginOut()
            
        }

    }
    
    //MARK: - RightBarItemButtonClick(选择和添加)方法
    func selectRightBarItemButtonClick(){
        
        //筛选的界面弹窗的效果
        let filerVC = UIStoryboard.instantiateInitialViewController(name: "YQFilterJournal")
        navigationController?.pushViewController(filerVC, animated: true)
        
    }
    
    func addRightBarItemButtonClick(){
        
        //添加发布界面弹窗的效果
        let releaseVC = UIStoryboard.instantiateInitialViewController(name: "YQReleaseJournal")
//        navigationController?.pushViewController(releaseVC, animated: true)
        self.present(releaseVC, animated: true, completion: nil)
        
    }

}

extension YQJournalViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "journalCell", for: indexPath)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //传递模型,跳转到详情界面
        let detailVC = UIStoryboard.instantiateInitialViewController(name: "YQJournalDetail") as? YQJournalDetailViewController
        
        self.navigationController?.pushViewController(detailVC!, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 300
    }
    
}
