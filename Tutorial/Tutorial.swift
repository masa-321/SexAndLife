//
//  Tutorial.swift
//  SexualMediaApp
//
//  Created by Masahiro Atarashi on 2019/12/18.
//  Copyright © 2019 Masahiro Atarashi. All rights reserved.//
//

import Foundation
import UIKit

struct Tutorial {
    
    //メンバ変数(ダミーデータを作成する)
    let id: Int
    let title: String
    let thumbnail: UIImage
    
    //イニシャライザ
    init(id: Int, title:String, thumbnail:UIImage) {
        self.id     = id
        self.title  = title
        self.thumbnail = thumbnail
    }
    
    static func getSampleData() -> [Tutorial] {
        return [
            Tutorial(
                id: 1,
                title:
                "チャンネルは指で左右にフリックすることで切り替えることができます。" ,
                thumbnail: UIImage.init(named: "tutorialDefault")!
            ),
            Tutorial(id: 2,
                     title: "役に立った記事や後で読みたい記事は、記事右端のクリップボタンでクリップします。",
                     thumbnail: UIImage.init(named: "tutorialClip2")!
            ),
            Tutorial(id: 3,
                     title: "クリップした記事はこちらに登録され、いつでも読み直すことができます。",
                     thumbnail: UIImage.init(named: "tutorialClip")!
            ),
            Tutorial(id: 4,
                     title: "こちらには性に関して困った時に相談できる窓口がまとめられています。大事な人が困っていたら、紹介してあげてください。",
                     thumbnail: UIImage.init(named: "tutorialConsultation")!
            ),
            Tutorial(id: 5,
                     title: "キーワードから記事を検索できます。",
                     thumbnail: UIImage.init(named: "tutorialSearch")!
            ),
            Tutorial(id: 6,
                     title: "チュートリアルは以上になります！",
                     thumbnail: UIImage.init(named: "tutorialDefault")!
            ),
        ]
    }
}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


