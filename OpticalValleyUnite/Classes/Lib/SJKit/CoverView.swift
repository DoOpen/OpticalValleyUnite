//
//  CoverView.swift
//  Dentist
//
//  Created by 贺思佳 on 2016/12/17.
//  Copyright © 2016年 贺思佳. All rights reserved.
//

import UIKit

class CoverView: UIView {
    let imageView = UIImageView()

    class func show(imageName:String) {
        self.show(image: UIImage(named: imageName)!)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print(NSStringFromClass(self.classForCoder) + "deinit")
    }
    
    class func showFullScreen(image:UIImage) {
        let coverView = CoverView()
        coverView.bounds = CGRect(x: 0, y: 0, width: SJScreeW, height: SJScreeH)
        coverView.center = SJKeyWindow!.center
        coverView.imageView.image = image
        coverView.imageView.frame = coverView.bounds
        
        SJKeyWindow?.addSubview(coverView)
//        UIView.transition(with: SJKeyWindow!, duration: 0.5, options:.curveEaseIn, animations:
//            {SJKeyWindow?.addSubview(coverView)}, completion: nil)

    }
    
    class func show(image:UIImage) {
        let coverView = CoverView()
        coverView.bounds = CGRect(x: 0, y: 0, width: SJScreeW, height: SJScreeH)
        coverView.center = SJKeyWindow!.center
        coverView.imageView.image = image
        coverView.imageView.frame.size = CGSize(width: SJScreeW, height: image.size.height / image.size.width * SJScreeW)
        coverView.imageView.center = coverView.center
        
        //SJKeyWindow?.addSubview(coverView)
        UIView.transition(with: SJKeyWindow!, duration: 0.5, options:.curveEaseIn, animations:
            {SJKeyWindow?.addSubview(coverView)}, completion: nil)
    }
    
    class func show( view: UIView) {
        
        let coverView = CoverView()
        coverView.frame = CGRect(x: 0, y: 0, width: SJScreeW, height: SJScreeH)

        coverView.addSubview(view)
        
        UIView.transition(with: SJKeyWindow!, duration: 0.5, options:.curveEaseIn, animations:
            {SJKeyWindow?.addSubview(coverView)}, completion: nil)
    }
    
    class func show(urlStr: String, frame: CGRect = CGRect(x: 0, y: 60, width: SJScreeW - 112 * 2, height: SJScreeH - 60 * 2)) {
        let coverView = CoverView()
        coverView.bounds = CGRect(x: 0, y: 0, width: SJScreeW, height: SJScreeH)
        coverView.center = SJKeyWindow!.center
        coverView.imageView.frame = frame
        let url = URL(string: urlStr)
        coverView.imageView.kf.setImage(with: url)
        UIView.transition(with: SJKeyWindow!, duration: 0.5, options:.curveEaseIn, animations:
            {SJKeyWindow?.addSubview(coverView)}, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.removeFromSuperview()
    }

}
