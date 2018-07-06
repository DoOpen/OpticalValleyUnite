//
//  YQAchievementDetailVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/6/22.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit
import SVProgressHUD


class YQAchievementDetailVC: UIViewController {

    @IBOutlet weak var headView: UIView!
    //试题属性列表
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var totalCountLabel: UILabel!
    
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var wrongLabel: UILabel!
    
    
    
    @IBOutlet weak var scrollContentView: UIView!
    
    let cell = "QuestionCollectionCell"
    
    @IBOutlet weak var returnBtn: UIButton!
    
    @IBOutlet weak var checkBtn: UIButton!
    //重点数据(试题的模型数组)
    var questionsArray = [YQSubjectModel]()
    
    
    //自定义的collectionView
    lazy var collectionView : UICollectionView = {
        
        let collectionV = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: self.flowLayout)
        
        collectionV.dataSource = self
        collectionV.delegate = self
        collectionV.backgroundColor = UIColor.white
        
        let nib = UINib.init(nibName: "YQQuestionCollectionCell", bundle: nil)
        //注册cell
        collectionV.register(nib, forCellWithReuseIdentifier: self.cell)
        
        return collectionV
    }()
    
    //自定义的流水布局
    lazy var flowLayout: UICollectionViewFlowLayout = {
        
        let width  = CGFloat((SJScreeW - 40) / 5)
        
        let flayout = UICollectionViewFlowLayout()
        //设置每个图片的大小
        flayout.itemSize = CGSize.init(width: width, height: width)
        //设置滚动方向的间距
        flayout.minimumLineSpacing = 5
        //设置上方的反方向
        flayout.minimumInteritemSpacing = 0
        //设置collectionView整体的上下左右之间的间距
        flayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        //设置滚动方向
        flayout.scrollDirection = UICollectionViewScrollDirection.vertical
        
        return flayout
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //1.init
        self.title = "成绩详情"
        //2.设置约束
        self.scrollContentView.addSubview(self.collectionView)
        
        self.collectionView.snp.makeConstraints { (maker) in
            
            maker.top.equalTo(self.headView.snp.bottom)
            maker.left.right.bottom.equalToSuperview()
            
        }

    }
    
    // MARK: - 获取成绩详情的数据接口
    func getAchievementsDataForServer(){
        
        var par = [String : Any]()
        
        //试卷id
        par["id"] = ""
        
        SVProgressHUD.show()
        
        HttpClient.instance.post(path: URLPath.getNewknowledgeOwnResultDetail, parameters: par, success: { (response) in
            
            SVProgressHUD.dismiss()
            
            let data = response as? [String : Any]
            
            if data == nil {
                
                SVProgressHUD.showError(withStatus: "没有更多数据!")
                return
            }
            
            //试卷name
            let name = data!["name"] as? String ?? ""
            self.titleLabel.text = name
            
            //考试时间
            let time = data!["time"] as? String ?? ""
            self.timeLabel.text = time
            
            //总题目数
            let count = data!["count"] as? Int ?? 0
            self.totalCountLabel.text = "共 " + "\(count)" + " 题"
            
            //答对多少题
            let correctCount = data!["correctCount"] as? Int ?? 0
            self.rightLabel.text = "\(correctCount)"
            
            //答错多少题
            let errorCount = data!["errorCount"] as? Int ?? 0
            self.wrongLabel.text = "\(errorCount)"
            
            //总得分
            let totalGrade = data!["totalGrade"] as? Int ?? 0
            self.scoreLabel.text = "\(totalGrade)" + "分"
            
            //核心数据字典转模型的操作:
            let subjectDetail = data!["subjectDetail"] as? Array<[String : Any]>
            
            var tempArray = [YQSubjectModel]()
            
            for dict in subjectDetail!{
                
                tempArray.append(YQSubjectModel.init(dict: dict))
            }
            
            self.questionsArray = tempArray
            
            
        }) { (error) in
            
            SVProgressHUD.showError(withStatus: "数据加载失败,请检查网络!")
        }
    }
    
    
    // MARK: - 按钮点击的方法
    @IBAction func checkButtonClick(_ sender: UIButton) {
        
        //点击开始答题进行的从1开始
        let vc = YQCheckAchievementDetailVC.init(nibName: "YQCheckAchievementDetailVC", bundle: nil)
        //传递所有的数据,索引从1开始
        
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func returnButtonClick(_ sender: UIButton) {
        
        
    }
    


}

extension YQAchievementDetailVC : UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 21
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cell, for: indexPath) as? YQQuestionCollectionCell
        
        if indexPath.item % 2 == 0 {
            
            cell?.questionBtn.isSelected = true
        }
        cell?.questionBtn.setTitle("\(indexPath.item + 1)", for: .normal)
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //传递题型,查看某个题目情况
        let vc = YQCheckAchievementDetailVC.init(nibName: "YQCheckAchievementDetailVC", bundle: nil)
        //传递所有的数据以及 当前显示的题目情况
        vc.selectIndex = indexPath.row + 1
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    

}

