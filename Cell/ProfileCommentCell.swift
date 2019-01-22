//
//  ProfileCommentCell.swift
//  SexualMediaApp
//
//  Created by Masahiro Atarashi on 2019/01/19.
//  Copyright © 2019 Masahiro Atarashi. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import SVProgressHUD

class ProfileCommentCell: UITableViewCell {
    
    var profileData:Profile?
    //var commentData:CommentData?
    
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articleSourceLabel: UILabel!
    
    @IBOutlet weak var commenterImageView: EnhancedCircleImageView!
    @IBOutlet weak var commenterNameLabel: UILabel!
    @IBOutlet weak var commenterEmploymentAndOccupationLabel: UILabel!
    @IBOutlet weak var textView: UILabel!
    
    @IBOutlet weak var profileBackgroundView: UIView!
    
    
    func setCellInfo(articleData:ArticleQueryData, id:String){
        SVProgressHUD.show()
        
        guard let imageUrl = articleData.imageUrl else {return}
        articleImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "placeholderImage"))
        articleImageView.contentMode = .scaleAspectFill
        articleImageView.clipsToBounds = true
        
        articleTitleLabel.text = articleData.titleStr
        articleSourceLabel.text = articleData.sourceName
        
        if Auth.auth().currentUser != nil {
            let ref = Firestore.firestore().collection("comments").document(id)
            ref.addSnapshotListener { (documentSnapshot, err) in
                if let err = err {
                    print("Error fetching documents: \(err)")
                } else {
                    for snapshot in (documentSnapshot?.data())! {
                        let commentData = CommentData(snapshot: snapshot, commenterID: id, myId: id)
                        if commentData.commentedArticleID == articleData.id {
                            self.setupCommenterInfo(commentData:commentData)
                            
                            print("self.setupCommenterInfo(commentData:comment)が呼ばれたよ。comment:",commentData,commentData.commentText)
                        }
                    }
                    
                }
            }
            
        }
    }
    
    
    /*
    func setCellInfo(articleData:ArticleQueryData){
        guard let imageUrl = articleData.imageUrl else {return}
        articleImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "placeholderImage"))
        articleImageView.contentMode = .scaleAspectFill
        articleImageView.clipsToBounds = true
        
        articleTitleLabel.text = articleData.titleStr
        articleSourceLabel.text = articleData.sourceName
        
        if Auth.auth().currentUser != nil {
            if let user = Auth.auth().currentUser {
                let ref = Firestore.firestore().collection("articleData").document(articleData.id!).collection("comments") //.document(user.uid)
                ref.addSnapshotListener { querySnapshot, err in
                    if let err = err {
                        print("Error fetching documents: \(err)")
                    } else {
                        
                        for document in querySnapshot!.documents {
                            /*self.commentData = CommentData(snapshot: document, myId: user.uid)
                            if self.commentData?.commenterID == user.uid {
                                self.setupCommenterInfo(commentData:self.commentData!)
                            }*/
                        }
                        
                        
                    }
                }
            }
        }
        selectionStyle = .none //ハイライトを消す
    }*/
    
    //TableViewの下半分を構築
    func setupCommenterInfo(commentData:CommentData) {
        self.textView.text = commentData.commentText
    
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
                    SVProgressHUD.dismiss()
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
