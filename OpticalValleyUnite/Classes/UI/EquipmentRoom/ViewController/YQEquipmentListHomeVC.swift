//
//  YQEquipmentListHomeVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/2/27.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit
import SnapKit


class YQEquipmentListHomeVC: UIViewController {
    
    //筛选条件view
    @IBOutlet weak var siftView: UIView!
    

    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    
    var siftVc: YQEquipTypeTVC?
    var coverView : UIView?
    
    //弹簧变量
    var selectBool = false
    //选择的type
    var selectType : Int = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "设备房列表"
        
        
    }

    // MARK: - 查询按钮的点击
    @IBAction func searchButtonClick(_ sender: UIButton) {
        
        if selectType == 0 {
            
            getDataForServer( searchText: searchTextField.text!)
        
        }else {
        
        
            getDataForServer( type: selectType, searchText: searchTextField.text!)
        }
        
    }
    
    // MARK: - 设备房类别按钮点击
    @IBAction func equipmentTypeClick(_ sender: UIButton) {
        //点击弹出tableView.图片转化
        selectBool = !selectBool
        
        if selectBool {
            
            self.imageView.image = UIImage.init(name: "caret_up")
            
            //创建蒙版视图
            let coverV = UIView()
            coverV.backgroundColor = UIColor.init(red: 180/255.0, green: 180/255.0, blue: 180/255.0, alpha: 0.7)
            self.coverView = coverV

            self.view.addSubview(coverV)
            
            self.coverView?.snp.makeConstraints({ (maker) in
                
                maker.top.equalTo(self.siftView.snp.bottom)
                maker.left.right.bottom.equalToSuperview()

                
            })
            
            
            //创建siftVC选择控制器
            let siftTypeVC = UIStoryboard.instantiateInitialViewController(name: "YQEquipTypeTVC") as! YQEquipTypeTVC
            
            self.siftVc = siftTypeVC
            let v =  siftTypeVC.view
            
        
            self.view.addSubview(v!)

            
            v?.snp.makeConstraints({ (maker) in
                
                maker.bottom.equalTo(self.view.snp.top)
                maker.left.right.equalToSuperview()
                maker.height.equalTo(280)
                
            })
            
            UIView.animate(withDuration: 0.25, animations: {
                
                v?.snp.removeConstraints()
                
                v?.snp.makeConstraints({ (maker) in
                    
                    maker.top.equalTo(self.siftView.snp.bottom)
                    maker.left.right.equalToSuperview()
                    maker.height.equalTo(280)
                })

            })

            
        }else{
            
            self.imageView.image = UIImage.init(name: "caret_down")
            
            UIView.animate(withDuration: 0.25, animations: {
                
                self.siftVc?.view.snp.removeConstraints()
                
                self.siftVc?.view.snp.makeConstraints({ (maker) in
                    
                    maker.bottom.equalTo(self.view.snp.top)
                    maker.left.right.equalToSuperview()
                    maker.height.equalTo(200)
                })

                
            }, completion: { (Bool) in
                
                self.coverView?.removeFromSuperview()
                
                self.siftVc?.view.removeFromSuperview()
                
            })

            
        }
        
        
        //选择sift的控制器要求回调函数
        self.siftVc?.selectCellClickHandel = { parmat in
            
            //拿出id 进行筛选调整
            self.selectType = (parmat["equipTypeId"] as? Int)!
        }

        
        
    }
    
    // MARK: - 获取数据的相应方法
    func getDataForServer(pageIndex : Int = 0, pageSize : Int = 20, type : Int = 0, searchText : String = ""){
        
        var par = [String : Any]()
        
        par["equipTypeId"] = type
        par["equipHouseName"] = searchText
            
        par["parkId"] = ""
        
        
        
    
    }
   
    
    
}
