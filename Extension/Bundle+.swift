//
//  Bundle+.swift
//  SexualMediaApp
//
//  Created by 新真大 on 2018/10/21.
//  Copyright © 2018年 Masahiro Atarashi. All rights reserved.
//

import Foundation

extension Bundle {
    
    enum Mailkey: String{
        ///お問い合わせ
        case inquiry = "Inquiry"
    }
    
    class func Mail(key: Mailkey) -> String {
        guard let dictionary = Bundle.main.infoDictionary?["Mail"] as? Dictionary<String, String> else {
            return ""
        }
        guard let returnString = dictionary[key.rawValue] as String? else {
            return "matarashi@gmail.com"
        }
        
        return returnString
    }
    
}
