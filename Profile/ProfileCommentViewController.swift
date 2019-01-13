//
//  ProfileCommentViewController.swift
//  SexualMediaApp
//
//  Created by Masahiro Atarashi on 2019/01/13.
//  Copyright © 2019 Masahiro Atarashi. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ProfileCommentViewController: UINavigationController,UITableViewDelegate, UITableViewDataSource{
    
    var masterViewPointer:ProfileViewController?
    var textView: UITextView = UITextView()
    let profileInfoButton: UIButton = UIButton()
    
    let ref = Firestore.firestore().collection("users")
    var receivedUserId = ""
    
    var tableView:UITableView = UITableView() {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            
            let nib = UINib(nibName: "CommentTableViewCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: "CommentTableViewCell")
        }
    }
    //fileplivateじゃなくていいのかな？(https://yuu.1000quu.com/implement_uitableview_using_extension)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // 背景色を記述
        self.view.backgroundColor = UIColor.groupTableViewBackground
        
        
        
        //textViewの位置とサイズを設定
        textView.frame = CGRect(x:0, y:10, width:self.view.frame.width, height:100)
        textView.font = UIFont.systemFont(ofSize: 14.0)
        textView.layer.borderWidth = 0
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = UIColor.white
        
        // ボタンのCGRect・タイトル・タイトルの色・タイトルのフォント・背景色を設定
        profileInfoButton.frame = CGRect(x:0, y:10+textView.frame.height,
                                         width:self.view.frame.width, height:50)
        profileInfoButton.setTitle("さらに表示", for:UIControl.State.normal)
        profileInfoButton.setTitleColor(UIColor.blue, for: .normal)
        profileInfoButton.titleLabel?.font =  UIFont.systemFont(ofSize: 14)
        profileInfoButton.backgroundColor = UIColor.white
        
        profileInfoButton.addTarget(self,action: #selector(profileInfoButtonTapped(sender:event:)),for: .touchUpInside)
        
        
        
        if let user = Auth.auth().currentUser {
            if receivedUserId == user.uid {
                print("receivedUserId == user.uidだったよ")
                ref.document(user.uid).getDocument { (document, error) in
                    if let document = document, document.exists {
                        if document.data()!["Profile"] != nil {
                            self.view.addSubview(self.textView)
                            self.view.addSubview(self.profileInfoButton)
                            self.tableView = UITableView(frame: CGRect(x:0, y:10+self.textView.frame.height+50+20, width:self.view.frame.width, height:self.textView.contentSize.height), style: .grouped)
                            self.view.addSubview(self.tableView)
                            return
                        } else {
                            self.tableView = UITableView(frame: CGRect(x:0, y:10, width:self.view.frame.width, height:self.textView.contentSize.height), style: .grouped)
                            self.view.addSubview(self.tableView)
                            return
                        }
                        
                    } else {
                        print("Document does not exist")
                        self.tableView = UITableView(frame: CGRect(x:0, y:10, width:self.view.frame.width, height:self.textView.contentSize.height), style: .grouped)
                        self.view.addSubview(self.tableView)
                        return
                    }
                }
            } else {
                //receivedUserIdが他人だった場合の処理式
                
            }
        }
        
        
        //tableView.frame = CGRect(x:0, y:10+textView.frame.height+50+10, width:self.view.frame.width, height:textView.contentSize.height)
        
        
    }
    
    
    @objc func profileInfoButtonTapped(sender:UIButton, event:UIEvent) {
        masterViewPointer?.pageMenu?.moveToPage(1)
        print("profileInfoButtonTappedが呼ばれたよ")
        //完全のこれマスターしたな。
    };
    
    /// セルの個数を指定するデリゲートメソッド（必須）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    /// セルに値を設定するデータソースメソッド（必須）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell") as! CommentTableViewCell
        cell.setCommentTableViewCellInfo()
        cell.selectionStyle = .none
        return cell
    }
    
    /// セルが選択された時に呼ばれるデリゲートメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
    }
}
