//
//  ExecutDetailCell.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/6/7.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit
import SnapKit

class ExecutDetailCell: UITableViewCell {
    var tabHeight: CGFloat = 0.0
    @IBOutlet weak var tableView: UITableView!
    weak var  superTableView: UITableView?
    var models = [ExecSectionModel](){
        didSet{
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var partviewheight: NSLayoutConstraint!
    
    
    var remarkTest : String? {
        
        didSet{
            
            self.remarkTextView.placeHolder = ""
            if remarkTest == nil {
                
                remarkTest = ""
            }
            self.remarkTextView.text = "备注:" + remarkTest!
            
        }
        
    }
    
    var partList : NSArray?{
        
        didSet{
            
            if partList != nil {
                
                for temp in 0..<(partList?.count)! {
                    
                    let dict = partList?[temp] as? [String : Any]
                    
                    //通过的是,配件库的添加信息显示布局
                    let view = Bundle.main.loadNibNamed("YQPartXib", owner: nil, options: nil)?[0] as! YQPartXibView
                    view.part.text = dict?["partsName"] as? String
                    view.partName.text = dict?["position"] as? String
                    
                    let num = dict?["amount"] as? Int ?? 0
                    
                    view.numberLabel.text = "\(num)"
                    
                    self.partArrayView.append(view)
                    self.partContentView.addSubview(view)
                    
                    if temp == 0 {
                        
                        view.snp.makeConstraints({ (maker) in
                            
                            maker.top.equalTo(20)
                            maker.left.right.equalToSuperview()
                            maker.height.equalTo(20)
                            
                        })
                        
                    }else{
                        
                        let tempV = self.partArrayView[temp - 1]
                        
                        view.snp.makeConstraints({ (maker) in
                            
                            maker.top.equalTo(tempV.snp.bottom)
                            maker.left.right.equalToSuperview()
                            maker.height.equalTo(20)
                            
                        })
                        
                    }
                }
            }
            
            partviewheight.constant = CGFloat(25 + (partList?.count)! * 20)
//            tableViewHeightConstaint.constant = CGFloat(125 + (partList?.count)! * 20)
            self.setNeedsDisplay()
            
        }
        
    }
    
    
    var partArrayView = [YQPartXibView]()
    
    
    @IBOutlet weak var partContentView: UIView!
    @IBOutlet weak var partContentViewHeightConstrait: NSLayoutConstraint!
    
    @IBOutlet weak var tableViewHeightConstaint: NSLayoutConstraint!
    
    @IBOutlet weak var remarkTextView: SJTextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let nib1 = UINib(nibName: "ExecuteDetailSubCell", bundle: nil)
//        let nib2 = UINib(nibName: "ExecuteDetailSubImageCell", bundle: nil)
        
        tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        tableView.register(nib1, forCellReuseIdentifier: "ExecuteDetailSubCell")
//        tableView.register(nib2, forCellReuseIdentifier: "ExecuteDetailSubImageCell")
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80.0
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableViewHeightConstaint.constant = 80
        
//        tableView.tableFooterView = UIView()
        
        if self.remarkTextView.text == "" {
            
            self.remarkTextView.placeHolder = "备注:"
        }
        
        self.remarkTextView.isEditable = false
        
        //注意的是:添加补充的逻辑的判断,是电梯才显示配件库的信息
        let reportName = UserDefaults.standard.object(forKey: Const.YQReportName) as? String
        if reportName == "报事" {//普通报事,要求隐藏功能
        
            partContentView.isHidden = true
            partContentViewHeightConstrait.constant = 0.5
            
        }
        
        
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        let height = tableView.contentSize.height
//        if height != tableViewHeightConstaint.constant{
//            tableViewHeightConstaint.constant = height
//            superTableView?.reloadData()
//        }
//    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize"{
            print("contentSize Changed")
            
            let height = (change?[.newKey] as! CGSize).height
            if height != tableViewHeightConstaint.constant{
                tabHeight = height
                print(tabHeight)
                
//                if shouldReload{
//                    shouldReload = false
//                    
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute:
//                    {
//                        //
//                        
//                        
//                        self.tableViewHeightConstaint.constant = (self.tableView.contentSize.height)
//                        
//                        self.superTableView?.reloadData()
//                        
//                })
            
            }
            
        }
    }
    
    deinit{
        tableView.removeObserver(self, forKeyPath: "contentSize")
    }

}



extension ExecutDetailCell: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let model = models[section]
        if model.isOpen{
            return model.childs.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let model = models[indexPath.section].childs[indexPath.row]
        
        if model.type == "1"{//有图片的框架
            
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ExecuteDetailSubImageCell", for: indexPath) as! ExecuteDetailSubImageCell
            let cell = Bundle.main.loadNibNamed("ExecuteDetailSubImageCell", owner: nil, options: nil)?[0] as? ExecuteDetailSubImageCell
            
            
            cell?.index = indexPath.row + 1
            cell?.model = model
            return cell!
            
        }else{

            let cell = tableView.dequeueReusableCell(withIdentifier: "ExecuteDetailSubCell", for: indexPath) as! ExecuteDetailSubCell
            cell.index = indexPath.row + 1
            cell.model = model
            return cell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = ExecutingSectionView.loadFromXib() as! ExecutingSectionView
        
        let model = models[section]
        
        view.titleLabel.text = "任务\(section + 1): " + model.name
        
        if model.isOpen{
            
            view.iconBtn.transform =  CGAffineTransform(rotationAngle: CGFloat.pi / 2 )
            view.openBtn.setTitle("收起", for: .normal)
        }else{
            
            view.iconBtn.transform = .identity
            view.openBtn.setTitle("展开", for: .normal)
        }
       
    
        view.didTouchHandle = { [weak self] in
            //            let realm = try! Realm()
            //            realm.beginWrite()
            model.isOpen = !model.isOpen
            
            self?.superTableView?.reloadData()
            self?.tableView.reloadData()
            self?.tableView.setNeedsLayout()
            self?.tableView.layoutIfNeeded()
           
            
            if model.isOpen{
                
                let indexPath = IndexPath(row: (self?.models[section].childs.count)! - 1, section: section)
                
                self?.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }

            self?.tableViewHeightConstaint.constant = (self?.tabHeight)!

            self?.superTableView?.reloadData()
            
        }
        
        
        return view
    }
    
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    
}

