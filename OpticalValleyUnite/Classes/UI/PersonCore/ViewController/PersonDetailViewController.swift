//
//  PersonDetailViewController.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/6/29.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit
import Kingfisher
import SVProgressHUD

class PersonDetailViewController: UITableViewController{
    @IBOutlet weak var photoBtn: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberIdLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!

    @IBOutlet weak var yearLabel: UILabel!

    var model: PersonInfo?{
        didSet{
            if let model = model{
                nameLabel.text = model.name
                numberIdLabel.text = model.job_code
                sexLabel.text = model.sex
                
                if model.birthday != ""{
                    let date = Date.dateFromString(dateStr: model.birthday, formetStr: "yyyy-MM-dd")
                    let compont = Calendar.current.dateComponents(
                        [.year], from: date, to: Date())
                    ageLabel.text = String(compont.year!) + "岁"
                }
                
//                if model.partin_day != ""{
//                    let date = Date.dateFromString(dateStr: model.partin_day, formetStr: "yyyy-MM-dd")
//                    let compont = Calendar.current.dateComponents(
//                        [.year], from: date, to: Date())
//                    yearLabel.text = String(compont.year!) + "岁"
//                }
                
                
                if model.year != "" {
                    
                    yearLabel.text = model.year
                    
                }
                
                
                if model.picture != ""{
                    
                    let basicPath = URLPath.systemSelectionURL
                    
                    if model.picture.contains("http"){
                        
                        photoBtn.kf.setBackgroundImage(with: URL(string:model.picture), for: .normal)
                        
                    }else{
                        
                        let imageValue = basicPath.replacingOccurrences(of: "/api/", with: "") + "/" + model.picture
                        
                        photoBtn.kf.setBackgroundImage(with: URL(string:imageValue), for: .normal)
                        
                    }
                    
                    
                    //重新要求 来进行的设置 user 的图片
                    let user = User.currentUser()
                    user?.avatar = model.picture
                    user?.saveUser()
                    
                }
            }
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "个人中心"
        tableView.tableFooterView = UIView()
        getDate()
    }

    private func getDate(){
        
        HttpClient.instance.get(path: URLPath.getPersonInfo, parameters: nil, success: { (response) in
            
            if let dic = (response as? Array<[String: Any]>)?.first{
                
                self.model = PersonInfo(parmart: dic)
                
            }
            
        }) { (error) in
            
        }
    }
    
    // MARK: - 调用点击上传图片框架接口
    @IBAction func changePhotoBtnClick() {
        
        SJTakePhotoHandle.takePhoto(imageBlock: { image in
            
            self.photoBtn.setBackgroundImage(image, for: .normal)
            
            if let image = image{
                
                self.uploadImage(image: image)
            }
            
        }, viewController: self, select: 1)// 选择头像的是 1 最大
        
    }

    // MARK: - 更新后台的图片的接口
    func uploadImage(image:UIImage){
        
        HttpClient.instance.upDataImage(image) { (url) in
            
            HttpClient.instance.post(path: URLPath.savePersonIcon, parameters: ["url": url], success: { (response) in
                
                SVProgressHUD.showSuccess(withStatus: "上传成功")
                //重调一下接口 来刷新数据
                self.getDate()

            }) { (error) in
                
            }
        }
        
    }

}
