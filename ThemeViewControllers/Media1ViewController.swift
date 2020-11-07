////
////  Media1ViewController.swift
////  SexualMediaApp
////
////  Created by 新 真大 on 2018/10/4.
////  Copyright © 2018年 Masahiro Atarashi. All rights reserved.
////
//
//import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase
//import SDWebImage
//import SVProgressHUD

class Media1ViewController: MediaViewController {
    
    let query = Firestore.firestore().collection("articleData")
    
    override func refresh() {
        fetchArticleData(query: query)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchArticleData(query: query)
    }
    
    override func toHome(sender: UIButton, event: UIEvent) {
        self.tableView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: true)
    }
}

class Media2ViewController: MediaViewController {
    
    let query = Firestore.firestore().collection("articleData").whereField("genreName", isEqualTo: "体のこと")
    
    override func refresh() {
        fetchArticleData(query: query)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchArticleData(query: query)
    }
    
    override func channelChange1(sender:UIButton, event:UIEvent) {
        self.tableView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: true)
    }
}

//class Media1ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
//    //TableViewの宣言
//    var tableView:UITableView = UITableView()
//
//    var articleDataArray:[ArticleQueryData] = []
//    var observing = false
//
//    let refreshControl = UIRefreshControl()
//
//    var masterViewPointer:ViewController?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        //下が足りない問題はこれで応急処置ができそう。
//        let edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
//        tableView.contentInset = edgeInsets
//        tableView.scrollIndicatorInsets = edgeInsets
//
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - 54.0)
//        //tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
//
//        tableView.backgroundColor = UIColor.white //謎の被る問題はこれであっけなく解決した。
//
//        tableView.register(R.nib.listCell)
//        tableView.separatorStyle = .none
//
//        let nib2 = UINib(nibName: "InitialTableViewCell", bundle: nil)
//        tableView.register(nib2, forCellReuseIdentifier: "InitialTableViewCell")
//        tableView.bounces = true
//
//        let nib3 = UINib(nibName: "QuestionAnswerCell", bundle: nil)
//        tableView.register(nib3, forCellReuseIdentifier: "QuestionAnswerCell")
//        tableView.bounces = true
//
//        let nib4 = UINib(nibName: "ChannelCell", bundle: nil)
//        tableView.register(nib4, forCellReuseIdentifier: "ChannelCell")
//        tableView.bounces = true
//
//
//        self.view.addSubview(tableView)
//        //tableView.estimatedRowHeight = 200 //まじかーーーーー！！これで解決かよ！<https://qiita.com/ShingoFukuyama/items/dc0d39bd69775f1d24a5>
//        //デリゲートメソッドでまとめようと思う。
//        tableView.rowHeight = UITableView.automaticDimension
//        //didSetに組み込むと、今回の場合読み込まれなくなってしまうようだ。
//
//        refreshControl.attributedTitle = NSAttributedString(string: "引っ張って更新")
//        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
//
//        tableView.addSubview(refreshControl)
//
//        tableView.showsVerticalScrollIndicator = false
//
//        //SVProgressHUD.show()
//        SVProgressHUD.setBackgroundColor(.clear)//試してみた。なんか全てのページに適応になった。
//
//        let initLabel = UILabel()
//
//        view.addSubview(initLabel)
//
//    }
//
//    @objc func refresh(){
//        fetchArticleData()
//        //fetchCellViewModell()
//         //別途定義した、firebaseからデータを取ってくる関数
//        tableView.reloadData()  //viewWillAppearの中でtableView.reloadData() ので、ここでは不要→viewWillAppearでなんとかなっていたLINEFirebaseBasicとは異なる。
//        refreshControl.endRefreshing()//ぐるぐるを止める。こうしないとリロードが永遠に止まらなくなる。
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        //print("viewWillAppearだよ")
//        //なぜか初回は呼ばれないようだ。他のカラムから戻ってきたら呼ばれる。
//        //fetchCellViewModell()
//        fetchArticleData()
//
//    }
//
//    //override func viewDidAppear(_ animated: Bool) {}
//    override func viewWillDisappear(_ animated: Bool) {
//        SVProgressHUD.dismiss()
//    }
//
//    func fetchArticleData() {
//        //ログイン済み（uidを取得済み）であることを確認
//
//        if let user = Auth.auth().currentUser {
//            let ref = Firestore.firestore().collection("articleData")
//            let uid = user.uid
//
//            ref.order(by: "date", descending: true).limit(to: 14).addSnapshotListener { querySnapshot, err in
//                if let err = err {
//                    print("Error fetching articleData documents: \(err)")
//                } else {
//                    self.articleDataArray = []
//                    for document in querySnapshot!.documents {
//                        let articleData = ArticleQueryData(snapshot: document, myId: uid)
//                        self.articleDataArray.insert(articleData, at: 0)
//                        //self.articleDataArray.sort(by: {$0.date > $1.date})
//
//                    }
//                    self.articleDataArray.reverse()
//
//                    print("articleData",self.articleDataArray)
//                    let before = self.tableView.contentOffset.y
//                    self.tableView.reloadData()
//                    let after = self.tableView.contentOffset.y
//
//                    if before > after {
//                        self.tableView.contentOffset.y = before
//                    }
//
//                    SVProgressHUD.dismiss()
//
//                    /*
//                    querySnapshot!.documentChanges.forEach{diff in
//                        if diff.type == .added {
//                            //print("added: \(diff.document.data())")
//                        } else if diff.type == .modified {
//                            //print("modified: \(diff.document.data())")
//                            print("Media1","modified")
//                            /*
//
//
//                            var index:Int = 0
//
//                            let articleData = ArticleQueryData(snapshot: diff.document, myId: uid)
//                            print("Media1",articleData.titleStr!)
//                            for article in self.articleDataArray {
//                                if article.id == articleData.id {
//                                    index = self.articleDataArray.index(of: article)!
//                                    break
//                                }
//                            }
//                            self.articleDataArray.remove(at: index)
//                            self.articleDataArray.insert(articleData, at: index)
//                            self.tableView.reloadData()
//
//
//                            SVProgressHUD.dismiss()
//                            */
//                        } else if diff.type == .removed {
//                            //print("removed: \(diff.document.data())")
//                        }
//
//                    }*/
//
//                }
//            } //ref.whereField...の終わり
//        } //if let user = Auth.auth().currentUser {...の終わり
//    }
//
//    /*
//    func fetchArticleData() {
//        //ログイン済み（uidを取得済み）であることを確認
//        if let user = Auth.auth().currentUser {
//            let ref = Firestore.firestore().collection("articleData")
//            let uid = user.uid
//            /*
//            ref.getDocuments() { (querySnapshot, err) in
//                if let err = err {
//                    print("Error getting documents: \(err)")
//                } else {
//                    for document in querySnapshot!.documents {
//                        let articleData = ArticleQueryData(snapshot: document, myId: uid)
//
//                        if self.articleDataArray.count < 14 { //トップ記事は10記事まで
//                            self.articleDataArray.insert(articleData, at: 0)
//                        }
//                        self.tableView.reloadData()
//                        SVProgressHUD.dismiss()
//
//                    }
//                }
//            }*/
//
//            ref.addSnapshotListener { querySnapshot, err in
//                if let err = err {
//                    print("Error fetching documents: \(err)")
//                } else {
//
//                    for document in querySnapshot!.documents {
//                        let articleData = ArticleQueryData(snapshot: document, myId: uid)
//
//                        if self.articleDataArray.count < 14 { //トップ記事は10記事まで
//                            self.articleDataArray.insert(articleData, at: 0)
//                        }
//                        self.tableView.reloadData()
//                        SVProgressHUD.dismiss()
//
//                    }
//
//                    querySnapshot!.documentChanges.forEach{diff in
//                        if diff.type == .added {
//                            print("added: \(diff.document.data())")
//                            /*
//                            var index:Int = 0
//                            let articleData = ArticleQueryData(snapshot: diff.document, myId: uid)
//                            for article in self.articleDataArray {
//                                if article.id == articleData.id {
//                                    index = self.articleDataArray.index(of: article)!
//                                    break
//                                }
//                            }
//                            self.articleDataArray.insert(articleData, at: index)
//                            //上のコードがなくても、articleDataArrayにたくさん記事は追加される。*/
//                            /*
//                            var index:Int = 0
//                            let articleData = ArticleQueryData(snapshot: diff.document, myId: uid)
//                            for article in self.articleDataArray {
//                                if article.id == articleData.id {
//                                    index = self.articleDataArray.index(of: article)!
//                                    break
//                                }
//                            }
//                            self.articleDataArray.remove(at: index)
//                            self.articleDataArray.insert(articleData, at: index)
//                            */
//
//                        }else if diff.type == .modified {
//                            print("modified: \(diff.document.data())")
//                            var index:Int = 0
//                            let articleData = ArticleQueryData(snapshot: diff.document, myId: uid)
//                            for article in self.articleDataArray {
//                                if article.id == articleData.id {
//                                    index = self.articleDataArray.index(of: article)!
//                                    break
//                                }
//                            }
//                            self.articleDataArray.remove(at: index)
//                            self.articleDataArray.insert(articleData, at: index)
//                            //できた…！
//                        }
//
//
//                        /*
//                        for document in documents {
//                            let articleData = ArticleQueryData(snapshot: document, myId: uid)
//                            var index: Int = 0
//                            for article in self.articleDataArray {
//                                if article.id == articleData.id {
//                                    index = self.articleDataArray.index(of: article)!
//                                    break
//                                }
//                            }
//                            //差し替えるために一度削除
//                            self.articleDataArray.remove(at: index)
//                            //削除したところに更新済みのデータを追加
//                            self.articleDataArray.insert(articleData, at:index)
//                        }*/
//                    }
//                    /*
//                    for document in querySnapshot!.documents {
//
//                        var index: Int = 0
//                        for article in self.articleDataArray {
//                            if article.id == articleData.id {
//                                index = self.articleDataArray.index(of: article)!
//                                break
//                            }
//                        }
//
//                    }*/
//                }
//            } //ref.whereField...の終わり
//        } //if let user = Auth.auth().currentUser {...の終わり
//    }*/
//
//    /*
//    func fetchCellViewModell() {
//        articleArray = [] //これがないと、fetchされるたびにarticleArrayが倍増していく。
//       if Auth.auth().currentUser != nil { //新着はAuthがnilでもいいや。
//            //if self.observing == false {
//                let articlesRef = Database.database().reference().child(Const.ArticlePath)
//                articlesRef.observe(.childAdded, with: {snapshot in
//                    //observeSingleEventは、元々のやり方とは合わなかったようだ。どういうわけかはよくわからない。
//
//
//                    //ArticleDataクラスを生成して受け取ったデータを設定する。
//                    if let uid = Auth.auth().currentUser?.uid {
//                        let articleData = ArticleData(snapshot: snapshot, myId: uid)
//                        ///★デバッグ★ print("articleData.relatedArticleIDsの数は？:" + "\(articleData.relatedArticleIDs)") //この時点でrelatedArticleIDsが引き継げていない。
//                        //★デバッグ★ print("likesの数は？: " + "\(articleData.likes)")
//                        if self.articleArray.count < 14 { //トップ記事は10記事まで
//                            self.articleArray.insert(articleData, at: 0)
//                        }
//
//                        //print(self.articleArray)
//                        // TableViewを再表示する
//                        self.tableView.reloadData() //ここをコメントアウトすると、本記事がなくなってしまい、offset調整どころではなくなる。た
//                        SVProgressHUD.dismiss()
//                    }
//                })
//
//                //.childChandedで、ボタンタップ時などの変更をキャッチしている。
//                articlesRef.observe(.childChanged, with: { snapshot in
//                    if let uid = Auth.auth().currentUser?.uid {
//                        let articleData = ArticleData(snapshot: snapshot, myId: uid)
//
//                        var index: Int = 0
//                        for article in self.articleArray {
//                            if article.id == articleData.id {
//                                index = self.articleArray.index(of: article)!
//                                break
//                            }
//                        }
//                        //差し替えるために一度削除
//                        self.articleArray.remove(at: index)
//                        //削除したところに更新済みのデータを追加
//                        self.articleArray.insert(articleData, at:index)
//
//                        let before = self.tableView.contentOffset.y
//                        self.tableView.reloadData()
//                        let after = self.tableView.contentOffset.y
//                        /*
//                        if before < after {
//                            self.tableView.contentOffset.y = after - before
//                            print(after - before)
//                        } else*/
//                         if before > after {
//                            self.tableView.contentOffset.y = before
//                        }
//
//                        SVProgressHUD.dismiss()
//
//                    }
//                })
//
//                //observing = true
//
//            /*} else { //observingも消してみよう
//                if observing == true {
//                    articleArray = []
//                    tableView.reloadData()
//                    Database.database().reference().removeAllObservers()
//
//                    observing = false
//                }
//             //引っ張るたびに消えたりするのは、ここの問題っぽかった。
//            }*/
//
//        }
//    }*/
//
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 3
//    }
//
//
//
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 {
//            if articleDataArray.count == 0 {
//                return 1
//            } else if articleDataArray.count > 0 && articleDataArray.count <= 7 {
//                return articleDataArray.count
//            } else {
//                return 7
//            }
//        } else if section == 1 {
//            if articleDataArray.count <= 7 {
//                return 0
//            } else {
//                return articleDataArray.count - 7
//            }
//        } else if section == 2 {
//            return 1 //5とかにすると、"チャンネル"のところがめっちゃダブることになる。
//        } else{ //other
//            return 1
//        }
//    }
//
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == 0 {
//            return 1500
//        } else if indexPath.section == 1 {
//            return 100
//        } else {
//            return UITableView.automaticDimension
//        }
//        //数字の値は色々試して見つけた。また、tableViewのreload時に呼ぶこのコードも気休め程度には効果があるかもしれない。
//        /*
//         let before = self.tableView.contentOffset.y
//         self.tableView.reloadData()
//         let after = self.tableView.contentOffset.y
//
//         if before > after {
//         self.tableView.contentOffset.y = before
//         }
//         */
//    }
//
//    /*
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 {
//            if articleArray.count == 0 {
//                return 1
//            } else if articleArray.count > 0 && articleArray.count <= 7 {
//                return articleArray.count
//            } else {
//                return 7
//            }
//        } else if section == 1 {
//            if articleArray.count <= 7 {
//                return 0
//            } else {
//                return articleArray.count - 7
//            }
//        } else if section == 2 {
//            return 1 //5とかにすると、"チャンネル"のところがめっちゃダブることになる。
//        } else{ //other
//            return 1
//        }
//    }*/
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
//        if indexPath.section == 0 {
//            if articleDataArray.count > 0 {
//
//                guard let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.listCell, for:indexPath)  else { return UITableViewCell()}
//                print("indexPath.row",indexPath.row)
//                print("articleDataArray.count:",articleDataArray.count)
//                cell.setCellInfo(articleData: articleDataArray[indexPath.row])
//                cell.clipButton.addTarget(self, action: #selector(handleButton(sender:event:)), for:   UIControl.Event.touchUpInside)
//
//                cell.selectionStyle = .none //ハイライトを消す
//                cell.backgroundColor = UIColor.clear
//                return cell
//
//            } else {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "InitialTableViewCell") as! InitialTableViewCell
//                cell.selectionStyle = .none
//                return cell
//            }
//        } else if indexPath.section == 1 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionAnswerCell") as! QuestionAnswerCell
//            cell.setQuestionAnswerCellInfo(articleData: articleDataArray[indexPath.row + 7])
//            cell.clipButton.addTarget(self, action: #selector(handleButton2(sender:event:)), for:   UIControl.Event.touchUpInside)
//            cell.selectionStyle = .none
//            return cell
//
//        } else/* if indexPath.section == 3 {
//             let cell = tableView.dequeueReusableCell(withIdentifier: "InitialTableViewCell") as! InitialTableViewCell
//             cell.setTitleLabel(string: "")
//             cell.selectionStyle = .none
//             return cell
//
//             } else*/ {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "ChannelCell") as! ChannelCell
//                //cell.setCommentTableViewCellInfo()
//                cell.selectionStyle = .none
//                cell.channelButton1.addTarget(self, action: #selector(channelChange1(sender:event:)), for:   UIControl.Event.touchUpInside)
//                cell.channelButton2.addTarget(self, action: #selector(channelChange2(sender:event:)), for:   UIControl.Event.touchUpInside)
//                cell.channelButton3.addTarget(self, action: #selector(channelChange3(sender:event:)), for:   UIControl.Event.touchUpInside)
//                cell.channelButton4.addTarget(self, action: #selector(channelChange4(sender:event:)), for:   UIControl.Event.touchUpInside)
//                cell.channelButton5.addTarget(self, action: #selector(channelChange5(sender:event:)), for:   UIControl.Event.touchUpInside)
//                cell.channelButton6.addTarget(self, action: #selector(channelChange6(sender:event:)), for:   UIControl.Event.touchUpInside)
//                cell.channelButton7.addTarget(self, action: #selector(channelChange7(sender:event:)), for:   UIControl.Event.touchUpInside)
//                cell.homeButton.addTarget(self, action: #selector(toHome(sender:event:)), for:   UIControl.Event.touchUpInside)
//                return cell
//        }
//    }
//    /*
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
//        if indexPath.section == 0 {
//            if articleArray.count > 0{
//                guard let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.listCell, for:indexPath)  else { return UITableViewCell()}
//                cell.setCellInfo(articleData: articleArray[indexPath.row])
//                cell.clipButton.addTarget(self, action: #selector(handleButton(sender:event:)), for:   UIControl.Event.touchUpInside)
//
//                cell.selectionStyle = .none //ハイライトを消す
//                cell.backgroundColor = UIColor.clear
//                return cell
//            } else {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "InitialTableViewCell") as! InitialTableViewCell
//                cell.selectionStyle = .none
//                return cell
//            }
//        } else if indexPath.section == 1 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionAnswerCell") as! QuestionAnswerCell
//            cell.setQuestionAnswerCellInfo(articleData: articleArray[indexPath.row + 7])
//            cell.clipButton.addTarget(self, action: #selector(handleButton2(sender:event:)), for:   UIControl.Event.touchUpInside)
//            cell.selectionStyle = .none
//            return cell
//
//        } else/* if indexPath.section == 3 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "InitialTableViewCell") as! InitialTableViewCell
//            cell.setTitleLabel(string: "")
//            cell.selectionStyle = .none
//            return cell
//
//        } else*/ {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ChannelCell") as! ChannelCell
//            //cell.setCommentTableViewCellInfo()
//            cell.selectionStyle = .none
//            cell.channelButton1.addTarget(self, action: #selector(channelChange1(sender:event:)), for:   UIControl.Event.touchUpInside)
//            cell.channelButton2.addTarget(self, action: #selector(channelChange2(sender:event:)), for:   UIControl.Event.touchUpInside)
//            cell.channelButton3.addTarget(self, action: #selector(channelChange3(sender:event:)), for:   UIControl.Event.touchUpInside)
//            cell.channelButton4.addTarget(self, action: #selector(channelChange4(sender:event:)), for:   UIControl.Event.touchUpInside)
//            cell.channelButton5.addTarget(self, action: #selector(channelChange5(sender:event:)), for:   UIControl.Event.touchUpInside)
//            cell.channelButton6.addTarget(self, action: #selector(channelChange6(sender:event:)), for:   UIControl.Event.touchUpInside)
//            cell.homeButton.addTarget(self, action: #selector(toHome(sender:event:)), for:   UIControl.Event.touchUpInside)
//            return cell
//        }
//    }*/
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("didSelectRowAtが呼ばれたよ")//これは呼ばれるらしい。
//        if indexPath.section == 0 {
//            if articleDataArray.count > 0{
//                let selectCellViewModel = articleDataArray[indexPath.row]
//                masterViewPointer?.summaryView(giveCellViewModel: selectCellViewModel)
//
//
//                //問題はこの部分。articleArrayは入っているから、masterViewPointerの問題か、summaryViewの問題か
//                //ページの遷移に問題があるように思われる。つまり、summaryViewだけではないと。clipも反応しないし、相談窓口ボタンも反応しなかった。
//                /*
//                 Terminating app due to uncaught exception 'NSGenericException', reason: 'Push segues can only be used when the source controller is managed by an instance of UINavigationController.
//                 */
//                //これはどういう意味だろう。navigationControllerが呼ばれていないということだろうか。home画面へ移動する際のコードがshowになっていて、navigation controllerを継承したものではなかったのが原因だった。
//
//
//            } else {
//                return
//            }
//        } else if indexPath.section == 1 {
//            if articleDataArray.count > 7{
//                let selectCellViewModel = articleDataArray[indexPath.row + 7]
//                masterViewPointer?.summaryView(giveCellViewModel: selectCellViewModel)
//            }
//        }
//    }
//    /*
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("didSelectRowAtが呼ばれたよ")//これは呼ばれるらしい。
//        if indexPath.section == 0 {
//            if articleArray.count > 0{
//                let selectCellViewModel = articleArray[indexPath.row]
//                masterViewPointer?.summaryView(giveCellViewModel: selectCellViewModel)
//                //問題はこの部分。articleArrayは入っているから、masterViewPointerの問題か、summaryViewの問題か
//                //ページの遷移に問題があるように思われる。つまり、summaryViewだけではないと。clipも反応しないし、相談窓口ボタンも反応しなかった。
//                /*
//                 Terminating app due to uncaught exception 'NSGenericException', reason: 'Push segues can only be used when the source controller is managed by an instance of UINavigationController.
//                */
//                //これはどういう意味だろう。navigationControllerが呼ばれていないということだろうか。home画面へ移動する際のコードがshowになっていて、navigation controllerを継承したものではなかったのが原因だった。
//
//            } else {
//                return
//            }
//        } else if indexPath.section == 1 {
//            if articleArray.count > 7{
//                let selectCellViewModel = articleArray[indexPath.row + 7]
//                masterViewPointer?.summaryView(giveCellViewModel: selectCellViewModel)
//            }
//        }
//    }*/
//
//    //以下はいいねボタンの処理。可能な限りコピペで使いまわしたい…
//    @objc func handleButton(sender:UIButton, event:UIEvent) {
//        // タップされたセルのインデックスを求める
//        let touch = event.allTouches?.first
//        let point = touch!.location(in: self.tableView)
//        let indexPath = tableView.indexPathForRow(at: point)
//
//        // 配列からタップされたインデックスのデータを取り出す
//        let articleData = articleDataArray[indexPath!.row]
//
//        //ずれの原因はここより下にあるようだ。
//        // Firebaseに保存するデータの準備
//        if let uid = Auth.auth().currentUser?.uid {
//            if articleData.isLiked {
//                // すでにいいねをしていた場合はいいねを解除するためIDを取り除く
//                var index = -1
//                for likeId in articleData.likes {
//                    if likeId == uid {
//                        // 削除するためにインデックスを保持しておく
//                        index = articleData.likes.firstIndex(of: likeId)!
//                        break
//                    }
//                }
//                articleData.likes.remove(at: index)
//                print(articleData.likes)
//                articleData.isLiked = false
//
//            } else {
//                articleData.likes.append(uid)
//                print(articleData.likes)
//                articleData.isLiked = true
//
//            }
//            //色も数値も変わるってことは、ローカル環境でのlikes配列の中に、uidが保存されているということ。問題は、それをFirebaseへアップできていない…。
//            //視覚的に更新されていないだけで、実際は更新されていたというオチ。
//
//            // 増えたlikesをFirebaseに保存する
//            let articleRef = Firestore.firestore().collection("articleData").document(articleData.id!)
//            let likes = ["likes": articleData.likes]
//
//            articleRef.updateData(likes){ err in
//                if let err = err {
//                    print("Error adding document: \(err)")
//                } else {
//                    print("Document successfully written!")
//                }
//
//            }
//            //addSnapshotListenerにしてから、自動的に更新されるはずだったか、isLikedの反転とreloadDataが呼ばれないことが多発したため、あらかじめ付け加えることにした。
//            tableView.reloadData()
//
//
//        }
//
//    }
//    /*
//    @objc func handleButton(sender:UIButton, event:UIEvent) {
//         // タップされたセルのインデックスを求める
//         let touch = event.allTouches?.first
//         let point = touch!.location(in: self.tableView)
//         let indexPath = tableView.indexPathForRow(at: point)
//
//         // 配列からタップされたインデックスのデータを取り出す
//         let articleData = articleArray[indexPath!.row]
//
//         //ずれの原因はここより下にあるようだ。
//         // Firebaseに保存するデータの準備
//         if let uid = Auth.auth().currentUser?.uid {
//            if articleData.isLiked {
//                // すでにいいねをしていた場合はいいねを解除するためIDを取り除く
//                var index = -1
//                for likeId in articleData.likes {
//                    if likeId == uid {
//                        // 削除するためにインデックスを保持しておく
//                        index = articleData.likes.index(of: likeId)!
//                        break
//                    }
//                }
//                articleData.likes.remove(at: index)
//                print(articleData.likes)
//
//            } else {
//                articleData.likes.append(uid)
//                print(articleData.likes)
//
//            }
//            //色も数値も変わるってことは、ローカル環境でのlikes配列の中に、uidが保存されているということ。問題は、それをFirebaseへアップできていない…。
//            //視覚的に更新されていないだけで、実際は更新されていたというオチ。
//
//            // 増えたlikesをFirebaseに保存する
//            let articleRef = Database.database().reference().child(Const.ArticlePath).child(articleData.id!)
//            let likes = ["likes": articleData.likes]
//            articleRef.updateChildValues(likes)
//
//
//         }
//
//    }*/
//    @objc func handleButton2(sender:UIButton, event:UIEvent) {
//        // タップされたセルのインデックスを求める
//        let touch = event.allTouches?.first
//        let point = touch!.location(in: self.tableView)
//        let indexPath = tableView.indexPathForRow(at: point)
//
//        // 配列からタップされたインデックスのデータを取り出す
//        let articleData = articleDataArray[indexPath!.row + 7]
//
//        //ずれの原因はここより下にあるようだ。
//        // Firebaseに保存するデータの準備
//        if let uid = Auth.auth().currentUser?.uid {
//            if articleData.isLiked {
//                // すでにいいねをしていた場合はいいねを解除するためIDを取り除く
//                var index = -1
//                for likeId in articleData.likes {
//                    if likeId == uid {
//                        // 削除するためにインデックスを保持しておく
//                        index = articleData.likes.firstIndex(of: likeId)!
//                        break
//                    }
//                }
//                articleData.likes.remove(at: index)
//
//            } else {
//                articleData.likes.append(uid)
//
//            }
//
//            // 増えたlikesをFirebaseに保存する
//            let articleRef = Firestore.firestore().collection("articleData").document(articleData.id!)
//            let likes = [
//                "likes": articleData.likes,
//                "likesCount":articleData.likes.count
//                ] as [String : Any]
//
//
//            articleRef.updateData(likes){ err in
//                if let err = err {
//                    print("Error adding document: \(err)")
//                } else {
//                    print("Document successfully written!")
//                }
//            }
//        }
//
//    }
//    /*
//    @objc func handleButton2(sender:UIButton, event:UIEvent) {
//        // タップされたセルのインデックスを求める
//        let touch = event.allTouches?.first
//        let point = touch!.location(in: self.tableView)
//        let indexPath = tableView.indexPathForRow(at: point)
//
//        // 配列からタップされたインデックスのデータを取り出す
//        let articleData = articleArray[indexPath!.row + 7]
//
//        //ずれの原因はここより下にあるようだ。
//        // Firebaseに保存するデータの準備
//        if let uid = Auth.auth().currentUser?.uid {
//            if articleData.isLiked {
//                // すでにいいねをしていた場合はいいねを解除するためIDを取り除く
//                var index = -1
//                for likeId in articleData.likes {
//                    if likeId == uid {
//                        // 削除するためにインデックスを保持しておく
//                        index = articleData.likes.index(of: likeId)!
//                        break
//                    }
//                }
//                articleData.likes.remove(at: index)
//
//            } else {
//                articleData.likes.append(uid)
//
//            }
//            // 増えたlikesをFirebaseに保存する
//            let articleRef = Database.database().reference().child(Const.ArticlePath).child(articleData.id!)
//            let likes = ["likes": articleData.likes]
//            articleRef.updateChildValues(likes)
//
//
//        }
//
//    }*/
//
//
//    @objc func channelChange1(sender:UIButton, event:UIEvent) {
//        print("channelChange1が呼ばれたよ")
//        //最初呼ばれなくてなんで？って思ったが、simulatorで所定の位置へ移動し、Debug＞View Debugging＞Capture View Hierarckyでで確認すると、Viewの大きさがおかしいことがわかった。constraintで大きさをと調整したらうまく動いた。
//        //そもそもViewの大きさが怪しいのでは？って気づくことができたのは、幾たびもの実験の成果である。
//
//        masterViewPointer?.coverFlowSliderView.scrollToItem(at: 1, animated: true)
//
//    }
//    @objc func channelChange2(sender:UIButton, event:UIEvent) {
//        masterViewPointer?.coverFlowSliderView.scrollToItem(at: 2, animated: true)
//
//    };
//    @objc func channelChange3(sender:UIButton, event:UIEvent) {
//        masterViewPointer?.coverFlowSliderView.scrollToItem(at: 3, animated: true)
//
//    }
//    @objc func channelChange4(sender:UIButton, event:UIEvent) {
//        masterViewPointer?.coverFlowSliderView.scrollToItem(at: 4, animated: true)
//
//    }
//    @objc func channelChange5(sender:UIButton, event:UIEvent) {
//        masterViewPointer?.coverFlowSliderView.scrollToItem(at: 5, animated: true)
//
//    }
//    @objc func channelChange6(sender:UIButton, event:UIEvent) {
//        masterViewPointer?.coverFlowSliderView.scrollToItem(at: 6, animated: true)
//
//    }
//    @objc func channelChange7(sender:UIButton, event:UIEvent) {
//        masterViewPointer?.coverFlowSliderView.scrollToItem(at: 7, animated: true)
//    }
//
//    @objc func toHome(sender:UIButton, event:UIEvent) {
//
//        self.tableView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: true)
//    }
//}
///*★★★★★★今までのFirebaseのリファレンス★★★★★★*/
//    /*
//宣言
//     //var cellViewModel_Array = [ListCellViewModel]()
//     //var cellViewModel = ListCellViewModel()
//fetchPost()の下
//     // self.cellViewModel = ListCellViewModel()
//     //self.cellViewModel_Array = [ListCellViewModel]()
//Firebaseから引っ張ってくるためのコード
//    let ref = Database.database().reference().child("CellViewModel")
//    ref.observeSingleEvent(of: .value) { (snap,error) in
//    let cellViewModelSnap = snap.value as? [String:NSDictionary]
//    if cellViewModelSnap == nil {
//    return
//    }
//    //print(cellViewModelSnap)
//    for(_,cell) in cellViewModelSnap!{
//    self.cellViewModel = ListCellViewModel()
//
//    if let summary = cell["summary"] as? String{
//    self.cellViewModel.summary = summary
//    }else{self.cellViewModel.summary = ""}
//
//    if let titleStr = cell["titleStr"] as? String{
//    self.cellViewModel.titleStr = titleStr
//    }else{self.cellViewModel.titleStr = ""}
//
//    if let articleUrl = cell["articleUrl"] as? String{
//    self.cellViewModel.articleUrl = articleUrl
//    }else{self.cellViewModel.articleUrl = ""}
//
//    if let genreName = cell["genreName"] as? String{
//    self.cellViewModel.genreName = genreName
//    }else{self.cellViewModel.genreName = ""}
//
//    if let sourceName = cell["sourceName"] as? String{
//    self.cellViewModel.sourceName = sourceName
//    }else{self.cellViewModel.sourceName = ""}
//
//    if let date = cell["date"] as? String {
//    self.cellViewModel.date = date
//    } else {self.cellViewModel.date = ""}
//
//    if let imageUrl = cell["imageUrl"] as? String {
//    self.cellViewModel.imageUrl = imageUrl
//    } else {self.cellViewModel.imageUrl = ""}
//
//    if let clipDate = cell["clipDate"] as? Date {
//    self.cellViewModel.clipDate = clipDate
//    } else {self.cellViewModel.clipDate = Date()}
//    print(self.cellViewModel.clipDate)
//
//    if let clipSumNumber = cell["clipSumNumber"] as? Int {
//    self.cellViewModel.clipSumNumber = clipSumNumber
//    } else {self.cellViewModel.clipSumNumber = 0}
//
//    if self.cellViewModel_Array.count < 30 {
//    self.cellViewModel_Array.append(self.cellViewModel)
//    } //配列の数を5個までとする。
//    }
//    self.tableView.reloadData()
//    }*/
//
//    /*★★★★★★スクリーンショット★★★★★★*/
//    /*
//    func getScreenShot() -> UIImage { //https://qiita.com/Kyomesuke3/items/928134e8c1ac60abf787 を参考にした
//
//        //context処理開始
//        UIGraphicsBeginImageContextWithOptions(UIScreen.main.bounds.size, false, 0.0)
//        self.view.drawHierarchy(in: self.view.bounds, afterScreenUpdates: true)
//
//        //context用意
//        let context: CGContext = UIGraphicsGetCurrentContext()!
//
//        //contextにスクリーンショットを書き込む
//        self.view.layer.render(in: context)
//
//        //contextをUIImageに書き出す
//        let capturedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
//
//        //context処理終了
//        UIGraphicsEndImageContext()
//
//        //UIImageをreturn
//        return capturedImage
//    }*/
//
//    /*
//
//    var urlArray = [String]() //String型の配列を作って初期化
//
//    //tabelViewを宣言し、初期化
//    var tableView:UITableView = UITableView()
//
//    //名前は適当。引っ張って更新するもの。
//    var refreshControl: UIRefreshControl!
//
//    //今回UIReferenceControlとUIWebViewはObjectを使わずにやっていく
//    var webView:UIWebView = UIWebView()
//
//    var goButton:UIButton!
//    var backButton:UIButton!
//    var cancelButton:UIButton!
//
//    var dotsView:DotsLoader = DotsLoader()
//
//    var parser = XMLParser()
//    var totalBox = NSMutableArray()
//    var elements = NSMutableDictionary()
//    var element = String() //タイトルが入ったり、リンクが入ったり
//    var titleString = NSMutableString() //Key値を決めてセットしたりする
//    var linkString = NSMutableString()
//    var urlString = String() //今回はString
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        //背景画像を作る
//        let imageView = UIImageView()
//        imageView.frame = self.view.bounds //画面一杯まで広げるという指示
//        imageView.image = UIImage(named: "0.jpg") //imageViewのimageをつける。後半はファイル名を書く。
//        self.view.addSubview(imageView) //画面に貼り付けましたよってこと
//
//        //引っ張って更新。先ほど宣言したrefreshControllをもう一回宣言
//        refreshControl = UIRefreshControl()
//        refreshControl.tintColor = UIColor.white //くるくるの部分
//        refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)//rerfreshで何をするのか。書き方は決まっている。addTarget。どこのメソッドを呼ぶのか→self、メソッド名？→#selector,どういう時か→UIControlEvents.valueCanged.
//
//        //tableViewを作成する
//        tableView.delegate = self //selfは宣言した場所。delegateメソッドが勝手に呼ばれる
//        tableView.dataSource = self
//        tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - 54.0) //幅は、自分の画面のサイズの幅にしろ＝目一杯広げろって意味。縦は、タブの分だけ下げている。
//        tableView.backgroundColor = UIColor.clear //clearにすることで後ろの画像が透けて見える
//        tableView.addSubview(refreshControl) //tableViewとrefreshControlが合体した。
//        self.view.addSubview(tableView)
//
//        //webViewを作成する
//        webView.frame = tableView.frame
//        //webViewもデリゲートメソッドを持つ
//        webView.delegate = self
//        //pcのサイトもwebViewのサイズに収まるようにする
//        webView.scalesPageToFit = true
//        webView.contentMode = .scaleAspectFit
//        //画面にくっつけていく　/上からかな？
//        self.view.addSubview(webView)
//
//        webView.isHidden = true
//
//        //1つ進むボタン
//        goButton = UIButton() //先ずは初期化する。
//        goButton.frame = CGRect(x: self.view.frame.size.width - 50, y: self.view.frame.size.height - 120, width: 50, height: 50)//大きさと位置を設定
//        goButton.setImage(UIImage(named: "go.png"), for: .normal) //画像の配置。後半の[for:]はどういう時に表示するのですか？ってこと。ハイライトなどが他の選択肢としてある。
//        goButton.addTarget(self, action: #selector(nextPage), for: .touchUpInside) //ボタンを押した時の操作について。どこの→self、どんな→nextPageメソッド、どんな時に？.touchUpInside→ボタンをタッチして、離した時。続いてnextPageというメソッドを作成する。
//        self.view.addSubview(goButton)
//
//        backButton = UIButton()
//        backButton.frame = CGRect(x: 10, y: self.view.frame.size.height - 120, width: 50, height: 50)
//        backButton.setImage(UIImage(named: "back.png"), for: .normal)
//        backButton.addTarget(self, action: #selector(backPage), for: .touchUpInside)
//        self.view.addSubview(backButton)
//
//        //キャンセルボタン
//        cancelButton = UIButton()
//        cancelButton.frame = CGRect(x: 10, y: 80, width: 50, height: 50)
//        cancelButton.setImage(UIImage(named: "cancel.png"), for: .normal)
//        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
//        self.view.addSubview(cancelButton)
//
//        //全てのボタンを消していく。//??
//        goButton.isHidden = true
//        backButton.isHidden = true
//        cancelButton.isHidden = true
//
//        //ドッツビュー
//        dotsView.frame = CGRect(x: 0, y: self.view.frame.size.height/3, width: self.view.frame.size.width, height: 100)
//        dotsView.dotsCount = 5
//        dotsView.dotsRadius = 10
//        self.view.addSubview(dotsView)
//        dotsView.isHidden = true
//
//        //パース(XMLを解析する)
//        let url:String = "https://www.cnet.com/rss/all/" //今度はCNET のALLをとってくる
//        let urlToSend:URL = URL(string:url)!
//        parser = XMLParser(contentsOf: urlToSend)!
//        totalBox = [] //初期化してからにした。
//        parser.delegate = self
//        parser.parse() //これで解析が始まります。
//        tableView.reloadData() //解析が始まったら、画面を更新する
//    }
//
//    //取り急ぎ作っておく
//    @objc func refresh (){ //Argument of '#selector' refers to instance method 'refresh()' that is not exposed to Objective-Cという表示がでたので、指示にしたがって@objc をつけた
//        perform(#selector(delay), with: nil, afterDelay: 2.0)
//        //2秒後にdelayメソッドでパースが行われる
//    }
//
//    @objc func delay() {
//        //パース(XMLを解析する)
//        let url:String = "https://www.cnet.com/rss/all/"
//        let urlToSend:URL = URL(string:url)!
//        parser = XMLParser(contentsOf: urlToSend)!
//        totalBox = [] //初期化してからにした。
//        parser.delegate = self
//        parser.parse() //これで解析が始まります。
//        tableView.reloadData() //解析が始まったら、画面を更新する
//
//        refreshControl.endRefreshing() //リフレッシュを止める
//    }
//
//    //webViewを１ぺージ進める
//    @objc func nextPage (){
//        //デリゲートメソッド？を使っていけばいい
//        webView.goForward()
//        //あとで作ればいい。
//    }
//
//    //webViewを１ぺージ戻す
//    @objc func backPage (){
//        webView.goBack()
//        //あとで作ればいい。
//    }
//
//    //webViewとボタンを隠す
//    @objc func cancel(){
//        webView.isHidden = true
//        //ボタンも消す
//        goButton.isHidden = true
//        backButton.isHidden = true
//        cancelButton.isHidden = true
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    //
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // 一つのsectionの中に入れるCellの数を決める。
//        //今回は取得した数
//        return totalBox.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        // Cellの内容を決める（超重要）
//
//
//
//
//        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
//        cell.selectionStyle = .none //この一行でCellをタップしたあとのハイライトを消すことができる。
//        cell.backgroundColor = UIColor.clear //後ろが見えるようになる。
//        cell.textLabel?.text = (totalBox[indexPath.row] as AnyObject).value(forKey: "title") as? String
//        //タイトルは次回にセットする。タイトルでとってきたものを"title"というKey値で保存している
//        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
//        cell.textLabel?.textColor = UIColor.white
//
//        cell.detailTextLabel?.text = (totalBox[indexPath.row] as AnyObject).value(forKey: "link") as? String
//        cell.detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 9.0)
//        cell.detailTextLabel?.textColor = UIColor.white
//
//        //cellのimageViewにリンク先のjpegのURLを持ってくる
//        let urlStr = urlArray[indexPath.row].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! //下のdidStartElementのメソッドによって、urlArrayの中にString型の画像のURLがたくさん入ってくる。それをまず取り出している。
//        let url:URL = URL(string: urlStr)! //それはString型なので、URL型に変換した。そしてそれはurlの中に入っている。
//        cell.imageView?.sd_setImage(with: url,placeholderImage: UIImage(named:"placeholderImage.png")) //このurlの画像を、キャッシュを取りながらimageViewに反映している。
//        //まず最初はこのplaceholderImageのpng画像が呼ばれるが、ダウンロードされた際には該当のファイルがこれと代わって映し出されることになる。
//
//
//
//
//        /*
//         let cell = tableView.dequeueReusableCell(withIdentifier: "beginnerCell", for: indexPath)
//         //ここで先ほど指定した『beginnerCell』を呼んでる。
//         cell.textLabel?.text = "swift"*/
//
//        return cell
//
//    }
//
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
//
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        //cellがタップされた時に行われる処理を書く
//        let linkURL = (totalBox[indexPath.row] as AnyObject).value(forKey: "link") as? String
//        /*let urlStr = linkURL?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) */ //News2の場合は困るらしい。CNETが受け付けてくれないみたい。
//
//        let url:URL = URL(string:linkURL!)!  //文字列linkURLを、URL型に変換して、urlの中に入れている。
//        let urlRequest = URLRequest(url: url) //NSURLRequestは、replacedされた。
//        webView.loadRequest(urlRequest)//ここまでは流れ作業
//
//    }
//
//    func webViewDidStartLoad(_ webView: UIWebView) { //webViewのデリゲートメソッド
//        dotsView.isHidden = false
//        dotsView.startAnimating() //dotsViewの持っているプロパティ
//    }
//
//    func webViewDidFinishLoad(_ webView: UIWebView) { //webViewのデリゲートメソッドで、ロードが終わった時
//        dotsView.isHidden = true
//        dotsView.stopAnimating() //dotsViewのアニメーションを止める。
//        webView.isHidden = false
//        goButton.isHidden = false
//        backButton.isHidden = false
//        cancelButton.isHidden = false //これでロードされた時に全てのパーツが揃うだろう。
//    }
//
//    //パースは3つある。タグを見つけたとき、タグの間にデータがあったとき、タグの終了を見つけたとき。これらを一つ一つ書いていくが、全てデリゲートメソッドとなる。
//
//    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
//
//        //elementNameという引数の中に入っているものをelementの中に入れる。
//        element = elementName
//        //elementの中にitemがあれば…
//        if element == "item" {
//            elements = NSMutableDictionary() //上で宣言している
//            elements = [:] //これは決まり文句
//            titleString = NSMutableString() //上で宣言している
//            titleString = ""
//            linkString = NSMutableString()
//            linkString = ""  //上で宣言している
//            urlString = String() //こちらでも初期化しておく。
//            //変数の初期化をしている。
//        } else if element == "media:thumbnail"{
//            urlString = attributeDict["url"]! //タグを見つけた時に、attributeDictが入ってくる。その時Key値が入ってくる。こちらの"media:thumbnail"のURLが入ってくる。それをurlStringの中に入れる。もちろんそれは画像.jpgの中身。それを下で配列の中に入れた。
//            urlArray.append(urlString)
//        }
//
//
//    }
//    //タグの間にデータがあったときのパース（開始タグと終了タグで括られた箇所にデータが存在したときに実行されるメソッド）
//    func parser(_ parser: XMLParser, foundCharacters string: String) {
//        if element == "title" {
//            titleString.append(string)
//        } else if element == "link" {
//            linkString.append(string)
//        }
//        //これで一旦OK。タイトルと、リンクを取得した。
//    }
//
//    //タグの終了時のパース
//    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
//        //itemという要素の中にあるのなら、
//        if elementName == "item" {
//            //titleStringの中身、linkStringの中身が、からでないのなら、つまり何かあるのなら、
//            if titleString != "" {
//                //elementsというNSMutableDictionary(）にKey値をあたえながらtitleStringをセットする。
//                elements.setObject(titleString, forKey: "title" as NSCopying)
//            }
//
//            if linkString != "" {
//                //elementsというNSMutableDictionary(）にKey値をあたえながらlinkStringをセットする。
//                elements.setObject(linkString, forKey: "link" as NSCopying)
//            }
//
//            elements.setObject(urlString, forKey: "url" as NSCopying) //Key値をurlにする。
//
//            //totalBoxの中に、elementsを入れる
//            totalBox.add(elements)
//        }
//    }
// */
//
