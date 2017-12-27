//
//  YQVideoDrawerViewController.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/12/4.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit
import SVProgressHUD
import KYDrawerController

class YQVideoDrawerViewController: UIViewController {
    ///属性列表:
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var patrolItemTagsView: RKTagsView!
    
    @IBOutlet weak var patrolRouteTagsView: RKTagsView!
    
    //scrollView的选项
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var scrollContentView: UIView!
    
    var parkID = ""
    
    var type : String = ""
    
    
    //加载的数据的模型
    var patrolItemArray = NSArray(){
        didSet{
            //缓存添加选项设置
            for index in 0 ..< patrolItemArray.count{
                
                let tag = patrolItemArray[index] as? NSDictionary
                
//                if projectname == tag.projectName{
//                    
//                    tag.selected = true
//                    indexNum = index
//                }
                
                let string = (tag?["name"] as? String)!
                
                self.patrolItemTagsView.addTag(string)
                self.setTagsView(tagsView: patrolItemTagsView)
                self.patrolItemTagsView.delegate = self
            }

        
        }
    
    }
    
    var patrolRouteArray = NSArray(){
        didSet{
            //缓存添加选项设置
            for index in 0 ..< patrolRouteArray.count{
                
                let tag = patrolRouteArray[index] as? NSDictionary
                
                //                if projectname == tag.projectName{
                //
                //                    tag.selected = true
                //                    indexNum = index
                //                }
                
                self.patrolRouteTagsView.addTag((tag?["wayName"] as? String)!)
                self.setTagsView(tagsView: patrolRouteTagsView)
                self.patrolItemTagsView.delegate = self
            }

        }
    }
    
    
    // MARK: - 视图生命周期的方法
    override func viewDidLoad() {
        super.viewDidLoad()
        //0.获取parkID
        let _ = setUpProjectNameLable()
        
        self.scrollView.contentSize = CGSize.init(width: 0, height: 600)
        self.searchBar.delegate = self
        
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //1.获取网络数据
        makeUpTagViewData()

    }
    
    // MARK: - 获取数据的方法
    func makeUpTagViewData(pointName : String = ""){
        
        var par = [String : Any]()
        par["parkId"] = self.parkID
        par["insPointName"] = pointName
        
        SVProgressHUD.show()
        //查巡查项
        HttpClient.instance.post(path: URLPath.getVideoPatrolAllItemType, parameters: par, success: { (response) in
            SVProgressHUD.dismiss()
            //设置数据添加到tagview
            self.patrolItemArray = response as! NSArray
            
        }) { (error) in
            
            SVProgressHUD.showError(withStatus: "数据加载失败,请检查网络!")
        }
        
        //查巡查路线
        HttpClient.instance.post(path: URLPath.getVideoPatrolLoadWayName, parameters: par, success: { (response) in
            SVProgressHUD.dismiss()
            //设置数据添加到tagview
            self.patrolRouteArray = response as! NSArray

        }) { (error) in
            
            SVProgressHUD.showError(withStatus: "数据加载失败,请检查网络!")
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
    
    
    // MARK: - tagsView的默认的设置的方法
    private func setTagsView(tagsView: RKTagsView,tags: [String]? = nil){
        tagsView.editable = false
        tagsView.selectable = true
        tagsView.lineSpacing = 15
        tagsView.interitemSpacing = 15
        tagsView.allowsMultipleSelection = true
        tagsView.delegate = self
        
        if tags != nil{
            
            for tag in tags!{
                tagsView.addTag(tag)
            }
        }
    }


    // MARK: - 重置,完成按钮的点击的情况
    @IBAction func resetButtonClick(_ sender: UIButton) {
        //重置数据选择数据
        self.patrolItemTagsView.deselectAll()
        self.patrolRouteTagsView.deselectAll()
        self.searchBar.text = ""
        
        self.type = "0"
    }
    
    @IBAction func compeleteButtonClick(_ sender: UIButton) {
        
        self.searchBar.text = ""
        
        var par = [String : Any]()
        par["parkId"] = self.parkID
        par["type"] = self.type
        
        if self.type == "0"{
            
            //重新的调用显示的- 地图所有点的情况!
            
            
            //回弹的方法接口
            if let drawerController = self.navigationController?.parent as? KYDrawerController {
                
                drawerController.setDrawerState(.closed , animated: true)
            }
            
            return
        }
        
        switch self.type {
            
        case "1"://根据巡查项类型查询
            let array = self.patrolItemTagsView.selectedTagIndexes
            var ItemTypeIds = ""
            for indexes in array {
                let typeDict = self.patrolItemArray[Int(indexes)] as! NSDictionary
                let id = typeDict["insItemTypeId"] as? Int ?? -1
                if ItemTypeIds == "" {
                    ItemTypeIds = "\( id)"
                }else{
                    
                    ItemTypeIds = ItemTypeIds + "," + ("\( id)")
                }
            }
            
            par["insItemTypeIds"] = ItemTypeIds
            
            break
        
        case "2"://根据巡查路线id查询
            
            let array = self.patrolRouteTagsView.selectedTagIndexes
            
            var wayIds = ""
            
            for indexes in array {
                
                let typeDict = self.patrolRouteArray[Int(indexes)] as? NSDictionary
                let id = typeDict?["insWayId"] as? Int ?? -1
                if wayIds == "" {
                    
                    wayIds = "\(id)"
                }else{
                    
                    wayIds = wayIds + "," + "\(id)"
                }
            }

            par["wayIds"] = wayIds
            break
            
        default:
            break
        }
        
        
        SVProgressHUD.show()
        
        HttpClient.instance.post(path: URLPath.getVideoPatrolMapByType, parameters: par, success: { (response) in
            
            SVProgressHUD.dismiss()
            
            let allDrawArray = NSMutableArray()
            
            //传递数据,重绘渲染
            for dict in response as! NSArray {
                
                let tempDict = dict as? NSDictionary
                let drawAarray = tempDict?["pointList"] as! NSArray
                allDrawArray.add(drawAarray)
            
            }
            
            //发送通知进行传值
            let center = NotificationCenter.default
            let notiesName = NSNotification.Name(rawValue: "drawerVideoLoadWaysNoties")
            center.post(name: notiesName, object: nil, userInfo: ["VideoLoadWaysArray": allDrawArray])
            
            
        }) { (error) in
            
            SVProgressHUD.showError(withStatus: "数据加载失败,请检查网络!")
        }
        
    }
    
}

extension YQVideoDrawerViewController : RKTagsViewDelegate {

    func tagsView(_ tagsView: RKTagsView, shouldSelectTagAt index: Int) -> Bool {
        
        if tagsView == patrolItemTagsView {
            
            self.patrolRouteTagsView.deselectAll()
            self.type = "1"
            
        }else{
            
            self.patrolItemTagsView.deselectAll()
            self.type = "2"
        }
        
        return true
    }

}

extension YQVideoDrawerViewController : UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(false)
        
        self.patrolItemTagsView.removeAllTags()
        self.patrolRouteTagsView.removeAllTags()
        //重新刷新数据
        self.makeUpTagViewData(pointName: self.searchBar.text!)
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.searchBar.endEditing(false)
        
    }
    
}
