//
//  YQStartExamDetailVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/6/25.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

let moreQuestionHeight = 40

class YQStartExamDetailVC: UIViewController {

    //属性添加title和定时器的显示
    //默认是第一题
    var titleIndes: Int = 1
    
    //问题view
    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var scrollContentView: UIView!
    
    @IBOutlet weak var showImageVConstraint: NSLayoutConstraint!
    
    //option(选项view)
    @IBOutlet weak var stemLabel: UILabel!
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var showImageV: ShowImageView!
    @IBOutlet weak var headViewConstraint: NSLayoutConstraint!
    
    
    //底部view
    @IBOutlet weak var bottomView: UIView!
    
    //底部bottomView的约束调整
    @IBOutlet weak var bottomViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var upBtn: UIButton!
    
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var handOverBtn: UIButton!
    
    //传递模型数组过来测试!
    var dataArray = [YQSubjectModel]()
    
    //记录当前的缓存view
    var currentView : UIView?
    //记录索引
    var selectIndex = 1
    
    let LetterA = ["A","B","C","D","E","F","G","H","I","J","K"]
    
    var endBtnClickHandel: (([YQSubjectModel]) -> ())?
    
    //总体的开关属性
    var isCheck = false
    var isEnd = false
    
    var timeValue = 0
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //init
        self.title = "题号: " + "\(self.titleIndes)"
        
        //1.添加right
        if !isCheck {
            
            setupRightAndLeftBarItem()
            
        }else{
            
            self.handOverBtn.setTitle("返回", for: .normal)
            
        }
        
        //2.模拟创建
        checkBottomViewChangeFunction(Index: selectIndex)
        let model = self.dataArray[selectIndex - 1]
        ClassificationOfQuestions(model: model)

    }
    
    func setupRightAndLeftBarItem(){
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image:UIImage(named:"ic_return"),
                                                                style:.plain, target:self, action: #selector(leftBarItemButtonClick))
        
        let imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 13, height: 13))
        imageView.image = UIImage.init(name: "clock")
        
        let right_add_Button = UIButton()
        right_add_Button.frame = CGRect(x : 0, y : 0, width : 60, height : 40)
        
        //设置font
        right_add_Button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        right_add_Button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        right_add_Button.setTitleColor(UIColor.init(red: 255/255.0, green: 144.001/255.0, blue: 0.01/255.0, alpha: 1), for: .normal)
        //设置时间,单位是s
        //总的时间是 1个小时
        if YQTimeCount == 0 {//初始化第一次进来
            
            right_add_Button.countDown(count: timeValue * 60)
            
        }else{//再次逻辑跳转
            
            right_add_Button.countDown(count: YQTimeCount)
        }
        
        let right1Bar = UIBarButtonItem()
        right1Bar.customView = imageView
        
        let  right2Bar = UIBarButtonItem()
        right2Bar.customView = right_add_Button
        
        self.navigationItem.rightBarButtonItems = [right2Bar,right1Bar]
        
    }
    
    func leftBarItemButtonClick() {
        
        self.saveAnswerFunction()
        //bolck 回调传值
        if let bolck = endBtnClickHandel{
            
            bolck(self.dataArray)
        }
        
        endBtnClickHandel = nil
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - 点击下一题的方法
    @IBAction func nextButtonClick(_ sender: UIButton) {
       
        saveAnswerFunction()
        
        //点击下一题的选项情况
        //通知重新创建题目控件
        self.selectIndex += 1
        checkBottomViewChangeFunction(Index: selectIndex)
        
        self.currentView?.removeFromSuperview()
        //数据模型的导入方法
        let newModel = self.dataArray[selectIndex - 1]
        ClassificationOfQuestions(model: newModel)
        
    
    }
    
    // MARK: - 点击上一题的方法
    @IBAction func upButtonClick(_ sender: UIButton) {
        
        saveAnswerFunction()
        
        self.selectIndex -= 1
        checkBottomViewChangeFunction(Index: selectIndex)
        
        self.currentView?.removeFromSuperview()
        //数据模型的导入方法
        let model = self.dataArray[selectIndex - 1]
        ClassificationOfQuestions(model: model)
    }
    
    // MARK: - 点击交卷按钮的方法
    @IBAction func HandOverButtonClick(_ sender: UIButton) {
        
        if isCheck {
            
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        self.saveAnswerFunction()
        //bolck 回调传值
        if let bolck = endBtnClickHandel{
            
            bolck(self.dataArray)
        }
        
        endBtnClickHandel = nil
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func saveAnswerFunction(){
        //旧模型
        let model = self.dataArray[selectIndex - 1]
        
        //答案内容的写入情况:
        if (self.currentView?.isKind(of: YQQuestionOptionView.classForCoder()))!{
            //单选
            let view = self.currentView as! YQQuestionOptionView
            
            for indexxx in 0..<view.selectButtonArray.count {
                
                let btn = view.selectButtonArray[indexxx]
                
                if btn.isSelected {
                    
                    model.choose = self.LetterA[indexxx]
                }
                
            }
            
            
        } else if (self.currentView?.isKind(of: YQJudgmentQuestionView.classForCoder()))!{
            //判断题
            let view = self.currentView as! YQJudgmentQuestionView
            if view.judgmentButton1.isSelected {
                
                model.choose = "A"
                
            }else if(view.judgmentButton2.isSelected){
                
                model.choose = "B"
            }
            
        }else if (self.currentView?.isKind(of: YQCompletionQuestionV.classForCoder()))!{
            
            //填空题
            let view = self.currentView as! YQCompletionQuestionV
            var str = ""
            
            for indexxx in 0..<view.subviews.count{
                
                let subV = view.subviews[indexxx]
                
                if subV.isKind(of: UILabel.classForCoder()){

                    if str == "" {
                        
                        str = "_"
                        
                    }else{
                        
                        str = str + "$" + "_"
                    }
                    
                }else if (subV.isKind(of: UITextView.classForCoder())){
                    
                    let textV = subV as! UITextView
                    
                    if str == "" {
                        
                        str = textV.text
                        
                    }else{
                        
                        str = str + "$" + textV.text
                    }
                }
                
            }
            
            model.choose = str

        }else if (self.currentView?.isKind(of: YQShortAnswerQuestionsV.classForCoder()))!{
            
            //简答题
            let view = self.currentView as! YQShortAnswerQuestionsV
            model.choose = view.shortAnswerTextView.text
            
        } else {
            
            var str = ""
            //多选题的情况
            for indexxx in 0..<(self.currentView?.subviews.count)! {
                
                let tempV = self.currentView?.subviews[indexxx] as! YQMoreQuestionView
                
                if (tempV.moreButton1.isSelected){
                    
                    if str == "" {
                        
                        str = LetterA[indexxx]
                        
                    }else{
                        
                        str = str + "$" + LetterA[indexxx]
                    }
                }
            }
            
            model.choose = str
            
        }
        
        self.dataArray.remove(at: selectIndex - 1)
        self.dataArray.insert(model, at: selectIndex - 1)
        
    }
    
    // MARK: - bottomButton的显示状态的方法
    func checkBottomViewChangeFunction(Index : Int){
        
        if Index == 1 {//最开始 头
            
            self.upBtn.isHidden = true
            self.nextBtn.isHidden = false
            self.bottomViewHeightConstraint.constant = 50

        }else if (Index == self.dataArray.count){//最尾部 末
            
            self.nextBtn.isHidden = true
            
            self.bottomViewHeightConstraint.constant = 100
            
        }else{//中间的业务跳转
            
            self.upBtn.isHidden = false
            self.nextBtn.isHidden = false
            self.bottomViewHeightConstraint.constant = 100
        }
        
        self.handOverBtn.isHidden = !self.nextBtn.isHidden
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
            creatMoreChoiceQuestion(model: model)
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
    
    // MARK: - 创建各种题框的方法
    //单选题
    func creatSingleChoiceQuestion(model : YQSubjectModel){
    
        let choose = model.choose
        
        //先输入 题干的情况
        self.stemLabel.text = model.question
        self.typeLabel.text = "单选题"
        
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
            
        }else{
            
            //调节约束展示
            self.headViewConstraint.constant = 120
            self.showImageVConstraint.constant = 0
            
        }
        
        //答题选项的内容情况
        let SingleQuestion = Bundle.main.loadNibNamed("YQQuestionOptionView", owner: nil, options: nil)?[0] as? YQQuestionOptionView
    
        SingleQuestion?.isUserInteractionEnabled = !isCheck
        
        let labelA = SingleQuestion?.contentLabelArray
        let btnA = SingleQuestion?.selectButtonArray
        
        for indexxx in 0..<model.optionDetail.count{
            
            let optionDetail = model.optionDetail[indexxx]
            let str1 = optionDetail["option"] as? String ?? ""
            let str2 = optionDetail["optionContent"] as? String ?? ""
            
            if choose != "" && str1 == choose {
                
                btnA![indexxx].isSelected = true
            }
            
            let label = labelA![indexxx]
            
            label.text = str1 + ". " + str2
        }
        
        self.scrollContentView.addSubview(SingleQuestion!)
        
        self.currentView = SingleQuestion
        
        SingleQuestion?.snp.makeConstraints({ (maker) in
            
            maker.top.equalTo(self.questionView.snp.bottom)
            maker.height.equalTo(180)
            maker.left.right.equalToSuperview().offset(20)
            
        })
        
    }
    
    //多选题
    func creatMoreChoiceQuestion(model : YQSubjectModel){
        
        let choose = model.choose
        let arrString = choose.components(separatedBy: "$")
        
        
        self.stemLabel.text = model.question
        self.typeLabel.text = "多选题"
        
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
            
        }else{
            //调节约束展示
            self.headViewConstraint.constant = 120
            self.showImageVConstraint.constant = 0
        }
        
        let view = UIView()
        var chooseStr = ""
        
        for indexxxxx in 0..<model.optionDetail.count {
            
            if indexxxxx <= arrString.count - 1 {
                
               chooseStr = arrString[indexxxxx]
            }
            
            let moreQV = Bundle.main.loadNibNamed("YQMoreQuestionView", owner: nil, options: nil)?[0] as! YQMoreQuestionView
            moreQV.isUserInteractionEnabled = !isCheck
            
            let optionDetail = model.optionDetail[indexxxxx]
            let str1 = optionDetail["option"] as? String ?? ""
            let str2 = optionDetail["optionContent"] as? String ?? ""
            
            if chooseStr != "" && chooseStr == str1 {
                
                moreQV.moreButton1.isSelected = true
            }
            
            moreQV.moreLabel1.text = str1 + ". " + str2
            
            if indexxxxx == 0 {
                
                view.addSubview(moreQV)
                
                moreQV.snp.makeConstraints({ (maker) in
                    
                    maker.top.left.right.equalToSuperview()
                    maker.height.equalTo(moreQuestionHeight)
                })
                
            }else{
                
                let lastSubV = view.subviews.last
                view.addSubview(moreQV)

                moreQV.snp.makeConstraints({ (maker) in
                    
                    maker.top.equalTo((lastSubV?.snp.bottom)!)
                    maker.left.right.equalToSuperview()
                    maker.height.equalTo(moreQuestionHeight)
                    
                })
            }
        }
        
        self.scrollContentView.addSubview(view)
        self.currentView = view
        
        view.snp.makeConstraints({ (maker) in
            
            maker.top.equalTo(self.questionView.snp.bottom)
            maker.height.equalTo(moreQuestionHeight * view.subviews.count)
            maker.left.right.equalToSuperview().offset(20)
            
        })
        
    }
    
    
    //判断题
    func creatJudgmentProblem(model : YQSubjectModel){
        
        let choose = model.choose
        
        self.stemLabel.text = model.question
        self.typeLabel.text = "判断题"
        
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
            
        }else{
            //调节约束展示
            self.headViewConstraint.constant = 120
            self.showImageVConstraint.constant = 0
        }
        
        let JudgmentProblem = Bundle.main.loadNibNamed("YQJudgmentQuestionView", owner: nil, options: nil)?[0] as! YQJudgmentQuestionView
        JudgmentProblem.isUserInteractionEnabled = !isCheck
        
        self.scrollContentView.addSubview(JudgmentProblem)
        
        if choose == "A"{
            
            JudgmentProblem.judgmentButton1.isSelected = true
            
        }else if (choose == "B"){
            
            JudgmentProblem.judgmentButton2.isSelected = true
        }
        
        self.currentView = JudgmentProblem
        
        JudgmentProblem.snp.makeConstraints({ (maker) in
            
            maker.top.equalTo(self.questionView.snp.bottom)
            maker.height.equalTo(90)
            maker.left.right.equalToSuperview().offset(20)
            
        })
        
    }
    
    //填空题
    func creatCompletionQuestion(model : YQSubjectModel){
        
        let choose = model.choose
        let arrString = choose.components(separatedBy: "$")
        
        let Completion = YQCompletionQuestionV()
        Completion.backgroundColor = UIColor.white
        self.typeLabel.text = "填空题"
        Completion.isEdit = !isCheck
        
        let chooseArray = model.choose.components(separatedBy: "$")
        
        for indexxx in 0..<model.optionDetail.count{

            let optionDetail = model.optionDetail[indexxx]
            let str1 = optionDetail["type"] as? Int64 ?? -1
            let str2 = optionDetail["blankContent"] as? String ?? ""
            
            if str1 == 1 {
                
                Completion.labelContent = str2
                
            }else{
                
                if Completion.isEdit {
                    
                    Completion.textViewContent =  "( " + " )"
                    
                }else {
                    
                    if chooseArray.count == model.optionDetail.count {
                        
                        Completion.textViewContent = chooseArray[indexxx]
                        
                    }else{
                        
                        Completion.textViewContent =  "( " + " )"
                    }
                    
                }
                
            }
        }
        
        //填空题的赋值方法
        if arrString.count == Completion.textFiledArray.count{
            
            for indexxxx in 0..<Completion.textFiledArray.count{
                
                let textV = Completion.textFiledArray[indexxxx]
                
                let str =  arrString[indexxxx]
                if str != "" {
                    
                    textV.text = str
                }
            }
            
        }
        
        self.scrollContentView.addSubview(Completion)
        self.currentView = Completion
        
        Completion.snp.makeConstraints({ (maker) in
            
            maker.top.equalToSuperview()
            
            maker.left.right.bottom.equalToSuperview().offset(10)
        })
        
    }
    
    //问答题
    func creatQuestionAndAnswerQuestion(model : YQSubjectModel){
        
        self.stemLabel.text = model.question
        self.typeLabel.text = "问答题"
        
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
            
        }else{
            
            //调节约束展示
            self.headViewConstraint.constant = 120
            self.showImageVConstraint.constant = 0
        }
        
        
        let ShortAnswerQuestionsV = Bundle.main.loadNibNamed("YQShortAnswerQuestionsV", owner: nil, options: nil)?[0] as! YQShortAnswerQuestionsV
        ShortAnswerQuestionsV.isUserInteractionEnabled = !isCheck
        
        if model.choose != "" {
            
            ShortAnswerQuestionsV.shortAnswerTextView.placeHolder = ""
            ShortAnswerQuestionsV.shortAnswerTextView.text = model.choose
            
        }
        
        self.scrollContentView.addSubview(ShortAnswerQuestionsV)
        
        self.currentView =  ShortAnswerQuestionsV
        
        ShortAnswerQuestionsV.snp.makeConstraints { (maker) in
            
            maker.top.equalTo(self.questionView.snp.bottom)
            maker.height.equalTo(200)
            maker.left.right.equalToSuperview().offset(20)
            
        }
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        self.headViewConstraint.constant = self.stemLabel.maxY + 20
//
//    }
    

}

