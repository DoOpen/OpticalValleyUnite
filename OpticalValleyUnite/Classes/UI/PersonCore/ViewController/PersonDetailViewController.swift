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
                    ageLabel.text = String(compont.year!) + "年"
                }
                
                if model.partin_day != ""{
                    let date = Date.dateFromString(dateStr: model.partin_day, formetStr: "yyyy-MM-dd")
                    let compont = Calendar.current.dateComponents(
                        [.year], from: date, to: Date())
                    yearLabel.text = String(compont.year!) + "年"
                }
                
                if model.picture != ""{
                    
                    let basicPath = URLPath.basicPath
                    let imageValue = basicPath.replacingOccurrences(of: "/api/", with: "") + model.picture
                    
                    photoBtn.kf.setBackgroundImage(with: URL(string:imageValue), for: .normal)
                    
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

    @IBAction func changePhotoBtnClick() {
        SJTakePhotoHandle.takePhoto(imageBlock: { image in
            self.photoBtn.setBackgroundImage(image, for: .normal)
            if let image = image{
                self.uploadImage(image: image)
            }
            
            
        }, viewController: self)
    }

    func uploadImage(image:UIImage){
        
        HttpClient.instance.upDataImage(image) { (url) in
            
            HttpClient.instance.post(path: URLPath.savePersonIcon, parameters: ["url": url], success: { (response) in
                
                SVProgressHUD.showSuccess(withStatus: "上传成功")

                
            }) { (error) in
                
            }

        }
    }

}
