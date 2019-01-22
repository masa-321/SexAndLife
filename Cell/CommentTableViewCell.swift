//
//  CommentTableViewCell.swift
//  SexualMediaApp
//
//  Created by 新真大 on 2018/10/31.
//  Copyright © 2018年 Masahiro Atarashi. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import ReadMoreTextView
import FirebaseUI
import SDWebImage

class CommentTableViewCell: UITableViewCell {
    var profileData:Profile?
    
    let ref = Firestore.firestore().collection("articleData").document("-LQqLtig-hxumfojMFTT").collection("comments")
    
    @IBOutlet weak var commenterImageView: EnhancedCircleImageView!
    @IBOutlet weak var commenterNameLabel: UILabel!
    @IBOutlet weak var commenterEmploymentAndOccupationLabel: UILabel!
    
    @IBOutlet weak var postDateLabel: UILabel!
    @IBOutlet weak var textView: ReadMoreTextView!
    @IBOutlet weak var likeNumberLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    
    
    func setCommentTableViewCellInfo(commentData:CommentData) {
        
        //postDateLabel.text = commentData.commentTime as String
        textView.text = commentData.commentText
        if let likeNumber =  commentData.likeSumNumber{
            self.likeNumberLabel.text = String(likeNumber)
        }
        selectionStyle = .none
        
        if commentData.isLiked {
            likeButton.backgroundColor = .white//UIColor(red:0.95, green:1.00, blue:0.36, alpha:1.0)
            likeButton.titleLabel?.font = .boldSystemFont(ofSize: 17.0)
            likeNumberLabel.font = .boldSystemFont(ofSize: 17.0)
            //clipButtonLabel.textColor = .black
        } else {
            likeButton.backgroundColor = .clear
            likeButton.titleLabel?.font = .systemFont(ofSize: 17.0)
            //likeNumberLabel.font = UIFont.labelFontSize
            //clipButtonLabel.textColor = .white
        }
        if Auth.auth().currentUser != nil {
            if let commenterID = commentData.commenterID {
                let ref = Firestore.firestore().collection("users").document(commenterID)
                print(commenterID)
                ref.addSnapshotListener { querySnapshot, err in
                    if let err = err {
                        print("Error fetching documents: \(err)")
                    } else {
                         self.profileData = Profile(snapshot: querySnapshot!)
                         //print("profileData",self.profileData)
                        
                         self.commenterImageView.sd_setImage(with: URL(string: self.profileData!.pictureUrl!),placeholderImage: UIImage(named: "profile2"))
                         self.commenterNameLabel.text = self.profileData?.name
                        
                         if self.profileData?.employment != "" {
                         self.commenterEmploymentAndOccupationLabel.text = self.profileData!.employment! + "  " + self.profileData!.occupation!
                         } else {
                         self.commenterEmploymentAndOccupationLabel.text = self.profileData!.occupation
                         }
                    }
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textView.shouldTrim = true
        textView.maximumNumberOfLines = 4
        /*
        ref.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    self.textView.text = document.data()["commentText"] as? String
                }
            }
        }*/
        
        
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
