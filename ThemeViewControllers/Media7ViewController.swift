//
//  Media7ViewController.swift
//  SexualMediaApp
//
//  Created by 新真大 on 2018/11/03.
//  Copyright © 2018年 Masahiro Atarashi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase
import SDWebImage
import SVProgressHUD

class Media7ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    //TableViewの宣言
    var tableView:UITableView = UITableView()
    var articleDataArray:[ArticleQueryData] = []
    var observing = false
    
    let refreshControl = UIRefreshControl()
    
    var masterViewPointer:ViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        tableView.contentInset = edgeInsets
        tableView.scrollIndicatorInsets = edgeInsets
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - 54.0)
        
        tableView.backgroundColor = UIColor.white //謎の被る問題はこれであっけなく解決した。
        tableView.register(R.nib.listCell)
        tableView.separatorStyle = .none
        
        let nib2 = UINib(nibName: "InitialTableViewCell", bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: "InitialTableViewCell")
        tableView.bounces = true
        
        let nib3 = UINib(nibName: "QuestionAnswerCell", bundle: nil)
        tableView.register(nib3, forCellReuseIdentifier: "QuestionAnswerCell")
        tableView.bounces = true
        
        let nib4 = UINib(nibName: "ChannelCell", bundle: nil)
        tableView.register(nib4, forCellReuseIdentifier: "ChannelCell")
        tableView.bounces = true
        
        
        self.view.addSubview(tableView)
        tableView.estimatedRowHeight = 200
        
        refreshControl.attributedTitle = NSAttributedString(string: "引っ張って更新")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        
        tableView.addSubview(refreshControl)
        
        tableView.showsVerticalScrollIndicator = false
        
        //SVProgressHUD.show()
        SVProgressHUD.setBackgroundColor(.clear)//試してみた。なんか全てのページに適応になった。
        
        let initLabel = UILabel()
        
        view.addSubview(initLabel)
        
    }
    
    @objc func refresh(){
        fetchCellViewModell() //別途定義した、firebaseからデータを取ってくる関数
        tableView.reloadData()  //viewWillAppearの中でtableView.reloadData() ので、ここでは不要→viewWillAppearでなんとかなっていたLINEFirebaseBasicとは異なる。
        refreshControl.endRefreshing()//ぐるぐるを止める。こうしないとリロードが永遠に止まらなくなる。
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //print("viewWillAppearだよ")
        //なぜか初回は呼ばれないようだ。他のカラムから戻ってきたら呼ばれる。
        fetchCellViewModell()
    }
    
    //override func viewDidAppear(_ animated: Bool) {}
    override func viewWillDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }
    
    
    func fetchCellViewModell() {
        articleDataArray = []
        if let user = Auth.auth().currentUser {
            let ref = Firestore.firestore().collection("articleData").whereField("genreName", isEqualTo: "パートナーシップ")
            let uid = user.uid
            
            ref.order(by: "date", descending: false).addSnapshotListener { querySnapshot, err in
                if let err = err {
                    print("Error fetching documents: \(err)")
                } else {
                    self.articleDataArray = []
                    for document in querySnapshot!.documents {
                        let articleData = ArticleQueryData(snapshot: document, myId: uid)
                        
                        if self.articleDataArray.count < 14 { //トップ記事は10記事まで
                            self.articleDataArray.insert(articleData, at: 0)
                        } 
                    }
                    //Clipボタンを押した時にcontentOffsetがずれる課題に対しての気休め
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
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if articleDataArray.count == 0 {
                return 1
            } else if articleDataArray.count > 0 && articleDataArray.count <= 7 {
                return articleDataArray.count
            } else {
                return 7
            }
        } else if section == 1 {
            if articleDataArray.count <= 7 {
                return 0
            } else {
                return articleDataArray.count - 7
            }
        } else if section == 2 {
            return 1 //5とかにすると、"チャンネル"のところがめっちゃダブることになる。
        } else{ //other
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 1500
        } else if indexPath.section == 1 {
            return 100
        } else {
            return UITableView.automaticDimension
        }
        //数字の値は色々試して見つけた。また、tableViewのreload時に呼ぶこのコードも気休め程度には効果があるかもしれない。
        /*
         let before = self.tableView.contentOffset.y
         self.tableView.reloadData()
         let after = self.tableView.contentOffset.y
         
         if before > after {
         self.tableView.contentOffset.y = before
         }
         */
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        if indexPath.section == 0 {
            if articleDataArray.count > 0{
                guard let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.listCell, for:indexPath)  else { return UITableViewCell()}
                cell.setCellInfo(articleData: articleDataArray[indexPath.row])
                cell.clipButton.addTarget(self, action: #selector(handleButton(sender:event:)), for:   UIControl.Event.touchUpInside)
                
                cell.selectionStyle = .none //ハイライトを消す
                cell.backgroundColor = UIColor.clear
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "InitialTableViewCell") as! InitialTableViewCell
                cell.selectionStyle = .none
                return cell
            }
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionAnswerCell") as! QuestionAnswerCell
            cell.setQuestionAnswerCellInfo(articleData: articleDataArray[indexPath.row + 7])
            cell.clipButton.addTarget(self, action: #selector(handleButton2(sender:event:)), for:   UIControl.Event.touchUpInside)
            cell.selectionStyle = .none
            return cell
            
        } else/* if indexPath.section == 3 {
             let cell = tableView.dequeueReusableCell(withIdentifier: "InitialTableViewCell") as! InitialTableViewCell
             cell.setTitleLabel(string: "")
             cell.selectionStyle = .none
             return cell
             
             } else*/ {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ChannelCell") as! ChannelCell
                //cell.setCommentTableViewCellInfo()
                cell.selectionStyle = .none
                cell.channelButton1.addTarget(self, action: #selector(channelChange1(sender:event:)), for:   UIControl.Event.touchUpInside)
                cell.channelButton2.addTarget(self, action: #selector(channelChange2(sender:event:)), for:   UIControl.Event.touchUpInside)
                cell.channelButton3.addTarget(self, action: #selector(channelChange3(sender:event:)), for:   UIControl.Event.touchUpInside)
                cell.channelButton4.addTarget(self, action: #selector(channelChange4(sender:event:)), for:   UIControl.Event.touchUpInside)
                cell.channelButton5.addTarget(self, action: #selector(channelChange5(sender:event:)), for:   UIControl.Event.touchUpInside)
                cell.channelButton6.addTarget(self, action: #selector(channelChange6(sender:event:)), for:   UIControl.Event.touchUpInside)
                cell.channelButton7.addTarget(self, action: #selector(channelChange7(sender:event:)), for:   UIControl.Event.touchUpInside)
                cell.homeButton.addTarget(self, action: #selector(toHome(sender:event:)), for:   UIControl.Event.touchUpInside)
                return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if articleDataArray.count > 0 && articleDataArray.count <= 7{
                let selectCellViewModel = articleDataArray[indexPath.row]
                masterViewPointer?.summaryView(giveCellViewModel: selectCellViewModel)
            } else {
                return
            }
        } else if indexPath.section == 1 {
            if articleDataArray.count > 7{
                let selectCellViewModel = articleDataArray[indexPath.row + 7]
                masterViewPointer?.summaryView(giveCellViewModel: selectCellViewModel)
            }
        }
    }
    
    //以下はいいねボタンの処理。可能な限りコピペで使いまわしたい…
    
    @objc func handleButton(sender:UIButton, event:UIEvent) {
        // タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        // 配列からタップされたインデックスのデータを取り出す
        let articleData = articleDataArray[indexPath!.row]
        
        //ずれの原因はここより下にあるようだ。
        // Firebaseに保存するデータの準備
        if let uid = Auth.auth().currentUser?.uid {
            if articleData.isLiked {
                // すでにいいねをしていた場合はいいねを解除するためIDを取り除く
                var index = -1
                for likeId in articleData.likes {
                    if likeId == uid {
                        // 削除するためにインデックスを保持しておく
                        index = articleData.likes.index(of: likeId)!
                        break
                    }
                }
                articleData.likes.remove(at: index)
                
            } else {
                articleData.likes.append(uid)
                
            }
            // 増えたlikesをFirebaseに保存する
            let articleRef = Firestore.firestore().collection("articleData").document(articleData.id!)
            let likes = ["likes": articleData.likes]
            
            articleRef.updateData(likes){ err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document successfully written!")
                }
                
            }
        }
        
    }
    @objc func handleButton2(sender:UIButton, event:UIEvent) {
        // タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        // 配列からタップされたインデックスのデータを取り出す
        let articleData = articleDataArray[indexPath!.row + 7]
        
        //ずれの原因はここより下にあるようだ。
        // Firebaseに保存するデータの準備
        if let uid = Auth.auth().currentUser?.uid {
            if articleData.isLiked {
                // すでにいいねをしていた場合はいいねを解除するためIDを取り除く
                var index = -1
                for likeId in articleData.likes {
                    if likeId == uid {
                        // 削除するためにインデックスを保持しておく
                        index = articleData.likes.index(of: likeId)!
                        break
                    }
                }
                articleData.likes.remove(at: index)
                articleData.isLiked = false
            } else {
                articleData.likes.append(uid)
                articleData.isLiked = true
            }
            // 増えたlikesをFirebaseに保存する
            let articleRef = Firestore.firestore().collection("articleData").document(articleData.id!)
            let likes = [
                "likes": articleData.likes,
                "likesCount":articleData.likes.count
                ] as [String : Any]
            
            articleRef.updateData(likes){ err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document successfully written!")
                }
                
            }
            tableView.reloadData()
        }
        
    }
    
    
    @objc func channelChange1(sender:UIButton, event:UIEvent) {
        masterViewPointer?.coverFlowSliderView.scrollToItem(at: 1, animated: true)
    }
    @objc func channelChange2(sender:UIButton, event:UIEvent) {
        masterViewPointer?.coverFlowSliderView.scrollToItem(at: 2, animated: true)
    }
    @objc func channelChange3(sender:UIButton, event:UIEvent) {
        masterViewPointer?.coverFlowSliderView.scrollToItem(at: 3, animated: true)
    }
    @objc func channelChange4(sender:UIButton, event:UIEvent) {
        masterViewPointer?.coverFlowSliderView.scrollToItem(at: 4, animated: true)
    }
    @objc func channelChange5(sender:UIButton, event:UIEvent) {
        masterViewPointer?.coverFlowSliderView.scrollToItem(at: 5, animated: true)
    }
    @objc func channelChange6(sender:UIButton, event:UIEvent) {
        self.tableView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: true)
    }
    
    @objc func channelChange7(sender:UIButton, event:UIEvent) {
        masterViewPointer?.coverFlowSliderView.scrollToItem(at: 7, animated: true)
    }
    
    @objc func toHome(sender:UIButton, event:UIEvent) {
        masterViewPointer?.coverFlowSliderView.scrollToItem(at: 0, animated: true)
    }
}
/*
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SDWebImage
import SVProgressHUD

class Media7ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    //TableViewの宣言
    var tableView:UITableView = UITableView()
    var articleArray:[ArticleData] = []
    var observing = false
    
    let refreshControl = UIRefreshControl()
    
    var masterViewPointer:ViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - 54.0)
        
        tableView.backgroundColor = UIColor.white //謎の被る問題はこれであっけなく解決した。
        tableView.register(R.nib.listCell)
        tableView.separatorStyle = .none
        
        let nib2 = UINib(nibName: "InitialTableViewCell", bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: "InitialTableViewCell")
        tableView.bounces = true
        
        
        
        
        self.view.addSubview(tableView)
        tableView.estimatedRowHeight = 200 //まじかーーーーー！！これで解決かよ！<https://qiita.com/ShingoFukuyama/items/dc0d39bd69775f1d24a5>
        //didSetに組み込むと、今回の場合読み込まれなくなってしまうようだ。
        
        refreshControl.attributedTitle = NSAttributedString(string: "引っ張って更新")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        
        tableView.addSubview(refreshControl)
        
        tableView.showsVerticalScrollIndicator = false
        
        SVProgressHUD.show()
        SVProgressHUD.setBackgroundColor(.clear)//試してみた。なんか全てのページに適応になった。
        
        let initLabel = UILabel()
        
        view.addSubview(initLabel)
        
    }
    
    @objc func refresh(){
        fetchCellViewModell() //別途定義した、firebaseからデータを取ってくる関数
        tableView.reloadData()  //viewWillAppearの中でtableView.reloadData() ので、ここでは不要→viewWillAppearでなんとかなっていたLINEFirebaseBasicとは異なる。
        refreshControl.endRefreshing()//ぐるぐるを止める。こうしないとリロードが永遠に止まらなくなる。
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //なぜか初回は呼ばれないようだ。他のカラムから戻ってきたら呼ばれる。→アカウント作成がまだだとプログラム上取得できなかったことに加え、Firebaseのルールでも禁止されていた。
        fetchCellViewModell()
    }
    
    //override func viewDidAppear(_ animated: Bool) {}
    override func viewWillDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }
    
    var refreshDataId = ""
    func fetchCellViewModell() {
        articleArray = [] 
        if Auth.auth().currentUser != nil { //新着はAuthがnilでもいいや。
            //if self.observing == false {
            let articlesRef = Database.database().reference().child(Const.ArticlePath)
            articlesRef.observe(.childAdded, with: {snapshot in
                //observeSingleEventは、元々のやり方とは合わなかったようだ。どういうわけかはよくわからない。
                
                
                //ArticleDataクラスを生成して受け取ったデータを設定する。
                if let uid = Auth.auth().currentUser?.uid {
                    let articleData = ArticleData(snapshot: snapshot, myId: uid)
                    
                    if self.articleArray.count < 30 && articleData.genreName == "パートナーシップ"{ //トップ記事は30記事まで
                        self.articleArray.insert(articleData, at: 0)
                    }
                    
                    //print(self.articleArray)
                    // TableViewを再表示する
                    self.tableView.reloadData() //ここをコメントアウトすると、本記事がなくなってしまい、offset調整どころではなくなる。た
                    SVProgressHUD.dismiss()
                }
            })
            articlesRef.observe(.childChanged, with: { snapshot in
                if let uid = Auth.auth().currentUser?.uid {
                    let articleData = ArticleData(snapshot: snapshot, myId: uid)
                    
                    var index: Int = 0
                    for article in self.articleArray {
                        if article.id == articleData.id {
                            index = self.articleArray.index(of: article)!
                            break
                        }
                    }
                    //変更があったCellのidを保存。
                    //self.refreshDataId = self.articleArray[index].id!
                    
                    if articleData.genreName == "パートナーシップ"{ //トップ記事は30記事まで
                        //差し替えるために一度削除 ここでエラーになった。
                        self.articleArray.remove(at: index)
                        //削除したところに更新済みのデータを追加
                        self.articleArray.insert(articleData, at:index)
                        
                    }
                    /*
                    for id in articleData.id! {
                        //全てのarticleDataの中から、変更があったCellを再度取り出す
                        if "\(id)" == self.refreshDataId {
                            self.articleArray.insert(articleData, at:index)
                        }
                    }*/
                   
                    let before = self.tableView.contentOffset.y
                    self.tableView.reloadData()
                    let after = self.tableView.contentOffset.y
                    /*
                     if before < after {
                     self.tableView.contentOffset.y = after - before
                     print(after - before)
                     } else*/
                    if before > after {
                        self.tableView.contentOffset.y = before
                    }
                    
                    SVProgressHUD.dismiss()
                    
                }
            })
            
            //observing = true
            
            /*} else { //observingも消してみよう
             if observing == true {
             articleArray = []
             tableView.reloadData()
             Database.database().reference().removeAllObservers()
             
             observing = false
             }
             //引っ張るたびに消えたりするのは、ここの問題っぽかった。
             }*/
            
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if articleArray.count > 0 {
            return articleArray.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        
        if articleArray.count > 0{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.listCell, for:indexPath)  else { return UITableViewCell()}
            cell.setCellInfo(articleData: articleArray[indexPath.row])
            cell.clipButton.addTarget(self, action: #selector(handleButton(sender:event:)), for:   UIControl.Event.touchUpInside)
            
            cell.selectionStyle = .none //ハイライトを消す
            cell.backgroundColor = UIColor.clear
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InitialTableViewCell") as! InitialTableViewCell
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if articleArray.count > 0{
            let selectCellViewModel = articleArray[indexPath.row]
            masterViewPointer?.summaryView(giveCellViewModel: selectCellViewModel)
        } else {
            return
        }
    }
    
    //以下はいいねボタンの処理。可能な限りコピペで使いまわしたい…
    
    @objc func handleButton(sender:UIButton, event:UIEvent) {
        
        // タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        // 配列からタップされたインデックスのデータを取り出す
        let articleData = articleArray[indexPath!.row]
        
        //ずれの原因はここより下にあるようだ。
        // Firebaseに保存するデータの準備
        if let uid = Auth.auth().currentUser?.uid {
            if articleData.isLiked {
                // すでにいいねをしていた場合はいいねを解除するためIDを取り除く
                var index = -1
                for likeId in articleData.likes {
                    if likeId == uid {
                        // 削除するためにインデックスを保持しておく
                        index = articleData.likes.index(of: likeId)!
                        break
                    }
                }
                articleData.likes.remove(at: index)
                
            } else {
                articleData.likes.append(uid)
                
            }
            // 増えたlikesをFirebaseに保存する
            let articleRef = Database.database().reference().child(Const.ArticlePath).child(articleData.id!)
            let likes = ["likes": articleData.likes]
            articleRef.updateChildValues(likes)
            
            
        }
        
    }
}
*/
