//
//  PartsModel.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/8/31.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit

class PartsModel: NSObject{
    //定义属性,要求保存的内容
    var partsId : Int = 0
    
    var position : String?
    
    var partsName : String?
    
    var partNum : String?
    
    
    // 字典转模型
    //初始化方法 init 的方法
     init( dict : [String: AnyObject] ) {
        //不用框架的话,就是应用系统的方法来进行
        super.init()
        setValuesForKeys(dict)
        
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    
    
    // 打印当前的模型
    /// 重写父类的方法
    var  properties  = ["partsId","position","partsName","partNum"]
    override var description : String{
        
        let dict = dictionaryWithValues(forKeys: properties)
        
        return "\(dict)"
    
    }
    
    
    /// MARK: - 加载数据的请求是要求 放在vc 和 model 中都是可以的, 注意灵活的应用
    
    
}
