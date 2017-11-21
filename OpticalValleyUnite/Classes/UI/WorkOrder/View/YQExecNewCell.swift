//
//  YQExecNewCell.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/11/21.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit

protocol YQExecNewCellClickDelegate : class {
    
    //删除模型数据的方法
    func ExecNewCellDeleteSuperModelFunction(view : UITableViewCell,currentRow : Int ,buttonTag : Int)
    
    //获取本地的相机的图片代理方法
    func ExecNewCellMakePhotoFunction(view : UITableViewCell,currentRow : Int )

}

class YQExecNewCell: UITableViewCell {
    
    // MARK: - 属性的列表
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var imageViewOne: UIImageView!
    
    @IBOutlet weak var imageViewtwo: UIImageView!
    
    @IBOutlet weak var imageViewthree: UIImageView!

    @IBOutlet weak var addButton: UIButton!
    
    var currentIndex = -1
    
    weak var  delegate : YQExecNewCellClickDelegate?
    
    
    //数据模型
    var model : ExecChild?{
        
        didSet{
            
            self.addButton.isHidden = false
            
            titleLabel.text = model?.name
            //图片的数据显示信息,需要的进行的显示判断的情况,有","分隔的是有多张图片
            let pictureName = model?.imageValue
            
            if pictureName == nil{
                
                return
            }
            
            for imageVV  in self.pictureArray {
                
                imageVV.image = UIImage.init(named: "")
                
            }
            
            
            if let url = model?.imageValue,url != ""{
                
                var imageValue = ""
                
                //通过逗号来进行的判断调整
                if url.contains(","){
                    //至少有两张图片,数组的循环的取值赋值
                    let stringArray = url.components(separatedBy: ",")
                    
                    if stringArray.count == 3 {
                        
                        self.addButton.isHidden = true
                    }

                    
                    for stringIndex in 0..<stringArray.count {
                        
                        let imageV = self.pictureArray[stringIndex] 
                        imageV.isUserInteractionEnabled = true
                        
                        let string = stringArray[stringIndex]
                        
                        
                        if string.contains("http"){
                            
                            imageValue = string
                            
                        }else{
                            
                            let basicPath = URLPath.basicPath
                            imageValue = basicPath.replacingOccurrences(of: "/api/", with: "") + string
                        }

                        
                        imageV.kf.setImage(with: URL(string: imageValue))
                        
                    }
                    
                }else{//只有一张图片
                    
                    if url.contains("http"){
                        
                        imageValue = url
                        
                    }else{
                        
                        let basicPath = URLPath.basicPath
                        imageValue = basicPath.replacingOccurrences(of: "/api/", with: "") + url
                    }

                    self.imageViewOne.kf.setImage(with: URL(string: imageValue))
                
                }
            }
        }
    }
    
    
    //图片模型
    lazy var pictureArray : [UIImageView] = {
        
        return [self.imageViewOne,self.imageViewtwo,self.imageViewthree]
        
    }()
    
    
    // MARK: - 设置预估行高
    func cellForHeight() -> CGFloat {
        
        return imageViewOne.frame.maxY + 5
    }
    

    // MARK: - 点击添加图片的回调的接口
    @IBAction func addTapButtonClick(_ sender: Any) {
        //打印的是,第几行的cell 的button 点击了
//        print("\(currentIndex)" + "行的button被点击了")
        
        self.delegate?.ExecNewCellMakePhotoFunction(view: self, currentRow: currentIndex)
        
    }
    
    // MARK: - 删除按钮的点击完成的情况
    @IBAction func deleteBtnClick(_ sender: UIButton) {
        
        //通过第几行的,button的tag 来进行的判断点击的事件
        self.delegate?.ExecNewCellDeleteSuperModelFunction(view: self, currentRow: currentIndex, buttonTag: sender.tag)
        
    }
    
    
}
