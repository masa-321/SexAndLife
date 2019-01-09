//
//  CellViewModel.swift
//  SexualMediaApp
//
//  Created by 新真大 on 2018/10/11.
//  Copyright © 2018年 Masahiro Atarashi. All rights reserved.
//

import UIKit

struct Genre {
    /// 更新日付
    var updateDate = Date(timeIntervalSince1970: 0)
    /// ジャンルリスト
    var genreList: [String] = []
}

/// 記事情報
struct Article {
    /// ジャンル名
    var genreName = ""
    /// 情報元名
    var sourceName = ""
    /// タイトル
    var title = ""
    /// 記事URL
    var url = ""
    /// 更新日付
    var date = Date(timeIntervalSince1970: 0)
    /// 画像リンク(ニュース一覧取得時は空状態)
    var imageUrl = ""
    /// スコア
    var score = 0
    /// クリップ日付
    var clipDate = Date(timeIntervalSince1970: 0)
}

class ListCellViewModel: NSObject {
    var titleStr = ""
    var articleUrl = ""
    var genreName = ""
    var sourceName = ""
    var summary = ""
    var date = ""
    var imageUrl = ""
}
