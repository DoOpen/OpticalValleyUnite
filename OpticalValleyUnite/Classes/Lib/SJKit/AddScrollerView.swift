//
//  AddScrollerView.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/2/20.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit
import Kingfisher
import SnapKit

let viewTag = 100

class AddScrollerView: UIView {

    var childView: UIView?
    var viewWidth: CGFloat?
    var viewHeight: CGFloat?
    var margin: CGFloat = 20
    
    var addBtnClickHandel: (() -> ())?
    
    var models: [Any]?{
        didSet{
            if let models = models{
                if !models.isEmpty{
                    
                    addChlidView()
                }
            }
        }
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        viewWidth = 60
        
        if let view = viewWithTag(1){
            
            childView = view
        }
        
        let addBtn = viewWithTag(viewTag) as! UIButton
        addBtn.addTarget(self, action: #selector(AddScrollerView.addBtnClick), for: .touchUpInside)
        
    }

    func addBtnClick(){
        if let  block = addBtnClickHandel {
            block()
        }
    }
    
    func addChlidView(){
//        var count = 0

        for view in subviews{
            if view.tag != viewTag{
                view.removeFromSuperview()
            }
        }
        
        for model in models! {
            
            if let model = model as? PersonModel{
   
                childView?.removeFromSuperview()
                
//                let contentV = UIView()
                
                //1.button视图
                let view1 = NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: childView!)) as! UIButton
                view1.isHidden = false
                view1.titleLabel?.font = UIFont.systemFont(ofSize: 12)
                
                view1.setTitle(model.name, for: .normal)
//                contentV.frame = view1.bounds
                
                let iconString = model.icon
                
                if iconString != "" {
                    
                    if (iconString.contains("http")){
                        
                        if let url = URL(string: model.icon){
                            
                            view1.kf.setImage(with: url, for: .normal)
                        }else{
                            
                            view1.setImage(UIImage.normalImageIcon(), for: .normal)
                        }
                        
                    }else{
                        
                        let basicPath = URLPath.systemSelectionURL
                        let newString = basicPath.replacingOccurrences(of: "/api/", with: "") + "/" + (iconString)
                        
                        if let url = URL(string: newString){
                            
                            view1.kf.setImage(with: url, for: .normal)
                        }else{
                            
                            view1.setImage(UIImage.normalImageIcon(), for: .normal)
                        }
                        
                    }
  
                    
                }else{
                    
                     view1.setImage(UIImage.normalImageIcon(), for: .normal)
                }
                
                
                self.addSubview(view1)
                
//                contentV.addSubview(view1)

                //2.设置projectLabel
                let projectLabel = UILabel()
                projectLabel.font = UIFont.systemFont(ofSize: 12)
                
                projectLabel.text = model.deptList?.first?["dept_names"] as? String ?? ""
                
                self.addSubview(projectLabel)
                
                
                
            }
            
        }
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        var count = 0
        let width = viewWidth ?? self.width
        
        var tempButton : UIView?
        
        for view in self.subviews{
            
            if view.tag == 1 {
                
                view.frame = CGRect(x: CGFloat(count) * (width + margin), y: 0, width: width, height: viewWidth!);
                tempButton = view
                count += 1
                
            }else if (view.tag == 0){
                
                view.frame = CGRect.init(x: (tempButton?.x)!, y: (tempButton?.maxY)! + 5, width: width, height: 18)
                
            }
            
        }
        
        
        
        let addBtn = viewWithTag(viewTag) as! UIButton
        
        addBtn.frame = CGRect(x: CGFloat(count) * (width + margin), y: 0, width: addBtn.width, height: addBtn.height);

    }
    
    
}
