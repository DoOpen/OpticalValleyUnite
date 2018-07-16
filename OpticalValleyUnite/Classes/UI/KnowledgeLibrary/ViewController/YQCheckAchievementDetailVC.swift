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
    
    @IBOutlet weak var headViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var MiddleView: UIView!
    
    @IBOutlet weak var stemLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var showImageV: ShowImageView!
    
    
    @IBOutlet weak var showImageVConstraint: NSLayoutConstraint!
    
    //选择题答案的整体选项
    @IBOutlet weak var answerTitleLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    
    @IBOutlet weak var rightAnswerLabel: UILabel!
    
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
        let QustionModel = self.dataArray[self.selectIndex - 1]
        checkBottomViewChangeFunction(Index: selectIndex)
        ClassificationOfQuestions(model: QustionModel)
        
        
        //3.题型选项的隐藏和判断
        checkBottomViewChangeFunction(Index: selectIndex)
        
        
    }


    // MARK: - 点击下一题
    @IBAction func nextButtonClick(_ sender: UIButton) {
        
        self.selectIndex += 1
        checkBottomViewChangeFunction(Index: selectIndex)
        self.currentView?.removeFromSuperview()
        self.currentAnswerView?.removeFromSuperview()
        //数据模型的导入方法
        
        let QustionModel = self.dataArray[self.selectIndex - 1]
        ClassificationOfQuestions(model: QustionModel)
        
    }
    
    // MARK: - 点击上一题
    @IBAction func upButtonClick(_ sender: UIButton) {
        
        self.selectIndex -= 1
        checkBottomViewChangeFunction(Index: selectIndex)
        self.currentView?.removeFromSuperview()
        self.currentAnswerView?.removeFromSuperview()
        //数据模型的导入方法
       
        let QustionModel = self.dataArray[self.selectIndex - 1]
        ClassificationOfQuestions(model: QustionModel)
        
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
                self.currentAnswerView?.removeFromSuperview()
                creatSingleChoiceQuestion(model: model)
                break
            
            case 2://多选
                self.currentAnswerView?.removeFromSuperview()
                creatSingleChoiceQuestion(model: model)
                break
            
            case 3://判断
                self.currentAnswerView?.removeFromSuperview()
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
        
        self.stemLabel.text = model.question
        self.typeLabel.text = "单选题"
    
        let view = UIView()
        let choose = model.choose.replacingOccurrences(of: "$", with: ",")
        
        
        let isRight = model.isRight
        
        let answer = model.answer.replacingOccurrences(of: "$", with: ",")
        
        if isRight == 1 {
            
            self.answerTitleLabel.text = "恭喜您答对了!"
            self.answerTitleLabel.textColor = UIColor.init(red: 5/255.0, green: 195/255.0, blue: 0/255.0, alpha: 1)
            
        }else{
            
            self.answerTitleLabel.text = "对不起,您答错了!"
            self.answerTitleLabel.textColor = UIColor.init(red: 236/255.0, green: 65/255.0, blue: 65/255.0, alpha: 1)
            
        }
        
        self.answerLabel.text = "你选择了" + choose
        self.rightAnswerLabel.text = "正确答案" + answer
        self.rightAnswerLabel.textColor = UIColor.init(red: 5/255.0, green: 195/255.0, blue: 0/255.0, alpha: 1)
        
        
        if model.images != "" {
            
            var photoImage = [Photo]()
            var pUrl = Photo()
            
            let images = model.images.components(separatedBy: ",")
            var temp = [String]()
            
            for url in images{
                
                if url.contains("http"){
                    
                    //空格转义情况!bug添加
                    let bUrl = url.replacingOccurrences(of: " ", with: "%20")
                    temp.append(bUrl)
                    pUrl = Photo.init(urlString: bUrl)
                    
                }else{
                    
                    let basicPath = URLPath.systemSelectionURL
                    let imageValue = basicPath.replacingOccurrences(of: "/api/", with: "") + "/" + url
                    temp.append(imageValue)
                    pUrl = Photo.init(urlString: url)
                    
                }
                photoImage.append(pUrl)
            }
            
            self.showImageVConstraint.constant = 90
            self.showImageV.showImageUrls(temp)
            //self.headViewConstraint.constant = 0
            
        }else{
            
            //调节约束展示
            self.headViewConstraint.constant = 120
            self.showImageVConstraint.constant = 0
            
        }
        
        //0..<model.optionDetail.count
        for indexxx in 0..<model.optionDetail.count {
            
            let AchievementV = Bundle.main.loadNibNamed("YQCheckAchievementDetailV", owner: nil
                , options: nil)?[0] as! YQCheckAchievementDetailV
            
            AchievementV.isUserInteractionEnabled = false
            
            let dict = model.optionDetail[indexxx]
            let options = dict["option"] as? String ?? ""
            let string = dict["optionContent"] as? String ?? ""
            
            AchievementV.optionLabel.text = options + ". " + string
            
            if choose.contains(options) {
                
                AchievementV.selectButton.isSelected = true
            }
            
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
                    
                    maker.top.equalToSuperview()
                    maker.left.equalToSuperview().offset(20)
                    maker.right.equalToSuperview().offset(-20)
                    maker.height.equalTo(moreQuestionHeight)
                    
                })
                
            }else{
                
                let lastSubV = view.subviews.last
                view.addSubview(AchievementV)
                
                AchievementV.snp.makeConstraints({ (maker) in
                    
                    maker.top.equalTo((lastSubV?.snp.bottom)!)
                    maker.left.equalToSuperview().offset(20)
                    maker.right.equalToSuperview().offset(-20)
                    maker.height.equalTo(moreQuestionHeight)
                    
                })
            }
        }
        
        self.currentView = view
        self.scrollContentView.addSubview(view)
        
        view.snp.makeConstraints { (maker) in
            
            maker.top.equalTo(self.MiddleView.snp.bottom).offset(5)
            maker.right.left.equalToSuperview()
            maker.height.equalTo(view.subviews.count * 45)
            
        }
        
    }
    
    //判断题
    func creatJudgmentProblem(model : YQSubjectModel){
      
        self.stemLabel.text = model.question
        self.typeLabel.text = "判断题"
        
        let view = UIView()
        
        let choose = model.choose
        let isRight = model.isRight
        let answer = model.answer
        
        if model.images != "" {
            
            var photoImage = [Photo]()
            var pUrl = Photo()
            
            let images = model.images.components(separatedBy: ",")
            var temp = [String]()
            
            for url in images{
                
                if url.contains("http"){
                    
                    //空格转义情况!bug添加
                    let bUrl = url.replacingOccurrences(of: " ", with: "%20")
                    temp.append(bUrl)
                    pUrl = Photo.init(urlString: bUrl)
                    
                }else{
                    
                    let basicPath = URLPath.systemSelectionURL
                    let imageValue = basicPath.replacingOccurrences(of: "/api/", with: "") + "/" + url
                    temp.append(imageValue)
                    pUrl = Photo.init(urlString: url)
                    
                }
                photoImage.append(pUrl)
            }
            
            self.showImageVConstraint.constant = 90
            self.showImageV.showImageUrls(temp)
            //self.headViewConstraint.constant = 0
            
        }else{
            
            //调节约束展示
            self.headViewConstraint.constant = 120
            self.showImageVConstraint.constant = 0
            
        }
        
        if isRight == 1 {
            
            self.answerTitleLabel.text = "恭喜您答对了!"
            self.answerTitleLabel.textColor = UIColor.init(red: 5/255.0, green: 195/255.0, blue: 0/255.0, alpha: 1)
            
        }else{
            
            self.answerTitleLabel.text = "对不起,您答错了!"
            self.answerTitleLabel.textColor = UIColor.init(red: 236/255.0, green: 65/255.0, blue: 65/255.0, alpha: 1)
            
        }
        
        self.answerLabel.text = "你选择了" + choose
        self.rightAnswerLabel.text = "正确答案" + answer
        self.rightAnswerLabel.textColor = UIColor.init(red: 5/255.0, green: 195/255.0, blue: 0/255.0, alpha: 1)
        
        //创建 是否 两个选项
        for indexxx in 0..<2 {
            
            let AchievementV = Bundle.main.loadNibNamed("YQCheckAchievementDetailV", owner: nil
                , options: nil)?[0] as! YQCheckAchievementDetailV
            
            AchievementV.isUserInteractionEnabled = false
            
           
            //布局约束
            if indexxx == 0 {
                
                if choose.contains("A") {
                    
                    AchievementV.selectButton.isSelected = true
                    if isRight == 1 {
                        
                        AchievementV.isRight = true
                    }else{
                        
                        AchievementV.isRight = false
                    }
                    
                }else{
                    
                    if isRight == 1 {
                        
                    }else{//没有选择而且又是 答错了  -->  显示的正确的答案逻辑
                        AchievementV.isRight = true
                    }
                    
                }
                
                AchievementV.optionLabel.text = "A. " + " 是"
                view.addSubview(AchievementV)
                
                AchievementV.snp.makeConstraints({ (maker) in
                    
                    maker.top.left.right.equalToSuperview()
                    maker.height.equalTo(moreQuestionHeight)
                    
                })
                
            }else{
                
               
                if choose.contains("B") {
                    
                    AchievementV.selectButton.isSelected = true
                    if isRight == 1 {
                        
                        AchievementV.isRight = true
                    }else{
                        
                        AchievementV.isRight = false
                    }
                    
                }
                
                AchievementV.optionLabel.text = "B. " + " 否"
                
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
        
        view.snp.makeConstraints { (maker) in
            
            maker.top.equalTo(self.MiddleView.snp.bottom).offset(5)
            maker.right.left.equalToSuperview()
            maker.height.equalTo(view.subviews.count * 45)
            
        }
        
    }
    
    //填空题
    func creatCompletionQuestion(model : YQSubjectModel){
        
        let Completion = YQCompletionQuestionV()
        Completion.backgroundColor = UIColor.white
        Completion.isUserInteractionEnabled = false
        
        let chooseArray = model.choose.components(separatedBy: "$")
        
        for indexxx in 0..<model.optionDetail.count{
            
            let optionDetail = model.optionDetail[indexxx]
            let str1 = optionDetail["type"] as? Int64 ?? -1
            let str2 = optionDetail["blankContent"] as? String ?? ""
            
            if str1 == 1 {
                
                Completion.labelContent = str2
                
            }else{
                
                Completion.textViewContent =  chooseArray[indexxx]
            }
        }
        
        self.scrollContentView.addSubview(Completion)
        self.currentView = Completion
        
        Completion.snp.makeConstraints({ (maker) in
            
            maker.top.equalToSuperview()
            maker.left.bottom.equalToSuperview().offset(10)
            maker.right.equalToSuperview().offset(-10)
            
        })
        
        addAnswerXib(answer: model.answer.replacingOccurrences(of: "$", with: ","))
        
    }
    
    //简答题
    func creatQuestionAndAnswerQuestion(model : YQSubjectModel){
        
        self.stemLabel.text = model.question
        self.typeLabel.text = "简答题"
        
        if model.images != "" {
            
            var photoImage = [Photo]()
            var pUrl = Photo()
            
            let images = model.images.components(separatedBy: ",")
            var temp = [String]()
            
            for url in images{
                
                if url.contains("http"){
                    
                    //空格转义情况!bug添加
                    let bUrl = url.replacingOccurrences(of: " ", with: "%20")
                    temp.append(bUrl)
                    pUrl = Photo.init(urlString: bUrl)
                    
                }else{
                    
                    let basicPath = URLPath.systemSelectionURL
                    let imageValue = basicPath.replacingOccurrences(of: "/api/", with: "") + "/" + url
                    temp.append(imageValue)
                    pUrl = Photo.init(urlString: url)
                    
                }
                photoImage.append(pUrl)
            }
            
            self.showImageVConstraint.constant = 90
            self.showImageV.showImageUrls(temp)
            //self.headViewConstraint.constant = 0
            
        }else{
            
            //调节约束展示
            self.headViewConstraint.constant = 120
            self.showImageVConstraint.constant = 0
            
        }
        
        let ShortAnswerQuestionsV = Bundle.main.loadNibNamed("YQShortAnswerQuestionsV", owner: nil, options: nil)?[0] as! YQShortAnswerQuestionsV
        ShortAnswerQuestionsV.isUserInteractionEnabled = false
        ShortAnswerQuestionsV.shortAnswerTextView.placeHolder = ""
        ShortAnswerQuestionsV.shortAnswerTextView.text = model.choose
        
        self.scrollContentView.addSubview(ShortAnswerQuestionsV)
        
        self.currentView =  ShortAnswerQuestionsV
        
        ShortAnswerQuestionsV.snp.makeConstraints { (maker) in
            
            maker.top.equalTo(self.headView.snp.bottom)
            maker.height.equalTo(200)
            maker.left.equalToSuperview().offset(10)
            maker.right.equalToSuperview().offset(-10)
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
