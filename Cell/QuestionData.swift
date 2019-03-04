//
//  QuestionData.swift
//  SexualMediaApp
//
//  Created by Masahiro Atarashi on 2019/03/04.
//  Copyright © 2019 Masahiro Atarashi. All rights reserved.
//

//CommentData.swiftを参考に構築
import Foundation
import Firebase
import FirebaseFirestore

class QuestionData:NSObject {
    var questionText:String?
    var questionTime:Date?
    var questionerID:String?
    var questionLikes:[String] = []
    var isLiked: Bool = false
    //var commentedArticleID:String? Questionは記事に紐つくわけではないのでなし
    var likeSumNumber:Int?
    
    init (snapshot:(key: String, value: Any), questionerID:String, myId: String) {
        
        self.questionerID = questionerID
        //self.commentedArticleID = snapshot.key //記事のID。しかしQuestionは記事に紐つくわけではないのでなし
        
        let valueDictionary = snapshot.value as! [String:Any]
        
        self.questionText = valueDictionary["questionText"] as? String
        self.questionTime = valueDictionary["questionTime"] as? Date
        
        if let questionlikes = valueDictionary["questionLikes"] as? [String] {
            self.questionLikes = questionlikes
            //print("ArticleData.swiftにて、likes:" + "\(self.likes)") //デバッグ用
        }
        
        for likeId in self.questionLikes {
            //"likes"のなかに自分のIDがあれば、いいね済み=trueってこと。
            if likeId == myId {
                self.isLiked = true
                break
            }
        }
        
        self.likeSumNumber = questionLikes.count
        
    }
}
