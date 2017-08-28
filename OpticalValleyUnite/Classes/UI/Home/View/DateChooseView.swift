//
//  DateChooseView.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/1/12.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit

class DateChooseView: UIView {

    var currentDateView: DateView?

    var didSelectHandle: ((String) -> ())?
    
    var scrollView: UIScrollView = UIScrollView()
    
    var selecIndex: Int?{
        didSet{
            for view in subviews{
                if view.tag == selecIndex!{
                    (view as! DateView).isSeleced = true
                    currentDateView = view as? DateView
                }
            }
        }
    }
    
    override func awakeFromNib() {
        addSubview(scrollView)
      scrollView.bounces = false
        
        let year = Date().dateCompoents().year!
        var month = Date().dateCompoents().month!
        month -= 1
        if month == 0 {
            month = 12
        }
        
        var count = Date.getDaysInMonth(year: year, month: month)
        
        count = count + Date().dateCompoents().day!
        let width = SJScreeW / 7.0
        scrollView.contentSize = CGSize(width: CGFloat(count) * width, height: 0)
        scrollView.contentOffset = CGPoint(x: CGFloat(count) * width, y:0)
        for i in 0 ..< count{
            let day = Date().dateSubtractingOneDay(count: count - 1 - i).dataString(dateFormetStr: "dd")
            let week = Date().dateSubtractingOneDay(count: count - 1 - i).dataString(dateFormetStr: "EEE")

            
            let dateView = DateView.loadFromXib() as! DateView
            dateView.frame = CGRect(x: width * CGFloat(i), y: 0, width: width, height: 67.0)
            dateView.dayBtn.setTitle(day, for: .normal)
            dateView.weekLabel.text = week
            dateView.dateStr = Date().dateSubtractingOneDay(count: count - 1 - i).dataString(dateFormetStr: "yyyy-MM-dd")
            
            dateView.tag = i
            
            if i == count - 1{
                dateView.isSeleced = true
                self.currentDateView = dateView
            }
            
            
            dateView.didClickBlock = {
                self.currentDateView?.isSeleced = false
                self.currentDateView = dateView
                self.currentDateView?.isSeleced = true
                
                if let block = self.didSelectHandle {
                    block(self.currentDateView!.dateStr!)
                }
                
            }
            
            scrollView.addSubview(dateView)
        }
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = bounds
    }

}

class DateView: UIView{
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var dayBtn: UIButton!
    
    var dateStr: String?
    
    var didClickBlock: (() -> ())?
    
    var isSeleced = false{
        didSet{
            if isSeleced {
                dayBtn.setTitleColor(UIColor.white, for: .normal)
                dayBtn.backgroundColor = Const.SJThemeColor
            }else{
                dayBtn.setTitleColor(UIColor.black, for: .normal)
                dayBtn.backgroundColor = UIColor.clear
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let didClickBlock = didClickBlock {
            didClickBlock()
        }
    }
}
