//
//  YQEquipmentDetailListVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/2/27.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit
import MJRefresh
import SVProgressHUD


class YQEquipmentDetailListVC: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var headScrollView: UIScrollView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    var dataArray = [YQEquipDetailListModel](){
        didSet{
        
            self.tableView.reloadData()
        }
    
    }
    
    var equipHouseId = 0
    
    var currentIndex = 0
    
    //选择的type
    var selectType : Int = 0
    //弹簧变量
    var selectBool = false
    
    var coverView : UIView?
    
    var siftVc: YQEquipTypeTVC?
    //行高缓存
    var heightDict = [String : Any]()
    var cellID = "EquipHomeListCell"
    
    //传值空间id
    var houseId = ""
    


    @IBOutlet weak var siftView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "设备房详情"
        
        //1.获取默认的项目
        self.automaticallyAdjustsScrollViewInsets = false
        
        //2.获取网络数据
        getDataForServer()
        
        //2.1获取传感器数据
        getHeadDataForServer()
        
        //3.上拉下拉刷新
        addRefirsh()
        
        
    }

    // MARK: - button点击的事件
    @IBAction func equipTypeClick(_ sender: UIButton) {
        
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
            siftTypeVC.isDetail = true
            siftTypeVC.houseId = self.houseId
            
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
            self.selectType = (parmat["equipTypeId"] as? Int)!
        }

    }
    
    @IBAction func searchButtonClick(_ sender: UIButton) {
        
        if selectType == 0 {
            
            getDataForServer( searchText: textField.text!)
            
        }else{
            
            getDataForServer( type: selectType, searchText: textField.text!)
        }
        
    }
    
    @IBAction func lookOutVideoClick(_ sender: UIButton) {
        
        //跳转到 视频相应的界面
        let video = YQWebVideoVC.init(nibName: "YQWebVideoVC", bundle: nil)
        video.equipHouseId = "\(self.equipHouseId)"
        
        navigationController?.pushViewController(video, animated: true)
        
    }
    
    
    // MARK: - 获取头部的数据相应方法
    func getHeadDataForServer(){
    
        var par = [String : Any]()
        par["equipHouseId"] = self.equipHouseId
        
        SVProgressHUD.show()
        
        HttpClient.instance.post(path: URLPath.getHouseSensorData, parameters: par, success: { (response) in
            
            SVProgressHUD.dismiss()
            
            let data = response as? Array<[String : Any]>
            
            if data == nil {
                
                SVProgressHUD.showError(withStatus: "没有加载更多数据!")
                
            }else{
                
                //scorllView 添加滚动的数据
                for indexxx in 0..<(data?.count)! {
                    
                    let dict = data?[indexxx]
                    
                    let sensorV = Bundle.main.loadNibNamed("YQSensorDetailView", owner: nil, options: nil)?[0] as! YQSensorDetailView
                    
                    let name = dict?["name"] as? String ?? ""
                    let val = dict?["val"] as? String ?? ""
                    let unit = dict?["unit"] as? String ?? ""
                    
                    sensorV.nameLabel.text = name
                    sensorV.valueLabel.text = val + unit
                    
                    //设置约束
                    sensorV.frame = CGRect.init(x: indexxx * 80, y: 0, width: 80, height: 80)
                    
                    self.headScrollView.addSubview(sensorV)
                    
                    //设置scrollView的contentsize 来体现滚动效果
                    if indexxx == (data?.count)! - 1 {
                    
                        self.headScrollView.contentSize = CGSize.init(width: (data?.count)! * 80 , height: 0)
                        
                    }
                    
                }
                
            }
            
            
            
            
        }) { (error) in
            
            SVProgressHUD.showError(withStatus: "网络数据加载失败,请检查网络!")

        }
    
    }
    
    
    // MARK: - 获取数据的相应方法
    func getDataForServer(pageIndex : Int = 0, pageSize : Int = 20, type : Int = 0, searchText : String = ""){
        
        var par = [String : Any]()
        
        par["houseId"] = self.houseId
        if type != 0 {
            
            par["equipTypeId"] = type
        }
        
        if searchText != "" {
            
            par["equipHouseName"] = searchText
        }
        
        
        par["pageIndex"] = pageIndex
        par["pageSize"] = pageSize
        
        par["equipHouseId"] = self.equipHouseId
        
        SVProgressHUD.show()
        
        HttpClient.instance.post(path: URLPath.getInnerEquip, parameters: par, success: { (response) in
            
            SVProgressHUD.dismiss()
            
            let data = response["data"] as? Array<[String : Any]>
            
            if data == nil {
                
                SVProgressHUD.showError(withStatus: "没有获取更多数据")
                self.scrollView.mj_header.endRefreshing()
                self.scrollView.mj_footer.endRefreshing()
                self.dataArray.removeAll()
                
                return
            }
            
            var tempData = [YQEquipDetailListModel]()
            
            for dict in data! {
                
                tempData.append(YQEquipDetailListModel.init(dict: dict))
            }
            
            //添加上拉下拉刷新的情况
            if pageIndex == 0 {
                
                self.dataArray = tempData
                self.scrollView.mj_header.endRefreshing()
                
            }else{
                
                if tempData.count > 0{
                    
                    self.currentIndex = pageIndex
                    self.dataArray.append(contentsOf: tempData)
                }
                
                self.scrollView.mj_footer.endRefreshing()
            }
            
            
        }) { (error) in
            
            SVProgressHUD.showError(withStatus: "网络数据加载失败,请检查网络!")
        }
    
    }


    // MARK: - 上下拉的刷新的界面情况
    func addRefirsh(){
        
        scrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            
            if self.selectType == 0 {
                
                self.getDataForServer( searchText: self.textField.text!)
                
            }else {
                
                self.getDataForServer( type: self.selectType, searchText: self.textField.text!)
            }
            
        })
        
        scrollView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            
            if self.selectType == 0 {
                
                self.getDataForServer( pageIndex : self.currentIndex + 1,searchText: self.textField.text!)
                
            }else {
                
                self.getDataForServer( pageIndex : self.currentIndex + 1,type: self.selectType, searchText: self.textField.text!)
            }
        })
    }

    

}

extension YQEquipmentDetailListVC : UITableViewDataSource,UITableViewDelegate{

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
//        let value = heightDict["\(indexPath.row)"] as! CGFloat
        
        return heightDict["\(indexPath.row)"] as! CGFloat
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? YQEquipHomeListCell
        
        if cell == nil {
            
            cell = Bundle.main.loadNibNamed("YQEquipHomeListCell", owner: nil, options: nil)?[0] as? YQEquipHomeListCell
        }
        
        cell?.detailModel = self.dataArray[indexPath.row]
        
        //强制更新cell的布局高度
        cell?.layoutIfNeeded()
        
        
        //缓存 行高
        //要求的定义的是 一个可变的字典的类型的来赋值
        self.heightDict["\(indexPath.row)"] = cell?.cellForHeight()
        
        return cell!

    }
    

}
