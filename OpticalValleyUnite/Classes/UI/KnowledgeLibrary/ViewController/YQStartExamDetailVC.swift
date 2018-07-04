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
    
    //option(选项view)
    
    
    //底部view
    @IBOutlet weak var bottomView: UIView!
    
    //底部bottomView的约束调整
    @IBOutlet weak var bottomViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var handOverBtn: UIButton!
    
    //传递模型数组过来测试!
    var dataArray = [UIView]()
    
    //记录当前的缓存view
    var currentView : UIView?
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //init
        self.title = "题号: " + "\(self.titleIndes)"
        
        //1.添加right
        setupRightAndLeftBarItem()
        
        //2.模拟创建
        creatSingleChoiceQuestion()

    }
    
    func setupRightAndLeftBarItem(){
        
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
            
            right_add_Button.countDown(count: 60 * 60)
            
        }else{//再次逻辑跳转
            
             right_add_Button.countDown(count: YQTimeCount)
        }
        
       
        let right1Bar = UIBarButtonItem()
        right1Bar.customView = imageView
        
        let  right2Bar = UIBarButtonItem()
        right2Bar.customView = right_add_Button
        
        self.navigationItem.rightBarButtonItems = [right2Bar,right1Bar]
        
    }
    
    
    
    // MARK: - 点击下一题的方法
    @IBAction func nextButtonClick(_ sender: UIButton) {
        //点击下一题的选项情况
        //通知重新创建题目控件
        self.currentView?.removeFromSuperview()
        
        self.creatCompletionQuestion()
        
    }
    
    // MARK: - 点击上一题的方法
    @IBAction func upButtonClick(_ sender: UIButton) {
        
        self.currentView?.removeFromSuperview()
        
        self.creatQuestionAndAnswerQuestion()
        
    }
    
    // MARK: - 点击交卷按钮的方法
    @IBAction func HandOverButtonClick(_ sender: UIButton) {
        
        
        
    }
    
    // MARK: - 创建各种题框的方法
    //单选题
    func creatSingleChoiceQuestion(){
        
        let SingleQuestion = Bundle.main.loadNibNamed("YQQuestionOptionView", owner: nil, options: nil)?[0] as? YQQuestionOptionView
        
        self.scrollContentView.addSubview(SingleQuestion!)
        
        self.currentView = SingleQuestion
        
        SingleQuestion?.snp.makeConstraints({ (maker) in
            
            maker.top.equalTo(self.questionView.snp.bottom)
            maker.height.equalTo(180)
            maker.left.right.equalToSuperview().offset(20)
            
        })
    }
    
    //多选题
    func creatMoreChoiceQuestion(){
        
//        let abcArray = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N" ,"O", "P", "Q" ,"R", "S" ,"T", "U", "V", "W", "X", "Y", "Z" ]
        
        let view = UIView()
        
        for indexxxxx in 0..<5 {
            
            let moreQV = Bundle.main.loadNibNamed("YQMoreQuestionView", owner: nil, options: nil)?[0] as! YQMoreQuestionView
            
            
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
    func creatJudgmentProblem(){
        
        let JudgmentProblem = Bundle.main.loadNibNamed("YQJudgmentQuestionView", owner: nil, options: nil)?[0] as! YQJudgmentQuestionView
        
        self.scrollContentView.addSubview(JudgmentProblem)
        
        self.currentView = JudgmentProblem
        
        JudgmentProblem.snp.makeConstraints({ (maker) in
            
            maker.top.equalTo(self.questionView.snp.bottom)
            maker.height.equalTo(90)
            maker.left.right.equalToSuperview().offset(20)
            
        })
        
    }
    
    //填空题
    func creatCompletionQuestion(){
        
        let Completion = YQCompletionQuestionV()
        
        for indexxx in 0..<5{

            Completion.labelContent = "填空题" + "\(indexxx)"
            Completion.textViewContent =  "\(indexxx)" + "."
            
        }
        
        self.scrollContentView.addSubview(Completion)
        self.currentView = Completion
        
        Completion.snp.makeConstraints({ (maker) in
            
            maker.top.equalToSuperview()
            
            maker.left.right.bottom.equalToSuperview().offset(20)
            
        })
        
    }
    
    
    //问答题
    func creatQuestionAndAnswerQuestion(){
        
        let ShortAnswerQuestionsV = Bundle.main.loadNibNamed("YQShortAnswerQuestionsV", owner: nil, options: nil)?[0] as! YQShortAnswerQuestionsV
        
        self.scrollContentView.addSubview(ShortAnswerQuestionsV)
        
        self.currentView =  ShortAnswerQuestionsV
        
        ShortAnswerQuestionsV.snp.makeConstraints { (maker) in
            
            maker.top.equalTo(self.questionView.snp.bottom)
            maker.height.equalTo(200)
            maker.left.right.equalToSuperview().offset(20)
            
        }
        
    }
    
    
  

 

}

