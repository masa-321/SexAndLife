//
//  InfoCellViewModel.swift
//  SexualMediaApp
//
//  Created by 新真大 on 2018/10/12.
//  Copyright © 2018年 Masahiro Atarashi. All rights reserved.
//

import Foundation
import UIKit

class InfoCellViewModel: NSObject {
    
    //表示種別
    var type = InfoViewModel.CellViewType.inquiry
    
    //タイトル
    var titleText = ""
    
    var iconImage: UIImage?
    
    var isNextImageHidden = false //隠さなくていんじゃない
    
    init(type: InfoViewModel.CellViewType) {
        self.type = type
        switch type {
        
        case .profile:
            titleText = "プロフィール編集"
            iconImage = UIImage(named: "profile")
        case .socialNetwork:
            titleText = "ソーシャル連携"
            iconImage = UIImage(named: "socialLink")
        /*case .notification:
            titleText = "通知設定"
            iconImage = UIImage(named: "notification")
            isNextImageHidden = true*/
        case .inquiry:
            titleText = "お問い合わせ"
            iconImage = UIImage(named: "mail")
            /*
        case .review:
            titleText = "レビューを書く"
            iconImage = UIImage(named: "review")*/
        case .privacyPolicy:
            titleText = "利用規約" //とりあえず、今はプライバシーポリシーを除く
            iconImage = UIImage(named: "document")
        case .licenseInfo:
            titleText = " ライセンス情報"
            iconImage = UIImage(named: "licence")
        }
    }
    
}
