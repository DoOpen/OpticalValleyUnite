//
//  YQStartExaminationVC.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/6/22.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit
import SnapKit

class YQStartExaminationVC: UIViewController {

    @IBOutlet weak var headView: UIView!
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var scrollContentView: UIView!
    
    @IBOutlet weak var scrollHieghtConstraint: NSLayoutConstraint!
    
    let cell = "QuestionCollectionCell"
    
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
        
    }

    @IBAction func startAnswerBtnClick(_ sender: UIButton) {
        //点击开始答题进行的从1开始
        let vc = YQStartExamDetailVC.init(nibName: "YQStartExamDetailVC", bundle: nil)
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        
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
