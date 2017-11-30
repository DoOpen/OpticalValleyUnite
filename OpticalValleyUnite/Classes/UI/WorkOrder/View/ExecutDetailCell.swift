//
//  ExecutDetailCell.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/6/7.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit

class ExecutDetailCell: UITableViewCell {
    var tabHeight: CGFloat = 0.0
    @IBOutlet weak var tableView: UITableView!
    weak var  superTableView: UITableView?
    var models = [ExecSectionModel](){
        didSet{
            tableView.reloadData()
        }
    }
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
        
//        tableView.tableFooterView = UIView()
        
        self.remarkTextView.placeHolder = "备注:"
        
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
        return 60
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

            self?.tableViewHeightConstaint.constant = (self?.tabHeight)! + 120

            self?.superTableView?.reloadData()
            
        }
        
        
        return view
    }
    
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    
}

