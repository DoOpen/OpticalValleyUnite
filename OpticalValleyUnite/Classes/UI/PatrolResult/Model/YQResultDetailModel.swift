//
//  YQResultDetailModel.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/12/12.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit

class YQResultDetailModel: NSObject {
    
    
    ///巡查点的类型的ID
    var insResultId : Int = 0
    
    //巡查项id
    var insItemId : Int = 0
    
    //巡查项名称
    var name : String = ""
    
    //巡查项类型名称
    var insItemTypeName : String = ""
    
    //巡查项描述
    var descriptionString : String = ""
    
    //巡查项标准图片路径
    var imgPath : String = ""

    //考评类型(通过类型来 进行判断相应的 回显的展示的效果界面)
    var checkType : Int = 0
    
    
    //考评得分
    var score : Int = 0
    //巡查意见
    var feedback : String  = ""
    //巡查结果上传图片路劲
    var itemImgPath : String = ""
    
    
    init(dic : [String : Any] ) {
        
        super.init()
        
        if let descriptionStr = dic["description"] as? String {
            
            self.descriptionString = descriptionStr
        }
        
        setValuesForKeys(dic)
        
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }

}
