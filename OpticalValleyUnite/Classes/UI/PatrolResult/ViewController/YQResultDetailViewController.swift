//
//  YQResultDetailViewController.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/12/9.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit
import SVProgressHUD


class YQResultDetailViewController: UIViewController {
    
    /// 属性列表
    var insResultId : Int = 0
    
    @IBOutlet weak var pointName: UILabel!
    
    @IBOutlet weak var patrolPerson: UILabel!
    
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var patrolTime: UILabel!
    
    @IBOutlet weak var patrolPointType: UILabel!
    
    @IBOutlet weak var headScrollView: UIScrollView!
    
    @IBOutlet weak var contentScrollView: UIScrollView!
    
    
    //定义的数据的模型数组
    var modelData = [YQResultDetailModel](){
        
        didSet{
            
            let y = 0
            let width = 150
            let height = self.headScrollView.height
            
            //创建上下两个scrollView内容详情
            for count in 0..<modelData.count{
                
                let x = count * width
                let model = modelData[count]
                
                //创建headButton的属性
                let button = UIButton()
                button.tag = count
                button.setTitle(model.name, for: .normal)
                button.frame = CGRect.init(x: x, y: y, width: width, height: Int(height))
                button.setTitleColor(UIColor.blue, for: .normal)
                button.addTarget(self, action: #selector(headScrollViewBtnClick(btn :)), for: .touchUpInside)
                self.headScrollView.addSubview(button)
                
                //通过 checkType的值来进行的判断
                let xxx = self.contentScrollView.width *  CGFloat(count)
                
                
                switch model.checkType {
                case 1://是否达标
                    let weather = Bundle.main.loadNibNamed("YQWeatherResult", owner: nil, options: nil)?[0] as! YQWeatherResult
                    weather.frame = CGRect.init(x: xxx, y: CGFloat(y), width: self.contentScrollView.width, height: self.contentScrollView.height)
                    weather.model = model
                    weather.superVC = self
                    
                    self.contentScrollView.addSubview(weather)
                    
                    break
                    
                case 2://评分
                    
                    let Score = Bundle.main.loadNibNamed("YQScoreResult", owner: nil, options: nil)?[0] as! YQScoreResult
                    
                    Score.frame = CGRect.init(x: xxx, y: CGFloat(y), width: self.contentScrollView.width, height: self.contentScrollView.height)
                    Score.model = model
                    Score.superVC = self
                    
                    self.contentScrollView.addSubview(Score)

                    break
                    
                default:
                    break
                }
            
            
            }
            
            self.headScrollView.contentSize = CGSize.init(width: CGFloat(modelData.count * width), height: 0)
            
            self.contentScrollView.contentSize = CGSize.init(width: CGFloat(modelData.count) * self.contentScrollView.width, height: 0)
        
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "巡查结果"
        self.automaticallyAdjustsScrollViewInsets = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
         makeUpDetailData()
    }
    
    // MARK: - 获取数据的详情
    func makeUpDetailData(){
    
        var par = [String : Any]()
        
        par["insResultId"] = insResultId
        
        SVProgressHUD.show()
        
        
        HttpClient.instance.post(path: URLPath.getResultDetail, parameters: par, success: { (response) in
            
            SVProgressHUD.dismiss()
            
            let dic = response as? NSDictionary
            self.pointName.text = dic?["insPointName"] as? String
            self.patrolPerson.text = dic?["personName"] as? String
            self.patrolTime.text = dic?["insTime"] as? String
            
            let type = dic?["insType"] as? Int ?? 0
            
            switch type {
                
            case 1:
                 self.patrolPointType.text = "室内"
                break
            case 2:
                 self.patrolPointType.text = "室外"
                break
            default:
                break
            }
            
            let insType = dic?["type"] as? Int ?? 0 // type
            
            switch insType {
                
            case 1:
                self.typeLabel.text = "视频巡查"
                break
            case 2:
                self.typeLabel.text = "人工巡查"
                break
            default:
                break
            }

           
            let detail = response["detil"] as? NSArray
            //字典转模型数组的情况
            var modelTemp = [YQResultDetailModel]()
            
            for temp in detail! {
                
                modelTemp.append(YQResultDetailModel.init(dic: temp as! [String : Any]))
            
            }
            
            self.modelData = modelTemp
        
        }) { (error) in
            
            SVProgressHUD.showError(withStatus: "数据加载失败,请检查网络!")
        }
    }
    
    func headScrollViewBtnClick(btn : UIButton) {
        
        let offsetX = CGFloat(btn.tag) * self.contentScrollView.width
        self.contentScrollView.setContentOffset(CGPoint.init(x: offsetX, y: 0), animated: true)
        
    }

}

extension YQResultDetailViewController : UIScrollViewDelegate {
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        // 获得当前需要显示的子控制器索引
        let index = contentScrollView.contentOffset.x / contentScrollView.frame.size.width
        
        self.headScrollView.setContentOffset(CGPoint.init(x: index * 150, y: 0), animated: true)
        
    }
    
}

