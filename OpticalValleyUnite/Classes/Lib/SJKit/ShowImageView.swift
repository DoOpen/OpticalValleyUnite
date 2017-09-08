//
//  ShowImageView.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/6/6.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit
import Kingfisher

private let KMaginX: CGFloat = 10.0

class ShowImageView: UIView {

    
    var didClickHandle: ((Int,UIImage) -> ())?
    
    var imageUrls = [String]()
    
    func showImageUrls(_ urls: [String]){
        
        guard !urls.isEmpty else {
            return
        }
        
        if subviews.isEmpty{
            addView(count: urls.count)
        }
        
        for (index,imageView) in subviews.enumerated(){
            if let imageView = imageView as? UIButton{
                let url = URL(string: urls[index])
                imageView.kf.setBackgroundImage(with: url, for: .normal)
            }
            
        }
    }
    
    private func addView(count: Int){
        for i in 0...count - 1{
            let btn = UIButton()
            btn.tag = i
//            btn.isUserInteractionEnabled = 
            btn.addTarget(self, action: #selector(ShowImageView.btnClick(sender:)), for: .touchUpInside)
            addSubview(btn)
        }
        
    }

    func btnClick(sender: UIButton){
        if let block = didClickHandle{
            let image = (subviews[sender.tag] as! UIButton).currentBackgroundImage
            if let image = image{
                block(sender.tag,image)
            }
            
        }
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        
//    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for (index, view) in subviews.enumerated(){
            view.frame = CGRect(x: (KMaginX + height) * CGFloat(index), y: 0, width: height, height: height)
        }
    }
}