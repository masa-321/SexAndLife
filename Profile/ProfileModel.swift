//
//  ProfileModel.swift
//  SexualMediaApp
//
//  Created by Masahiro Atarashi on 2019/01/16.
//  Copyright © 2019 Masahiro Atarashi. All rights reserved.
//

import Foundation
import FirebaseFirestore

class Profile:NSObject {
    var id:String?
    var name:String?
    var pictureUrl:String?
    var age:String?
    var sex:String?
    var profile:String?
    var employment:String?
    var occupation:String?
    //var commentedArticleIDs:[String] = []
    
    //follow機能の実装
    var followers:[String] = []
    var followersSum:Int?
    var isFollowed:Bool = false
    
    var isProfessional:Bool = false
    var isDoctor:Bool = false
    var isYouthPro:Bool = false
    
    init(snapshot:DocumentSnapshot, myId: String) {
        self.id = snapshot.documentID //取り急ぎ
        
        let valueDictionary = snapshot.data()
        //self.id = valueDictionary!["id"] as? String
        //コメンターがFabebook認証していないと、nilが表示されたわけだ。
        //FirebaseのAuthenticationをで、userを削除すると、プロフィール画面がエラーになる。uidはあるが、userデータは存在しないということになって、エラーになる。それを回避するためにはデータを削除した時は、初期画面に戻すことでは？
        /*
        if let name = valueDictionary!["name"] as? String {
            if name == "" {
                self.name = "\(snapshot.documentID)"
            } else {
                self.name = name
            }
        } else {
            self.name = "\(snapshot.documentID)"
        }*/
        if let name = valueDictionary!["name"] as? String {
            self.name = name
        } else {
            self.name = ""
        }
        
        
        if let pictureUrl = valueDictionary!["pictureUrl"] as? String {
            self.pictureUrl = pictureUrl
        } else {
            self.pictureUrl = ""
        }
        /*
        //firebaseの構造だろう。
        if let pictureData = valueDictionary!["picture"] as? [String : Any] {
            let pictureProperties = pictureData["data"] as? [String:Any]
            self.pictureUrl = pictureProperties!["url"] as? String
        } else {
            self.pictureUrl = ""
        }
        //self.profileImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "profile"))
        */
        
        if let age = valueDictionary!["年齢"] as? String {
            self.age = age
        } else {
            self.age = ""
        }
        
        if let sex = valueDictionary!["性別"] as? String {
            self.sex = sex
        } else {
            self.sex = ""
        }
        
        
        
        if let profile = valueDictionary!["Profile"] as? String {
            self.profile = profile
        } else {
            self.profile = ""
        }
        
        if let employment = valueDictionary!["Employment"] as? String {
            self.employment = employment
        } else {
            self.employment = ""
        }
        
        if let occupation = valueDictionary!["Occupation"] as? String {
            self.occupation = occupation
        } else {
            self.occupation = ""
        }
  
        /*
        if let commentedArticleIDs:[String] = valueDictionary!["CommentedArticleIDs"] as? [String] {
            self.commentedArticleIDs = commentedArticleIDs
        } else {
            print("CommentedArticleIDsはnilです")
        }*/
        
        if let followers:[String] = valueDictionary!["followers"] as? [String] {
            self.followers = followers
        }
        
        for followerId in self.followers {
            if followerId == myId {
                self.isFollowed = true
                break
            }
        }
        
        self.followersSum = followers.count
        
        
        if let isProfessional:Bool = valueDictionary!["isProfessional"] as? Bool {
            self.isProfessional = isProfessional
        }
        
        if let isDoctor:Bool = valueDictionary!["isDoctor"] as? Bool {
            self.isDoctor = isDoctor
        }
        
        if let isYouthPro:Bool = valueDictionary!["isYouthPro"] as? Bool {
            self.isYouthPro = isYouthPro
        }
        
        
    }
    
}
