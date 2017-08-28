//
//  MyStatisticsViewController.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/1/14.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit
import Kingfisher

class MyStatisticsViewController: UIViewController {

    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var datePickView: UIMonthYearPicker!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var starCountLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var supervisorLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconBtn: UIButton!
    
    var model: WorkStaticModel?{
        didSet{
            totalLabel.text = "\(model!.totalCount)"
            starCountLabel.text = "\(model!.starOrderCount)"
            percentageLabel.text = model!.percentage
            backLabel.text = "\(model!.drawsBackCount)"
            supervisorLabel.text = "\(model!.dubanCount)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        datePickView._delegate = self
        datePickView.date = Date()
        //不传时间 获取总的工作统计
        getWorkStatic(paramet: nil)
        
        if let user = User.currentUser(){
            nameLabel.text = user.nickname
          //  iconBtn.kf.setBackgroundImage(with: user.avatar as! Resource, for: .normal)
        }
        
        
    }


    func getWorkStatic(dateStr: String){
        
        var paramet = [String: Any]()
        paramet["YEAR"] = (dateStr as NSString).components(separatedBy: "-")[0]
        paramet["MONTH"] = (dateStr as NSString).components(separatedBy: "-")[1]
        
        getWorkStatic(paramet: paramet)
    }
    
    func getWorkStatic(paramet: [String: Any]?){
        HttpClient.instance.get(path: URLPath.getWorkOrderStatic, parameters: paramet, success: { (response) in
            
            if let dic = response as? [String: Any] {
                let model = WorkStaticModel(parmart: dic)
                self.model = model
            }
            
        }) { (error) in
            
        }
    }

    @IBAction func rightBtnClick(_ sender: UIBarButtonItem) {
//        let dateChooseView = LTHMonthYearPickerView()
        dateView.isHidden = false
    }

    @IBAction func cancelBtnClick() {
        dateView.isHidden = true
    }

    @IBAction func doneBtnClick() {
        dateView.isHidden = true
        let dateStr = datePickView.date.dataString(dateFormetStr: "yyyy-MM")
        print(dateStr)
        getWorkStatic(dateStr: dateStr)
    }


}

extension MyStatisticsViewController: UIMonthYearPickerDelegate{
    func pickerView(_ pickerView: UIPickerView!, didChange newDate: Date!) {
        print(newDate)
    }
}
