//
//  CommentViewController.swift
//  SexualMediaApp
//
//  Created by 新真大 on 2018/11/02.
//  Copyright © 2018年 Masahiro Atarashi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FBSDKCoreKit
import FBSDKLoginKit
import SDWebImage
import SVProgressHUD

class CommentViewController: UIViewController, UITextViewDelegate {
    
    var profileData:Profile?
    var receivedArticleData:ArticleQueryData?
    var postedCommentData:CommentData?
    //var commentedArticleIDs:[String]?
    
    @IBOutlet weak var imageView: EnhancedCircleImageView!{
        didSet{
            imageView.sd_setImage(with: URL(string: profileData!.pictureUrl!), placeholderImage: UIImage(named: "profile4"))
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel! {
        didSet{
            self.nameLabel.text = profileData!.name
        }
    }
    
    @IBOutlet weak var employmentAndOccupationLabel: UILabel! {
        didSet{
            if profileData!.employment != "" {
                //self.employmentAndOccupationLabel.text = "\(self.profileData!.employment) \(self.profileData!.occupation)"
                self.employmentAndOccupationLabel.text = profileData!.employment! + "  " + profileData!.occupation!
            } else {
                //self.employmentAndOccupationLabel.text = "\(self.profileData!.occupation)"
                self.employmentAndOccupationLabel.text = profileData!.occupation
            }
        }
    }
    
    @IBOutlet weak var textView: UITextView!{
        didSet{
            if let savedText = UserDefaults.standard.object(forKey: "comment") as? String{
                //すでに記事にコメントしたものがあれば、編集から再開する。そのためのpostedCommentData
                if postedCommentData == nil {
                    textView.text = savedText
                    let commentNum = textView.text.count
                    if commentNum <= 289 {
                        commentNumLabel.text = "残り " + String(300 - commentNum)
                        commentNumLabel.textColor = UIColor(red: 0/255, green: 150/255, blue: 255/255, alpha: 1)
                    } else if commentNum > 289 && commentNum <= 300{
                        commentNumLabel.text = "残り " + String(300 - commentNum)
                        commentNumLabel.textColor = .orange
                    } else {
                        commentNumLabel.text = "残り 0"
                        commentNumLabel.textColor = .red
                    }
                    
                } else {
                    textView.text = postedCommentData!.commentText
                    let commentNum = textView.text.count
                    if commentNum <= 289 {
                        commentNumLabel.text = "残り " + String(300 - commentNum)
                        commentNumLabel.textColor = UIColor(red: 0/255, green: 150/255, blue: 255/255, alpha: 1)
                    } else if commentNum > 289 && commentNum <= 300{
                        commentNumLabel.text = "残り " + String(300 - commentNum)
                        commentNumLabel.textColor = .orange
                    } else {
                        commentNumLabel.text = "残り 0"
                        commentNumLabel.textColor = .red
                    }
                }
            }
        }
    }
    
    
    @IBOutlet weak var upperView: UIView!{
        didSet{
            upperView.layer.cornerRadius = 15.0
            upperView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            
        }
    }

    @IBOutlet weak var lowerView: UIView!{
        didSet {
            //lowerView.layer.cornerRadius = 15.0
            lowerView.layer.cornerRadius = 15.0
            lowerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
    }

    @IBOutlet weak var commentNumLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        
        
        
        /*
        if let user = Auth.auth().currentUser {
            let ref = Firestore.firestore().collection("users").document(user.uid)
            ref.addSnapshotListener {querySnapshot, err in
                if let err = err {
                    print("Error fetching documents: \(err)")
                } else {
                    self.profileData = Profile(snapshot: querySnapshot!)
                    self.commentedArticleIDs = self.profileData!.commentedArticleIDs
                    if !self.commentedArticleIDs!.contains(self.receivedArticleData!.id!){
                        self.commentedArticleIDs!.append(self.receivedArticleData!.id!)
                    }
                }
            }
        }*/
        
        /*
        // 仮のサイズでツールバー生成
        let kbToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        kbToolBar.barStyle = UIBarStyle.default  // スタイルを設定
        
        kbToolBar.sizeToFit()  // 画面幅に合わせてサイズを変更
        
        // スペーサー
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        
        // 閉じるボタン
        let commitButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(commitButtonTapped(sender:event:)))
        
        kbToolBar.items = [spacer, commitButton]
        textView.inputAccessoryView = kbToolBar*/
        
    }
    /*
    @objc func commitButtonTapped (sender:UIBarButtonItem, event:UIEvent) {
        textView.resignFirstResponder()
        print("完了")
    }*/
    
    
    @IBAction func clearButton(_ sender: Any) {
        textView.text = ""
    }
    
    @IBAction func submitButton(_ sender: Any) {
        SVProgressHUD.show()
        
        /*
        profileData?.commentedArticleIDs.append(receivedArticleData!.id!)
        let commentedArticleIDs = [
            "CommentedArticleIDs":receivedArticleData!.id
        ]*/
        
        
        if let user = Auth.auth().currentUser {
            let now = NSDate()
            //Firestoreに格納するために辞書型の箱を作っている
            var commentData:[String : Any] = [:]
            if postedCommentData == nil {
                let comment = [
                    receivedArticleData!.id: [
                        "commentLikes": [],
                        "commentText": textView.text,
                        "commentTime": now,
                    ]
                    ] as! [String : Any]
                commentData = comment
            } else {
                let comment = [
                    receivedArticleData!.id: [
                        "commentLikes": postedCommentData!.commentLikes,
                        "commentText": textView.text,
                        "commentTime": now,
                        
                    ]
                    ] as! [String : Any]
                commentData = comment
            }
            
            //"comments"コレクションの編集
            let ref = Firestore.firestore().collection("comments").document(user.uid)
            ref.updateData(commentData) { err in
                if let err = err {
                    print("updateData(comment) Error adding document: \(err)")
                    //updateDataが通用するのはすでにuser.uidに紐ついたdocumentが存在したケース。存在しない場合は新たにuser.uidに紐ついたdocumentを作成しなければならない。
                    //documentが存在しなかった場合の処理
                    if "\(err)".contains("No document to update") {
                        ref.setData(commentData) {err in
                            if let err = err {
                                print("setData(comment) Error adding document: \(err)")
                            } else {
                                print("setData(comment) Document successfully written!")
                                
                                UserDefaults.standard.set("", forKey: "comment")
                                self.dismiss(animated: true, completion:nil)
                                SVProgressHUD.dismiss()
                                self.updateCommenterIDs()
                                return
                            }
                        }
                    }
                    
                } else {
                    //documentが存在していれば、アップデートされる。
                    print("updateData(commentData) Document successfully written!")
                    //navigationControllerで一つ前の画面に戻る
                    //self.navigationController?.popViewController(animated: true)
                    //送信成功と同時に、UserDefaultsにて"question"というkey値で保存されたデータをリセット
                    UserDefaults.standard.set("", forKey: "comment") //UserDefaultをリセット
                    
                    self.dismiss(animated: true, completion:nil)
                    
                    SVProgressHUD.dismiss()
                    
                    self.updateCommenterIDs()
                    
                    return
                }
            }
            
        }
    }
    
    func updateCommenterIDs() {
        if let user = Auth.auth().currentUser {
            //"articleData"コレクションの編集。commentの数を確認できるようにするため。
            var newCommenterIDs:[String] = receivedArticleData!.commenterIDs
            
            if !newCommenterIDs.contains(user.uid) {
                newCommenterIDs.append(user.uid)
            }
            let includingNewCommenterData = [
                "commenterIDs":newCommenterIDs
            ]
            let ref2 = Firestore.firestore().collection("articleData").document(receivedArticleData!.id!)
            ref2.updateData(includingNewCommenterData) { err in
                if let err = err {
                    print("updateData(includingCommenterData) Error adding document: \(err)")
                } else {
                    //documentは必ず存在するから、アップデートのみの処理で良い。
                    print("updateData(includingCommenterData) Document successfully written!")
                }
            }
        }
    }
    
    
    
    @IBAction func okButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        //View以外のところに触れればdismiss
    }

    
    //画面の外を押したら閉じる処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.textView.isFirstResponder) {
            self.textView.resignFirstResponder()
        }
    }
    
    //編集中でも情報を送ることができた。
    func textViewDidChange(_ textView: UITextView) {
       // masterViewPointer?.profileData?.profile = self.textView.text
        
        //文字数をカウントし、残りの文字数を描画する。
        let commentNum = textView.text.count
        //残りの文字数に応じて、ラベルの色を変える。
        if commentNum <= 289 {
            commentNumLabel.text = "残り " + String(300 - commentNum)
            commentNumLabel.textColor = UIColor(red: 0/255, green: 150/255, blue: 255/255, alpha: 1)
        } else if commentNum > 289 && commentNum <= 300{
            commentNumLabel.text = "残り " + String(300 - commentNum)
            commentNumLabel.textColor = .orange
        } else {
            commentNumLabel.text = "残り 0"
            commentNumLabel.textColor = .red
        }
        
        //文字数制限を加える
        let beforeStr: String = textView.text // 文字列をあらかじめ取得しておく
        if textView.text.count > 299 { // 300字を超えた時
            // 以下，範囲指定する
            let zero = beforeStr.startIndex
            let start = beforeStr.index(zero, offsetBy: 0)
            let end = beforeStr.index(zero, offsetBy: 299)
            textView.text = String(beforeStr[start...end])
        }
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //let writtenText = textView.text! as NSString
        //let replaceString = writtenText.replacingCharacters(in: range, with: string)
        UserDefaults.standard.set(textView.text, forKey: "comment")
        return true
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
