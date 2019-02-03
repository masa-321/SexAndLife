//
//  CommentData.swift
//  SexualMediaApp
//
//  Created by Masahiro Atarashi on 2019/01/18.
//  Copyright © 2019 Masahiro Atarashi. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

class CommentData:NSObject {
    var commentText:String?
    var commentTime:Date?
    var commenterID:String?
    var commentLikes:[String] = []
    var isLiked: Bool = false
    var commentedArticleID:String?
    var likeSumNumber:Int?
    
    init (snapshot:(key: String, value: Any), commenterID:String, myId: String) {
        //self.commenterID = myId//ユーザーのID...これはおかしい
        self.commenterID = commenterID
        self.commentedArticleID = snapshot.key //記事のID
        
        let valueDictionary = snapshot.value as! [String:Any]
        
        self.commentText = valueDictionary["commentText"] as? String
        self.commentTime = valueDictionary["commentTime"] as? Date
        
        //self.commentedArticleID = valueDictionary["commentedArticleID"] as? String
        
        if let commentlikes = valueDictionary["commentLikes"] as? [String] {
            self.commentLikes = commentlikes
            //print("ArticleData.swiftにて、likes:" + "\(self.likes)")
        }
        
        for likeId in self.commentLikes {
            //"likes"のなかに自分のIDがあれば、いいね済み=trueってこと。
            if likeId == myId {
                self.isLiked = true
                break
            }
        }
        
        self.likeSumNumber = commentLikes.count
        
    }
}
