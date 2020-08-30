//
//  ClipViewController.swift
//  SexualMediaApp
//
//  Created by 新真大 on 2018/10/29.
//  Copyright © 2018年 Masahiro Atarashi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD
import FirebaseFirestore

class ClipViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //clip記事が格納される配列を用意
    var likesArray: [ArticleQueryData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(R.nib.listCell)
        tableView.estimatedRowHeight = 200
        SVProgressHUD.show()
        reloadFavoriteData()
        /*
        Firestore.firestore().collection("users").getDocuments(){(querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.userSum = querySnapshot!.documents.count
                print("userSum①",self.userSum)
                self.reloadFavoriteData()
            }
        }*/
        /*
        Database.database().reference().child("users").observeSingleEvent(of: .value) {  (snap,error) in
            if let users = snap.value as? [String:NSDictionary] {
                self.userSum = users.count
         
            }
        }*/
        
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.title = "クリップ記事"
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil //UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = .white //clear
        navigationController?.navigationBar.tintColor = .black  //clear
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    func reloadFavoriteData() {
        if let user = Auth.auth().currentUser {
            let uid = user.uid
            
            //.orderは約10個以上になるとうまく表示されない可能性がある。慎重に。
            let ref = Firestore.firestore().collection("articleData")
            ref.order(by: "date", descending: true).addSnapshotListener { querySnapshot, err in
                if let err = err {
                    print("Error fetching documents: \(err)")
                } else {
                    self.likesArray = []
                    print("呼ばれたよ")
                    for document in querySnapshot!.documents {
                        let articleData = ArticleQueryData(snapshot: document, myId: uid)
                        print("documentがあったよ")
                        self.likesArray.insert(articleData, at: 0)
                    }
                    self.likesArray.reverse()
                    
                    self.likesArray = self.likesArray.filter { $0.likes.contains(uid) }
                    
                    let before = self.tableView.contentOffset.y
                    self.tableView.reloadData()
                    let after = self.tableView.contentOffset.y
                    
                    if before > after {
                        self.tableView.contentOffset.y = before
                    }
                    
                    SVProgressHUD.dismiss()
                    
                }
               
            }
        }
    }
        /*
        //print("reloadFavoriteData()が呼ばれたよ")
     
        tableView.reloadData()
        if Auth.auth().currentUser != nil {
            if self.observing == false {
                if let uid = Auth.auth().currentUser?.uid {
                    print("userSum:" + "\(userSum)")
                    for x in 0...userSum { //3ってなんだ？userSumじゃないのか？like数 3以下だったら、追加されるのでは？という仮説の元タッチしたら追加された。Firebaseの方も無事反応。じゃあ5つ以上の方はなぜ？
                        let LikesRef = Database.database().reference().child(Const.ArticlePath).queryOrdered(byChild:"likes/\(x)").queryEqual(toValue: uid)
                        
                        LikesRef.observe(.childAdded, with: { snapshot in
                            let likesData = ArticleData(snapshot: snapshot, myId: uid)
                            print("likesData:" + "\(likesData.id!)")
                            self.likesArray.insert(likesData, at: 0)
                            self.tableView.reloadData()
                            SVProgressHUD.dismiss()
                        })
                        
                        LikesRef.observe(.childChanged, with: { snapshot in
                            let likesData = ArticleData(snapshot: snapshot, myId: uid)
                            
                            // 保持している配列からidが同じものを探す
                            var index: Int = 0
                            for like in self.likesArray {
                                if like.id == likesData.id {
                                    index = self.likesArray.index(of: like)!
                                    break
                                }
                            }
                            // 差し替えるため一度削除する
                            self.likesArray.remove(at: index)
                            
                            // 削除したところに更新済みのでデータを追加する
                            self.likesArray.insert(likesData, at: index)
                            
                            // TableViewの現在表示されているセルを更新する
                            self.tableView.reloadData()
                            SVProgressHUD.dismiss()
                        })
                    }
                }
            }
        }*/
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.listCell, for:indexPath)  else { return UITableViewCell()}
        cell.setCellInfo(articleData: likesArray[indexPath.row])
        cell.clipButton.addTarget(self, action: #selector(handleButton(sender:event:)), for: UIControl.Event.touchUpInside)
        cell.selectionStyle = .none //ハイライトを消す
        cell.backgroundColor = UIColor.black //.clear //一時的に黒へ //後ろが見えるようになる。
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectCellViewModel = likesArray[indexPath.row]
        fromClipArticleToSummary(giveCellViewModel: selectCellViewModel)
    }
    
    func fromClipArticleToSummary(giveCellViewModel:ArticleQueryData) {
        let giveCellViewModel = giveCellViewModel
        let vc:SummaryViewController = storyboard?.instantiateViewController(withIdentifier: "SummaryViewController") as! SummaryViewController
        vc.receiveCellViewModel = giveCellViewModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //減らしていくだけの処理なので、他と少し異なることに注意。そのままコピペするとエラーになる。
    @objc func handleButton(sender: UIButton, event:UIEvent) {
        // タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        // 配列からタップされたインデックスのデータを取り出す
        let likeData = likesArray[indexPath!.row]
        
        // Firebaseに保存するデータの準備
        if let uid = Auth.auth().currentUser?.uid {
            var index = -1
            for likeId in likeData.likes {
                if likeId == uid {
                    // 削除するためにインデックスを保持しておく
                    index = likeData.likes.firstIndex(of: likeId)!
                    break
                }
            }
            likeData.likes.remove(at: index)
            
            /*
            //let likeRef = Database.database().reference().child(Const.ArticlePath).child(likeData.id!)
            let likes = ["likes": likeData.likes]
            likeRef.updateChildValues(likes)
            self.reloadFavoriteData()*/
            
            let likeRef = Firestore.firestore().collection("articleData").document(likeData.id!)
            let likes = ["likes": likeData.likes]
            
            likeRef.updateData(likes){ err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document successfully written!")
                }
                
            }
            /*
            //この時点でuidはnilではない。
            if likeData.isLiked {
                //このpostDataには、指定のCellのisLikedプロパティ(Bool)。デフォルトはfalse、つまり"いいね"していないということ。
                // すでにいいねをしていた場合はいいねを解除するためIDを取り除く
                var index = -1
                for likeId in likeData.likes {
                    if likeId == uid {
                        // 削除するためにインデックスを保持しておく
                        index = likeData.likes.index(of: likeId)!
                        break
                    }
                }
                likeData.likes.remove(at: index)
                
            } else {
                likeData.likes.append(uid)
            }
            
            // 増えたlikesをFirebaseに保存する
            let likeRef = Database.database().reference().child(Const.ArticlePath).child(likeData.id!)
            let likes = ["likes": likeData.likes]
            likeRef.updateChildValues(likes)
            self.tableView.reloadData()
            */
            /*
             let userRef  = Database.database().reference().child("users")
             let likeList = ["お気に入り":[]]
             userRef.child(uid).setValue(likeList)
             */
        }
        
    }

}
