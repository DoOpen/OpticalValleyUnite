//
//  UIButton+YQTime.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/6/25.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

//设置全局的时间保存宏
var YQTimeCount = 0

class UIButton_YQTime: UIButton {

}

extension UIButton{
    
    public func countDown(count: Int){
        // 倒计时开始,禁止点击事件
        isEnabled = false
        
        // 保存当前的背景颜色
        let defaultColor = self.backgroundColor
        // 设置倒计时,按钮背景颜色
        // backgroundColor = UIColor.gray
        
        
        var remainingCount: Int = count {
            
            willSet {

                DispatchQueue.main.async(execute: {
                    
                    YQTimeCount = remainingCount
                    //计算剩余时间
                    let days = Int(remainingCount) / (3600 * 24)
                    
                    let hours = (Int(remainingCount) - Int(days) * 24 * 3600) / 3600
                    let minutes = (Int(remainingCount) - Int(days) * 24 * 3600 - Int(hours) * 3600) / 60
                    let seconds = Int(remainingCount) - Int(days) * 24 * 3600 - Int(hours) * 3600 - Int(minutes) * 60

                    var minute = ""
                    var second = ""
                    
                    if minutes < 10 {
                        minute = "0" + "\(minutes)"
                    } else {
                        minute = "\(minutes)"
                    }
                    
                    if seconds < 10 {
                        
                        second = "0" + "\(seconds)"
                        
                    } else {
                        
                       second = "\(seconds)"
                    }
                    
                    let btnString = minute + "'" + second + "'"
                    
                    self.setTitle(btnString, for: .normal)
                    
                    if newValue <= 0 {
                        
                        self.setTitle("考试结束", for: .normal)
                        //实现的逻辑要求强制的通知提交答案,并且强制界面返回刷新
                        
                    }
                    
                })
            }
            
        }
        
        // 在global线程里创建一个时间源
        let codeTimer = DispatchSource.makeTimerSource(queue:DispatchQueue.global())
        // 设定这个时间源是每秒循环一次，立即开始
        codeTimer.scheduleRepeating(deadline: .now(), interval: .seconds(1))
        // 设定时间源的触发事件
        codeTimer.setEventHandler(handler: {
            
            // 返回主线程处理一些事件，更新UI等等
            DispatchQueue.main.async {
                // 每秒计时一次
                remainingCount -= 1
                // 时间到了取消时间源
                if remainingCount <= 0 {
                    
                    self.backgroundColor = defaultColor
                    self.isEnabled = true
                    codeTimer.cancel()
                    
                }
            }
            
        })
        // 启动时间源
        codeTimer.resume()
    }
    
}


