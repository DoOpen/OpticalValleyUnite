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
    
    var photoImages = [Photo]()
    
    var photos = [ImageProtocol]()
    
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
                //执行离线工单的 数据没有加载过来,导致没有缓存的数据来加载
                self.photoImages.remove(at: index)

            })

            photos.append(image)
            //添加控件的高级用法; 插入子视图, 最后添加最后一个addbutton
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
    
    
    //点击进行的预览 图片的情况
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if self.photoImages.count <= 0 {
            
            return
        }
        
        let pb = PhotoBrowser(photos: self.photoImages , currentIndex: 0)
        pb.indicatorStyle = .pageControl
        
        SJKeyWindow?.rootViewController?.present(pb, animated: true, completion: nil)
        
    }

    
    
    @objc private func addBtnClick(){
        
        //添加关联的index的索引值
        let index = maxCount - self.photoImages.count
        
        SJTakePhotoHandle.takePhoto(imageBlock: { (image) in
            
            self.addImage(AddViewModel(image: image!))
            
            let photo = Photo.init(image: image)
            self.photoImages.append(photo)
            
        }, viewController: (SJKeyWindow?.rootViewController ),select : Int32(index))
        
        
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
    
    var photos = [Photo]()
    
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
        
        let kDeletBtnWH: CGFloat = 20.0
        imageView.frame = bounds
        deleteBtn.frame = CGRect(x: width - kDeletBtnWH, y: 0, width: kDeletBtnWH, height: kDeletBtnWH)
    }
    
    
}

struct AddViewModel: ImageProtocol {
    internal var image: UIImage
    
    
}


