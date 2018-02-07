//
//  YQDecorationScreenVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/2/6.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQDecorationScreenVC: UIViewController {

    @IBOutlet weak var decorationRoutButton: UIButton!
    
    @IBOutlet weak var decorationAcceptButton: UIButton!
    /// 当前选中的button
    var currentSelectBtn : UIButton?
    
    @IBOutlet weak var tableView: UITableView!
    
    /// 模拟的cell的数据
    var dataArray = ["区/期","栋","单元","房号"]
    var cellID = "decorationScreenCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "筛选"
//        decorationRoutButton.isSelected = true
//        self.currentSelectBtn = decorationRoutButton
        self.automaticallyAdjustsScrollViewInsets = false
        
        //注册原型cell
        let nib = UINib.init(nibName: "YQDecorationScreenCell", bundle: nil)
        
        tableView.register(nib, forCellReuseIdentifier: cellID)
    
    }
    
    
    // MARK: - buttonClick方法的应用
    @IBAction func decorationButtonSelect(_ sender: UIButton) {
        
        currentSelectBtn?.isSelected = false
        sender.isSelected = true
        currentSelectBtn = sender
        
    }
    
    @IBAction func cancelButtonSelect(_ sender: UIButton) {
        
      navigationController?.popViewController(animated: true)
        
    }
  
    @IBAction func makeSureButtonClick(_ sender: UIButton) {
        
        
        
    }


}

extension YQDecorationScreenVC : UITableViewDataSource,UITableViewDelegate{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! YQDecorationScreenCell
        cell.staticLabel.text = self.dataArray[indexPath.row]
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detail = YQLocationDetailsVC.init(nibName: "YQLocationDetailsVC", bundle: nil) as? YQLocationDetailsVC
        
        detail?.titile = self.dataArray[indexPath.row]
        
        navigationController?.pushViewController(detail!, animated: true)
        
        
        
    }

}

