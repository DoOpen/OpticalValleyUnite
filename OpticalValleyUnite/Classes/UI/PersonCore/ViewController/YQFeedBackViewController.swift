//
//  YQFeedBackViewController.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/3/30.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit
import SVProgressHUD

class YQFeedBackViewController: UIViewController {
    
    //主题
    @IBOutlet weak var titleTextField: UITextField!
    //内容
    @IBOutlet weak var contentTextView: SJTextView!
    
    //图片
    @IBOutlet weak var addImageView: SJAddView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1.初始化
        self.title = "意见反馈"
        self.contentTextView.placeHolder = "请输入不少于10个字的描述"
        
        //添加rightBar
        setupRightAndLeftBarItem()
        
    }
    
    
    // MARK: - 自定义的right_left barItem
    func setupRightAndLeftBarItem(){
        
        let right_add_Button = UIButton()
        
        right_add_Button.frame = CGRect(x : 0, y : 0, width : 60, height : 40)
        right_add_Button.setImage(UIImage(named: "反馈"), for: .normal)
        right_add_Button.setTitle("我的反馈", for: .normal)
        //设置font
        right_add_Button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        right_add_Button.setTitleColor(UIColor.blue, for: .normal)
        
        right_add_Button.addTarget(self, action: #selector(addRightBarItemButtonClick), for: .touchUpInside)
        
        let  right2Bar = UIBarButtonItem()
        right2Bar.customView = right_add_Button
        
        self.navigationItem.rightBarButtonItems = [right2Bar]
        
    }
    
    //MARK: - leftBarItemButtonClick方法
    func addRightBarItemButtonClick(){
        
        //跳转到反馈的界面
        let vc = UIStoryboard.instantiateInitialViewController(name: "YQMyFeedList")
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    // MARK: - 接口数据上传
    func uploadDataForService(){
        
        let images = addImageView.photos.map { (image) -> UIImage in
            
            return image.image
        }

        var parameter = [String : Any]()
        
        parameter["content"] = self.contentTextView.text
        parameter["title"] = self.titleTextField.text
        
        //1.上传图片中
        if images.count > 0 {
            
            self.upDataImage(images, complit: { (url) in
                
                parameter["images"] = url
                SVProgressHUD.show(withStatus: "正在保存...")
                //2.上传添加数据
                HttpClient.instance.post(path: URLPath.getFeedbackAdd, parameters: parameter, success: { (response) in
                    
                    SVProgressHUD.dismiss()
                    SVProgressHUD.showSuccess(withStatus: "保存成功!")
                    self.navigationController?.popViewController(animated: true)
                    
                }) { (error) in
                    
                    SVProgressHUD.showError(withStatus: "数据加载失败,请检查网络!")
                }
                
            })
            
        }else{
            
            SVProgressHUD.show(withStatus: "正在保存...")
            //2.上传添加数据
            HttpClient.instance.post(path: URLPath.getFeedbackAdd, parameters: parameter, success: { (response) in
                
                SVProgressHUD.dismiss()
                SVProgressHUD.showSuccess(withStatus: "保存成功!")
                self.navigationController?.popViewController(animated: true)
                
            }) { (error) in
                
                SVProgressHUD.showError(withStatus: "数据加载失败,请检查网络!")
            }
            
        }
        
       
        
        
    }

    //MARK: - 上传图片的专门的接口
    func upDataImage(_ images: [UIImage], complit: @escaping ((String) -> ()),errorHandle: (() -> ())? = nil){
        
        SVProgressHUD.show(withStatus: "上传图片中...")
        
        HttpClient.instance.upLoadImages(images, succses: { (url) in
            
            SVProgressHUD.dismiss()
            
            complit(url!)
            
        }) { (error) in
            
            SVProgressHUD.dismiss()
            
            if let errorHandle = errorHandle{
                
                errorHandle()
            }
        }
    }
    
    // MARK: - 确定和取消按钮的点击事件方法
    @IBAction func cancelButtonClick(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func makeSureButtonClick(_ sender: UIButton) {
        
        self.uploadDataForService()
        
    }


}
