//
//  CommentTableViewCell.swift
//  SexualMediaApp
//
//  Created by 新真大 on 2018/10/31.
//  Copyright © 2018年 Masahiro Atarashi. All rights reserved.
//

import UIKit
import FirebaseFirestore
import ReadMoreTextView

class CommentTableViewCell: UITableViewCell {
    
    let ref = Firestore.firestore().collection("articleData").document("-LQqLtig-hxumfojMFTT").collection("comments")
    @IBOutlet weak var defaultLabel: UILabel!
    @IBOutlet weak var textView: ReadMoreTextView!
    
    func setCommentTableViewCellInfo() {
        defaultLabel.text = "コメントがありません"
    
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textView.shouldTrim = true
        textView.maximumNumberOfLines = 4
        
        ref.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    self.textView.text = document.data()["commentText"] as? String
                }
            }
        }
        
        
        
        
        
        
        //NSAttributedStringで文字就職を実現することができるのか。
        let readMoreTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.blue,//view.tintColor,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)
        ]
        let readLessTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.red,
            NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: 16)
        ]
        
        textView.attributedReadMoreText = NSAttributedString(string: "... Read more", attributes: readMoreTextAttributes)
        textView.attributedReadLessText = NSAttributedString(string: " Read less", attributes: readLessTextAttributes)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        textView.onSizeChange = { _ in }
        textView.shouldTrim = true
    }
}
