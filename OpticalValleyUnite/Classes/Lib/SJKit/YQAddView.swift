//
//  YQAddView.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/12/27.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit


class YQAddView: UIView {

    var superVC : UIViewController?
    
    var maxCount = 3
    
    var photos = [ImageProtocol](){
        
        didSet{
            
        }
        
    }
    
    var PhotpView : SJPhotpView?
    
    
    lazy var addButton: UIButton = {
        
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named:"btn_addphoto"), for: .normal)
        btn.addTarget(self, action: #selector(YQAddView.addBtnClick), for: .touchUpInside)
        return btn
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(addButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubview(addButton)
    }
    
    
    func addImage(_ image :ImageProtocol){
        
        
        if photos.count > maxCount {
            
            return
            
        }else{
            
            self.PhotpView = SJPhotpView.photoView(image: image.image, deletBtnClickBlock: {
                
                self.layoutIfNeeded()
                
                let index = self.photos.index(where: {photo in
                    photo.image == image.image
                }) ?? 0
                self.photos.remove(at: index)
                
            })
            
            photos.append(image)
            
            insertSubview(self.PhotpView!, belowSubview: addButton)
            
            if photos.count == maxCount {
                
                addButton.removeFromSuperview()
            }
        }
        
        layoutSubviews()
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let cloms = 4, margin: CGFloat = 10.0, wh = self.height - CGFloat(2.0 * margin)
        var x: CGFloat = 0, y: CGFloat = 0, col = 0, row = 0, i = 0
        
        for img in subviews {
            col = i % cloms;
            row = i / cloms;
            
            x = CGFloat(col) * (wh + margin) + margin
            y = CGFloat(row) * (wh + margin) + margin;
            img.frame = CGRect(x: x, y: y, width: wh, height: wh)
            i += 1
        }
        if (self.subviews.count < self.maxCount) {
            addSubview(addButton)
        }
    }
    
    
    
    @objc private func addBtnClick(){
        
        
        SJTakePhotoHandle.takePhoto(imageBlock: { (image) in
            
            self.addImage(AddViewModel(image: image!))
            
        }, viewController: (self.superVC))
        
        
    }
    
    deinit {
        
        self.PhotpView?.removeFromSuperview()
        self.PhotpView = nil
        print("sjaddview 挂了吗")
        
    }


}
