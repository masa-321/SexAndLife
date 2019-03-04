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
            cell.receivedUserId = self.receivedUserId
            //cell.followButton.addTarget(self, action: #selector(followUnfollow(sender:event:)), for: UIControl.Event.touchUpInside)
           
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
            
            ref.order(by: "date", descending: false).addSnapshotListener { querySnapshot, err in
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
    
    
    @objc func followUnfollow(sender:UIButton, event:UIEvent) {
        if let user = Auth.auth().currentUser {
            if receivedUserId == user.uid {
                
            }
        }
        // 配列からタップされたインデックスのデータを取り出す
        let profileData = self.profileData
        
        if let uid = Auth.auth().currentUser?.uid {
            //相手が自分よってフォローされていたとしたら
            if profileData!.isFollowed {
                var index = 0
                for followerId in profileData!.followers {
                    if followerId == uid {
                        index = profileData!.followers.index(of: followerId)!
                    }
                }
                
                profileData?.followers.remove(at: index)
                profileData?.isFollowed = false
            } else {
                profileData?.followers.append(uid)
                profileData?.isFollowed = true
            }
            
            // 増えたlikesをFirebaseに保存する
            let profileRef = Firestore.firestore().collection("users").document(profileData!.id!)
            let followers = ["followers": profileData!.followers]
            
            profileRef.updateData(followers){ err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document successfully written!")
                }
                
            }
            //addSnapshotListenerにしてから、自動的に更新されるはずだったか、isLikedの反転とreloadDataが呼ばれないことが多発したため、あらかじめ付け加えることにした。
            tableView.reloadData()
            
        }
    }
}
    

class ProfileInfoCell:UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!{
        didSet {
            nameLabel.text = ""
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
    
    
    
    @IBOutlet weak var employmentAndOccupationLabel: UILabel!{
        didSet {
            employmentAndOccupationLabel.text = ""
        }
    }
    @IBOutlet weak var profileImage: EnhancedCircleImageView!
    @IBOutlet weak var profileButton: RoundedButton!
    
    @IBOutlet weak var followButton: RoundedButton!{
        didSet{
            followButton.addTarget(self, action: #selector(followUnfollow(sender:event:)), for: UIControl.Event.touchUpInside)
        }
    }
    
    @IBOutlet weak var followButtonLabel: UILabel!
    
    var receivedUserId = ""
    var profileData:Profile?
    var masterViewPointer:ProfileViewController?
    
    @IBOutlet weak var followLabel: UILabel!
    
    @IBOutlet weak var followerLabel: UILabel!
    
    @IBOutlet weak var professionalCertification: UIButton!{
        didSet {
            //professionalCertificationボタンは、管理人がプロフィールページをのぞいた時のみ、表示される。
            professionalCertification.isHidden = true
            professionalCertification.addTarget(self, action: #selector(professionalCertificate(sender:event:)), for: UIControl.Event.touchUpInside)
        }
    }
    
    
    @IBOutlet weak var doctorCertification: UIButton!{
        didSet {
            //doctorCertificationボタンは、管理人がプロフィールページをのぞいた時のみ、表示される。
            doctorCertification.isHidden = true
            doctorCertification.addTarget(self, action: #selector(doctorCertificate(sender:event:)), for: UIControl.Event.touchUpInside)
        }
    }
    
    @IBOutlet weak var youthProCertification: UIButton!{
        didSet {
            //youthProCertificationボタンは、管理人がプロフィールページをのぞいた時のみ、表示される。
            youthProCertification.isHidden = true
            youthProCertification.addTarget(self, action: #selector(youthProCertificate(sender:event:)), for: UIControl.Event.touchUpInside)
        }
    }


    
    
    func setCellInfo(receivedUserId:String) {
        if let user = Auth.auth().currentUser {
            
            //もしユーザーが管理人だったら、doctorCertificationボタンを表示させる。
            if user.uid == "eT7OYTOD0nW7URSW8gDk23RTXzv2" {
                professionalCertification.isHidden = false
                doctorCertification.isHidden = false
                youthProCertification.isHidden = false
            }
            
            //プロフィールページを開いたのがユーザー本人だったら。
            if receivedUserId == user.uid {
                //ボタンを表示させる
                self.profileButton.isHidden = false
                self.followButton.isHidden = true
                
                //編集ボタンにメソッドを付与
                self.profileButton.addTarget(self, action: #selector(self.editing(sender:event:)), for: UIControl.Event.touchUpInside)
                
                //Firebaseからユーザー本人の情報を引っ張ってくる。
                let ref = Firestore.firestore().collection("users").document("\(user.uid)")
                ref.addSnapshotListener { querySnapshot, err in
                    if let err = err {
                        print("Error fetching documents: \(err)")
                    } else {
                        //引っ張ってきたユーザー情報をsetCellInfoメソッドの引数として渡す
                        self.profileData = Profile(snapshot: querySnapshot!, myId: user.uid)
                        self.setCellInfo2(profileData:self.profileData!)
                    }
                }
                
                
                
            } else {
                //receivedUserIdが他人だった場合の処理式。receivedUserIdには、commenterIDが入っている。
                //編集ボタンを消す必要ある。
                self.profileButton.isHidden = true
                self.followButton.isHidden = false
                
                
                
                //Firebaseからcommenterの情報を引っ張ってくる。
                let ref = Firestore.firestore().collection("users").document(receivedUserId)
                ref.addSnapshotListener { querySnapshot, err in
                    if let err = err {
                        print("Error fetching documents: \(err)")
                    } else {
                        //引っ張ってきたユーザー情報をsetCellInfoメソッドの引数として渡す
                        self.profileData = Profile(snapshot: querySnapshot!, myId: user.uid)
                        self.setCellInfo2(profileData:self.profileData!)
                        
                        //他人だった場合、フォローボタンの装飾を考えないと
                        if self.profileData!.isFollowed {
                            self.followButtonLabel.text = "信頼を保留"
                        } else {
                            self.followButtonLabel.text = "信頼する"
                        }
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
        
        //この段階で、やっとProfile情報が取得されている。
        if let follwersSum = profileData.followersSum {
            followerLabel.text = "\(follwersSum)"
        }
        
        if profileData.isProfessional {
            professionalImage.isHidden = false
            //professionalImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
        }
        
        if profileData.isDoctor {
            doctorImage.isHidden = false
            //doctorImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
        }
        
        if profileData.isYouthPro {
            youthProImage.isHidden = false
        }
        //うまく表示させるためには、配列に格納して、順に…って感じなんでしょうかね。〜
    }
    
    //self.profileDataの中身が入っているかはちょっと確認してみないとわからない。
    @objc func editing(sender:UIButton, event:UIEvent){
        masterViewPointer?.next(profileData:self.profileData!)
    }
    
    @objc func followUnfollow(sender:UIButton, event:UIEvent) {
        print("followUnfollowが呼ばれたよ")
        if let user = Auth.auth().currentUser {
            let ref = Firestore.firestore().collection("users").document(receivedUserId)
            ref.getDocument{ (querySnapshot, err) in
                //addlistenerにしていた時は、以下の処理が繰り返し永遠に呼ばれてしまった。listenを削除。
                if let err = err {
                    print("Error fetching documents: \(err)")
                } else {
                    //引っ張ってきたユーザー情報をsetCellInfoメソッドの引数として渡す
                    let profileData = Profile(snapshot: querySnapshot!, myId: user.uid)
                    print("profileDataをフェッチしたよ")
                    //相手が自分よってフォローされていたとしたら
                    if profileData.isFollowed {
                        var index = 0
                        for followerId in profileData.followers {
                            if followerId == user.uid {
                                index = profileData.followers.index(of: followerId)!
                            }
                        }
                        
                        profileData.followers.remove(at: index)
                        profileData.isFollowed = false
                        //self.followButton.titleLabel?.text = "フォローする"
                    } else {
                        profileData.followers.append(user.uid)
                        profileData.isFollowed = true
                        //self.followButton.titleLabel?.text = "フォロー解除"
                    }
                    
                    // 増えたlikesをFirebaseに保存する
                    let profileRef = Firestore.firestore().collection("users").document(profileData.id!)
                    let followers = ["followers": profileData.followers]
                    
                    profileRef.updateData(followers){ err in
                        if let err = err {
                            print("Error adding document: \(err)")
                        } else {
                            print("Document successfully written!")
                        }
                    }
                    //addSnapshotListenerにしてから、自動的に更新されるはずだったか、isLikedの反転とreloadDataが呼ばれないことが多発したため、あらかじめ付け加えることにした。
                    //self.masterViewPointer!.tableView.reloadData()
                }
            }
            
            
        }

    }
    //管理人がワンタップで、思春期プロを確認する
    @objc func professionalCertificate(sender:UIButton, event:UIEvent) {
        print("certificateが呼ばれたよ")
        if let user = Auth.auth().currentUser {
            let ref = Firestore.firestore().collection("users").document(receivedUserId)
            ref.getDocument{ (querySnapshot, err) in
                
                if let err = err {
                    print("Error fetching documents: \(err)")
                } else {
                    //引っ張ってきたユーザー情報をsetCellInfoメソッドの引数として渡す
                    let profileData = Profile(snapshot: querySnapshot!, myId: user.uid)
                    print("profileDataをフェッチしたよ")
                    
                    if profileData.isProfessional {
                        profileData.isProfessional = false
                        self.professionalImage.isHidden = true
                        
                    } else {
                        profileData.isProfessional = true
                        
                    }
                    
                    // 増えたlikesをFirebaseに保存する
                    let profileRef = Firestore.firestore().collection("users").document(profileData.id!)
                    let isProfessional = ["isProfessional": profileData.isProfessional]
                    
                    profileRef.updateData(isProfessional){ err in
                        if let err = err {
                            print("Error adding document: \(err)")
                        } else {
                            print("Document successfully written!")
                        }
                    }
                }
            }
            
            
        }
        
    }
    
    //管理人がワンタップで、医者を確認する
    @objc func doctorCertificate(sender:UIButton, event:UIEvent) {
        print("certificateが呼ばれたよ")
        if let user = Auth.auth().currentUser {
            let ref = Firestore.firestore().collection("users").document(receivedUserId)
            ref.getDocument{ (querySnapshot, err) in
                
                if let err = err {
                    print("Error fetching documents: \(err)")
                } else {
                    //引っ張ってきたユーザー情報をsetCellInfoメソッドの引数として渡す
                    let profileData = Profile(snapshot: querySnapshot!, myId: user.uid)
                    print("profileDataをフェッチしたよ")
                    
                    if profileData.isDoctor {
                        profileData.isDoctor = false
                        self.doctorImage.isHidden = true
                       
                    } else {
                        profileData.isDoctor = true
                        
                    }
                    
                    // 増えたlikesをFirebaseに保存する
                    let profileRef = Firestore.firestore().collection("users").document(profileData.id!)
                    let isDoctor = ["isDoctor": profileData.isDoctor]
                    
                    profileRef.updateData(isDoctor){ err in
                        if let err = err {
                            print("Error adding document: \(err)")
                        } else {
                            print("Document successfully written!")
                        }
                    }
                }
            }
            
            
        }
        
    }
    
    //管理人がワンタップで、YouthProを確認する
    @objc func youthProCertificate(sender:UIButton, event:UIEvent) {
        print("certificateが呼ばれたよ")
        if let user = Auth.auth().currentUser {
            let ref = Firestore.firestore().collection("users").document(receivedUserId)
            ref.getDocument{ (querySnapshot, err) in
                
                if let err = err {
                    print("Error fetching documents: \(err)")
                } else {
                    //引っ張ってきたユーザー情報をsetCellInfoメソッドの引数として渡す
                    let profileData = Profile(snapshot: querySnapshot!, myId: user.uid)
                    print("profileDataをフェッチしたよ")
                    
                    if profileData.isYouthPro {
                        profileData.isYouthPro = false
                        self.youthProImage.isHidden = true
                        
                    } else {
                        profileData.isYouthPro = true
                        
                    }
                    
                    // 増えたlikesをFirebaseに保存する
                    let profileRef = Firestore.firestore().collection("users").document(profileData.id!)
                    let isYouthPro = ["isYouthPro": profileData.isYouthPro]
                    
                    profileRef.updateData(isYouthPro){ err in
                        if let err = err {
                            print("Error adding document: \(err)")
                        } else {
                            print("Document successfully written!")
                        }
                    }
                }
            }
            
            
        }
        
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
                        self.profileData = Profile(snapshot: querySnapshot!, myId: user.uid)
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
                        self.profileData = Profile(snapshot: querySnapshot!, myId: user.uid)
                        self.textView.text = self.profileData!.profile
                    }
                }
            }
        }
    }
}
