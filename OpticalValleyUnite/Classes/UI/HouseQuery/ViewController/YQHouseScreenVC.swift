//
//  YQHouseScreenVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/2/9.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQHouseScreenVC: UIViewController {

    ///属性列表值
    @IBOutlet weak var screenSegment: UISegmentedControl!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var selectePrameter = [String : Any](){
        didSet{
            
            locationView.selectePrameter = selectePrameter
        }
    
    }
    
    /// content属性
    var phoneView : YQPhoneScreenView!
    var locationView : YQHouseLocationScreenView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "房屋查询"
        
        addScrollView()
        //添加通知
        addNoticeMethod()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let parkName = setUpProjectNameLable()
        if parkName != "请选择默认项目"{
        
            locationView.tableView.reloadData()
        }
        
    }
    
    // MARK: - 视图控件添加布局
    func addScrollView(){
        
        phoneView = Bundle.main.loadNibNamed("YQPhoneScreen", owner: nil, options: nil)?[0] as! YQPhoneScreenView
        
        locationView = Bundle.main.loadNibNamed("YQHouseLocationScreen", owner: nil, options: nil)?[0] as? YQHouseLocationScreenView
        locationView.delegate = self
        locationView.tableView.dataSource = locationView
        locationView.tableView.delegate = locationView
        locationView.tableView.reloadData()
        
        locationView.frame = CGRect.init(x: 0, y: 0, width: SJScreeW, height: scrollView.height)
        phoneView.frame = CGRect.init(x: SJScreeW, y: 0, width: SJScreeW, height: scrollView.height)
        self.scrollView.addSubview(locationView)
        self.scrollView.addSubview(phoneView)
        
        self.scrollView.contentSize = CGSize.init(width: locationView.maxX, height: 0)
        
    }

    @IBAction func screenSegmentClick(_ sender: UISegmentedControl) {
        
        self.scrollView.setContentOffset(CGPoint.init(x: CGFloat (sender.selectedSegmentIndex)  * SJScreeW, y: 0), animated: true)
        
    }
    
    // MARK: - 添加默认的项目选择方法
    func setUpProjectNameLable() -> String{
        
        let dic = UserDefaults.standard.object(forKey: Const.YQProjectModel) as? [String : Any]
        
        var projectName  = ""
        
        if dic != nil {
            
            projectName = dic?["PARK_NAME"] as! String
            
        }else{
            
            projectName = "请选择默认项目"
        }
        
        return projectName
    }

    
    // MARK: - 接受通知的方法
    func addNoticeMethod(){
        
        let center = NotificationCenter.default
        let notiesName = NSNotification.Name(rawValue: "selectLocationNoties")
        
        center.addObserver(self, selector: #selector(selectLocationParmeter(info:)), name: notiesName, object: nil)
    }
    
    func selectLocationParmeter(info: NSNotification){
        
        let value = info.userInfo?["selectLocation"] as! [String : Any]
        self.selectePrameter = value
        
    }


    
}

extension YQHouseScreenVC : UIScrollViewDelegate{

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    
        let num =  Int(scrollView.contentOffset.x / SJScreeW)
        
        self.screenSegment.selectedSegmentIndex = num
        
    }

}

extension YQHouseScreenVC : YQHouseLocationScreenViewDelegate{

    func houseLocationScreenViewJumpToLocation(selecteTitile : String, indexPathRow : Int) {
    
        if indexPathRow == 0 {
        
            let project = UIStoryboard.instantiateInitialViewController(name: "YQAllProjectSelect")
            self.navigationController?.pushViewController(project, animated: true)
            
        
        }else{
        
            let detail = YQLocationDetailsVC.init(nibName: "YQLocationDetailsVC", bundle: nil)
            detail.selectDict = self.selectePrameter
            detail.titile = selecteTitile
            
            navigationController?.pushViewController(detail, animated: true)
        
        }
    }
    
    
}


