//
//  ChoosePersonViewController.swift
//  OpticalValleyUnite
//
//  Created by 贺思佳 on 2017/1/20.
//  Copyright © 2017年 贺思佳. All rights reserved.
//

import UIKit
import SVProgressHUD

class ChoosePersonViewController: UIViewController,ShloudPopType {

    /*
     add 协助人的按钮的点击的 执行的block代码块的情况
     */
    @IBOutlet weak var addManageerView: AddScrollerView!
    @IBOutlet weak var execPeopleBtn: SJUpButton!
    @IBOutlet weak var managePeopleBtn: SJUpButton!
    
    //添加输入框备注框
    @IBOutlet weak var remarksTextView: SJTextView!
    
    
    weak var ProgressVC: WorkOrderProgressViewController?
    var workId = ""
    var parkId = ""
    
    var execPeopleModel: PersonModel?
    var managePeopleModel: PersonModel?
    var assePeopleModel: [PersonModel]?
    
    // MARK: - 添加执行人和 添加管理人的点击方法
    @IBAction func chooseBtnClick(_ sender: UIButton) {
        
        let vc = PeopleListViewController.loadFromStoryboard(name: "WorkOrder") as! PeopleListViewController
        vc.type = sender.tag
        vc.parkId = self.parkId
        vc.doneBtnClickHandel = didSelecte
            navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //设置text 默认的文字
        self.remarksTextView.placeHolder = "请输入备注内容"
        
        addManageerView.addBtnClickHandel = { [weak self] in
            
            let vc = PeopleListViewController.loadFromStoryboard(name: "WorkOrder") as! PeopleListViewController
            vc.type = 2
            vc.parkId = (self?.parkId)!
            vc.doneBtnClickHandel = self?.didSelecte
            self?.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    
    // MARK: - 完成按钮的点击,传输所有的输入的字段
    @IBAction func doneBtnClick() {
        
        if let execPeopleModel = execPeopleModel, let managePeopleModel = managePeopleModel{
            //添加备注消息的内容
            var parmat = [String: Any]()
            parmat["WORKUNIT_ID"] = workId
            parmat["EXEC_PERSON_ID"] = execPeopleModel.id
            parmat["MANAGE_PERSON_ID"] = managePeopleModel.id
            parmat["REMARK"] = self.remarksTextView.text
            
            if let assePeopleModel = assePeopleModel{
                var text = ""
                text = assePeopleModel.map{$0.id}.reduce("", {$0 + "," + $1})
                text = (text as NSString).replacingCharacters(in: NSMakeRange(0, 1), with: "")
                parmat["ASSES_PERSON_ID"] = text
                
                if (parmat["ASSES_PERSON_ID"] as! String).contains(execPeopleModel.id){
                    SVProgressHUD.showError(withStatus: "执行人能和协助人不能相同")
                    return
                }
            }

            if execPeopleModel.id == managePeopleModel.id{
                SVProgressHUD.showError(withStatus: "执行人能和管理人不能相同")
                return
            }
            
            SVProgressHUD.show(withStatus: "派发中")
            HttpClient.instance.post(path: URLPath.workunitDistribute, parameters: parmat, success: { (response) in
                SVProgressHUD.dismiss()
                SVProgressHUD.showSuccess(withStatus: "工单派发成功")
                
                self.ProgressVC?.reloadStatus(status: 1)
                
                _ = self.navigationController?.popViewController(animated: true)
                
            }, failure: { (error) in
                SVProgressHUD.dismiss()
            })
            
        }else{
            
            SVProgressHUD.showError(withStatus: "请选择所有人员后再点击派发")
        }
        
    }


    func didSelecte(type: Int, models: [PersonModel]){
        
        if type == 0 {
            
            execPeopleBtn.setTitle(models.first?.name, for: .normal)
            
            if let url = URL(string: (models.first?.icon)!){
                execPeopleBtn.kf.setImage(with: url, for: .normal)
                
            }else{
                
                execPeopleBtn.setImage(UIImage.normalImageIcon(), for: .normal)
            }
            
            execPeopleBtn.isHidden = false
            execPeopleModel = models.first
            
        }else if type == 1{
            
            managePeopleBtn.setTitle(models.first?.name, for: .normal)
            
            managePeopleBtn.kf.setImage(with: URL(string: (models.first?.icon)!), for: .normal)
            managePeopleBtn.isHidden = false
            managePeopleModel = models.first
            
            if let url = URL(string: (models.first?.icon)!){
                managePeopleBtn.kf.setImage(with: url, for: .normal)
            }else{
                managePeopleBtn.setImage(UIImage.normalImageIcon(), for: .normal)
            }
            
        }else if type == 2{
            
            addManageerView.models = models
            assePeopleModel = models
        }
        
    }
    

    func viewShloudPop(){
        
        if let _ = execPeopleModel, let _ = managePeopleModel, let _ = assePeopleModel{
            _ = navigationController?.popViewController(animated: true)
        }else{
            self.alert(message: "还没有选择人员派发,是否确认要退出", doneBlock: { (action) in
                _ = self.navigationController?.popViewController(animated: true)
            })
        }
    }
    

}

protocol ShloudPopType {
    
    func viewShloudPop()
}


extension UIImage{
    static func normalImageIcon() -> (UIImage){
        return UIImage(named: "avatar") ?? UIImage()
    }
}
