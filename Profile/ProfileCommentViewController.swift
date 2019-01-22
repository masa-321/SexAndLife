//
//  ProfileCommentViewController.swift
//  SexualMediaApp
//
//  Created by Masahiro Atarashi on 2019/01/13.
//  Copyright © 2019 Masahiro Atarashi. All rights reserved.
//
/*/*
import UIKit
import FirebaseAuth
import FirebaseFirestore

class ProfileCommentViewController: UINavigationController,UITableViewDelegate, UITableViewDataSource{
    
    var masterViewPointer:ProfileViewController?
    
    
    let ref = Firestore.firestore().collection("users")
    var commentedArticleIDs:[String] = []
    var commentedArticleArray:[ArticleQueryData] = []
    var receivedUserId = ""
    var profileData:Profile?
    var receiveTextViewText = ""
    
    var tableView:UITableView = UITableView() {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            //tableView.register(R.nib.listCell)
            
            
        }
    }
    //fileplivateじゃなくていいのかな？(https://yuu.1000quu.com/implement_uitableview_using_extension)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // 背景色を記述
        self.view.backgroundColor = UIColor.groupTableViewBackground

        tableView = UITableView(frame: UIScreen.main.bounds, style: .plain)
        self.view.addSubview(tableView)
        
    }
    
    func fetchProfile() {
        if let user = Auth.auth().currentUser {
            if receivedUserId == user.uid {
                //print("receivedUserId == user.uidだったよ")
                ref.document(user.uid).addSnapshotListener { querySnapshot, err in
                    if let err = err {
                        print("Error fetching documents: \(err)")
                    } else {
                        //まずはprofile情報を取得
                        self.profileData = Profile(snapshot: querySnapshot!)
                        
                        //profileテキストがあれば、textViewを生成
                        if !(self.profileData!.profile! == "") {
                            self.view.addSubview(self.textView)
                            self.view.addSubview(self.profileInfoButton)
                            self.tableView = UITableView(frame: CGRect(x:0, y:10+self.textView.frame.height+50+20, width:self.view.frame.width, height:self.textView.contentSize.height), style: .grouped)
                            self.view.addSubview(self.tableView)
                        } else {
                            //なければtableViewのみ生成
                            self.tableView = UITableView(frame: CGRect(x:0, y:10, width:self.view.frame.width, height:self.textView.contentSize.height), style: .grouped)
                            self.view.addSubview(self.tableView)
                        }
                        
                        if !(self.profileData!.commentedArticleIDs == []) {
                            self.fetchUserComments(commentedArticleIDs:self.profileData!.commentedArticleIDs)
                        } else {
                            return
                        }
                    }
                }
                
            } else {
                //receivedUserIdが他人だった場合の処理式
                
            }
        }
    }*/
    
    func fetchUserComments(commentedArticleIDs:[String]) {
        //ログイン済み（uidを取得済み）であることを確認
        if let user = Auth.auth().currentUser {
            let ref = Firestore.firestore().collection("articleData")
            let uid = user.uid
            
            ref.addSnapshotListener { querySnapshot, err in
                if let err = err {
                    print("Error fetching documents: \(err)")
                } else {
                    self.commentedArticleArray = []
                    for document in querySnapshot!.documents {
                        let commentedArticleData = ArticleQueryData(snapshot: document, myId: uid)
                        
                        for id in commentedArticleIDs {
                            if (commentedArticleData.id)! == id && self.commentedArticleArray.count < 5 {
                                self.commentedArticleArray.insert(commentedArticleData, at: 0)
                            }
                        }
                    }
                    self.tableView.reloadData()
                    
                    /*
                    let before = self.tableView.contentOffset.y
                    self.tableView.reloadData()
                    let after = self.tableView.contentOffset.y
                    
                    if before > after {
                        self.tableView.contentOffset.y = before
                    }
                    SVProgressHUD.dismiss()*/
                    
                }
            }
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    /// セルの個数を指定するデリゲートメソッド（必須）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 1
        } else if section == 0 {
            print("commentedArticleArray.count",commentedArticleArray.count)
            return commentedArticleArray.count
            //commentedArticleArray.countが0の時はtableViewがなくなる。
        } else {
            return 0
        }
    }
    
    /// セルに値を設定するデータソースメソッド（必須）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell") as! CommentTableViewCell
        cell.setCommentTableViewCellInfo(commentData:CommentData)
        */
        
        if indexPath.section == 1 {
            print("indexPath.section == 0は呼ばれている")
            let cell:TextViewCell = TextViewCell()
            cell.setCellInfo(receivedUserId:receivedUserId,receiveTextViewText:receiveTextViewText)
            
            
            //fetchProfile()
            
            return cell
        } else if indexPath.section == 0 {
            print("indexPath.section == 1は呼ばれている")
            if commentedArticleArray.count != 0 {
                print("ProfileCommentCellは呼ばれている")
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCommentCell", for:indexPath) as! ProfileCommentCell
                if let user = Auth.auth().currentUser {
                    if receivedUserId == user.uid {
                        ref.document(user.uid).addSnapshotListener { querySnapshot, err in
                            if let err = err {
                                print("Error fetching documents: \(err)")
                            } else {
                                //まずはprofile情報を取得
                                self.profileData = Profile(snapshot: querySnapshot!)
                                
                                if !(self.profileData!.commentedArticleIDs == []) {
                                    self.fetchUserComments(commentedArticleIDs:self.profileData!.commentedArticleIDs)
                                    cell.setCellInfo(articleData: self.commentedArticleArray[indexPath.row])
                                    cell.selectionStyle = .none
                                    
                                } else {
                                    return
                                }
                            }
                        }
                    }
                }
                
                //cell.clipButton.addTarget(self, action:#selector(handleButton2(sender:event:)), for:  UIControl.Event.touchUpInside)
                
                return cell
            } else {
                print("commentedArticleArray.countは0です")
                return UITableViewCell()
            }
        } else {
            
            return UITableViewCell()
        }
    }
    
    /// セルが選択された時に呼ばれるデリゲートメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
    }
}


class TextViewCell:UITableViewCell {
    var textView: UITextView = UITextView()
    let profileInfoButton: UIButton = UIButton()
    
    var profileData:Profile?
    
    func setCellInfo(receivedUserId:String,receiveTextViewText:String){
        //textViewの位置とサイズを設定
        textView.frame = CGRect(x:0, y:10, width: UIScreen.main.bounds.size.width, height:100)
        textView.font = UIFont.systemFont(ofSize: 14.0)
        textView.layer.borderWidth = 0
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = UIColor.white
        textView.text = receiveTextViewText
        print("receiveTextViewText",receiveTextViewText)
        
        // ボタンのCGRect・タイトル・タイトルの色・タイトルのフォント・背景色を設定
        profileInfoButton.frame = CGRect(x:0, y:textView.frame.height,
                                         width:UIScreen.main.bounds.size.width, height:50)
        profileInfoButton.setTitle("さらに表示", for:UIControl.State.normal)
        profileInfoButton.setTitleColor(UIColor.blue, for: .normal)
        profileInfoButton.titleLabel?.font =  UIFont.systemFont(ofSize: 14)
        profileInfoButton.backgroundColor = UIColor.brown
        
        profileInfoButton.addTarget(self,action: #selector(profileInfoButtonTapped(sender:event:)),for: .touchUpInside)
        
        fetchProfile(receivedUserId:receivedUserId,textView:textView,profileInfoButton:profileInfoButton)
        
    }
    
    @objc func profileInfoButtonTapped(sender:UIButton, event:UIEvent) {
        //masterViewPointer?. pageMenu?.moveToPage(1)
        print("profileInfoButtonTappedが呼ばれたよ")
        //完全のこれマスターしたな。
    }
    
    func fetchProfile(receivedUserId:String, textView:UITextView, profileInfoButton:UIButton) {
        if let user = Auth.auth().currentUser {
            if receivedUserId == user.uid {
                //print("receivedUserId == user.uidだったよ")
                ref.document(user.uid).addSnapshotListener { querySnapshot, err in
                    if let err = err {
                        print("Error fetching documents: \(err)")
                    } else {
                        //まずはprofile情報を取得
                        self.profileData = Profile(snapshot: querySnapshot!)
                        
                        //profileテキストがあれば、textViewを生成
                        if !(self.profileData!.profile! == "") {
                            self.contentView.addSubview(self.textView)
                            self.contentView.addSubview(self.profileInfoButton)
                            //self.tableView = UITableView(frame: CGRect(x:0, y:10+self.textView.frame.height+50+20, width:self.view.frame.width, height:self.textView.contentSize.height), style: .grouped)
                            //self.view.addSubview(self.tableView)
                        } else {
                            //なければtableViewのみ生成
                            //self.tableView = UITableView(frame: CGRect(x:0, y:10, width:self.view.frame.width, height:self.textView.contentSize.height), style: .grouped)
                            //self.view.addSubview(self.tableView)
                        }
                        
                        
                    }
                }
                
            } else {
                //receivedUserIdが他人だった場合の処理式
                
            }
        }
    }
}*/

