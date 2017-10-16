//
//  YQReleaseJournalFooterV.swift
//  OpticalValleyUnite
//
//  Created by 杨庆 on 2017/10/13.
//  Copyright © 2017年 yangqing. All rights reserved.
//

import UIKit

protocol YQReseaseJouranlFooterDeletage : class{
    
    func reseaseJouranlFooterButtonClick(releaseJournal : YQReleaseJournalFooterV)
    
}

class YQReleaseJournalFooterV: UIView {

    @IBOutlet weak var addEventButtonClick: UIButton!
    
    /// 设置代理
    weak var deletage : YQReseaseJouranlFooterDeletage?
    
    @IBAction func addEventButtonClick(_ sender: Any) {
        //添加代理,执行代理方法,跳转到界面详情
        self.deletage?.reseaseJouranlFooterButtonClick(releaseJournal: self)
    }

}
