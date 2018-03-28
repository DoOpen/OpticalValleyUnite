//
//  YQHomeWeatherTVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/3/27.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQHomeWeatherTVC: UITableViewController {

    var dataArray = [AMapLocalDayWeatherForecast](){
        
        didSet{
            
            self.tableView.reloadData()
            
        }
        
    }
    
    var cellID = "weatherCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
      
    }


    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataArray.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! YQWeatherCell
        
        cell.weatherModel = self.dataArray[indexPath.row]
        
        return cell
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 30
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = Bundle.main.loadNibNamed("YQWeatherHeadView", owner: nil, options: nil)?[0] as? YQWeatherHeadView
        
        return view
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 30
    }
    
}
