//
//  YQResultViewCell.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/12/11.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit

protocol YQResultViewCellDelegate : class {
    
    func resultViewCellDelegate(view : UIView, indexRow : Int)
}


class YQResultViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBOutlet weak var noLabel: UILabel!
    
    @IBOutlet weak var pointNameLabel: UILabel!

    @IBOutlet weak var personNameLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBAction func searchButtonClick(_ sender: UIButton) {
        
        //通知代理来执行操作
        self.delegate?.resultViewCellDelegate(view: self, indexRow: indexpathRow)
    }

    var indexpathRow = 0
    
    weak var delegate : YQResultViewCellDelegate?
    
    var model : YQResultCellModel?{
        
        didSet{
            
            //巡查路线名称
            self.noLabel.text = model?.insWayName
            //巡查点名称
            self.pointNameLabel.text = model?.wayPointName
            
            self.personNameLabel.text = model?.personName
            
//            let timeInterval:TimeInterval = TimeInterval((model?.createTime)!)
//            let date = Date.init(timeIntervalSinceNow: timeInterval)
//            let formatter = DateFormatter()
//            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//            formatter.string(from: date)
            
            self.timeLabel.text = model?.createTime
            
            
        }
    }

}
