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
import SVProgressHUD

class CommentTableViewCell: UITableViewCell/*,UITextViewDelegate*/ {
    var profileData:Profile? //コメント・コメンターの情報
    
    let ref = Firestore.firestore().collection("articleData").document("-LQqLtig-hxumfojMFTT").collection("comments")//このref使われている？？？
    var commentedArticleID = String()
    
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
    
    //summaryViewControllerのtableViewのcellForRowAtでcell.myVC = selfとしている
    weak var myVC : SummaryViewController? //UIViewController?
    
    @IBAction func reportButton(_ sender: Any) {
        
        let actionsheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        //actionsheetがiPadだとエラーになる問題を解決。
        if UIDevice.current.userInterfaceIdiom == .pad{
            let screenSize = UIScreen.main.bounds
            actionsheet.popoverPresentationController?.sourceView = self.myVC?.view //これでCommentTableViewCell.swiftがviewを持っていませんというエラーは解決できたか？
            actionsheet.popoverPresentationController?.sourceRect = CGRect(x: screenSize.size.width/2, y: screenSize.size.height, width: 0, height: 0)
        }
        
        actionsheet.addAction(UIAlertAction(title: "ブロックする", style: UIAlertAction.Style.default, handler: { (action) -> Void in
            print("ユーザーID：",Auth.auth().currentUser?.uid,"/コメンターID：",self.profileData?.id,"/コメントされた記事：",self.commentedArticleID)
            
            let alertController = UIAlertController(title: "この方を非表示にしますか？", message: "再起動後、この方のコメントは画面に表示されなくなります", preferredStyle: UIAlertController.Style.alert)
            
            let okAction:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler :{ (action:UIAlertAction) in
                //ここで処理の続行へ戻させる
                self.block(commenterId: self.profileData!.id!)
            })
            
            let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (action:UIAlertAction!) -> Void in
                //キャンセル時の処理を書く。ただ処理をやめるだけなら書く必要はない。
            })
            
            
            
            alertController.addAction(cancelAction) //addActionなのね。
            alertController.addAction(okAction)
            self.myVC?.present(alertController, animated: true, completion: nil)
            
            
        }))
        
        actionsheet.addAction(UIAlertAction(title: "報告する", style: UIAlertAction.Style.default, handler: { (action) -> Void in
            
            //ReportViewControllerへ移る
            let storyboard: UIStoryboard = UIStoryboard(name: "Report", bundle: nil)//Main.storyboardを宣言
            let reportVC:ReportViewController = storyboard.instantiateViewController(withIdentifier: "Report") as! ReportViewController//遷移先のReportViewControllerを宣言
            //ReportViewControllerへ情報を送る
            reportVC.commentedArticleID = self.commentedArticleID
            reportVC.profileData = self.profileData
            
            //遷移。
            //self.myVC?.present(reportVC, animated: true, completion: nil)
            self.myVC?.navigationController?.pushViewController(reportVC, animated: true)
            
        }))
        actionsheet.addAction(UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler: { (action) -> Void in
            
        }))
        myVC?.present(actionsheet, animated: true, completion: nil)

    }
    
    //var masterViewPointer:SummaryViewController?
    
    func block(commenterId:String){
        SVProgressHUD.show()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            //self.myVC?.navigationController?.popViewController(animated: true)
            self.myVC?.relatedTableView.reloadData()
            
        }
        
        if let user = Auth.auth().currentUser {
            let ref = Firestore.firestore().collection("users").document(user.uid)
            ref.getDocument{ (document, err) in
            if let err = err {
                print("Error fetching documents: \(err)")
            } else {
                if let blockedUserIds = document!.data()!["blockedUserIds"] as? [String] {
                    var blockedUserIds:[String] = blockedUserIds
                    blockedUserIds.append(commenterId)
                    
                    let userInfo = [
                        "blockedUserIds": blockedUserIds
                    ]
                    
                    ref.updateData(userInfo){ err in
                    if let err = err {
                            print("Error adding document: \(err)")
                        } else {
                            print("Document successfully written!")
                            SVProgressHUD.dismiss()

                        }//else
                    
                        }//updateData
                    } else {
                    //まだblockedUserIdsが存在しないケース。commenterIdを格納した配列をそのまま作ればいい。
                    let userInfo = [
                        "blockedUserIds": [commenterId]
                    ]
                    ref.updateData(userInfo){ err in
                    if let err = err {
                            print("Error adding document: \(err)")
                        } else {
                            print("Document successfully written!")
                            SVProgressHUD.dismiss()
                            //self.myVC?.navigationController?.popoverPresentationController ここに書いても呼ばれない
                        }//else
                    
                        }
                    }
                
                }//else
            }//getDocument
        }//currentUser
    }
    
    
    
    let formatter = DateFormatter()
    
    func setCommentTableViewCellInfo(commentData:CommentData) {
        
        //report機能のために、commentedArticleIDを渡す準備
        commentedArticleID = commentData.commentedArticleID!
        
        //Date型をString型に変換する準備
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMM", options: 0, locale: Locale(identifier: "ja_JP"))
        
        postDateLabel.text = formatter.string(from: commentData.commentTime!)
        
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
            //コメンターとユーザーが同一人物であれば、削除・編集ボタンを出現させる
            if user.uid == commentData.commenterID {
                deleteButton.isHidden = false
                editButton.isHidden = false
            }
            
            //
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
