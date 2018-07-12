//
//  YQCheckAchievementDetailVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/6/27.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQCheckAchievementDetailVC: UIViewController {

    //题目view
    @IBOutlet weak var scrollContentView: UIView!
    
    @IBOutlet weak var scrollContentHightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var headView: UIView!
    
    @IBOutlet weak var MiddleView: UIView!
    
    
  
    //选择题答案的整体选项
    @IBOutlet weak var answerTitleLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var answerView: UIView!
    @IBOutlet weak var answerViewHeightConstraint: NSLayoutConstraint!
    
    
    
    // MARK: - 底部按钮组
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var returnBtn: UIButton!
    
    @IBOutlet weak var upBtn: UIButton!
    
    @IBOutlet weak var bottomHightConstraint: NSLayoutConstraint!
    
    
    //数据data
    var dataArray = [YQSubjectModel]()
    //选择的索引
    var selectIndex = 1
    //缓存加载view
    var currentView : UIView?
    var currentAnswerView : UIView?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //1.init
        self.title = "题号" + "\(selectIndex)"
        
        //2.取模型进行判断执行
//        let QustionModel = self.dataArray[self.selectIndex - 1]
//        ClassificationOfQuestions(model: QustionModel)
        
        //3.题型选项的隐藏和判断
        checkBottomViewChangeFunction(Index: selectIndex)
        
       
    }


    // MARK: - 点击下一题
    @IBAction func nextButtonClick(_ sender: UIButton) {
        
        self.selectIndex += 1
        checkBottomViewChangeFunction(Index: selectIndex)
        
        self.currentView?.removeFromSuperview()
        //数据模型的导入方法
        
    }
    
    // MARK: - 点击上一题
    @IBAction func upButtonClick(_ sender: UIButton) {
        
        self.selectIndex -= 1
        checkBottomViewChangeFunction(Index: selectIndex)
        
        self.currentView?.removeFromSuperview()
        //数据模型的导入方法
        
    }
    
    // MARK: - 最后点击返回按钮的情况
    @IBAction func returnButtonClick(_ sender: UIButton) {
        
        //达到最后一题之后点击,返回按钮
        self.navigationController?.popViewController(animated: true)

    }
    
    // MARK: - bottomButton的显示状态的方法
    func checkBottomViewChangeFunction(Index : Int){
        
        if Index == 1 {//最开始 头
            
            self.upBtn.isHidden = true
            self.nextBtn.isHidden = false
            self.bottomHightConstraint.constant = 50
            
            
        }else if (Index == self.dataArray.count){//最尾部 末
            
            self.nextBtn.isHidden = true
            
            self.bottomHightConstraint.constant = 100
            
        }else{//中间的业务跳转
            
            self.upBtn.isHidden = false
            self.nextBtn.isHidden = false
            self.bottomHightConstraint.constant = 100
        }
        
        self.returnBtn.isHidden = !self.nextBtn.isHidden
        self.title = "题号" + "\(selectIndex)"
        
    }
    
    // MARK: - 判断各种的题型的方法
    func ClassificationOfQuestions(model : YQSubjectModel){
        
        switch model.type {
            //题目类型. 1单选 2多选 3判断 4填空 5问答
            case 1://单选
                creatSingleChoiceQuestion(model: model)
                break
            
            case 2://多选
                creatSingleChoiceQuestion(model: model)
                break
            
            case 3://判断
                creatJudgmentProblem(model: model)
                break
            
            case 4://填空
                creatCompletionQuestion(model: model)
                break
            
            case 5://问答
                creatQuestionAndAnswerQuestion(model: model)
                break
            
            default:
                break
            
        }

    }
    
    
    // MARK: - 创建各种题型的方法
    //单选题,多选题的创建的核心代码逻辑
    func creatSingleChoiceQuestion(model : YQSubjectModel){
        
        
        
        let view = UIView()
        
        let choose = model.choose
        //let chooseArray = choose.components(separatedBy: "$")
        
        let isRight = model.isRight
        
        let answer = model.answer
        
        //0..<model.optionDetail.count
        for indexxx in 0..<model.optionDetail.count {
            
            let AchievementV = Bundle.main.loadNibNamed("YQCheckAchievementDetailV", owner: nil
                , options: nil)?[0] as! YQCheckAchievementDetailV
            
            let dict = model.optionDetail[indexxx]
            let options = dict["option"] as? String ?? ""
            let string = dict["optionContent"] as? String ?? ""
            
            AchievementV.optionLabel.text = options + string
            
            if isRight == 1 {
                
                if choose.contains(options) {
                    
                    AchievementV.isRight = true
                }
                
            }else{
                
                if answer.contains(options){
                    
                    AchievementV.isRight = true
                    
                }else if (choose.contains(options)){
                    
                    AchievementV.isRight = false
                }
                
            }
            
            //布局约束
            if indexxx == 0 {
                
                view.addSubview(AchievementV)
                
                AchievementV.snp.makeConstraints({ (maker) in
                    
                    maker.top.left.right.equalToSuperview()
                    maker.height.equalTo(moreQuestionHeight)
                    
                })
                
            }else{
                
                let lastSubV = view.subviews.last
                view.addSubview(AchievementV)
                
                AchievementV.snp.makeConstraints({ (maker) in
                    
                    maker.top.equalTo((lastSubV?.snp.bottom)!)
                    maker.left.right.equalToSuperview()
                    maker.height.equalTo(moreQuestionHeight)
                    
                })
            }
        }
        
        self.currentView = view
        self.scrollContentView.addSubview(view)
        
    }
    
    //多选题
    func creatMoreChoiceQuestion(model : YQSubjectModel){
        
        let view = UIView()
        
        let choose = model.choose
        let chooseArray = choose.components(separatedBy: "$")
        
        //0..<model.optionDetail.count
        for indexxx in 0..<model.optionDetail.count {
            
            let AchievementV = Bundle.main.loadNibNamed("YQCheckAchievementDetailV", owner: nil
                , options: nil)?[0] as! YQCheckAchievementDetailV
            
            let dict = model.optionDetail[indexxx]
            let options = dict["option"] as? String ?? ""
            let string = dict["optionContent"] as? String ?? ""
            
            AchievementV.optionLabel.text = options + string
            
            //布局约束
            if indexxx == 0 {
                
                view.addSubview(AchievementV)
                
                AchievementV.snp.makeConstraints({ (maker) in
                    
                    maker.top.left.right.equalToSuperview()
                    maker.height.equalTo(moreQuestionHeight)
                    
                })
                
            }else{
                
                let lastSubV = view.subviews.last
                view.addSubview(AchievementV)
                
                AchievementV.snp.makeConstraints({ (maker) in
                    
                    maker.top.equalTo((lastSubV?.snp.bottom)!)
                    maker.left.right.equalToSuperview()
                    maker.height.equalTo(moreQuestionHeight)
                    
                })
            }
        }
        
        self.currentView = view
        self.scrollContentView.addSubview(view)
    }
    
    //判断题
    func creatJudgmentProblem(model : YQSubjectModel){
      
        let view = UIView()
        
        let choose = model.choose
        
        //创建 是否 两个选项
        for indexxx in 0..<2 {
            
            let AchievementV = Bundle.main.loadNibNamed("YQCheckAchievementDetailV", owner: nil
                , options: nil)?[0] as! YQCheckAchievementDetailV
            
            let dict = model.optionDetail[indexxx]
            let options = dict["option"] as? String ?? ""
            
            
            //布局约束
            if indexxx == 0 {
                
                AchievementV.optionLabel.text = options + " 是"
                view.addSubview(AchievementV)
                
                AchievementV.snp.makeConstraints({ (maker) in
                    
                    maker.top.left.right.equalToSuperview()
                    maker.height.equalTo(moreQuestionHeight)
                    
                })
                
            }else{
                
                AchievementV.optionLabel.text = options + " 否"
                
                let lastSubV = view.subviews.last
                view.addSubview(AchievementV)
                
                AchievementV.snp.makeConstraints({ (maker) in
                    
                    maker.top.equalTo((lastSubV?.snp.bottom)!)
                    maker.left.right.equalToSuperview()
                    maker.height.equalTo(moreQuestionHeight)
                    
                })
            }
        }
    }
    
    //填空题
    func creatCompletionQuestion(model : YQSubjectModel){
        
        let Completion = YQCompletionQuestionV()
        
        for indexxx in 0..<model.optionDetail.count{
            
            Completion.labelContent = "填空题" + "\(indexxx)"
            Completion.textViewContent =  "\(indexxx)" + "."
            
        }
        
        self.scrollContentView.addSubview(Completion)
        self.currentView = Completion
        
        Completion.snp.makeConstraints({ (maker) in
            
            maker.top.equalToSuperview()
            maker.left.right.bottom.equalToSuperview().offset(20)
            
        })
        
        addAnswerXib(answer: model.answer)
        
    }
    
    //简答题
    func creatQuestionAndAnswerQuestion(model : YQSubjectModel){
        
        let ShortAnswerQuestionsV = Bundle.main.loadNibNamed("YQShortAnswerQuestionsV", owner: nil, options: nil)?[0] as! YQShortAnswerQuestionsV
        
        self.scrollContentView.addSubview(ShortAnswerQuestionsV)
        
        self.currentView =  ShortAnswerQuestionsV
        
        ShortAnswerQuestionsV.snp.makeConstraints { (maker) in
            
            maker.top.equalTo(self.headView.snp.bottom)
            maker.height.equalTo(200)
            maker.left.right.equalToSuperview().offset(20)
            
        }
        
        //添加答案
        addAnswerXib(answer: model.answer)
        
    }
    
    // MARK: - 创建添加答案的方法
    func addAnswerXib(answer : String){
        
        self.currentAnswerView?.removeFromSuperview()
        
        let answerV = Bundle.main.loadNibNamed("YQAnswerAndShortAnswerV", owner: nil, options: nil)?[0] as! YQAnswerAndShortAnswerV
        
        answerV.answerTextV.text = answer
        
        self.answerViewHeightConstraint.constant = 120
        self.answerView.addSubview(answerV)
        
        answerV.snp.makeConstraints { (maker) in
            
            maker.top.bottom.left.right.equalToSuperview()
        }
        
        self.currentAnswerView = answerV
        
    }
    

}
