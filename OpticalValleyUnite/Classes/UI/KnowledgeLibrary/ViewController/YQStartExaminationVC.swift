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
    var isEnd = -1{
        didSet{
            
            if isEnd == 1{
                
                SVProgressHUD.showError(withStatus: "考试已结束")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    //题目数组(核心数据)
    //模型数组
    var subjectArray  = [YQSubjectModel]()
    
    var id = ""
    
    //只能查看的 开关 按钮
    var isCheck = false
    
    var time = 0
    
    
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
        
        if isCheck {//查看试卷的情况
            
            self.startButton.setTitle("查看", for: .normal)
            self.handOverButton.setTitle("返回", for: .normal)
            
        }
        
        
        //2.设置约束
        self.scrollContentView.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (maker) in
            
            maker.top.equalTo(self.headView.snp.bottom)
            maker.bottom.equalTo(self.bottomView.snp.top)
            maker.left.right.equalToSuperview()
            
        }
        
        //3.获取总的数据量
        getStartExamDetailData()

    }

    
    
    // MARK: - 开始结束答题的按钮的点击
    @IBAction func startAnswerBtnClick(_ sender: UIButton) {
        //点击开始答题进行的从1开始
        let vc = YQStartExamDetailVC.init(nibName: "YQStartExamDetailVC", bundle: nil)
        vc.dataArray = self.subjectArray
        
        vc.endBtnClickHandel = { data in
            
            self.subjectArray = data
            self.collectionView.reloadData()
        }
        
        vc.isCheck = self.isCheck
        vc.timeValue = self.time
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        //同时设置两个计时工具
        if !isCheck {
            
            setupRightAndLeftBarItem()
        }
        
        self.startButton.isHidden = true
        self.handOverButton.isHidden = false
        
    
    }
    
    @IBAction func handOverButtonClick(_ sender: UIButton) {
        
        if isCheck {
            
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        //完成交卷的逻辑!数据提交
        var par = [String : Any]()
        //这里的要求格式化json
        par["paperId"] = self.id
        
        var temp =  Array<[String : Any]>()
        
        for answer in self.subjectArray{
            var dict = [String : Any]()
            dict["subjectId"] = "\(answer.id)"
            dict["choose"] = answer.choose
            
            temp.append(dict)
            
        }
        
        do{
            
            let jsonData = try JSONSerialization.data(withJSONObject: temp, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8){
                
                //格式化的json字典的情况
                print(JSONString)
                
                //注意的是这里的par 要求序列化json
                par["params"] = JSONString
                
            }
            
        } catch {
            
            print("转换错误 ")
        }
        
        SVProgressHUD.show()
        
        HttpClient.instance.post(path: URLPath.getNewknowledgeOwnSubmit, parameters: par, success: { (response) in
            
            SVProgressHUD.dismiss()
            SVProgressHUD.showSuccess(withStatus: "提交成功!")
            
            DispatchQueue.main.async {
                
                self.navigationController?.popViewController(animated: true)
            }
            
            
        }) { (error) in
            
            SVProgressHUD.showError(withStatus: "提交失败,请检查网络!")
        }
        
        
    }
    
    
    
    // MARK: - 获取考试数据详情的界面
    func getStartExamDetailData(){
        
        var par = [String : Any]()
        
        par["id"] = self.id
        
        SVProgressHUD.show()
        
        HttpClient.instance.post(path: URLPath.getNewknowledgeOwnDetail, parameters: par, success: { (response) in
            
            SVProgressHUD.dismiss()
            let data = response as? [String : Any]
            
            if data == nil || (data?.isEmpty)! {
                
                SVProgressHUD.showError(withStatus: "没有更多数据!")
                return
            }
            
            let dict = data!
            //是否结束
            self.isEnd = dict["isEnd"] as? Int ?? -1
            
            //时间
            let time = dict["time"] as? String ?? ""
            self.timeLabel.text = "考试时间 " + time + "分"
            self.time = Int(time)!
            
            //纪要
            let print = dict["points"] as? String ?? ""
            self.summaryLabel.text = print
            
            //题目数量
            let count = dict["totalCount"] as? Int ?? 0
            self.countLabel.text = "共" + "\(count)" + "题"
            
            //题目数组
            let subjectDetail = dict["subjectDetail"] as? Array<[String : Any]>  //里面包含选项的数组id
            
            var tempArray = [YQSubjectModel]()
            
            for dict in subjectDetail!{
                tempArray.append(YQSubjectModel.init(dict: dict))
            }
            
            self.subjectArray = tempArray
            
            self.collectionView.reloadData()
            
            
        }) { (error) in
            
            SVProgressHUD.showError(withStatus: "网络数据加载失败,请检查网络!")
        }
        
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
        //总的时间是 1个小时
        if YQTimeCount == 0 {//初始化第一次进来
            
            right_add_Button.countDown(count: time * 60)
            
        } else {//再次逻辑跳转
            
            right_add_Button.countDown(count: YQTimeCount)
        }
        
        let right1Bar = UIBarButtonItem()
        right1Bar.customView = imageView
        
        let  right2Bar = UIBarButtonItem()
        right2Bar.customView = right_add_Button
        
        self.navigationItem.rightBarButtonItems = [right2Bar,right1Bar]
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func leftBarItemButtonClick() {
        
        self.alert(message: "是否确定退出", doneBlock: { (alert) in
            
            self.navigationController?.popViewController(animated: true)
            
        }) { (alert) in
            
        }
        
    }
    
    deinit {
        
        //清空时间宏
        YQTimeCount = 0
        
    }
    
}

extension YQStartExaminationVC : UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return self.subjectArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cell, for: indexPath) as? YQQuestionCollectionCell
        
        cell?.backgroundColor = UIColor.clear
        cell?.questionBtn.setTitle("\(indexPath.item + 1)", for: .normal)
        
        let model = self.subjectArray[indexPath.row]
        
        if model.choose != "" && model.choose != "(  )$(  )$(  )" {
            
            cell?.questionBtn.backgroundColor = UIColor.init(red: 108/255.0, green: 202/255.0, blue: 255/255.0, alpha: 1)
        }
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if !self.startButton.isHidden {
            
            if isCheck {
                
                //点击开始答题进行的从1开始
                let vc = YQStartExamDetailVC.init(nibName: "YQStartExamDetailVC", bundle: nil)
                vc.dataArray = self.subjectArray
                vc.selectIndex = indexPath.row + 1
                vc.isCheck = self.isCheck
                
                vc.endBtnClickHandel = { data in
                    
                    self.subjectArray = data
                    self.collectionView.reloadData()
                }
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            
            return
            
        }else{
            
            //点击开始答题进行的从1开始
            let vc = YQStartExamDetailVC.init(nibName: "YQStartExamDetailVC", bundle: nil)
            vc.dataArray = self.subjectArray
            vc.selectIndex = indexPath.row + 1
            vc.isCheck = self.isCheck
            vc.timeValue = self.time
            
            vc.endBtnClickHandel = { data in
                
                self.subjectArray = data
                self.collectionView.reloadData()
                
            }
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        
    }
    
    
    
}
