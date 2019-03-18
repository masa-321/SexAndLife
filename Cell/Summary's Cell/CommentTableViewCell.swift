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
import FirebaseUI
import SDWebImage

class CommentTableViewCell: UITableViewCell/*,UITextViewDelegate*/ {
    var profileData:Profile?
    
    let ref = Firestore.firestore().collection("articleData").document("-LQqLtig-hxumfojMFTT").collection("comments")
    
    @IBOutlet weak var commenterImageView: EnhancedCircleImageView!
    @IBOutlet weak var commenterNameLabel: UILabel!
    @IBOutlet weak var commenterEmploymentAndOccupationLabel: UILabel!
    
    @IBOutlet weak var postDateLabel: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var likeNumberLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    
    @IBOutlet weak var deleteButton: UIButton! {
        didSet {
            deleteButton.isHidden = true
        }
    }
    @IBOutlet weak var editButton: UIButton! {
        didSet {
            editButton.isHidden = true
        }
    }
    
    @IBOutlet weak var professionalImage: UIImageView! {
        didSet {
            professionalImage.isHidden = true
            //professionalImage.widthAnchor.constraint(equalToConstant: 0).isActive = true
        }
    }
    
    
    @IBOutlet weak var doctorImage: UIImageView!{
        didSet {
            doctorImage.isHidden = true
            //doctorImage.widthAnchor.constraint(equalToConstant: 0).isActive = true
        }
    }
    
    @IBOutlet weak var youthProImage: UIImageView!{
        didSet {
            youthProImage.isHidden = true
        }
    }
    
    
    
    
    let formatter = DateFormatter()
    
    func setCommentTableViewCellInfo(commentData:CommentData) {
        
        //Date型をString型に変換する準備
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMM", options: 0, locale: Locale(identifier: "ja_JP"))
        postDateLabel.text = formatter.string(from: commentData.commentTime! /*Date()*/)
        
        //TextViewの高さを可変にする処理
        textView.text = commentData.commentText
        
        let contentSize = self.textView.sizeThatFits(self.textView.bounds.size)
        var frame = self.textView.frame
        frame.size.height = contentSize.height
        self.textView.frame = frame
        
        let aspectRatioTextViewConstraint = NSLayoutConstraint(item: self.textView, attribute: .height, relatedBy: .equal, toItem: self.textView, attribute: .width, multiplier: textView.bounds.height/textView.bounds.width, constant: 1)
        self.textView.addConstraint(aspectRatioTextViewConstraint)
        //なんかよくわからないがこれで、可変になったようだ。
        
        
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
            likeButton.titleLabel?.font = .systemFont(ofSize: 17.0) //デフォルト（太字ではない）
            likeNumberLabel.font = .systemFont(ofSize: 17.0)
            //likeNumberLabel.font = UIFont.labelFontSize
            //clipButtonLabel.textColor = .white
        }
        
        if let user = Auth.auth().currentUser {
            if user.uid == commentData.commenterID {
                deleteButton.isHidden = false
                editButton.isHidden = false
            }
            
            if let commenterID = commentData.commenterID {
                let ref = Firestore.firestore().collection("users").document(commenterID)
                print(commenterID)
                ref.addSnapshotListener { querySnapshot, err in
                    if let err = err {
                        print("Error fetching documents: \(err)")
                    } else {
                        self.profileData = Profile(snapshot: querySnapshot!, myId: user.uid)
                         //print("profileData",self.profileData)
                        
                         self.commenterImageView.sd_setImage(with: URL(string: self.profileData!.pictureUrl!),placeholderImage: UIImage(named: "profile4"))
                         self.commenterNameLabel.text = self.profileData?.name
                        
                         if self.profileData?.employment != "" {
                         self.commenterEmploymentAndOccupationLabel.text = self.profileData!.employment! + "  " + self.profileData!.occupation!
                         } else {
                         self.commenterEmploymentAndOccupationLabel.text = self.profileData!.occupation
                         }
                        
                        if self.profileData!.isProfessional {
                            self.professionalImage.isHidden = false
                        }
                        
                        if self.profileData!.isDoctor {
                            self.doctorImage.isHidden = false
                        }
                        
                        if self.profileData!.isYouthPro {
                            self.youthProImage.isHidden = false
                        }
                    }
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
        
        /*
        //NSAttributedStringで文字修飾を実現することができるのか。
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
        */
        
        /*
        let baseString = textView.text
        let attributedString = NSMutableAttributedString(string: baseString!)
        attributedString.addAttribute(.link,
                                      value: UIApplication.openSettingsURLString,
                                      range: NSString(string: baseString!).range(of: "https://medu4.com/"))
        attributedString.addAttribute(.link,
                                      value: "https://www.google.co.jp/",
                                      range: NSString(string: baseString!).range(of: "https://medu4.com/"))
        
        textView.attributedText = attributedString
        textView.isSelectable = true
        textView.delegate = self*/
        
    }
    /*
    func textView(_ textView: UITextView,
                  shouldInteractWith URL: URL,
                  in characterRange: NSRange,
                  interaction: UITextItemInteraction) -> Bool {
        
        UIApplication.shared.open(URL)
        
        return false
    }*/

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
