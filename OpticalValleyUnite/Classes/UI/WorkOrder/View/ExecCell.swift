//
//  ExecCell.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/2/22.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit
import SVProgressHUD
import Kingfisher
import SnapKit

class ExecCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!


    @IBOutlet weak var addPhotoView: SJAddView!
    @IBOutlet weak var textView: UITextView!
    
    var newAddPhotoView = SJAddView()
    
    var doneBtnClickHandle: (([UIImage]?,String?) -> ())?
    
    var model: ExecChild?{
        
        didSet{
            
            titleLabel.text = model?.name
            
                if model?.type == "1"{
                    
                    addPhotoView.isHidden = false
                    textView.isHidden = true
                    
//                    self.newAddPhotoView.photos.removeAll()
//                    self.newAddPhotoView.layoutSubviews()
                    
//                    print(self.newAddPhotoView)
//                    print(self.newAddPhotoView.subviews)
                    
//                    let newaddView = SJAddView()
                    
                    
                    
                    //注意的是:这里的图片进行的复用的bug
                    if let url = model?.imageValue,url != ""{
                        //图片的缓存处理的逻辑
                        var imageValue = ""
                        
                        if url.contains("http"){
                            
                            imageValue = url
                            
                        }else{
                            
                            let basicPath = URLPath.basicPath
                            imageValue = basicPath.replacingOccurrences(of: "/api/", with: "") + url
                        }
                        
//                        addPhotoView.addButton.kf.setBackgroundImage(with: URL(string: imageValue), for: .normal)
                        
//                        let imageView = UIImageView()
//                        
//                        imageView.kf.setImage(with: URL(string: imageValue))
//                        
//                        var _ : NSData = NSData(contentsOf:URL(string: imageValue)!)
                        
                        DispatchQueue.global().async {
                            
                            if let data = NSData.init(contentsOf: URL(string: imageValue)!) {
                                
                                DispatchQueue.main.async {
                                    
                                    if let image = UIImage.init(data: data as Data){
                                        
                                        self.newAddPhotoView.addImage(AddViewModel(image: image))
//                                        self.newAddPhotoView = newaddView
                                        
                                    }
                                }
                                
                            }
                            
                        }
                        
                    }
                    
//                    else{
//                        
//                        addPhotoView.addButton.setBackgroundImage(UIImage(named:"btn_addphoto"), for: .normal)
//                    }
                    
                    
                }else if model?.type == "2" || model?.type == "4" {
                    
                    addPhotoView.isHidden = true
                    textView.isHidden = false
                    
                    textView.keyboardType = .default
                    
//                    textView.isEditable = false
                    textView.text = model?.value ?? ""
                    
                }
            
//            addPhotoView.setNeedsDisplay()
//            addPhotoView.setNeedsLayout()
//            addPhotoView.layoutSubviews()
            
            layoutIfNeeded()
            setNeedsDisplay()
            setNeedsLayout()
            
            
//            }else{
//                
//                if model?.type == "1"{
//                    addPhotoView.isHidden = false
//                    textView.isHidden = true
////                    if let url = URL(string: (model?.value)!){
////                        addPhotoView.addButton.kf.setBackgroundImage(with: url, for: .normal)
////                    }else{
////                        addPhotoView.addButton.setBackgroundImage(UIImage(named:"btn_addphoto"), for: .normal)
////                    }
//                    if let image = addPhotoView.photos.first?.image{
//                        addPhotoView.addButton.setBackgroundImage(image, for: .normal)
//                    }else{
//                    addPhotoView.addButton.setBackgroundImage(UIImage(named:"btn_addphoto"), for: .normal)
//                    }
//                    
//                    
//                }else if model?.type == "2" || model?.type == "4" {
//                    addPhotoView.isHidden = true
//                    textView.isHidden = false
//                    textView.text = model?.value ?? ""
//                    if model?.type == "2" {
//                        textView.keyboardType = .phonePad
//                    }else{
//                        textView.keyboardType = .default
//                    }
//                    
//                }
//            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        newAddPhotoView.maxCount = 3
        self.contentView.addSubview(newAddPhotoView)
        newAddPhotoView.snp.makeConstraints { (make) in
            
            make.top.left.right.equalTo(self.textView)
            make.bottom.equalTo(self)
            
        }
        
        selectionStyle = .none
        textView.delegate = self
    }
    


    @IBAction func doneBtnClick() {
        if let block = doneBtnClickHandle ,!model!.isDone{
            
            if model?.type == "1"{
                if addPhotoView.photos.count > 0 {
                    let images = addPhotoView.photos.map{return $0.image}
                    block(images,nil)
                }else{
                    SVProgressHUD.showError(withStatus: "必须上传图片")
                }
                
            }else{
                let text = textView.text
                if text != ""{
                    block(nil,text)
                }else{
                    SVProgressHUD.showError(withStatus: "必须输入文字内容")
                }
                
            }
            

            
            
            
        }
    }
}

extension ExecCell: UITextViewDelegate{
    func textViewDidEndEditing(_ textView: UITextView) {
        model?.value = textView.text
    }
}
