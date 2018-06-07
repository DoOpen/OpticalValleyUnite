//
//  YQAllViewController.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2018/6/7.
//  Copyright © 2018年 yangqing. All rights reserved.
//

import UIKit

class YQAllViewController: UIViewController {

    let cell = "collectionCell"
    let headCell =  "headCell"
    let footCell = "footCell"
    
    //数据源的方法
    var topArray = [PermissionModel]()
    
    var bottomArray = [PermissionModel]()
    
    
    lazy var collectionView : UICollectionView = {
        
        let collectionV = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: SJScreeW, height: SJScreeH), collectionViewLayout: self.flowLayout)
        collectionV.dataSource = self
        collectionV.delegate = self
        collectionV.backgroundColor = UIColor.white
        collectionV.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(UInt8(UIViewAutoresizing.flexibleHeight.rawValue) | UInt8(UIViewAutoresizing.flexibleWidth.rawValue)))
        
        let nib = UINib.init(nibName: "YQBtnViewCollectionCell", bundle: nil)
        //注册cell
        collectionV.register(nib, forCellWithReuseIdentifier: self.cell)
        
        //注册header
        collectionV.register(SYLifeManagerHeaderView.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: self.headCell)
        
        //注册footer
        collectionV.register(SYLIfeManagerFooterView.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: self.footCell)
        
        
        return collectionV
    }()
    
    lazy var flowLayout: SYLifeManagerLayout = {
        
        let width  = CGFloat((SJScreeW - 80) / 4)
        
        let flayout = SYLifeManagerLayout()
        flayout.delegate = self;
        //设置每个图片的大小
        flayout.itemSize = CGSize.init(width: width, height: width)
        //设置滚动方向的间距
        flayout.minimumLineSpacing = 10
        //设置上方的反方向
        flayout.minimumInteritemSpacing = 0
        //设置collectionView整体的上下左右之间的间距
        flayout.sectionInset = UIEdgeInsetsMake(15, 20, 20, 20)
        //设置滚动方向
        flayout.scrollDirection = UICollectionViewScrollDirection.vertical
        
        return flayout
    }()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //1.init
        self.view.addSubview(self.collectionView)
        
        //2.rightAndLeftBar
        addRightBarButtonItem()
    
        //3.添加right,leftbar
        addRightBarButtonItem()
    }
    
    // MARK: - 添加rightBarbutton选项
    func addRightBarButtonItem(){
        
        let button = UIButton()
        button.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        button.setTitle("完成", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.sizeToFit()
        button.addTarget(self, action: #selector(FinishEditorsButtonClick), for: .touchUpInside)
        
        let barItem = UIBarButtonItem()
        barItem.customView = button
        
        navigationItem.rightBarButtonItem = barItem
        
    }
    
    func FinishEditorsButtonClick(){
        
        
        
    }
    
    
}

extension YQAllViewController : UICollectionViewDelegate,UICollectionViewDataSource,SYLifeManagerDelegate{
   
    // MARK: - CollectionViewDataSource,Delegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 2
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            
            return self.topArray.count
            
        }else{
            
            return self.bottomArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cell, for: indexPath) as? YQBtnViewCollectionCell
        
    
        if (indexPath.section == 0) {
            
            cell?.model = self.topArray[indexPath.item]
            
        } else {
            
            cell?.model = self.bottomArray[indexPath.item]
        }
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    
    // MARK: - SYLifeManagerDelegate
    /// 更新数据源的方法
    func moveItem(at formPath: IndexPath!, to toPath: IndexPath!) {
        
        
    }
    
    func didChangeEditState(_ inEditState: Bool) {
        
        
    }
    
    // MARK: - HeaderAndFooter
    /*
     collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:
     
     - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
     
     - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
     */
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if (kind == UICollectionElementKindSectionHeader) {
            
            let headView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headCell, for: indexPath) as! SYLifeManagerHeaderView
            
            if (indexPath.section == 0) {
                headView.headLabel.text = "我的应用";
            } else {
                headView.headLabel.text = "便捷生活";
            }
            
            return headView
            
        } else if (kind  == UICollectionElementKindSectionFooter){
            
            let footView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footCell, for: indexPath)
            
            return footView
        }
        
        return UICollectionReusableView()
    }
    

    
    
    
    
    
    
    
    
}

