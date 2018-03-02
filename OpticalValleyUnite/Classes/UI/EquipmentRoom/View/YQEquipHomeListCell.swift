//
//  YQEquipHomeListCell.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/2/27.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit
import SnapKit

class YQEquipHomeListCell: UITableViewCell {
    
    ///属性列表项
    @IBOutlet weak var showImageView: ShowImageView!
    
    @IBOutlet weak var showContentView: UITextView!
    
    var sensorViewArray = [YQSensorPart]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    var model : YQEquipHomeListModel?{
        didSet{
            
            //文本
            showContentView.text = model?.equipHouseName
            //图片
            
            if model?.screenUrl != "" {//数组为 空的情况
                
                let basicPath = URLPath.systemSelectionURL
                
                if (model?.screenUrl.contains("http"))! {
                    
                    showImageView.showImageUrls([(model?.screenUrl)!])
                    
                }else{
                    
                    let imageValue = basicPath.replacingOccurrences(of: "/api/", with: "") + "/" + (model?.screenUrl)!
                    
                    showImageView.showImageUrls([imageValue])
                    
                }
                
            }else{// 数组不为 空的情况
                
                showImageView.showImageUrls([(model?.screenUrl)!])
            }
            
            showImageView.didClickHandle = { _,image in
                
                CoverView.show(image: image)
            }
            
            
            if (model?.sensorData.isEmpty)! {
                //没有传感器数据
                return
                
            }else{
                
                var tempV : YQSensorPart?
                
                //动态添加传感器的数据值
                for indexxxx in 0..<(model?.sensorData.count)! {
                    
                    let dict = model?.sensorData[indexxxx]
                    
                    if indexxxx % 2 == 0 {
                        //重新创建
                        let sensorV = Bundle.main.loadNibNamed( "YQSensorPart", owner: nil, options: nil)?[0] as! YQSensorPart
                        tempV = sensorV
                        
                        self.addSubview(sensorV)
                        
                        if indexxxx == 0 {
                            
                            tempV?.snp.makeConstraints({ (maker) in
                                
                                maker.left.equalTo(self.showContentView.snp.left)
                                
                                maker.right.equalTo(self.showContentView.snp.right)
                                
                                maker.top.equalTo(self.showContentView.snp.bottom).offset(10)
                                maker.height.equalTo(20)
                            })
                            
                        }else{
                            
                            let lastView = self.sensorViewArray.last
                        
                            tempV?.snp.makeConstraints({ (maker) in
                                
                                maker.left.equalTo(self.showContentView.snp.left)
                                
                                maker.right.equalTo(self.showContentView.snp.right)
                                
                                maker.top.equalTo((lastView?.snp.bottom)!).offset(5)
                                maker.height.equalTo(20)
                            })

                        
                        }
                        
                        sensorViewArray.append(sensorV)
                        
                        let name = dict?["name"] as? String ?? ""
                        let val = dict?["val"] as? String ?? ""
                        let unit = dict?["unit"] as? String ?? ""
                        
                        tempV?.sensorLabel.text = name + ":" + val + unit
                        
                    }else{//已经执行
                        
                        let name = dict?["name"] as? String
                        let val = dict?["val"] as? String
                        let unit = dict?["unit"] as? String
                        
                        tempV?.sensorLabel2.text = name! + ":" + val! + unit!
                        
                    }
                    
                    
                }
                
                
            }
        
            self.setNeedsLayout()
        }
        
        
    }

    
    
}
