//
//  CoverFlow.swift
//  SexualMediaApp
//
//  Created by 新 真大 on 2018/10/08.
//  Copyright © 2018年 Masahiro Atarashi. All rights reserved.
//

import Foundation
import UIKit

struct Coverflow {
    
    //メンバ変数（ダミーデータを作成する）
    let id: Int
    var thumbnail: UIImage
    
    /*
    let vc1 = Media1ViewController()
    var thumbnail1:UIImage = UIImage()
    */
    
    //イニシャライザ
    init(id: Int, thumbnail: UIImage) {
        self.id        = id
        self.thumbnail = thumbnail
    }
    
    static func getSampleData() -> [Coverflow] {
        //thumbnail1 = vc1.vcImage
        return [
            Coverflow(
                id: 1,
                thumbnail: UIImage.init(named: "defaultImage")!
            ),
            Coverflow(
                id: 2,
                thumbnail: UIImage.init(named: "defaultImage")!
            ),
            Coverflow(
                id: 3,
                thumbnail: UIImage.init(named: "defaultImage")!
            ),
            Coverflow(
                id: 4,
                thumbnail: UIImage.init(named: "defaultImage")!
            ),
            Coverflow(
                id: 5,
                thumbnail: UIImage.init(named: "defaultImage")!
            ),
            
            Coverflow(
                id: 6,
                thumbnail: UIImage.init(named: "defaultImage")!
            ),
            Coverflow(
                id: 7,
                thumbnail: UIImage.init(named: "defaultImage")!
            ),/*
            Coverflow(
                id: 8,
                thumbnail: UIImage.init(named: "defaultImage")!
            ),*/
        ]
    }
}
