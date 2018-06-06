//
//  YQOwnerAndTenantCell.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/2/20.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit



class YQOwnerAndTenantCell: UITableViewCell {

    @IBOutlet weak var relationshipLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var telLabel: UILabel!
    
    @IBOutlet weak var titleNameLabel: UILabel!

    @IBOutlet weak var titleTelLabel: UILabel!
    
    
    var model : YQHouseRelativeModel? {
        didSet{
            
            //// 与业主关系 0、父母：1、子女：2、其他
//            switch (model?.relationRole)! {
//            case 0:
//                self.relationshipLabel.text = "父母"
//
//                break
//            case 1:
//                self.relationshipLabel.text = "子女"
//
//                break
//            case 2:
//                self.relationshipLabel.text = "其他"
//
//                break
//            default:
//                break
//            }
            
            
            if model?.tenantName != "" {
                
                self.titleNameLabel.text = "租户姓名"
                self.titleTelLabel.text = "租户电话"
                
                self.relationshipLabel.text = model?.typeName
                self.telLabel.text = model?.tenantTel
                self.nameLabel.text = model?.tenantName
            
            }else{
            
                self.relationshipLabel.text = model?.relationRoleName
                self.telLabel.text = model?.relationTel
                self.nameLabel.text = model?.relationName
            
            }
            
        }
    }
    
    
}
