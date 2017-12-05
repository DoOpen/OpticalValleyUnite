//
//  YQStepShowModel.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/11/14.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit

class YQStepShowModel: NSObject {
    
    //姓名
    var name : String = ""
    //部门
    var department : String = ""
    //步数
    var steps : Int = -1
    //排名
    var rankno : Int = -1
    //头像
    var avatar : String = ""
    //项目
    var project : String = ""
    //职位
    var position : String = ""
    
    /// 点赞的功能调试
    //用户ID
    var userid : String = ""
    //zan
    var zan : Int = -1
    //iszan
    //0：没有点赞；1点赞了
    var iszan : Int = -1
    
    
    init(dict : [String : Any]){
        super.init()
        
        setValuesForKeys(dict)
    
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
        
    }
    

}
