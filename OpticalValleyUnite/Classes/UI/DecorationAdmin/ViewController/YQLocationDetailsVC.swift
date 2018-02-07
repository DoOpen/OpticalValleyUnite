//
//  YQLocationDetailsVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/2/7.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQLocationDetailsVC: UIViewController {
    ///属性列表
    @IBOutlet weak var titileLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    //列表属性
    var titile : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }
    
    @IBAction func makeSureButtonClick(_ sender: UIButton) {
        //确定按钮的点击执行的操作
        
        
    }
    

}

extension YQLocationDetailsVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    
}


