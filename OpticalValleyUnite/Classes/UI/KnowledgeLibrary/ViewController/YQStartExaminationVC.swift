//
//  YQStartExaminationVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/6/22.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD

class YQStartExaminationVC: UIViewController {

    @IBOutlet weak var headView: UIView!
    
    //试题列表
    @IBOutlet weak var titleLabel: UILabel!
    //题目数量
    @IBOutlet weak var countLabel: UILabel!
    //时间列表
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var scrollContentView: UIView!
    
    @IBOutlet weak var scrollHieghtConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var summaryLabel: UILabel!
    
    //bottomButton的选项属性
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var handOverButton: UIButton!
    
    let cell = "QuestionCollectionCell"
    
    //考试是否结束
    var isEnd = -1
    
    //题目数组(核心数据)
    //模型数组
    var subjectArray  = [YQSubjectModel]()
    
    
    
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
        self.title = "开始考试"
        //2.设置约束
        self.scrollContentView.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (maker) in
            
            maker.top.equalTo(self.headView.snp.bottom)
            maker.bottom.equalTo(self.bottomView.snp.top)
            maker.left.right.equalToSuperview()
            
        }
        
        //3.获取总的数据量
        getStartExamDetailData()
        
        //4.模拟创建
        creatSingleChoiceQuestion()
        
        
    }

    @IBAction func startAnswerBtnClick(_ sender: UIButton) {
        //点击开始答题进行的从1开始
        let vc = YQStartExamDetailVC.init(nibName: "YQStartExamDetailVC", bundle: nil)
        
        self.navigationController?.pushViewController(vc, animated: true)
    
    }
    
    // MARK: - 获取考试数据详情的界面
    func getStartExamDetailData(){
        
        var par = [String : Any]()
        
        par["id"] = ""
        
        SVProgressHUD.show()
        
        HttpClient.instance.post(path: URLPath.getNewknowledgeOwnDetail, parameters: par, success: { (response) in
            
            SVProgressHUD.dismiss()
            let data = response as? Array<[String : Any]>
            
            if data == nil || (data?.isEmpty)! {
                
                SVProgressHUD.showError(withStatus: "没有更多数据!")
            }
            
            let dict = data![0]
            //是否结束
            self.isEnd = dict["isEnd"] as? Int ?? -1
            
            //时间
            let time = dict["time"] as? String ?? ""
            self.timeLabel.text = time + "分"
            
            //纪要
            let print = dict["points"] as? String ?? ""
            self.summaryLabel.text = print
            
            //题目数量
            let count = dict["count"] as? Int ?? 0
            self.countLabel.text = "\(count)" + "题"
            
            //题目数组
            let subjectDetail = dict["subjectDetail"] as? Array<[String : Any]>  //里面包含选项的数组id
            
            var tempArray = [YQSubjectModel]()
            
            for dict in subjectDetail!{
                
                tempArray.append(YQSubjectModel.init(dict: dict))
            }
            
            self.subjectArray = tempArray
            //取出第一个
            let first = tempArray.first
            
            if first?.type == 1 {//单选
                
                
            }else if (first?.type == 2){//多选
                
                
            }else if (first?.type == 3){//判断
                
                
            }else if (first?.type == 4){//填空
                
                
            }else if (first?.type == 5){//问答
                
                
            }
            
            
        }) { (error) in
            
            SVProgressHUD.showError(withStatus: "网络数据加载失败,请检查网络!")
        }
        
    }
    
    // MARK: - 创建各种题框的方法
    //单选题
    func creatSingleChoiceQuestion(){
        
        let SingleQuestion = Bundle.main.loadNibNamed("YQQuestionOptionView", owner: nil, options: nil)?[0] as? YQQuestionOptionView
        
        self.scrollContentView.addSubview(SingleQuestion!)
        
        SingleQuestion?.snp.makeConstraints({ (maker) in
            
            maker.top.equalTo(self.headView.snp.bottom).offset(20)
            maker.bottom.equalTo(self.bottomView.snp.top)
            maker.left.right.equalToSuperview()
            
        })
    }
    
    //多选题
    func creatMoreChoiceQuestion(){
        
        
    }
    
    //判断题
    func creatJudgmentProblem(){
        
        let JudgmentProblem = Bundle.main.loadNibNamed("", owner: nil, options: nil)?[0] as! YQJudgmentQuestionView
        
        self.scrollContentView.addSubview(JudgmentProblem)
        
        JudgmentProblem.snp.makeConstraints({ (maker) in
            
            maker.top.equalTo(self.headView.snp.bottom).offset(20)
            maker.bottom.equalTo(self.bottomView.snp.top)
            maker.left.right.equalToSuperview()
            
        })
        
    }
    
    //填空题
    func creatCompletionQuestion(){
        
        
    }
    
    //问答题
    func creatQuestionAndAnswerQuestion(){
        
        let ShortAnswerQuestionsV = Bundle.main.loadNibNamed("YQShortAnswerQuestionsV", owner: nil, options: nil)?[0] as! YQShortAnswerQuestionsV
        
        self.scrollContentView.addSubview(ShortAnswerQuestionsV)
        
        ShortAnswerQuestionsV.snp.makeConstraints { (maker) in
            
            maker.top.equalTo(self.headView.snp.bottom).offset(20)
            maker.bottom.equalTo(self.bottomView.snp.top)
            maker.left.right.equalToSuperview()
            
        }
    
    }
    
    
    
}

extension YQStartExaminationVC : UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return 21
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cell, for: indexPath) as? YQQuestionCollectionCell
        
        cell?.questionBtn.setTitle("\(indexPath.item + 1)", for: .normal)
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    
    
    
}
