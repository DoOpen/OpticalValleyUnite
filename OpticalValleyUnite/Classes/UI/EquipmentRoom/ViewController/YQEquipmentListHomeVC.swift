//
//  YQEquipmentListHomeVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/2/27.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD
import MJRefresh

class YQEquipmentListHomeVC: UIViewController {
    
    //筛选条件view
    @IBOutlet weak var siftView: UIView!

    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var siftVc: YQEquipTypeTVC?
    var coverView : UIView?
    
    
    //弹簧变量
    var selectBool = false
    //选择的type
    var selectType : Int64 = 0
    //parkID
    var parkID = ""
    var parkName = ""
    
    //行高缓存
    var heightDict = [String : Any]()
    var cellID = "EquipHomeListCell"
    
    var currentIndex = 0
    
    var dataArray = [YQEquipHomeListModel](){
        didSet{
            
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "设备房列表"
        
        //1.上拉,下拉数据刷新
        addRefirsh()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
    
        let newName = setUpProjectNameLable()
        
        if self.parkName != newName {
        
            getDataForServer()
            self.parkName = newName

        }
        
    }
    
    
    // MARK: - 查询按钮的点击
    @IBAction func searchButtonClick(_ sender: UIButton) {
        
        if selectType == 0 {
            
            //查全部
            getDataForServer( searchText: searchTextField.text!)
        
        }else {
            
            getDataForServer( type: selectType, searchText: searchTextField.text!)
        }
        
    }
    
    // MARK: - 设备房类别按钮点击
    @IBAction func equipmentTypeClick(_ sender: UIButton) {
        //点击弹出tableView.图片转化
        selectBool = !selectBool
        
        if selectBool {
            
            self.imageView.image = UIImage.init(name: "caret_up")
            
            //创建蒙版视图
            let coverV = UIView()
            coverV.backgroundColor = UIColor.init(red: 180/255.0, green: 180/255.0, blue: 180/255.0, alpha: 0.7)
            self.coverView = coverV

            self.view.addSubview(coverV)
            
            self.coverView?.snp.makeConstraints({ (maker) in
                
                maker.top.equalTo(self.siftView.snp.bottom)
                maker.left.right.bottom.equalToSuperview()
                
            })
            
            //创建siftVC选择控制器
            let siftTypeVC = UIStoryboard.instantiateInitialViewController(name: "YQEquipTypeTVC") as! YQEquipTypeTVC
            siftTypeVC.selectTypeString = selectType
            
            self.siftVc = siftTypeVC
            let v =  siftTypeVC.view
            
            self.view.addSubview(v!)

            v?.snp.makeConstraints({ (maker) in
                
                maker.bottom.equalTo(self.view.snp.top)
                maker.left.right.equalToSuperview()
                maker.height.equalTo(280)
                
            })
            
            UIView.animate(withDuration: 0.25, animations: {
                
                v?.snp.removeConstraints()
                
                v?.snp.makeConstraints({ (maker) in
                    
                    maker.top.equalTo(self.siftView.snp.bottom)
                    maker.left.right.equalToSuperview()
                    maker.height.equalTo(280)
                })

            })

            
        }else{
            
            self.imageView.image = UIImage.init(name: "caret_down")
            
            UIView.animate(withDuration: 0.25, animations: {
                
                self.siftVc?.view.snp.removeConstraints()
                
                self.siftVc?.view.snp.makeConstraints({ (maker) in
                    
                    maker.bottom.equalTo(self.view.snp.top)
                    maker.left.right.equalToSuperview()
                    maker.height.equalTo(200)
                })

            }, completion: { (Bool) in
                
                self.coverView?.removeFromSuperview()
                
                self.siftVc?.view.removeFromSuperview()
                
            })
        }
        
        
        //选择sift的控制器要求回调函数
        self.siftVc?.selectCellClickHandel = { parmat in
            
            //拿出id 进行筛选调整
            self.selectType = (parmat["equipTypeId"] as? Int64 ?? 0)!
            
            //退出选项
            self.equipmentTypeClick(UIButton())
            //查询数据
            self.searchButtonClick(UIButton())
        }
        
    }
    
    // MARK: - 获取数据的相应方法
    func getDataForServer(pageIndex : Int = 0, pageSize : Int = 20, type : Int64 = 0, searchText : String = ""){
        
        var par = [String : Any]()
        if type != 0 {
            
            par["equipTypeId"] = type
        }
        
        if searchText != "" {
        
            par["equipHouseName"] = searchText
        }
        
        
        par["pageIndex"] = pageIndex
        par["pageSize"] = pageSize
        
        
        par["parkId"] = self.parkID
        
        if self.parkID == "" {
            
            let project = UIStoryboard.instantiateInitialViewController(name: "YQAllProjectSelect")
            self.navigationController?.pushViewController(project, animated: true)
            return
            
        }
        
        SVProgressHUD.show()
        
        HttpClient.instance.post(path: URLPath.getEquiphouseList, parameters: par, success: { (response) in
            
            SVProgressHUD.dismiss()
            
            let data = response["data"] as? Array<[String : Any]>
            
            if data == nil {
                
                SVProgressHUD.showError(withStatus: "没有获取更多数据")
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.endRefreshing()
                self.dataArray.removeAll()
                
                return
            }
            
            var tempData = [YQEquipHomeListModel]()
            
            for dict in data! {
                
                tempData.append(YQEquipHomeListModel.init(dict: dict))
            }
            
            //添加上拉下拉刷新的情况
            if pageIndex == 0 {
                
                self.dataArray = tempData
                self.tableView.mj_header.endRefreshing()
                
            }else{
                
                if tempData.count > 0{
                    
                    self.currentIndex = pageIndex
                    self.dataArray.append(contentsOf: tempData)
                }
                
                self.tableView.mj_footer.endRefreshing()
            }

            
        }) { (error) in
            
            SVProgressHUD.showError(withStatus: "网络数据加载失败,请检查网络!")
        }
        
    
    }
    
    // MARK: - 添加默认的项目选择方法
    func setUpProjectNameLable() -> String{
        
        let dic = UserDefaults.standard.object(forKey: Const.YQProjectModel) as? [String : Any]
        
        var projectName  = ""
        
        if dic != nil {
            
            projectName = dic?["PARK_NAME"] as! String
            self.parkID = (dic?["ID"] as? String)!
            
        }else{
            
            projectName = "请选择默认项目"
        }
        
        return projectName
    }
    
    // MARK: - 上下拉的刷新的界面情况
    func addRefirsh(){
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            
            if self.selectType == 0 {
                
                self.getDataForServer( searchText: self.searchTextField.text!)
                
            }else {
                
                self.getDataForServer( type: self.selectType, searchText: self.searchTextField.text!)
            }

        })
        
        
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            
            if self.selectType == 0 {
                
                self.getDataForServer( pageIndex : self.currentIndex + 1,searchText: self.searchTextField.text!)
                
            }else {
                
                self.getDataForServer( pageIndex : self.currentIndex + 1,type: self.selectType, searchText: self.searchTextField.text!)
            }
        })
        
    }


}


extension YQEquipmentListHomeVC : UITableViewDataSource,UITableViewDelegate{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //跳转到详情的界面
        let detail = UIStoryboard.instantiateInitialViewController(name: "YQEquipmentDetailList") as! YQEquipmentDetailListVC
        
        detail.houseId = self.dataArray[indexPath.row].houseId
        detail.equipHouseId = self.dataArray[indexPath.row].equipHouseId
        
        navigationController?.pushViewController(detail, animated: true)
        
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? YQEquipHomeListCell
        
        if cell == nil {
            
            cell = Bundle.main.loadNibNamed("YQEquipHomeListCell", owner: nil, options: nil)?[0] as? YQEquipHomeListCell
        }
        
        cell?.model = self.dataArray[indexPath.row]
        
        //强制更新cell的布局高度
        cell?.layoutIfNeeded()
        
        //缓存 行高
        //要求的定义的是 一个可变的字典的类型的来赋值
        heightDict["\(indexPath.row)"] = cell?.cellForHeight()
    
        return cell!
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return heightDict["\(indexPath.row)"] as! CGFloat
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
    
    
}
