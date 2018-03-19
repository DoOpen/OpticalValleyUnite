//
//  SJAddView.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/1/16.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit


protocol ImageProtocol {
    
    var image: UIImage {get}
}


class SJAddView: UIView {

    var maxCount = 3
    
    var photos = [ImageProtocol](){
        
        didSet{
            
           
        
        }
    
    }
    
    var PhotpView : SJPhotpView?
    
    
    lazy var addButton: UIButton = {
        
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named:"btn_addphoto"), for: .normal)
        btn.addTarget(self, action: #selector(SJAddView.addBtnClick), for: .touchUpInside)
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
            
        }, viewController: (SJKeyWindow?.rootViewController ))
        
        
    }
    
    deinit {
        
        self.PhotpView?.removeFromSuperview()
        self.PhotpView = nil
        print("sjaddview 挂了吗")
        
    }

}



class SJPhotpView: UIView {
    
    var imageView = UIImageView()
    var deleteBlock: (()->())?
    
    lazy var deleteBtn: UIButton = {
        
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named:"exit"), for: .normal)
        btn.addTarget(self, action: #selector(SJPhotpView.deleteBtnClick), for: .touchUpInside)
        return btn

    }()
    
    
    deinit {
        print(NSStringFromClass(self.classForCoder) + "销毁" + #function)
    }
    
    static func photoView(image: UIImage, deletBtnClickBlock:@escaping (() -> ())) -> SJPhotpView{
        
        let view = SJPhotpView()
        view.imageView.image = image
        view.addSubview(view.imageView)
        view.addSubview(view.deleteBtn)
        view.deleteBlock = deletBtnClickBlock
        
        return view
        
    }
    
    func deleteBtnClick(){
        
        self.removeFromSuperview()
        
        if let deleteBlock = deleteBlock {
            
            deleteBlock();
            
        }
        
        deleteBlock = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let kDeletBtnWH: CGFloat = 15.0
        imageView.frame = bounds
        deleteBtn.frame = CGRect(x: width - kDeletBtnWH, y: 0, width: kDeletBtnWH, height: kDeletBtnWH)
    }
    
    
    
    
    
    
    
}

struct AddViewModel: ImageProtocol {
    internal var image: UIImage
    
    
}


