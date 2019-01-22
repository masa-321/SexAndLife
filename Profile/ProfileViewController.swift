//
//  ProfileViewController.swift
//  SexualMediaApp
//
//  Created by Masahiro Atarashi on 2019/01/06.
//  Copyright © 2019 Masahiro Atarashi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
//import SDWebImage

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    var receivedUserId = ""    //自分で自分のプロフィールページを見ているのか、他人が覗いているのかの判断。後続するコードで、infoViewControllerからprofileViewControllerへ移った時に、receiveUserId == user.uidとなっていることが確かめられた。うまくできている。
    //let ref = Firestore.firestore().collection("users")
    let fs = Firestore.firestore()
    var commentedArticleIDs:[String] = []
    var commentedArticleArray:[ArticleQueryData] = []
    var profileData:Profile?
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            
            let nib = UINib(nibName: "ProfileCommentCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: "ProfileCommentCell")
            tableView.bounces = true
            
            tableView.separatorStyle = .none
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchCommentedArticleIDs()
        /*
        if let user = Auth.auth().currentUser {
            if receivedUserId == user.uid {
                //fs.collection("articleData").document("ArticleID").collection("comments").whereField("commenterID", isEqualTo: user.uid)
                //let ref = fs.collection("articleData").document("ArticleID").collection("comments.\(user.uid)").whereField("commenterID", isEqualTo: user.uid) //ダメだ。commentを取得したいんじゃない。articleを取得したいのだから
                
                let ref = fs.collection("comments").document(user.uid)
                
                ref.addSnapshotListener { documentSnapshot, err in
                    if let err = err {
                        print("Error fetching documents: \(err)")
                    } else {
                        print("DocumentSnapshot?.data()?.keys:",documentSnapshot?.data()?.keys)
                        self.commentedArticleArray = []
                        if let dickeys = documentSnapshot?.data()?.keys {
                            self.commentedArticleIDs = [String](dickeys) //keyを配列として取得するためのコード
                            print(self.commentedArticleIDs)
                        }
                        
                        
                        /*
                        self.commentedArticleArray = [] //commentedArticleArrayを一旦初期化。処理の度に複製されないようにするため。
                        for document in querySnapshot!.documents {
                            print(document.data())
                            let articleData = ArticleQueryData(snapshot: document, myId: user.uid)
                            print(articleData.comments)
                            //if articleData.commenterIDs
                        }*/
                    }
                }
            }
        }*/
        
        //★★★本人かそうでないかによる場合分けの設定★★★//
        //receiveUserIdにuser.uidが入っていれば、編集ボタンを表示させ、基礎情報には自分の基礎情報を。入っていなければ編集ボタンを消去し、receivedUserIdに基づいた基礎情報を。
        
    }
    

    
    
    override func viewWillAppear(_ animated: Bool) {
        //★★★navigationBarの設定★★★//
        navigationItem.title = "プロフィール"
        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = .white //clear
        navigationController?.navigationBar.tintColor = .gray  //clear
        navigationController?.navigationBar.alpha = 1 //0
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.gray]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            print("commentedArticleArray.count in numberOfRowsInSection",commentedArticleArray.count)
            return commentedArticleArray.count
        } else {
            return 1
        }
    }
    
    //高さを調整してみた。
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 {
            return 200
        } else {
            return UITableView.automaticDimension
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            print("indexPath.section == 0は呼ばれています")
            let cell:ProfileInfoCell = tableView.dequeueReusableCell(withIdentifier: "ProfileInfoCell", for:indexPath) as! ProfileInfoCell
            cell.setCellInfo(receivedUserId: self.receivedUserId)
            cell.masterViewPointer = self
            cell.selectionStyle = .none
            return cell
            
            
        } else if indexPath.section == 1 {
            print("indexPath.section == 1は呼ばれています")
            let cell:ProfileTextViewCell = tableView.dequeueReusableCell(withIdentifier: "ProfileTextViewCell", for:indexPath) as! ProfileTextViewCell
            cell.setCellInfo(receivedUserId: self.receivedUserId)
            cell.selectionStyle = .none
            return cell
            
        } else if indexPath.section == 2 {
            print("indexPath.section == 2は呼ばれています")
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCommentCell", for:indexPath) as! ProfileCommentCell
            cell.selectionStyle = .none
            let uid = Auth.auth().currentUser!.uid
            if !self.commentedArticleArray.isEmpty && self.receivedUserId == uid {
                cell.setCellInfo(articleData: self.commentedArticleArray[indexPath.row],id:uid)
                
            } else if !self.commentedArticleArray.isEmpty && self.receivedUserId != uid {
                cell.setCellInfo(articleData: self.commentedArticleArray[indexPath.row],id:self.receivedUserId)
            } else {
                print("self.commentedArticleArrayは[]だったよ")
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func fetchCommentedArticleIDs(){
        if let user = Auth.auth().currentUser {
            if receivedUserId == user.uid {
                //fs.collection("articleData").document("ArticleID").collection("comments").whereField("commenterID", isEqualTo: user.uid)
                //let ref = fs.collection("articleData").document("ArticleID").collection("comments.\(user.uid)").whereField("commenterID", isEqualTo: user.uid) //ダメだ。commentを取得したいんじゃない。articleを取得したいのだから
    
                let ref = fs.collection("comments").document(user.uid)
    
                ref.addSnapshotListener { documentSnapshot, err in
                    if let err = err {
                        print("Error fetching documents: \(err)")
                    } else {
                        print("DocumentSnapshot?.data()?.keys:",documentSnapshot?.data()?.keys)
                        self.commentedArticleArray = []
                        if let dickeys = documentSnapshot?.data()?.keys {
                            self.commentedArticleIDs = [String](dickeys) //keyを配列として取得するためのコード
                            print(self.commentedArticleIDs)
                            self.fetchCommentedArticleArray(commentedArticleIDs:self.commentedArticleIDs)
                        }
    
    
                        /*
                        self.commentedArticleArray = [] //commentedArticleArrayを一旦初期化。処理の度に複製されないようにするため。
                        for document in querySnapshot!.documents {
                            print(document.data())
                            let articleData = ArticleQueryData(snapshot: document, myId: user.uid)
                            print(articleData.comments)
                            //if articleData.commenterIDs
                        }*/
                    }
                }
            } else {
                //receivedUserIdが他人だった場合の処理式。receivedUserIdには、commenterIDが入っている。
                let ref = fs.collection("comments").document(receivedUserId)
                //commenterIDが存在するということは、少なくとも１つはdocumentは存在するだろう…
                ref.addSnapshotListener { documentSnapshot, err in
                    if let err = err {
                        print("Error fetching documents: \(err)")
                    } else {
                        self.commentedArticleArray = []
                        if let dickeys = documentSnapshot?.data()?.keys {
                            self.commentedArticleIDs = [String](dickeys) //keyを配列として取得するためのコード
                            print(self.commentedArticleIDs)
                            self.fetchCommentedArticleArray(commentedArticleIDs:self.commentedArticleIDs)
                        }
                    }
                }
            }
        }
    }
    
    func fetchCommentedArticleArray(commentedArticleIDs:[String]) {
        if let user = Auth.auth().currentUser {
            //if receivedUserId == user.uid { //これなくても良いのでは？
                self.fs.collection("articleData").getDocuments { querySnapshot, err in
                    if let err = err {
                        print("Error fetching documents: \(err)")
                    } else {
                        self.commentedArticleArray = []
                        for document in querySnapshot!.documents {
                            let commentedArticleData = ArticleQueryData(snapshot: document, myId: user.uid)
    
                            for id in commentedArticleIDs {
                                print("id",id)
                                if commentedArticleData.id == id{
                                    self.commentedArticleArray.insert(commentedArticleData, at: 0)
                                }
                            }
                            //print("insert後のself.commentedArticleArray",self.commentedArticleArray)
                            self.tableView.reloadData()
                        }
                    }
                }
            //}
        }
    }
    
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
    
    
    /// セルが選択された時に呼ばれるデリゲートメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 || indexPath.section == 1 {
            return
        } else if indexPath.section == 2 {
            let commentedArticleData = commentedArticleArray[indexPath.row]
            fromProfileToSummary(giveCellViewModel: commentedArticleData)
        }
    }
    
    func fromProfileToSummary(giveCellViewModel: ArticleQueryData) {
        //let giveCellViewModel = giveCellViewModel
        let MainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc:SummaryViewController = MainStoryboard.instantiateViewController(withIdentifier: "SummaryViewController") as! SummaryViewController
        vc.receiveCellViewModel = giveCellViewModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    func next(profileData:Profile){
        let editingVc:ProfileEditViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileEditViewController") as! ProfileEditViewController
        editingVc.profileData = profileData
        //if profileData != nil {
            self.navigationController?.pushViewController(editingVc, animated: true)
        /*} else {
            let title = "ロード中です！"
            let message = "ロード完了まで数秒お待ちください"
            let okText = "OK"
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            let okayButton = UIAlertAction(title: okText, style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(okayButton)
            
            present(alert, animated: true, completion: nil)
        }*/
    }
}
    

class ProfileInfoCell:UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!{
        didSet {
            nameLabel.text = ""
        }
    }
    @IBOutlet weak var employmentAndOccupationLabel: UILabel!{
        didSet {
            employmentAndOccupationLabel.text = ""
        }
    }
    @IBOutlet weak var profileImage: EnhancedCircleImageView!
    @IBOutlet weak var profileButton: RoundedButton!
    
    var receivedUserId = ""
    var profileData:Profile?
    var masterViewPointer:ProfileViewController?
    
    func setCellInfo(receivedUserId:String) {
        if let user = Auth.auth().currentUser {
            //プロフィールページを開いたのがユーザー本人だったら。
            if receivedUserId == user.uid {
                //ボタンを表示させる
                self.profileButton.isHidden = false
                //編集ボタンにメソッドを付与
                self.profileButton.addTarget(self, action: #selector(self.Editing(sender:event:)), for: UIControl.Event.touchUpInside)
                
                //Firebaseからユーザー本人の情報を引っ張ってくる。
                let ref = Firestore.firestore().collection("users").document("\(user.uid)")
                ref.addSnapshotListener { querySnapshot, err in
                    if let err = err {
                        print("Error fetching documents: \(err)")
                    } else {
                        //引っ張ってきたユーザー情報をsetCellInfoメソッドの引数として渡す
                        self.profileData = Profile(snapshot: querySnapshot!)
                        self.setCellInfo2(profileData:self.profileData!)
                    }
                }
                
            } else {
                //receivedUserIdが他人だった場合の処理式。receivedUserIdには、commenterIDが入っている。
                //編集ボタンを消す必要ある。
                self.profileButton.isHidden = true
                
                //Firebaseからcommenterの情報を引っ張ってくる。
                let ref = Firestore.firestore().collection("users").document(receivedUserId)
                ref.addSnapshotListener { querySnapshot, err in
                    if let err = err {
                        print("Error fetching documents: \(err)")
                    } else {
                        //引っ張ってきたユーザー情報をsetCellInfoメソッドの引数として渡す
                        self.profileData = Profile(snapshot: querySnapshot!)
                        self.setCellInfo2(profileData:self.profileData!)
                    }
                }
                
            }
        }
    }
    
    
    
    func setCellInfo2(profileData:Profile) {
        self.profileImage.sd_setImage(with: URL(string: profileData.pictureUrl!), placeholderImage: UIImage(named: "profile2"))
        self.nameLabel.text = profileData.name
        if profileData.employment != "" {
            //self.employmentAndOccupationLabel.text = "\(self.profileData!.employment) \(self.profileData!.occupation)"
            self.employmentAndOccupationLabel.text = profileData.employment! + "  " + profileData.occupation!
        } else {
            //self.employmentAndOccupationLabel.text = "\(self.profileData!.occupation)"
            self.employmentAndOccupationLabel.text = profileData.occupation
        }
    }
    
    //self.profileDataの中身が入っているかはちょっと確認してみないとわからない。
    @objc func Editing(sender:UIButton, event:UIEvent){
        masterViewPointer?.next(profileData:self.profileData!)
    }
}
    

class ProfileTextViewCell:UITableViewCell {
    
    @IBOutlet weak var textView: UITextView!
    var profileData:Profile?
    
    func setCellInfo(receivedUserId:String) {
        if let user = Auth.auth().currentUser {
            //プロフィールページを開いたのがユーザー本人だったら。
            if receivedUserId == user.uid {
                //Firebaseからユーザー本人の情報を引っ張ってくる。
                let ref = Firestore.firestore().collection("users").document("\(user.uid)")
                ref.addSnapshotListener { querySnapshot, err in
                    if let err = err {
                        print("Error fetching documents: \(err)")
                    } else {
                        //引っ張ってきたユーザー情報をsetCellInfoメソッドの引数として渡す
                        self.profileData = Profile(snapshot: querySnapshot!)
                        self.textView.text = self.profileData!.profile
                    }
                }
            } else {
                //receivedUserIdが他人だった場合の処理式。receivedUserIdには、commenterIDが入っている。
                let ref = Firestore.firestore().collection("users").document(receivedUserId)
                ref.addSnapshotListener { querySnapshot, err in
                    if let err = err {
                        print("Error fetching documents: \(err)")
                    } else {
                        //引っ張ってきたユーザー情報をsetCellInfoメソッドの引数として渡す
                        self.profileData = Profile(snapshot: querySnapshot!)
                        self.textView.text = self.profileData!.profile
                    }
                }
            }
        }
    }
}
