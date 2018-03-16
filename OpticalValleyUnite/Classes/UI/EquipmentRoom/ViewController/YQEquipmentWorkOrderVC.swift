//
//  YQEquipmentWorkOrderVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/2/27.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh

class YQEquipmentWorkOrderVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    //dataAarry
    var currentDatas = [WorkOrderModel2]()
    
    //currentIndex
    var pageNo = 0
    
    var siftsiftParmat : [String : Any]?
    
    var siftVc: YQEquipmentSiftVC?
    
    
    @IBOutlet weak var waittingHandleBtn: UIButton!
    var currentSelectBtn : UIButton?
    
    //项目id
    var parkID = "parkID"
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.title = "设备房工单列表"
        self.waittingHandleBtn.isSelected = true
        self.currentSelectBtn = self.waittingHandleBtn
        
        let nib = UINib(nibName: "WorkOrder2Cell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0

        
        //1.添加rightBarButton
        addLeftRightBarButtonFunction()
        
        //2.添加上拉,下拉
        addRefirsh()
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let parkID = getUserDefaultsProject()
        
        if self.parkID != parkID {
            
            self.parkID = parkID
            
            getWorkOrderForServer(tag: (self.currentSelectBtn?.tag)!)
            
        }
        
        
    }
    
    
    // MARK: - 添加左右barItem的情况
    func addLeftRightBarButtonFunction(){
      
        let rightBtn = UIButton()
        rightBtn.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        rightBtn.setImage(UIImage.init(name: "筛选"), for: .normal)
        rightBtn.addTarget(self, action: #selector(rightBarButtonClick), for: .touchUpInside)
        let batItem2 = UIBarButtonItem()
        batItem2.customView = rightBtn
        
        self.navigationItem.rightBarButtonItem = batItem2
        
    }
    
    func rightBarButtonClick(){
        
        //跳转到筛选的界面情况
        let vc = UIStoryboard.instantiateInitialViewController(name: "YQEquipmentSiftVC") as! YQEquipmentSiftVC
        
        //传递筛选条件,进行缓存和保存
        vc.siftParmat = self.siftsiftParmat
        
        siftVc = vc
        
        let subView = vc.view
        
        subView?.frame = CGRect(x: 100, y: 0, width: SJScreeW - 100, height: SJScreeH)
        CoverView.show(view: subView!)
        
        //点击筛选的完成的 block的回调的情况
        /*
         实现的思路是: 综合拼接响应的筛选的结果
         */
        vc.doenBtnClickHandel = { parmat in
            
            if parmat.isEmpty{//为空的话
                
                self.siftsiftParmat = nil
                //在闭包的 回调中 拿到了选择的参数, 进行重新的网络请求,数据的刷新
                self.getWorkOrderForServer(tag: (self.currentSelectBtn?.tag)!)
                
            }else{
                
                self.siftsiftParmat = parmat
                self.getWorkOrderForServer(tag: (self.currentSelectBtn?.tag)!)
                
            }
            
            subView?.superview?.removeFromSuperview()
            self.siftVc = nil
        }


    }
    
    
    @IBAction func selectButtonClickAction(_ sender: UIButton) {
        
        self.currentSelectBtn?.isSelected = false
        sender.isSelected = true
        self.currentSelectBtn = sender
        
        //拉取网络数据
        self.getWorkOrderForServer(tag: (self.currentSelectBtn?.tag)!)
        
    }
    
    

    
    // MARK: - 获取默认的项目的值来显示
    func getUserDefaultsProject() -> String {
        
        let dic = UserDefaults.standard.object(forKey: Const.YQProjectModel) as? [String : Any]
        
        var projectID  = ""
        
        if dic != nil {
            
            projectID = dic?["ID"] as! String
        }
        
        return projectID
        
    }
    
    
    // MARK: - 获取网络请求的数据
    func getWorkOrderForServer(tag : Int ,pageIndex : Int = 0, pageSize : Int = 20,parmert : [String : Any] = [String : Any]()){
        
        var par = [String : Any]()
        
        par["isEquipHouse"] = 1
        par["pageSize"] = pageSize
        par["pageIndex"] = pageIndex
        
        par["PARK_ID"] = self.parkID
        
        if self.parkID == "" {
        
            let project = UIStoryboard.instantiateInitialViewController(name: "YQAllProjectSelect")
            self.navigationController?.pushViewController(project, animated: true)
            
            return
        }
        
        switch tag {
            
            case 1://待处理
                par["STATUS"] = "DCL"

                break
            case 2://待处理
                par["STATUS"] = "YCL"

                break

            default:
                break
        }
        
        for (key,value) in parmert{
            par[key] = value
        }

        //经过筛选项,筛选的条件
        if let dic = siftsiftParmat{
            for (key,value) in dic{
                
                par[key] = value
            }
        }

        
        SVProgressHUD.show()
        
        HttpClient.instance.post(path: URLPath.getEquipWorkunitList, parameters: par, success: { (response) in
            
            SVProgressHUD.dismiss()
            
            let data = response["data"] as? Array<[String: Any]>
            
            if data == nil {
            
                SVProgressHUD.showError(withStatus: "没有更多数据!")
                self.currentDatas.removeAll()
                
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.endRefreshing()
                
                return
            }
            
            var temp = [WorkOrderModel2]()
            
            for dic in data!  {
                
                let model = WorkOrderModel2(parmart: dic)
                
                temp.append(model)
            }
            
            if pageIndex == 0{
                
                self.pageNo = 0
                self.currentDatas = temp
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.resetNoMoreData()
                
            }else{
                
                if temp.count > 0{
                    
                    self.pageNo = pageIndex
                    self.currentDatas.append(contentsOf: temp)
                    self.tableView.mj_footer.endRefreshing()
                    
                }else{
                    
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                    
                }
            }
            
            self.tableView.reloadData()
    
        }) { (error) in
            
            SVProgressHUD.showError(withStatus: "数据加载失败,请检查网络!")
        }
    }
    
    func addRefirsh(){
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            
            self.getWorkOrderForServer(tag: (self.currentSelectBtn?.tag)!)
        })
        
        
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            
            self.getWorkOrderForServer(tag: (self.currentSelectBtn?.tag)!, pageIndex: self.pageNo + 1)
        })
    }


}

extension YQEquipmentWorkOrderVC: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return currentDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: WorkOrder2Cell //注意的是,细小的bug 两个的cell是不同的模型,应用的WorkOrder2Cell-> 2的cell模型
        
        cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! WorkOrder2Cell
        cell.model2 = currentDatas[indexPath.row]
        
        return cell
    }
    
    
}

