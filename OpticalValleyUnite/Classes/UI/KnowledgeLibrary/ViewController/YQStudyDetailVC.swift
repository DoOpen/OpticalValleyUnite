//
//  YQStudyDetailVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/6/21.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit
import SVProgressHUD

class YQStudyDetailVC: UIViewController {

    @IBOutlet weak var studyTitleLabel: UILabel!
    
    @IBOutlet weak var studyContentTextV: UITextView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var dataArray = [String]()
    var attachmentPdfPathArray = [String]()
    
    var cellID = "StudyDetailCell"
    
    var id = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //1.init
        self.title = "培训详情"
        
        //2.注册原型cell
        let nib = UINib.init(nibName: "YQStudyDetailCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: cellID)
        
        //3.获取网络的数据
        self.getDetailDataForServer()
        
    }
    
    
    func getDetailDataForServer(){
        
        var par = [String : Any]()
        par["id"] = self.id
        
        SVProgressHUD.show()
        
        HttpClient.instance.post(path: URLPath.getNewknowledgeDetail, parameters: par, success: { (response) in
            SVProgressHUD.dismiss()
            
            let data = response as? [String : Any]
            
            if data == nil {
                
                SVProgressHUD.showError(withStatus: "没有更多数据!")
                return
            }
            
            self.studyTitleLabel.text = data!["title"] as? String ?? ""
            self.studyContentTextV.text = data!["content"] as? String ?? ""
            
            let urlString = data!["attachmentName"] as? String ?? ""
            let urlArray = urlString.components(separatedBy: ",")
            
            let attachmentPdfPath = data!["attachmentPdfPath"] as? String ?? ""
            //let attachmentPath = data!["attachmentPath"] as? String ?? ""
            
            self.attachmentPdfPathArray = attachmentPdfPath.components(separatedBy: ",")
            self.dataArray = urlArray
            //转化直播的pdf地址数组
            
            self.tableView.reloadData()
            
        }) { (error) in
            
            SVProgressHUD.showError(withStatus: "网络数据加载失败,请检查网络!")
        }

    }
    
}

extension YQStudyDetailVC : UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! YQStudyDetailCell
        cell
        .titleButton.setTitle(self.dataArray[indexPath.row], for: .normal)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let str = attachmentPdfPathArray[indexPath.row]
        
        let vc = YQEditTextVC.init(nibName: "YQEditTextVC", bundle: nil)
        vc.urlString = str
        vc.id = self.id
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
