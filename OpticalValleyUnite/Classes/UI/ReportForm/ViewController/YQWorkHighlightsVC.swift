//
//  YQWorkHighlightsVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/1/18.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD


class YQWorkHighlightsVC: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    var cellID = "WorkHighlights"
    
    var height = 300
    
    var childsArray = [YQAddHighlights]()
    
    var id : Int = 0
    
    var parkID = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "工作亮点"
        
        let _ = setUpProjectNameLable()
        
        let view =  Bundle.main.loadNibNamed("YQAddHighlights", owner: nil, options: nil)?[0] as! YQAddHighlights
        view.frame = CGRect.init(x: 0, y: 0, width: Int(SJScreeW), height: height)
        childsArray.append(view)
        
        self.scrollView.contentSize = CGSize.init(width: 0, height:childsArray.count * (height + 5))
        
        self.scrollView.addSubview(view)
        
    }

    //取消
    @IBAction func cancelButtonClick(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }
    
    //确定
    @IBAction func makeSureButtonClick(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        var fristParmerte = [String : Any]()
        
        //调用保存接口,保存add工作计划报告
        var par = [String : Any]()
        par["id"] = id
        par["parkId"] = self.parkID
        
        
        var array = Array<[String : Any]>()
        
        let group = DispatchGroup()
        
        SVProgressHUD.show()
        
        for view in self.childsArray{
            
            var dict = [String : Any]()
            dict["lightspotTitle"] = view.highLightsText.text
            dict["lightspotContent"] = view.hightLightContentTextView.text
            
            let images = view.pictureAddView.photos.map { (image) -> UIImage in
                
                return image.image
            }
            
            group.enter()

            upDataImage(images, complit: { (url) in
                
                dict["imgPaths"] = url
                array.append(dict)
                group.leave()
                
            }, errorHandle: {
                
                group.leave()
            })

        }
        
        group.notify(queue: DispatchQueue.main) {
            
            par["lightspotList"] = array
            
            do{
                
                let jsonData = try JSONSerialization.data(withJSONObject: par, options: JSONSerialization.WritingOptions.prettyPrinted)
                
                if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8){
                    
                    //格式化的json字典的情况
                    print(JSONString)
                    
                    //注意的是这里的par 要求序列化json
                    fristParmerte["add"] = JSONString
                    
                }
                
            } catch {
                
                print("转换错误 ")
            }
            
            
            HttpClient.instance.post(path: URLPath.getReportAdd, parameters: fristParmerte, success: { (response) in
                SVProgressHUD.dismiss()
                SVProgressHUD.showSuccess(withStatus: "上传成功!")
                self.navigationController?.popViewController(animated: true)
                
            }) { (error) in
                
                SVProgressHUD.showError(withStatus: "保存失败,请检查网络!")
            }
        }
        
    }
    
    //添加
    @IBAction func addButtonClick(_ sender: UIButton) {
        
        let view =  Bundle.main.loadNibNamed("YQAddHighlights", owner: nil, options: nil)?[0] as! YQAddHighlights
        let y = childsArray.count * (height + 5)
        
        view.frame = CGRect.init(x: 0, y: y, width: Int(SJScreeW), height: height)
    
        self.scrollView.addSubview(view)
        childsArray.append(view)
        
        self.scrollView.contentSize = CGSize.init(width: 0, height:childsArray.count * (height + 5))
        
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
    
    // MARK: - 添加默认的项目选择方法
    func setUpProjectNameLable() -> String{
        
        let dic = UserDefaults.standard.object(forKey: Const.YQProjectModel) as? [String : Any]
        
        var projectName  = ""
        
        if dic != nil {
            
            projectName = dic?["PARK_NAME"] as! String
            self.parkID = dic?["ID"] as! String
            
        }else{
            
            projectName = "请选择默认项目"
        }
        
        return projectName
    }

 
}

extension YQWorkHighlightsVC : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        let boutton = UIButton()
        view.addSubview(boutton)
        
        return view
        
    }
    
}

