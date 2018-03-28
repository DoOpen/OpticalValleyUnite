//
//  YQWeatherCell.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/3/28.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQWeatherCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var weekLabel: UILabel!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var weatherModel : AMapLocalDayWeatherForecast?{
        
        didSet{
            
            dateLabel.text = weatherModel?.date
            weekLabel.text = weatherModel?.week
            
            let high = weatherModel?.dayTemp
            let low = weatherModel?.nightTemp
            
            temperatureLabel.text = high! + "/" + low! + "℃"
            
        }
    
    }

  
}
