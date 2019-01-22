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
    //var commentedArticleIDs:[String]?
    
    @IBOutlet weak var imageView: EnhancedCircleImageView!{
        didSet{
            imageView.sd_setImage(with: URL(string: profileData!.pictureUrl!), placeholderImage: UIImage(named: "profile2"))
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
                textView.text = savedText
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
            let comment = [
                receivedArticleData!.id: [
                    "commentLikes": [],
                    "commentText": textView.text,
                    "commentTime": now,
                ]
                ] as! [String : Any]
            
            let ref = Firestore.firestore().collection("comments").document(user.uid)
            ref.updateData(comment) { err in
                if let err = err {
                    print("updateData(comment) Error adding document: \(err)")
                    //documentが存在しなかった場合の処理
                    if "\(err)".contains("No document to update") {
                        ref.setData(comment) {err in
                            if let err = err {
                                print("setData(comment) Error adding document: \(err)")
                            } else {
                                print("setData(comment) Document successfully written!")
                                
                                UserDefaults.standard.set("", forKey: "comment")
                                self.dismiss(animated: true, completion:nil)
                                SVProgressHUD.dismiss()
                                return
                            }
                        }
                    }
                    
                } else {
                    //documentが存在していれば、アップデートされる。
                    print("updateData(comment) Document successfully written!")
                    //navigationControllerで一つ前の画面に戻る
                    //self.navigationController?.popViewController(animated: true)
                    UserDefaults.standard.set("", forKey: "comment") //UserDefaultをリセット
                    
                    self.dismiss(animated: true, completion:nil)
                    
                    SVProgressHUD.dismiss()
                    return
                }
            }
            
            
            //なぞ過ぎるので、頑張って、commentsカラムからcommentcellを引っ張ってくるようにしよう。
            //usersの方にはcommentsは書かないような設計…実現できるかわからないがそれしか道はないとして。
            /*
            let ref = Firestore.firestore().collection("users").document(user.uid)
            ref.updateData(commentedArticleIDs) { err in
                if let err = err {
                    print("updateData(CommentedArticleIDs) Error adding document: \(err)")
                    
                } else {
                    print("updateData(CommentedArticleIDs) Document successfully written!")
                }
            }*/
            
            
            
            /*
            let comment = [
                "comments": [user.uid: [
                    "commentLikes": [],
                    "commentText": textView.text,
                    "commentTime": now,
                    "commentedArticleID": receivedArticleData!.id
                    ]
                ]
            ] as [String : Any]
            
            */
            //扱いづらいか…でもこっちの方が美しいように思える。
/*
            let comment = [
                "commenterID":user.uid,
                "commentLikes": [],
                "commentText": textView.text,
                "commentTime": now,
                "commentedArticleID": receivedArticleData!.id
                ] as [String : Any]
            */
            
            //let ref = Firestore.firestore().collection("articleData").document(self.receivedArticleData!.id!).collection("comments").document(user.uid)
            /*
            let ref = Firestore.firestore().collection("comments")
            if ref.whereField("commentedArticleID", isEqualTo: receivedArticleData!.id) == nil {
                if ref.whereField("commenterID", isEqualTo: user.uid) == nil {
                    ref.setValue("commentedArticleID", forKey: self.receivedArticleData!.id)
                    ref.setValue(
                    ref.setValue(textView.text, forKey: "commentText")
                    ref.setValue(now, forKey: "commentTime")
                    ref.setValue(receivedArticleData!.id, forKey: "commentedArticleID")
                } else {
                    
                }
            } else if
            //美しくない*/
            
            
            
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
