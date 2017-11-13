//
//  YQPedometerViewController.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/11/10.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit

import CoreMotion

class YQPedometerViewController: UIViewController {
    
    //设置注册 计步设备的
    lazy var counter = {() -> CMStepCounter
        
        in
        
        return CMStepCounter()
        
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        if !CMStepCounter.isStepCountingAvailable() {
            self.alert(message: "设备不可用! 抱歉")
            
        }else{
            
            self.counter.startStepCountingUpdates(to: OperationQueue.current!, updateOn: 5, withHandler: { (Steps, timestamp, Error) in
                
                if (Error != nil) {
                    
                    return
                }
                
                print("实际走的数量的情况" + "\(Steps)")
                
            })
        
        }
        
        
        
    }

    
    

}
