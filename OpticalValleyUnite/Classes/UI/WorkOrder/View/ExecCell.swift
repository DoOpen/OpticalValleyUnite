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

class ExecCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!


    @IBOutlet weak var addPhotoView: SJAddView!
    @IBOutlet weak var textView: UITextView!
    
    var doneBtnClickHandle: (([UIImage]?,String?) -> ())?
    
    var model: ExecChild?{
        didSet{
            titleLabel.text = model?.name
            
           
               

                
                if model?.type == "1"{
                    addPhotoView.isHidden = false
                    textView.isHidden = true
                    addPhotoView.addButton.isEnabled = true
                    if let url = model?.imageValue,url != ""{
                        let basicPath = URLPath.basicPath
                        let imageValue = basicPath.replacingOccurrences(of: "/api/", with: "") + url
                        
                        addPhotoView.addButton.kf.setBackgroundImage(with: URL(string: imageValue), for: .normal)
                    }else{
                        addPhotoView.addButton.setBackgroundImage(UIImage(named:"btn_addphoto"), for: .normal)
                    }
                    
                    
                }else if model?.type == "2" || model?.type == "4" {
                    addPhotoView.isHidden = true
                    textView.isHidden = false
                    
           
                        textView.keyboardType = .default
                    
//                    textView.isEditable = false
                    textView.text = model?.value ?? ""
                }
                
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
        addPhotoView.maxCount = 3
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
