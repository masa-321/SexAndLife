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
    var questionID:String? //Question固有のuuid
    var likeSumNumber:Int?
    
    init (snapshot:(key: String, value: Any), questionerID:String, myId: String) {
        
        self.questionerID = questionerID
        self.questionID = snapshot.key //Question固有のuuid
        
        let valueDictionary = snapshot.value as! [String:Any]
        
        self.questionText = valueDictionary["questionText"] as? String
        
        let timestamp = valueDictionary["questionTime"] as? Timestamp
        self.questionTime = timestamp?.dateValue() //FirestoreのTimestampの仕様変更に伴う修正
        
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
