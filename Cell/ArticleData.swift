//
//  ArticleData.swift
//  SexualMediaApp
//
//  Created by 新真大 on 2018/10/28.
//  Copyright © 2018年 Masahiro Atarashi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseFirestore

class ArticleData: NSObject {
    
    
    var id: String?
    var articleUrl:String?
    var genreName:String?
    var sourceName:String?
    var summary:String?
    var imageUrl:String?
    var imageString: String?
    var titleStr: String?
    var date: String?
    //var date: NSDate?
    var likes: [String] = []
    var isLiked: Bool = false
    var clipSumNumber:Int?
    var tags: String?
    var relatedArticleIDs:[String] = []

    
    init(snapshot: DataSnapshot, myId: String) {
        self.id = snapshot.key
        //keyって記事のIDであっているよな…
        
        let valueDictionary = snapshot.value as! [String: AnyObject]
        
        //以下Keyに対応させて引っ張ってきている
        self.articleUrl = valueDictionary["articleUrl"] as? String
        self.date = valueDictionary["date"] as? String
        self.genreName = valueDictionary["genreName"] as? String
        self.imageUrl = valueDictionary["imageUrl"] as? String
        self.sourceName = valueDictionary["sourceName"] as? String
        self.titleStr = valueDictionary["titleStr"] as? String
        self.summary = valueDictionary["summary"] as? String
        self.tags = valueDictionary["tags"] as? String //これ忘れていると、upexpected nilとなってエラーになり止まる。

        //let time = valueDictionary["time"] as? String
        //self.date = NSDate(timeIntervalSinceReferenceDate: TimeInterval(time!)!)

        
        if let relatedArticleIDs = valueDictionary["relatedArticleIDs"] as? [String]{
            self.relatedArticleIDs = relatedArticleIDs
            //print("ArticleData.swiftにて、relatedArticleIDs:" + "\(self.relatedArticleIDs)")
        }
        
        if let likes = valueDictionary["likes"] as? [String] {
            self.likes = likes
            //print("ArticleData.swiftにて、likes:" + "\(self.likes)")
        }
        
        for likeId in self.likes {
            //"likes"のなかに自分のIDがあれば、いいね済み=trueってこと。
            if likeId == myId {
                self.isLiked = true
                break
            }
        }
        
        self.clipSumNumber = likes.count
    }
    
    
    

}

class ArticleQueryData: NSObject {
    
    //var articleQueryData:[ArticleQueryData] = []
    
    var id: String?
    var articleUrl:String = ""
    var genreName:String?
    var sourceName:String = ""
    var summary:String = ""
    var imageUrl:String?
    var imageString: String = ""
    var titleStr: String = ""
    var date: NSDate?
    var likes: [String] = []
    var isLiked: Bool = false
    var clipSumNumber:Int?
    var tags: String?
    var relatedArticleIDs:[String] = []
    
    var isCommented: Bool = false
    var comments:[String:Any] = [:]
    
    var isFAQ:Bool = false
    
    init(snapshot: QueryDocumentSnapshot, myId: String) {
        self.id = snapshot.documentID
        //snapshotはkeyもvalueもある。これはDictionary型ってことだ。それは、Firestoreでは当てはまらないらしい。
        
        let valueDictionary = snapshot.data() 
        
        //以下Keyに対応させて引っ張ってきている。
        //FAQでもArticleでも記事登録時に、commentsとlikesとisFAQ以外それぞれの項目を作成しているので、!アンラップしてもエラーにはならない。
        if let articleUrl = valueDictionary["articleUrl"] as? String {
            self.articleUrl = articleUrl
        } 
        
        self.date = valueDictionary["date"] as? NSDate
        self.genreName = valueDictionary["genreName"] as? String
        
        if let imageUrl = valueDictionary["imageUrl"] as? String {
            self.imageUrl = imageUrl
        }
        
        if let sourceName = valueDictionary["sourceName"] as? String {
            self.sourceName = sourceName
        }
        
        
        if let titleStr = valueDictionary["titleStr"] as? String {
            self.titleStr = titleStr
        }
        
        if let summary = valueDictionary["summary"] as? String {
            self.summary = summary
        }

        self.tags = valueDictionary["tags"] as? String //これ忘れていると、upexpected nilとなってエラーになり止まる。
        
        
        
        
        //isFAQにはBool値としてtrueが登録される。Formで送信しただけでそうなる。
        if let isFAQ = valueDictionary["isFAQ"] as? Bool {
            self.isFAQ = isFAQ
        }
        
        //let time = valueDictionary["time"] as? String
        //self.date = NSDate(timeIntervalSinceReferenceDate: TimeInterval(time!)!)
        //commentsは項目が最初存在しないので、if letで丁寧に取り出す。
        if let comments = valueDictionary["comments"] as? [String:Any] {
            self.comments = comments
        }
        
        
        if let relatedArticleIDs = valueDictionary["relatedArticleIDs"] as? [String]{
            self.relatedArticleIDs = relatedArticleIDs
            //print("ArticleData.swiftにて、relatedArticleIDs:" + "\(self.relatedArticleIDs)")
        }
        
        //likesは項目が最初存在しないので、if letで丁寧に取り出す。
        if let likes = valueDictionary["likes"] as? [String] {
            self.likes = likes
            //print("ArticleData.swiftにて、likes:" + "\(self.likes)")
        }
        
        for likeId in self.likes {
            //"likes"のなかに自分のIDがあれば、いいね済み=trueってこと。
            if likeId == myId {
                self.isLiked = true
                break
            }
        }
        
        self.clipSumNumber = likes.count
        
    
    }
}
