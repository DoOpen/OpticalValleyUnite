//
//  MessageView.swift
//  Dentist
//
//  Created by 贺思佳 on 2016/12/27.
//  Copyright © 2016年 贺思佳. All rights reserved.
//

import UIKit

class MessageShowView {

    static func show(message: String){
        
        let alc = UIAlertController(title: message, message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alc.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.cancel, handler: nil))
        SJKeyWindow?.rootViewController?.present(alc, animated: true, completion: nil)
    }

}
