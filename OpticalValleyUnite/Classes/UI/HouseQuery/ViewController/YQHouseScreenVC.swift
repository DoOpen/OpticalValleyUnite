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
    
    /// content属性
    var phoneView : YQPhoneScreenView!
    var locationView : YQHouseLocationScreenView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "房屋查询"
        
        addScrollView()
        
    }
    
    // MARK: - 视图控件添加布局
    func addScrollView(){
        
        phoneView = Bundle.main.loadNibNamed("YQPhoneScreen", owner: nil, options: nil)?[0] as! YQPhoneScreenView
        
        locationView = Bundle.main.loadNibNamed("YQHouseLocationScreen", owner: nil, options: nil)?[0] as? YQHouseLocationScreenView
        
        phoneView.frame = CGRect.init(x: 0, y: 0, width: SJScreeW, height: scrollView.height)
        locationView.frame = CGRect.init(x: SJScreeW, y: 0, width: SJScreeW, height: scrollView.height)
        self.scrollView.addSubview(phoneView)
        self.scrollView.addSubview(locationView)
        
        self.scrollView.contentSize = CGSize.init(width: locationView.maxX, height: 0)
        
    
    }

    @IBAction func screenSegmentClick(_ sender: UISegmentedControl) {
        
        self.scrollView.setContentOffset(CGPoint.init(x: CGFloat (sender.selectedSegmentIndex)  * SJScreeW, y: 0), animated: true)
        
    }

    
}

extension YQHouseScreenVC : UIScrollViewDelegate{

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    
        let num =  Int(scrollView.contentOffset.x / SJScreeW)
        
        self.screenSegment.selectedSegmentIndex = num
        
    }

}


